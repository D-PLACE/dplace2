from __future__ import unicode_literals

from sqlalchemy.orm import joinedload, joinedload_all
from clld.web.datatables.base import (
    Col, LinkCol, LinkToMapCol, IdCol, DetailsRowLinkCol, RefsCol, DataTable,
)
from clld.web.datatables.language import Languages
from clld.web.datatables.contribution import Contributions, CitationCol
from clld.web.datatables.parameter import Parameters
from clld.web.datatables.value import Values, ValueNameCol
from clld.db.meta import DBSession
from clld.db.util import get_distinct_values, icontains
from clld.db.models import common
from clld.web.util.htmllib import HTML
from clld_phylogeny_plugin.datatables import Phylogenies

from dplace2.models import (
    DplaceDataset, Society, Variable, Category, VariableCategory, Datapoint,
    DatapointReference, DplacePhylogeny, Societyset,
)


class CategoryCol(Col):
    __kw__ = {'sortable': False}

    def __init__(self, dt, *args, **kw):
        if dt.contribution:
            choices = DBSession.query(Category.name)\
                .join(VariableCategory)\
                .join(Variable)\
                .filter(Variable.dataset_pk == dt.contribution.pk)\
                .distinct()
        else:
            choices = DBSession.query(Category.name).distinct()
        kw['choices'] = sorted(c for c, in choices)
        kw['model_col'] = Variable.categories_str
        Col.__init__(self, dt, *args, **kw)

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
            Col(self, 'type', choices=get_distinct_values(Variable.type), model_col=Variable.type),
            CategoryCol(self, 'category'),
        ]
        if not self.contribution:
            res.append(
                LinkCol(
                    self,
                    'dataset',
                    choices=sorted((c for c, in DBSession.query(DplaceDataset.name).distinct())),
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
    __constraints__ = {Societyset}

    def base_query(self, query):
        query = query.join(Societyset).options(joinedload(Society.societyset))
        if self.societyset:
            query = query.filter(Society.societyset_pk == self.societyset.pk)
        return query

    def col_defs(self):
        res = [
            IdCol(self, 'id'),
            LinkCol(self, 'name'),
            Col(self, 'glottocode', model_col=Society.glottocode),
            Col(self, 'language', model_col=Society.language, sTitle='Language'),
            Col(self,
                'language_family',
                model_col=Society.language_family,
                choices=get_distinct_values(Society.language_family)),
            Col(self,
                'latitude',
                sDescription='<small>The geographic latitude</small>'),
            Col(self,
                'longitude',
                sDescription='<small>The geographic longitude</small>'),
            Col(self, 'region', model_col=Society.region),
            LinkToMapCol(self, '#'),
        ]
        if not self.societyset:
            res.append(LinkCol(
                self,
                'societyset',
                choices=sorted((c for c, in DBSession.query(Societyset.name).join(Society).distinct())),
                model_col=Societyset.name,
                get_object=lambda i: i.societyset))
            res.append(LinkToMapCol(self, 'm'))
        return res


class FloatCol(Col):
    def format(self, item):
        return '{0:,}'.format(item.value_float)


class Datapoints(Values):
    def base_query(self, query):
        query = query.join(common.ValueSet).options(
            joinedload_all(Datapoint.references, DatapointReference.source)
        )

        if self.language:
            query = query.join(common.ValueSet.parameter)
            return query.filter(common.ValueSet.language_pk == self.language.pk)

        if self.parameter:
            query = query.join(common.ValueSet.language)
            query = query.outerjoin(common.DomainElement).options(
                joinedload(common.Value.domainelement))
            return query.filter(common.ValueSet.parameter_pk == self.parameter.pk)

        if self.contribution:
            query = query.join(common.ValueSet.parameter)
            return query.filter(common.ValueSet.contribution_pk == self.contribution.pk)

        return query

    def col_defs(self):
        name_col = ValueNameCol(self, 'value')
        if self.parameter and self.parameter.domain:
            name_col.choices = [de.name for de in self.parameter.domain]

        res = [
            DetailsRowLinkCol(self, 'comment'),
            name_col
        ]

        if self.parameter:
            if self.parameter.type == 'Continuous':
                res = [FloatCol(self, 'value', model_col=Datapoint.value_float)]
            res += [
                # FIXME: use value_float col!
                LinkCol(self,
                        'language',
                        model_col=common.Language.name,
                        get_object=lambda i: i.valueset.language),
                Col(self,
                    'language_family',
                    sClass='linguistic',
                    sTitle='Language family',
                    model_col=Society.language_family,
                    get_object=lambda i: i.valueset.language),
                RefsCol(self, 'source'),
                LinkToMapCol(self, 'm', get_object=lambda i: i.valueset.language),
            ]

        if self.language:
            res += [
                LinkCol(self,
                        'parameter',
                        sTitle=self.req.translate('Parameter'),
                        model_col=common.Parameter.name,
                        get_object=lambda i: i.valueset.parameter),
                #RefsCol(self, 'source'),
            ]

        return res + [
            #Col(self, 'comment', model_col=Datapoint.comment),
            Col(self, 'year', model_col=Datapoint.year, sTitle='focal year', input_size='mini'),
            Col(self, 'sub_case', model_col=Datapoint.sub_case, sTitle='Subcase'),
        ]


class DplacePhylogenies(Phylogenies):
    def col_defs(self):
        return [
            LinkCol(self, 'name'),
            Col(self, 'author', model_col=DplacePhylogeny.author),
            Col(self, 'year', model_col=DplacePhylogeny.year),
            Col(self, 'glottolog', model_col=DplacePhylogeny.glottolog),
            Col(self, 'description'),
        ]

    def get_options(self):
        opts = super(DplacePhylogenies, self).get_options()
        opts['aaSorting'] = [[3, 'asc'], [0, 'asc']]
        return opts


class Societysets(DataTable):
    def col_defs(self):
        return [
            LinkCol(self, 'name'),
            Col(self, 'societies', sTitle='#', model_col=Societyset.count_societies),
            Col(self, 'reference', model_col=Societyset.reference),
        ]


def includeme(config):
    config.register_datatable('languages', Societies)
    config.register_datatable('contributions', Datasets)
    config.register_datatable('societysets', Societysets)
    config.register_datatable('parameters', Variables)
    config.register_datatable('values', Datapoints)
    config.register_datatable('phylogenys', DplacePhylogenies)
