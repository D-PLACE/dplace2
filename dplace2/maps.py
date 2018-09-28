from clld.web.maps import Map, Layer, ParameterMap
from clld.db.meta import DBSession
from clld.web.util.helpers import map_marker_img

from dplace2.models import Societyset, Society


class LanguagesMap(Map):
    def __init__(self, ctx, req, eid='map', societyset=None):
        Map.__init__(self, ctx, req, eid=eid)
        self.societyset = societyset

    def get_layers(self):
        for ds in DBSession.query(Societyset).join(Society).distinct():
            if (not self.societyset) or ds.id == self.societyset:
                yield Layer(
                    ds.id,
                    ds.name,
                    self.req.route_url(
                        'languages_alt',
                        ext='geojson',
                        _query=dict(societyset=str(ds.id), **self.req.query_params)
                    ),
                    marker=map_marker_img(self.req, ds, marker=self.map_marker)
                )

    def get_default_options(self):
        return {'hash': True, 'icon_size': 15, 'base_layer': "Esri.WorldPhysical"}


class VariableMap(ParameterMap):
    def get_default_options(self):
        return {'hash': True, 'icon_size': 15, 'base_layer': "Esri.WorldPhysical"}


def includeme(config):
    config.register_map('parameter', VariableMap)
    config.register_map('languages', LanguagesMap)
