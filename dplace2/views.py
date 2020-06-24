from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound, HTTPNotFound

from dplace2 import models


@view_config(route_name='variable_on_tree')
def variable_on_tree(req):
    try:
        return HTTPFound(req.resource_url(
            models.DplacePhylogeny.get(req.params['phylogeny']),
            _query=[('parameter', pid) for pid in req.params.getall('parameter')]))
    except KeyError:
        return HTTPNotFound()


@view_config(route_name='datasources', renderer='datasources.mako')
def datasources(req):
    return {}
