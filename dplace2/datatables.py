from __future__ import unicode_literals

from sqlalchemy.orm import joinedload
from clld.web.datatables.base import Col, LinkCol, LinkToMapCol, IdCol, DetailsRowLinkCol
from clld.web.datatables.language import Languages
from clld.web.datatables.contribution import Contributions, CitationCol
from clld.web.datatables.parameter import Parameters
from clld.db.meta import DBSession
from clld.db.util import get_distinct_values, icontains
from clld.db.models import common
from clld.web.util.htmllib import HTML

from dplace2.models import DplaceDataset, Society, Variable, Category


class CategoryCol(Col):
    __kw__ = {'sortable': False}

    def __init__(self, *args, **kw):
        kw['choices'] = get_distinct_values(Category.name)
        kw['model_col'] = Variable.categories_str
        Col.__init__(self, *args, **kw)

    def search(self, qs):
        return icontains(self.model_col, qs)

    def format(self, item):
        return HTML.ul(*[HTML.li(n) for n in sorted(item.categories_str.split('|'))])


class Variables(Parameters):
    __constraints__ = {common.Contribution}

    def base_query(self, query):
        query = query.join(DplaceDataset).options(joinedload(Variable.dataset))
        if self.contribution:
            query = query.filter(Variable.dataset_pk == self.contribution.pk)
        return query.distinct()

    def col_defs(self):
        res = [
            LinkCol(self, 'name'),
            Col(self, 'type', choices=get_distinct_values(Variable.type)),
            CategoryCol(self, 'category'),
        ]
        if not self.contribution:
            res.append(
                LinkCol(
                    self,
                    'dataset',
                    choices=sorted((c for c, in DBSession.query(DplaceDataset.name).join(Society).distinct())),
                    model_col=DplaceDataset.name,
                    get_object=lambda i: i.dataset))
        return res


class Datasets(Contributions):
    def col_defs(self):
        return [
            DetailsRowLinkCol(self, 'more'),
            LinkCol(self, 'name'),
            Col(self, 'type', model_col=DplaceDataset.type),
            Col(self, 'cvars', sTitle='# variables', model_col=DplaceDataset.count_variables),
            Col(self, 'csoc', sTitle='# societies', model_col=DplaceDataset.count_societies),
            CitationCol(self, 'cite'),
        ]


class Societies(Languages):
    __constraints__ = {common.Contribution}

    def base_query(self, query):
        query = query.join(DplaceDataset).options(joinedload(Society.dataset))
        if self.contribution:
            query = query.filter(Society.dataset_pk == self.contribution.pk)
        return query

    def col_defs(self):
        res = [
            IdCol(self, 'id'),
            LinkCol(self, 'name'),
            Col(self,
                'latitude',
                sDescription='<small>The geographic latitude</small>'),
            Col(self,
                'longitude',
                sDescription='<small>The geographic longitude</small>'),
        ]
        if not self.contribution:
            res.append(LinkCol(
                self,
                'dataset',
                choices=sorted((c for c, in DBSession.query(DplaceDataset.name).join(Society).distinct())),
                model_col=DplaceDataset.name,
                get_object=lambda i: i.dataset))
            res.append(LinkToMapCol(self, 'm'))
        return res


def includeme(config):
    config.register_datatable('languages', Societies)
    config.register_datatable('contributions', Datasets)
    config.register_datatable('parameters', Variables)
