from sqlalchemy.orm import joinedload_all, joinedload
from clld.db.meta import DBSession
from clld.db.models import common
from clld.interfaces import IParameter
from clld.web.adapters.geojson import GeoJson, GeoJsonParameter
from clld_phylogeny_plugin.tree import Tree
from clld_phylogeny_plugin.interfaces import ITree

from dplace2.models import get_color




#            dl = []
#            for ds, langs in groupby(
#                sorted(label.languages, key=lambda l: (l.dataset_pk, l.name)),
#                lambda l: l.dataset
#            ):
#                dl.append(HTML.dt(link(self.req, ds)))
#                dl.append(HTML.dd(*[HTML.li(link(self.req, l)) for l in langs]))
#            res['tooltip'] = HTML.dl(*dl)


class VariableTree(Tree):
    def get_marker(self, valueset):
        return 'c', get_color(valueset)


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
                    joinedload_all(common.ValueSet.values, common.Value.domainelement),
                    joinedload(common.ValueSet.language),
                )\
                .distinct()
        return self.get_query(ctx, req)

    def feature_properties(self, ctx, req, valueset):
        value = valueset.values[0]
        if value.domainelement:
            color = value.domainelement.color
        elif 'color' in value.jsondata or {}:
            color = value.jsondata['color']
        else:
            color = '#ff0000'
        return {
            'color': color,
            'label': value.domainelement.name if value.domainelement else ('{0:,}'.format(value.value_float) if value.value_float else value.name),
        }


def includeme(config):
    config.register_adapter(GeoJsonVariable, IParameter)
    config.registry.registerUtility(VariableTree, ITree)
