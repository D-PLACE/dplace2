from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound

from dplace2 import models


@view_config(route_name='variable_on_tree')
def variable_on_tree(req):
    return HTTPFound(req.resource_url(
        models.DplacePhylogeny.get(req.params['phylogeny']),
        _query=dict(parameter=req.params['parameter'])))
