from __future__ import unicode_literals

from pyramid.config import Configurator
from sqlalchemy.orm import joinedload
from clld.web.app import CtxFactoryQuery
from clld.interfaces import ICtxFactoryQuery, IMapMarker
from clld.db.models import common
from clld.web.icon import MapMarker
from clld.lib import svg

# we must make sure custom models are known at database initialization!
from dplace2 import models
from dplace2 import interfaces
from dplace2 import adapters
from dplace2 import datatables

_ = lambda s: s
_('Language')
_('Languages')
_('Contribution')
_('Contributions')
_('Phylogeny')
_('Phylogenys')
_('Parameter')
_('Parameters')
_('DomainElement')
_('DomainElements')
_('Value')
_('Values')


class DplaceMapMarker(MapMarker):
    def __call__(self, ctx, req):
        icon = models.get_icon(ctx)
        if not icon:
            return MapMarker.__call__(self, ctx, req)

        return svg.data_url(svg.icon(icon))


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
    config.include('clld_phylogeny_plugin')
    config.registry.registerUtility(DplaceCtxFactoryQuery(), ICtxFactoryQuery)
    config.registry.registerUtility(DplaceMapMarker(), IMapMarker)
    config.add_route('variable_on_tree', '/variable_on_tree')
    config.add_301('/team', lambda req: req.route_url('about', _anchor='team'))
    config.add_301('/publication', lambda req: req.route_url('about', _anchor='publications'))
    config.add_301('/howtocite', lambda req: req.route_url('about', _anchor='howtocite'))
    config.add_301('/source', lambda req: req.route_url('contributions'))
    return config.make_wsgi_app()
