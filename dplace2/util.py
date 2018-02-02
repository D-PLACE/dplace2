"""
This module will be available in templates as ``u``.

This module is also used to lookup custom template context providers, i.e. functions
following a special naming convention which are called to update the template context
before rendering resource's detail or index views.
"""
from sqlalchemy import func
from sqlalchemy.orm import joinedload
from clld.db.meta import DBSession
from clld.db.models import common
from clld.web.util.htmllib import HTML
from clld.web.util.helpers import external_link
from purl import URL

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
