from __future__ import unicode_literals
import sys
from itertools import groupby

from sqlalchemy import func
from sqlalchemy.orm import joinedload_all
from clldutils.path import Path
from clldutils.misc import slug
from csvw.dsv import reader
from clld.scripts.util import initializedb, Data
from clld.db.meta import DBSession
from clld.db.models import common
from pycldf import StructureDataset

import dplace2
from dplace2 import models


DATA_REPOS = Path(dplace2.__file__).parent / '..' / '..' / 'dplace-data'


def main(args):
    data = Data()

    dataset = common.Dataset(
        id=dplace2.__name__,
        name="D-PLACE",
        publisher_name="Max Planck Institute for the Science of Human History",
        publisher_place="Jena",
        publisher_url="http://www.shh.mpg.de",
        license="http://creativecommons.org/licenses/by/4.0/",
        domain='dplace2.clld.org',
        jsondata={
            'license_icon': 'cc-by.png',
            'license_name': 'Creative Commons Attribution 4.0 International License'})

    DBSession.add(dataset)

    #
    # TODO: add editors!
    #

    dss = {}
    for row in sorted(
        reader(DATA_REPOS / 'datasets' / 'index.csv', namedtuples=True),
        key=lambda d: d.type
    ):
        c = data.add(
            models.DplaceDataset,
            row.id,
            id=row.id,
            name=row.name,
            description=row.reference,  # FIXME: we should have a real description!
            type=row.type)
        ds = StructureDataset.from_metadata(
            DATA_REPOS / 'cldf' / row.id / 'StructureDataset-metadata.json')
        try:
            for row in ds['LanguageTable']:
                data.add(
                    models.Society,
                    row['id'],
                    id=row['id'],
                    name=row['pref_name_for_society'],
                    latitude=row['Lat'],
                    longitude=row['Long'],
                    dataset=c,
                )
        except KeyError:
            # Dataset does not provide any societies
            pass

        try:
            for row in ds['ParameterTable']:
                v = data.add(
                    models.Variable,
                    row['id'],
                    id=row['id'].replace('.', '-'),
                    name='{0} [{1}]'.format(row['title'], row['id']),
                    description=row['definition'],
                    type=row['type'],
                    dataset=c,
                )
                for cat in set(row['category']):
                    obj = data['Category'].get(cat)
                    if not obj:
                        obj = data.add(models.Category, cat, id=slug(cat), name=cat)
                    DBSession.add(models.VariableCategory(variable=v, category=obj))

        except KeyError:
            # Dataset does not provide any variables
            pass

        dss[c.id] = ds

    DBSession.flush()

    for cid, ds in dss.items():
        try:
            for code in ds['CodeTable']:
                try:
                    number = int(code['code'])
                except ValueError:
                    number = None

                data.add(
                    models.Code,
                    (code['var_id'], code['code']),
                    id='{0}-{1}'.format(code['var_id'], code['code']).replace('.', '_'),
                    number=number,
                    abbr=code['code'],
                    name=code['name'],
                    description=code['description'],
                    parameter_pk=data['Variable'][code['var_id']].pk,
                )
        except KeyError:
            pass

    DBSession.flush()

    for cid, ds in dss.items():
        seen = set()
        c = data['DplaceDataset'][cid]
        for (var_id, soc_id), rows in groupby(
            sorted(ds['ValueTable'], key=lambda r: (r['var_id'], r['soc_id'])),
            lambda r: (r['var_id'], r['soc_id'])
        ):
            vsid = '{0}-{1}'.format(var_id, soc_id).replace('.', '_')
            vs = data.add(
                common.ValueSet,
                vsid,
                id=vsid,
                contribution=c,
                language=data['Society'][soc_id],
                parameter=data['Variable'][var_id],
            )
            for i, row in enumerate(rows):
                code = data['Code'].get((var_id, row['code']))
                if code:
                    k = (vsid, code.pk, row['code'])
                    if k in seen:
                        print('skipping duplicate value {0}'.format(k))
                        continue
                    seen.add(k)
                vid = '{0}-{1}'.format(vsid, i + 1)
                common.Value(id=vid, valueset=vs, name=row['code'], domainelement=code)


def prime_cache(args):
    """If data needs to be denormalized for lookup, do that here.
    This procedure should be separate from the db initialization, because
    it will have to be run periodically whenever data has been updated.
    """
    for var in DBSession.query(models.Variable).options(
        joinedload_all(models.Variable.category_assocs, models.VariableCategory.category)
    ):
        var.categories_str = '|'.join(ca.category.name for ca in var.category_assocs)

    for attr, t in [
        ('count_societies', models.Society),
        ('count_variables', models.Variable)
    ]:
        counts = DBSession.query(
            t.dataset_pk, func.count(t.pk)).group_by(t.dataset_pk).all()
        for pk, count in counts:
            setattr(models.DplaceDataset.get(pk), attr, count)


if __name__ == '__main__':  # pragma: no cover
    initializedb(create=main, prime_cache=prime_cache)
    sys.exit(0)
