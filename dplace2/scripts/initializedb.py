from __future__ import unicode_literals
import sys
from itertools import groupby, cycle, chain
import re
from colorsys import hsv_to_rgb

import transaction
from sqlalchemy import func
from sqlalchemy.orm import joinedload_all
from clldutils.path import Path
from clldutils.misc import slug
from clldutils.jsonlib import load
from csvw.dsv import reader
from clld.scripts.util import initializedb, Data, bibtex2source
from clld.db.meta import DBSession
from clld.db.models import common
from clld.lib.bibtex import Database
from pycldf import StructureDataset

import dplace2
from dplace2 import models

DATA_REPOS = Path(dplace2.__file__).parent / '..' / '..' / 'dplace-data'
colorMap = [  # https://sashat.me/2017/01/11/list-of-20-simple-distinct-colors/
    '#e6194b',
    '#3cb44b',
    '#ffe119',
    '#0082c8',
    '#f58231',
    '#911eb4',
    '#46f0f0',
    '#f032e6',
    '#d2f53c',
    '#fabebe',
    '#008080',
    '#e6beff',
    '#aa6e28',
    '#fffac8',
    '#800000',
    '#aaffc3',
    '#808000',
    '#ffd8b1',
    '#000080',
    '#808080',
    '#FFFFFF',
    '#000000',
    '#FF0000',
    '#00FF00',
    '#0000FF',
]

biomes = {
    '01': '#00ff00',
    '02': '#b2e519',
    '03': '#adff2f',
    '04': '#3cb371',
    '05': '#3cb371',
    '06': '#d5fe00',
    '07': '#feac00',
    '08': '#ffd700',
    '09': '#7fffd4',
    '10': '#d2b48c',
    '11': '#00cc00',
    '12': '#ff0000',
    '13': '#f08080',
    '14': '#9f21a3',
    '15': '#ffffff',
    '16': '#d5d8e6',
}


def valid_id(s):
    return s.replace('.', '_')


def main(args):
    data = Data()

    dataset = common.Dataset(
        id=dplace2.__name__,
        name="D-PLACE",
        publisher_name="Max Planck Institute for the Science of Human History",
        publisher_place="Jena",
        publisher_url="http://www.shh.mpg.de",
        license="http://creativecommons.org/licenses/by/4.0/",
        contact='dplace@shh.mpg.de',
        domain='dplace2.clld.org',
        jsondata={
            'license_icon': 'cc-by.png',
            'license_name': 'Creative Commons Attribution 4.0 International License'})

    for i, (id_, name) in enumerate([
        ('kirbykate', 'Kate Kirby'),
        ('greenhillsimon', 'Simon Greenhill'),
        ('forkelrobert', 'Robert Forkel'),
    ]):
        ed = data.add(common.Contributor, id_, id=id_, name=name)
        common.Editor(dataset=dataset, contributor=ed, ord=i + 1)
    DBSession.add(dataset)

    for rec in Database.from_file(DATA_REPOS / 'datasets' / 'sources.bib', lowercase=True):
        data.add(common.Source, rec.id, _obj=bibtex2source(rec))

    regions = load(DATA_REPOS / 'geo' / 'societies_tdwg.json')
    dscolors = cycle(colorMap)
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
            color=next(dscolors),
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
                    region=regions.get(row['id'], {}).get('name'),
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
                    id=valid_id(row['id']),
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
            for var_id, codes in groupby(
                sorted(
                    ds['CodeTable'],
                    key=lambda i: (
                        i['var_id'],
                        int(i['code']) if re.match('[0-9]+$', i['code']) else i['code'])),
                lambda i: i['var_id']
            ):
                codes = [code for code in codes if code['code'] != 'NA']
                for i, code in enumerate(codes):
                    if len(codes) <= len(colorMap):
                        color = colorMap[i]
                    else:
                        color = '#f58231'

                    if var_id == 'EcoRegion':
                        color = biomes[code['code'][1:3]]
                    elif var_id == 'Biome':
                        color = biomes['{0:02}'.format(int(code['code']))]

                    try:
                        number = int(code['code'])
                    except ValueError:
                        number = None

                    data.add(
                        models.Code,
                        (var_id, code['code']),
                        id=valid_id('{0}-{1}'.format(code['var_id'], code['code'])),
                        number=number,
                        abbr=code['code'],
                        name=code['name'],
                        description=code['description'],
                        color=color,
                        parameter_pk=data['Variable'][code['var_id']].pk,
                    )
        except KeyError:
            pass

    transaction.commit()

    year_pattern = re.compile('(?P<year>-?[0-9]+)')
    for cid, ds in dss.items():
        print(cid)
        transaction.begin()
        seen = set()
        c = models.DplaceDataset.get(cid)

        societies = {
            k: v for k, v in DBSession.query(models.Society.id, models.Society.pk)}
        variables = {
            k: v for k, v in DBSession.query(models.Variable.id, models.Variable.pk)}
        codes = {
            k: v for k, v in DBSession.query(models.Code.id, models.Code.pk)}
        sources = {
            k: v for k, v in DBSession.query(common.Source.id, common.Source.pk)}

        for (var_id, soc_id), rows in groupby(
            sorted(ds['ValueTable'], key=lambda r: (r['var_id'], r['soc_id'])),
            lambda r: (r['var_id'], r['soc_id'])
        ):
            rows = [row for row in rows if row['code'] != 'NA']
            if not rows:
                continue

            vsid = '{0}-{1}'.format(var_id, soc_id).replace('.', '_')
            vs = data.add(
                common.ValueSet,
                vsid,
                id=vsid,
                contribution=c,
                language_pk=societies[soc_id],
                parameter_pk=variables[valid_id(var_id)],
            )
            for i, row in enumerate(rows):
                code = codes.get(valid_id('{0}-{1}'.format(var_id, row['code'])))
                if code:
                    k = (vsid, code, row['code'])
                    if k in seen:
                        print('skipping duplicate value {0}'.format(k))
                        continue
                    seen.add(k)
                vid = '{0}-{1}'.format(vsid, i + 1)
                m = year_pattern.match(row['year'] or '')
                try:
                    fv = float(row['code'])
                except (TypeError, ValueError):
                    fv = None
                v = models.Datapoint(
                    id=vid,
                    valueset=vs,
                    name=row['code'],
                    comment=row['comment'],
                    year=int(m.group('year')) if m else None,
                    sub_case=row['sub_case'],
                    value_float=fv,
                    domainelement_pk=code)
                for ref in row['references']:
                    sid, _, desc = ref.partition(':')
                    models.DatapointReference(
                        value=v, source_pk=sources[sid], description=desc or None)
        transaction.commit()


