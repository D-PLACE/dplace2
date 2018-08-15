from __future__ import unicode_literals
import sys
from itertools import groupby, chain
import re
from colorsys import hsv_to_rgb
from collections import defaultdict, OrderedDict
import math

import transaction
from sqlalchemy import func
from sqlalchemy.orm import joinedload_all
from clldutils.path import Path
from clldutils.misc import slug
from clld.scripts.util import initializedb, Data, bibtex2source
from clld.db.meta import DBSession
from clld.db.models import common
from clld.lib.color import qualitative_colors, sequential_colors
from clld.lib.bibtex import Database
from pycldf import StructureDataset
from pydplace.api import Repos

import dplace2
from dplace2 import models
from clld_phylogeny_plugin.models import TreeLabel, LanguageTreeLabel

DATA_REPOS = Path(dplace2.__file__).parent / '..' / '..' / 'dplace-data'
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

hraf_pattern = re.compile('(?P<name>[^(]+)\((?P<id>[^)/]+)')
SHAPES = list('ctfds')


def get_batches(codes):
    try:
        code_map = {int(code['code']): code['code'] for code in codes}
        codes = list(code_map.keys())
    except ValueError:
        return
    codes = sorted(codes, key=lambda n: n or 0)
    if len(codes) > 1 and codes[0] == 10 and codes[1] == 20:
        res = defaultdict(list)
        for code in codes:
            res[code // 10].append(code_map[code])
        if max(len(v) for v in res.values()) <= len(SHAPES):
            return [list(zip(v, SHAPES)) for k, v in sorted(res.items())]


def valid_id(s):
    return s.replace('.', '_')


def main(args):
    data = Data()
    repos = Repos(DATA_REPOS)

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

    for rec in Database.from_file(repos.path('datasets', 'sources.bib'), lowercase=True):
        data.add(common.Source, rec.id, _obj=bibtex2source(rec))

    regions = repos.read_json('geo', 'societies_tdwg.json')
    glottolog = {
        r.id: r for r in repos.read_csv('csv', 'glottolog.csv', namedtuples=True)}
    dscolors = qualitative_colors(len(repos.datasets))
    dss = {}
    for i, row in enumerate(sorted(repos.datasets, key=lambda d: (d.type, d.id))):
        c = data.add(
            models.DplaceDataset,
            row.id,
            id=row.id,
            name=row.name,
            description=row.reference,  # FIXME: we should have a real description!
            color=dscolors[i],
            type=row.type)
        ds = StructureDataset.from_metadata(
            repos.path('cldf', row.id, 'StructureDataset-metadata.json'))
        try:
            for row in ds['LanguageTable']:
                #alt_names_by_society
                if row['HRAF_name_ID']:
                    hraf_match = hraf_pattern.match(row['HRAF_name_ID'])
                else:
                    hraf_match = None
                data.add(
                    models.Society,
                    row['id'],
                    id=row['id'],
                    xid=row['xd_id'],
                    name=row['pref_name_for_society'],
                    latitude=row['Lat'],
                    longitude=row['Long'],
                    region=regions.get(row['id'], {}).get('name'),
                    dataset=c,
                    hraf_id=hraf_match.group('id') if hraf_match else None,
                    hraf_name=hraf_match.group('name') if hraf_match else None,
                    glottocode=row['glottocode'],
                    year=row['main_focal_year'],
                    name_in_source=row['ORIG_name_and_ID_in_this_dataset'],
                    language=glottolog[row['glottocode']].name,
                    language_family=glottolog[row['glottocode']].family_name or None,
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
        #
        # Testing
        #
        #break

    DBSession.flush()

    for cid, ds in dss.items():
        try:
            for var_id, codes in groupby(
                sorted(
                    ds['CodeTable'],
                    key=lambda i: (
                        i['var_id'],
                        i['code'].rjust(10, '0') if re.match('[0-9]+$', i['code']) else i['code'])),
                lambda i: i['var_id']
            ):
                codes = [code for code in codes if code['code'] != 'NA']
                batches = get_batches(codes)
                ncolors = len(batches) if batches else len(codes)
                colors = qualitative_colors(ncolors)
                if data['Variable'][var_id].type == 'Ordinal' and 3 <= ncolors <= 9:
                    colors = sequential_colors(ncolors)
                if batches:
                    icons = {}
                    for batch, color in zip(batches, colors):
                        for c, shape in batch:
                            icons[c] = shape + color[1:]
                    print(icons)
                else:
                    icons = dict(zip([c['code'] for c in codes], ['c' + c.replace('#', '') for c in colors]))
                for code in codes:
                    icon = icons[code['code']]
                    if var_id == 'EcoRegion':
                        icon = 'c' + biomes[code['code'][1:3]][1:]
                    elif var_id == 'Biome':
                        icon = 'c' + biomes['{0:02}'.format(int(code['code']))][1:]

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
                        icon=icon,
                        parameter_pk=data['Variable'][code['var_id']].pk,
                    )
        except KeyError:
            pass

    transaction.commit()

    for row in repos.phylogenies:
        transaction.begin()
        soc_by_id = {}
        soc_by_xid = defaultdict(list)
        for s in DBSession.query(models.Society):
            soc_by_id[s.id] = s.pk
            soc_by_xid[s.xid].append(s.pk)

        tree = models.DplacePhylogeny(
            id=row.id,
            name=row.name,
            description=row.reference,
            glottolog=row.is_glottolog,
            newick=row.newick,
            author=row.author,
            year=int(row.year),
            url=row.url,
            reference=row.reference,
        )
        for k, taxon in enumerate(row.taxa):
            label = TreeLabel(
                id='{0}-{1}-{2}'.format(tree.id, slug(taxon.taxon), k + 1),
                name=taxon.taxon,
                phylogeny=tree,
                description=taxon.glottocode)
            socpks = []
            for x in taxon.soc_ids:
                if x in soc_by_id:
                    spk = soc_by_id[x]
                    if spk not in socpks:
                        socpks.append(spk)
            for x in taxon.xd_ids:
                if x in soc_by_xid:
                    for spk in soc_by_xid[x]:
                        if spk not in socpks:
                            socpks.append(spk)
            for i, spk in enumerate(socpks):
                LanguageTreeLabel(ord=i + 1, language_pk=spk, treelabel=label)

        DBSession.add(tree)
        transaction.commit()

    year_pattern = re.compile('(?P<year>-?[0-9]+)')
    for cid, ds in dss.items():
        print(cid)
        transaction.begin()
        dsdata = Data()
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
                name = row['code']
                m = year_pattern.match(row['year'] or '')
                if m:
                    name += ' ({0})'.format(m.group('year'))
                if row['sub_case']:
                    name += ' [{0}]'.format(row['sub_case'])

                vid = '{0}-{1}'.format(vsid, i + 1)
                v, k = None, None
                code = codes.get(valid_id('{0}-{1}'.format(var_id, row['code'])))
                if code:
                    k = (vsid, code, name)
                    v = dsdata['Datapoint'].get(k)
                    if v:
                        v.frequency += 1
                if not v:
                    try:
                        fv = float(row['code'])
                    except (TypeError, ValueError):
                        fv = None
                    v = models.Datapoint(
                        id=vid,
                        valueset=vs,
                        name=name,#row['code'],
                        comment=row['comment'],
                        year=int(m.group('year')) if m else None,
                        sub_case=row['sub_case'],
                        value_float=fv,
                        frequency=1,
                        domainelement_pk=code)
                if code and k:
                    dsdata['Datapoint'][k] = v
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


def mlog(n):
    return math.log(max([n, 0.0001]))


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
        values = [v.value_float for v in chain(*[vs.values for vs in var.valuesets])]
        cminimum = minimum = min(values)
        cmaximum = maximum = max(values)

        dist = OrderedDict()
        step = (maximum - minimum) / 10
        val = minimum
        while val < maximum:
            dist[(val, val + step)] = 0
            val += step

        for v in sorted(values):
            for mi, ma in dist.keys():
                if mi <= v < ma:
                    dist[(mi, ma)] += 1

        dist = list(dist.values())
        log = False
        if dist[0] > (10 * dist[-1]):
            print(var.name)
            log = True
            try:
                cminimum = mlog(minimum)
            except ValueError:
                print(minimum)
                raise
            cmaximum = mlog(maximum)

        # check bucket sizes, if skewed towards minimum, use log, if skewed toward maximum, use exp

        incr = (maximum - minimum) / 6
        var.jsondata = {
            'range': [(minimum + i * incr, color(cminimum, cmaximum, (cminimum + i * (cmaximum - cminimum) / 6) if log else minimum + i * incr))
                      for i in range(7)]
        }

        for vs in var.valuesets:
            for v in vs.values:
                v.jsondata = {'color': color(cminimum, cmaximum, mlog(v.value_float) if log else float(v.value_float))}

    #return
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
