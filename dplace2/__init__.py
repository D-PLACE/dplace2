from pyramid.config import Configurator
from sqlalchemy.orm import joinedload
from clld.web.app import CtxFactoryQuery
from clld.interfaces import ICtxFactoryQuery
from clld.db.models import common

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
    return config.make_wsgi_app()
