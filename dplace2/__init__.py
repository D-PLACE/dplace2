from pyramid.config import Configurator
from sqlalchemy.orm import joinedload
from clld.web.app import CtxFactoryQuery
from clld.interfaces import ICtxFactoryQuery, IMapMarker, IRepresentation, IParameter, IIndex
from clld.db.models import common
from clld.web.icon import MapMarker
from clldutils import svg

# we must make sure custom models are known at database initialization!
from dplace2 import models
from dplace2 import interfaces
from dplace2 import adapters
from dplace2 import datatables
from dplace2.interfaces import ISocietyset

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
_('Societyset')
_('Societysets')


class DplaceMapMarker(MapMarker):
    def __call__(self, ctx, req):
        icon = models.get_icon(ctx)
        if not icon:
            return MapMarker.__call__(self, ctx, req)  # pragma: no cover

        return svg.data_url(svg.icon(icon))


class DplaceCtxFactoryQuery(CtxFactoryQuery):
    def refined_query(self, query, model, req):
        if model == common.Contribution:
            return query.options(joinedload(models.DplaceDataset.variables))
        if model == models.Societyset:
            return query.options(joinedload(models.Societyset.societies))
        if model == common.Parameter:
            return query.options(
                joinedload(common.Parameter.domain),
                joinedload(common.Parameter.valuesets).joinedload(common.ValueSet.values),
                joinedload(common.Parameter.valuesets, common.ValueSet.language),
            )
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

    menuitems = config.registry.settings['clld.menuitems_list']
    config.register_menu(('about', dict(label='About')), *menuitems)

    #config.register_datatable('societyset', Phylogenies, overwrite=False)
    config.register_resource('societyset', models.Societyset, ISocietyset, with_index=True)
    config.registry.registerUtility(DplaceCtxFactoryQuery(), ICtxFactoryQuery)
    config.registry.registerUtility(DplaceMapMarker(), IMapMarker)

    #config.register_adapter(None, IParameter, IIndex, name='application/atom+xml')
    config.registry.unregisterAdapter(required=[IParameter], provided=IIndex, name='application/atom+xml')

    config.add_route('variable_on_tree', '/variable_on_tree')
    config.add_route('datasources', '/source')
    #/howto
    #/technology

    config.add_301('/angular/', lambda req: req.route_url('dataset'))
    config.add_301('/home', lambda req: req.route_url('dataset'))
    config.add_301('/team', lambda req: req.route_url('about', _anchor='team'))
    config.add_301('/publication', lambda req: req.route_url('about', _anchor='publications'))
    config.add_301('/howtocite', lambda req: req.route_url('about', _anchor='howtocite'))
    return config.make_wsgi_app()
