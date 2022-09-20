from itertools import chain

from sqlalchemy.orm import joinedload
from clld.db.meta import DBSession
from clld.db.models import common
from clld.interfaces import IParameter
from clld.web.adapters.geojson import GeoJson, GeoJsonParameter
from clld.web.adapters.csv import CsvAdapter
from clld.interfaces import IIndex
from clld_phylogeny_plugin.tree import Tree
from clld_phylogeny_plugin.interfaces import ITree
from csvw.dsv import UnicodeWriter

from dplace2.models import get_icon


class VariableCsvAdapter(CsvAdapter):
    def render(self, ctx, req):
        cols = None
        with UnicodeWriter() as writer:
            for v in chain(*[vs.values for vs in ctx.valuesets]):
                if not cols:
                    cols = v.csv_head()
                    writer.writerow(cols)
                writer.writerow(v.to_csv(ctx=ctx, req=req, cols=cols))
            return writer.read()

    def render_to_response(self, ctx, req):
        res = super(CsvAdapter, self).render_to_response(ctx, req)
        res.content_disposition = 'attachment; filename="dplace_variable_%s.csv"' % ctx.id
        return res


class VariableTree(Tree):
    def get_marker(self, valueset):
        icon = get_icon(valueset)
        return icon[:1], '#' + icon[1:]


class GeoJsonSocieties(GeoJson):
    def feature_properties(self, ctx, req, language):
        if hasattr(ctx, 'icon_url'):  # pragma: no cover
            # special handling for domain elements of feature combinations
            return {'icon': ctx.icon_url}


class GeoJsonVariable(GeoJsonParameter):
    def feature_iterator(self, ctx, req):
        de = req.params.get('domainelement')
        if de:
            return DBSession.query(common.ValueSet)\
                .join(common.Value)\
                .join(common.DomainElement)\
                .filter(common.DomainElement.id == de)\
                .options(
                    joinedload(common.ValueSet.values).joinedload(common.Value.domainelement),
                    joinedload(common.ValueSet.language),
                )\
                .distinct()
        return self.get_query(ctx, req)

    def feature_properties(self, ctx, req, valueset):
        value = valueset.values[0]
        return {
            'label': value.domainelement.name if value.domainelement else ('{0:,}'.format(value.value_float) if value.value_float else value.name),
        }


def includeme(config):
    config.register_adapter(GeoJsonVariable, IParameter)
    config.registry.registerUtility(VariableTree, ITree)
