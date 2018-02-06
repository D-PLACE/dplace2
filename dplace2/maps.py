from clld.web.maps import Map, Layer, ParameterMap
from clld.db.meta import DBSession
from clld.web.util.helpers import map_marker_img

from dplace2.models import DplaceDataset, Society


class LanguagesMap(Map):
    def get_layers(self):
        for ds in DBSession.query(DplaceDataset).join(Society).distinct():
            yield Layer(
                ds.id,
                ds.name,
                self.req.route_url(
                    'languages_alt',
                    ext='geojson',
                    _query=dict(contribution=str(ds.id), **self.req.query_params)
                ),
                marker=map_marker_img(self.req, ds, marker=self.map_marker)
            )
        yield Layer(
            'regions',
            'TDWG Level 2 Regions',
            self.req.static_url('dplace2:static/level2.geojson'))

    def get_default_options(self):
        return {'hash': True, 'icon_size': 15, 'base_layer': "Esri.WorldPhysical"}


class VariableMap(ParameterMap):
    def get_default_options(self):
        res = ParameterMap.get_default_options(self)
        res['icons'] = 'div'
        return res


def includeme(config):
    config.register_map('languages', LanguagesMap)
    config.register_map('parameter', VariableMap)
