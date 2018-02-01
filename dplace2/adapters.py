from clld.interfaces import IParameter
from clld.web.adapters.geojson import GeoJson, GeoJsonParameter


class GeoJsonSocieties(GeoJson):
    def feature_properties(self, ctx, req, language):
        if hasattr(ctx, 'icon_url'):  # pragma: no cover
            # special handling for domain elements of feature combinations
            return {'icon': ctx.icon_url}


class GeoJsonVariable(GeoJsonParameter):
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
            'label': value.domainelement.name if value.domainelement else value.name,
        }


def includeme(config):
    config.register_adapter(GeoJsonVariable, IParameter)
