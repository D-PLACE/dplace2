from clld.web.maps import Map, Layer
from clld.db.meta import DBSession

from dplace2.models import DplaceDataset, Society


class LanguagesMap(Map):
    def get_layers(self):
        yield Layer(
            'regions',
            'TDWG Level 2 Regions',
            self.req.static_url('dplace2:static/level2.geojson'))
        for ds in DBSession.query(DplaceDataset).join(Society).distinct():
            yield Layer(
                ds.id,
                ds.name,
                self.req.route_url(
                    'languages_alt',
                    ext='geojson',
                    _query=dict(contribution=str(ds.id), **self.req.query_params)
                ),
                #marker=helpers.map_marker_img(self.req, de, marker=self.map_marker)
            )

    def get_default_options(self):
        return {'hash': True, 'icon_size': 15, 'base_layer': "Esri.WorldPhysical"}


def includeme(config):
    config.register_map('languages', LanguagesMap)
