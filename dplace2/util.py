"""
This module will be available in templates as ``u``.

This module is also used to lookup custom template context providers, i.e. functions
following a special naming convention which are called to update the template context
before rendering resource's detail or index views.
"""
from itertools import chain
import re
from collections import Counter

from sqlalchemy import func, desc
from sqlalchemy.orm import aliased
from clld.db.meta import DBSession
from clld.db.models import common
from clld.web.util.htmllib import HTML
from clld.web.util.helpers import external_link, get_referents, link
from clld.web.util.multiselect import CombinationMultiSelect
from purl import URL

from dplace2 import models


def phylogeny_detail_html(request=None, context=None, **kw):
    return {'ms': CombinationMultiSelect}


def link_sources(req, value, s=None):
    s = s if s is not None else (value.comment or '')
    sources = {ref.source.id: ref.source for ref in value.references if ref.source.id}
    if sources:
        return re.sub(
            '(?P<id>%s)' % '|'.join(re.escape(k) for k in sources),
            lambda m: link(req, sources[m.group('id')]),
            s)
    return s


def ext_link(url):
    return external_link(url, label=URL(url).domain(), title=url)


def language_detail_html(request=None, context=None, **kw):
    return {
        'sources': DBSession.query(common.Source)
        .join(common.LanguageSource)
        .filter(common.LanguageSource.language_pk == context.pk)
        .order_by(common.Source.name)
        .all()}


def contribution_detail_html(request=None, context=None, **kw):
    cats = DBSession.execute("""\
SELECT
    c.name, count(v.pk) as vs FROM category AS c, variablecategory AS vc, variable AS v
WHERE
    c.pk = vc.category_pk AND vc.variable_pk = v.pk AND v.dataset_pk = {0}
GROUP BY
    c.name
ORDER BY vs DESC
""".format(context.pk))
    years = (r[0] for r in DBSession.query(models.Datapoint.year)
        .join(common.ValueSet)
        .filter(common.ValueSet.contribution_pk == context.pk))

    def batch(y):
        if not y:
            return (5, 'NA')
        if y > 1950:
            return (4, 'after 1950')
        if y >= 1900:
            return (3, '1900 - 1950')
        if y >= 1800:
            return (2, '1800 - 1899')
        return (1, 'before 1800')

    years = Counter(map(batch, years))
    return {
        'focal_years': [(k[1], int(n / sum(years.values()) * 100)) for k, n in sorted(years.items())],
        'categories': list(cats)
    }


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
        'trees': DBSession.query(models.DplacePhylogeny)
        .order_by(models.DplacePhylogeny.glottolog, models.Phylogeny.name).all()
    }


def parameter_detail_html(context=None, request=None, **kw):
    return dict(
        trees=DBSession.query(models.DplacePhylogeny)
        .order_by(models.DplacePhylogeny.glottolog, models.Phylogeny.name).all())


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


def source_detail_html(context=None, request=None, **kw):
    return {'referents': get_referents(context)}
