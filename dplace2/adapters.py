from clld.web.adapters.geojson import GeoJson


class GeoJsonSocieties(GeoJson):
    def feature_properties(self, ctx, req, language):
        if hasattr(ctx, 'icon_url'):  # pragma: no cover
            # special handling for domain elements of feature combinations
            return {'icon': ctx.icon_url}


def includeme(config):
    pass
