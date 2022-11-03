from clld.web.maps import Map, Layer, ParameterMap, CombinationMap, Legend
from clld.db.meta import DBSession
from clld.web.util.helpers import map_marker_img
from clld.web.util.htmllib import HTML
from clld.web.adapters.geojson import GeoJson
from clldutils.svg import pie, data_url

from dplace2.models import Societyset, Society, get_icon, grouped_values


class CombinationGeojson(GeoJson):
    def feature_iterator(self, ctx, req):
        return grouped_values(ctx)

    def get_language(self, ctx, req, feature):
        return feature[0]

    def feature_properties(self, ctx, req, feature):
        colors, stroke = [], False
        for param in ctx.parameters:
            values = feature[1][param.pk]
            colors.append('#' + get_icon(values[0])[1:])
            if len(set(v.name for v in values)) > 1:
                stroke = '#ff0000'
        return {
            'icon': data_url(pie([1 for _ in colors], colors, width=20, stroke_circle=stroke)),
        }


class DplaceCombinationMap(CombinationMap):
    def get_layers(self):
        yield Layer(
                'l',
                'llll',
                CombinationGeojson(None).render(self.ctx, self.req, dump=False),
            )

    def get_legends(self):
        def icon(p):
            return HTML.span(
                HTML.img(
                    width=20,
                    src=data_url(pie(
                        [1 for _ in self.ctx.parameters],
                        ['#ffffff' if p != pp else '#000000' for pp in self.ctx.parameters]))),
                ' ',
                p.name,
            )
        yield Legend(
            self,
            'pie',
            [icon(p) for p in self.ctx.parameters],
            label='Variable')

    def get_default_options(self):
        return {'hash': True, 'icon_size': 15}


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
        return {
            'hash': True, 
            'icon_size': 15, 
            'resize_direction': 's',
        }


class VariableMap(ParameterMap):
    def get_default_options(self):
        return {
            'hash': True, 
            'icon_size': 15, 
            'resize_direction': 's',
        }


def includeme(config):
    config.register_map('parameter', VariableMap)
    config.register_map('languages', LanguagesMap)
    config.register_map('combination', DplaceCombinationMap)
