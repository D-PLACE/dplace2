"""
This module will be available in templates as ``u``.

This module is also used to lookup custom template context providers, i.e. functions
following a special naming convention which are called to update the template context
before rendering resource's detail or index views.
"""
from itertools import chain

from sqlalchemy import func
from sqlalchemy.orm import aliased
from clld.db.meta import DBSession
from clld.db.models import common
from clld.web.util.htmllib import HTML
from clld.web.util.helpers import external_link
from clld.web.util.multiselect import CombinationMultiSelect
from purl import URL
from ete3 import Tree

from dplace2 import models


def ext_link(url):
    return external_link(url, label=URL(url).domain(), title=url)


def language_detail_html(request=None, context=None, **kw):
    return {
        'sources': DBSession.query(common.Source)
        .join(common.LanguageSource)
        .filter(common.LanguageSource.language_pk == context.pk)
        .order_by(common.Source.name)
        .all()}


class VariableMultiSelect(CombinationMultiSelect):
    def get_options(self):
        res = CombinationMultiSelect.get_options(self)
        res['maximumSelectionSize'] = 3
        return res


def combination_detail_html(request=None, context=None, **kw):
    p = [(p, {de.pk: de for de in p.domain or []}) for p in context.parameters]
    vs = [aliased(common.ValueSet) for _ in range(len(p))]
    v = [aliased(common.Value) for _ in range(len(p))]
    entities = [common.Language] + list(chain(*zip(v, vs)))
    q = DBSession.query(*entities).order_by(common.Language.name)
    for i in range(len(p)):
        q = q.filter(v[i].valueset_pk == vs[i].pk)
        q = q.filter(vs[i].language_pk == common.Language.pk)
        q = q.filter(vs[i].parameter_pk == p[i][0].pk)
    return {
        'params': p,
        'res': q.all(),
        'ms': VariableMultiSelect,
    }


def parameter_detail_html(context=None, request=None, **kw):
    res = dict(
        tree=None,
        trees=DBSession.query(models.Phylogeny)
        .order_by(models.Phylogeny.glottolog, models.Phylogeny.name).all())

    if 'phylogeny' in request.params:
        tree = models.Phylogeny.get(request.params['phylogeny'])
        color_by_soc = {vs.language_pk: models.get_color(vs) for vs in context.valuesets}
        color_by_label = {}
        for label in tree.labels:
            for sa in label.society_assocs:
                if sa.society_pk in color_by_soc:
                    color_by_label[label.name] = color_by_soc[sa.society_pk]
                    break
        t = Tree(tree.newick, format=1)
        nodes = [n.encode('utf8') for n in color_by_label.keys()]
        try:
            t.prune(nodes, preserve_branch_length=True)
        except ValueError as e:
            if 'Node names not found: [' in e.message:
                for name in eval('[' + e.message.split('[')[1]):
                    try:
                        nodes.remove(name.encode('utf8'))
                    except ValueError:
                        pass
                t.prune(nodes, preserve_branch_length=True)
            else:
                raise
        res.update(
            tree=models.Phylogeny.get(request.params['phylogeny']),
            newick=t.write(format=1),
            color_by_label=color_by_label)
    return res


def variables_by_category(dataset):
    rows = []
    cats = {c.pk: c.name for c in DBSession.query(models.Category)}
    ss = DBSession.query(models.Variable.pk).filter(models.Variable.dataset_pk == dataset.pk).subquery()
    for cpk, count in DBSession.query(models.VariableCategory.category_pk, func.count(models.VariableCategory.variable_pk))\
            .filter(models.VariableCategory.variable_pk.in_(ss))\
            .group_by(models.VariableCategory.category_pk):
        rows.append(HTML.tr(
            HTML.td(cats[cpk]),
            HTML.td(count, class_='right')
        ))
    return HTML.table(
        HTML.thead(HTML.tr(HTML.th('category'), HTML.th('# variables'))),
        HTML.tbody(*rows),
        class_='table table-nonfluid table-condensed')
