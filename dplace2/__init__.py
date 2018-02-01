from __future__ import unicode_literals

from base64 import b64encode

from pyramid.config import Configurator
from sqlalchemy.orm import joinedload
from clld.web.app import CtxFactoryQuery
from clld.interfaces import ICtxFactoryQuery, IMapMarker
from clld.db.models import common
from clld.web.icon import MapMarker
from clld.web.util.helpers import data_uri

# we must make sure custom models are known at database initialization!
from dplace2 import models

_ = lambda s: s
_('Language')
_('Languages')
_('Contribution')
_('Contributions')
_('Parameter')
_('Parameters')
_('DomainElement')
_('DomainElements')


class DplaceMapMarker(MapMarker):
    def __call__(self, ctx, req):
        color = None
        if isinstance(ctx, common.ValueSet):
            value = ctx.values[0]
            if value.domainelement:
                color = value.domainelement.color
            elif 'color' in value.jsondata or {}:
                color = value.jsondata['color']
        elif isinstance(ctx, common.Value):
            if ctx.domainelement:
                color = ctx.domainelement.color
            elif 'color' in ctx.jsondata or {}:
                color = ctx.jsondata['color']
        elif isinstance(ctx, common.DomainElement):
            color = ctx.color
        elif isinstance(ctx, common.Language):
            color = ctx.dataset.color
        elif isinstance(ctx, common.Contribution):
            color = ctx.color

        if not color:
            return MapMarker.__call__(self, ctx, req)

        svg = """\
<svg xmlns="http://www.w3.org/2000/svg" 
     xmlns:xlink="http://www.w3.org/1999/xlink"
     height="20"
     width="20">
    <circle cx="10" cy="10" r="8" style="stroke:#000000; fill:{0}" opacity="0.8"/>
</svg>""".format(color)
        return 'data:image/svg+xml;base64,%s' % b64encode(svg.encode('utf8')).decode()


class DplaceCtxFactoryQuery(CtxFactoryQuery):
    def refined_query(self, query, model, req):
        if model == common.Contribution:
            return query.options(joinedload(models.DplaceDataset.variables))
        return query


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    settings['route_patterns'] = {
        'language': '/society/{id:[^/\.]+}',
    }
    config = Configurator(settings=settings)
    config.include('clldmpg')
    config.registry.registerUtility(DplaceCtxFactoryQuery(), ICtxFactoryQuery)
    config.registry.registerUtility(DplaceMapMarker(), IMapMarker)
    return config.make_wsgi_app()