def color(minval, maxval, val):
    """ Convert val in range minval..maxval to the range 0..120 degrees which
        correspond to the colors Red and Green in the HSV colorspace.
    """
    h = 120 - (float(val-minval) / (maxval-minval)) * 120

    # Convert hsv color (h,1,1) to its rgb equivalent.
    # Note: hsv_to_rgb() function expects h to be in the range 0..1 not 0..360
    return '#' + ''.join("{0:02x}".format(int(255*n)) for n in hsv_to_rgb(h/360, 1., 1.))


def prime_cache(args):
    """If data needs to be denormalized for lookup, do that here.
    This procedure should be separate from the db initialization, because
    it will have to be run periodically whenever data has been updated.
    """
    for var in DBSession.query(models.Variable).options(
        joinedload_all(models.Variable.category_assocs, models.VariableCategory.category)
    ):
        var.categories_str = '|'.join(ca.category.name for ca in var.category_assocs)

    for var in DBSession.query(models.Variable)\
            .options(joinedload_all(models.Variable.valuesets, common.ValueSet.values))\
            .filter(models.Variable.type == 'Continuous'):
        minimum = min(float(v.name) for v in chain(*[vs.values for vs in var.valuesets]))
        maximum = max(float(v.name) for v in chain(*[vs.values for vs in var.valuesets]))
        incr = (maximum - minimum) / 6
        var.jsondata = {
            'range': [(minimum + i * incr, color(minimum, maximum, minimum + i * incr))
                      for i in range(7)]
        }

        for vs in var.valuesets:
            for v in vs.values:
                v.jsondata = {'color': color(minimum, maximum, float(v.name))}

    for attr, t in [
        ('count_societies', models.Society),
        ('count_variables', models.Variable)
    ]:
        counts = DBSession.query(
            t.dataset_pk, func.count(t.pk)).group_by(t.dataset_pk).all()
        for pk, count in counts:
            setattr(models.DplaceDataset.get(pk), attr, count)

    srs = {
        k: v for k, v in DBSession.execute("""\
select l.pk, array_agg(distinct dpr.source_pk) 
from language as l, valueset as vs, value as v, datapointreference as dpr 
where l.pk = vs.language_pk and vs.pk = v.valueset_pk and v.pk = dpr.value_pk 
group by l.pk""")}
    for lpk, sspks in srs.items():
        for spk in sspks:
            DBSession.add(common.LanguageSource(language_pk=lpk, source_pk=spk))


if __name__ == '__main__':  # pragma: no cover
    initializedb(create=main, prime_cache=prime_cache)
    sys.exit(0)
