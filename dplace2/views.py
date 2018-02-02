from itertools import chain

from sqlalchemy.orm import aliased, joinedload
from pyramid.view import view_config
from pyramid.httpexceptions import HTTPFound
from clld.db.meta import DBSession
from clld.db.models import common

from dplace2 import models


@view_config(route_name='dcombination', renderer='combination.mako')
def combination(req):
    p = [
        (p, {de.pk: de for de in p.domain or []}) for p in
        DBSession.query(common.Parameter)\
        .filter(common.Parameter.id.in_(['B0{0}'.format(i + 1) for i in range(14, 18, 1)]))\
        .options(joinedload(common.Parameter.domain))]
    vs = [aliased(common.ValueSet) for _ in range(len(p))]
    v = [aliased(common.Value) for _ in range(len(p))]
    entities = [common.Language] + list(chain(*zip(v, vs)))
    q = DBSession.query(*entities).order_by(common.Language.name)
    for i in range(len(p)):
        q = q.filter(v[i].valueset_pk == vs[i].pk)
        q = q.filter(vs[i].language_pk == common.Language.pk)
        q = q.filter(vs[i].parameter_pk == p[i][0].pk)
    return {
        'params': p,
        'res': q.all()
    }
