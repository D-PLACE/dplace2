from __future__ import unicode_literals
import sys
from itertools import groupby, chain
import re
from colorsys import hsv_to_rgb
from collections import defaultdict, OrderedDict
import math

import transaction
from sqlalchemy import func, distinct
from sqlalchemy.orm import joinedload_all, joinedload
from clldutils.path import Path
from clldutils.misc import slug
from clld.scripts.util import initializedb, Data, bibtex2source
from clld.db.meta import DBSession
from clld.db.models import common
from clld.lib.color import qualitative_colors, sequential_colors
from clld.lib.bibtex import Database
from pydplace.api import Repos

import dplace2
from dplace2 import models
from clld_phylogeny_plugin.models import TreeLabel, LanguageTreeLabel, Phylogeny

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
    '99': '#000000',
}

SHAPES = list('ctfds')


def get_batches(codes):  # pragma: no cover
    try:
        code_map = {int(code.code): code.code for code in codes}
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


def valid_id(s):  # pragma: no cover
    return s.replace('.', '_')


def main(args):  # pragma: no cover
    data = Data()
    repos = Repos(DATA_REPOS)

    dataset = common.Dataset(
        id=dplace2.__name__,
        name="D-PLACE",
        publisher_name="Max Planck Institute for the Science of Human History",
        publisher_place="Jena",
        publisher_url="https://www.shh.mpg.de",
        license="http://creativecommons.org/licenses/by-nc/4.0/",
        contact='dplace@shh.mpg.de',
        domain='dplace2.clld.org',
        jsondata={
            'license_icon': 'cc-by-nc.png',
            'license_name': 'Creative Commons Attribution-NonCommercial 4.0 International License'})

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
    altname_count = 0
    for i, ds in enumerate(sorted(repos.datasets, key=lambda d: (d.type, d.id))):
        if ds.societies:
            societyset = data.add(
                models.Societyset,
                ds.id,
                id=ds.id,
                name=ds.name,
                description=ds.description,
                reference=ds.reference,
                color=dscolors[i])
            for soc in ds.societies:
                s = data.add(
                    models.Society,
                    soc.id,
                    id=soc.id,
                    xid=soc.xd_id,
                    name=soc.pref_name_for_society,
                    latitude=soc.Lat,
                    longitude=soc.Long,
                    region=regions.get(soc.id, {}).get('name'),
                    societyset=societyset,
                    hraf_id=soc.HRAF_name_ID.id if soc.HRAF_name_ID else None,
                    hraf_name=soc.HRAF_name_ID.name if soc.HRAF_name_ID else None,
                    glottocode=soc.glottocode,
                    year=soc.main_focal_year,
                    name_in_source=soc.ORIG_name_and_ID_in_this_dataset,
                    language=glottolog[soc.glottocode].name,
                    language_family=glottolog[soc.glottocode].family_name or None,
                )
                for n in soc.alt_names_by_society:
                    altname_count += 1
                    common.LanguageIdentifier(
                        language=s,
                        identifier=common.Identifier(
                            name=n, type='Other names', id=str(altname_count)))

        if ds.variables:
            dataset = data.add(
                models.DplaceDataset,
                ds.id,
                id=ds.id,
                name=ds.name,
                description=ds.description,
                reference=ds.reference,
                type=ds.type)
            for row in ds.variables:
                v = data.add(
                    models.Variable,
                    row.id,
                    id=valid_id(row.id),
                    name='{0} [{1}]'.format(row.title, row.id),
                    description=row.definition,
                    type=row.type,
                    dataset=dataset,
                )
                for cat in set(row.category):
                    obj = data['Category'].get(slug(cat))
                    if not obj:
                        obj = data.add(models.Category, slug(cat), id=slug(cat), name=cat)
                    DBSession.add(models.VariableCategory(variable=v, category=obj))

                codes = [code for code in row.codes if code.code != 'NA']
                batches = get_batches(codes)
                ncolors = len(batches) if batches else len(codes)
                colors = qualitative_colors(ncolors)
                if v.type == 'Ordinal' and 3 <= ncolors <= 9:
                    colors = sequential_colors(ncolors)
                if batches:
                    icons = {}
                    for batch, color in zip(batches, colors):
                        for c, shape in batch:
                            icons[c] = shape + color[1:]
                else:
                    icons = dict(zip([c.code for c in codes], ['c' + c.replace('#', '') for c in colors]))
                for code in codes:
                    icon = icons[code.code]
                    if v.id == 'EcoRegion':
                        icon = 'c' + biomes[code.code[1:3]][1:]
                    elif v.id == 'Biome':
                        icon = 'c' + biomes['{0:02}'.format(int(code.code))][1:]

                    try:
                        number = int(code.code)
                    except ValueError:
                        number = None

                    data.add(
                        models.Code,
                        (v.id, code.code),
                        id=valid_id('{0}-{1}'.format(code.var_id, code.code)),
                        number=number,
                        abbr=code.code,
                        name=code.name,
                        description=code.description,
                    icon=icon,
                    parameter=v,
                )
        dss[ds.id] = ds

    DBSession.flush()

    for ds in dss.values():
        #
        # FIXME: do we have to evaluate xd_id as well?
        #
        for relsocs in ds.society_relations:
            soc = data['Society'][relsocs.id]
            for relsoc in relsocs.related:
                if relsoc.dataset in dss and relsoc.id in data['Society']:
                    # A relation between two societies in D-PLACE!
                    DBSession.add(
                        models.SocietyRelation(from_pk=soc.pk, to_pk=data['Society'][relsoc.id].pk))
                else:
                    # An external relation; we just add a LanguageIdentifier
                    identifier = data['Identifier'].get((relsoc.dataset, relsoc.id))
                    if not identifier:
                        identifier = data.add(
                            common.Identifier,
                            (relsoc.dataset, relsoc.id),
                            id='{0}-{1}'.format(relsoc.dataset, relsoc.id),
                            name='{0}'.format(relsoc),
                            type=relsoc.dataset)
                    DBSession.add(common.LanguageIdentifier(language=soc, identifier=identifier))

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
            sorted(ds.data, key=lambda r: (r.var_id, r.soc_id)), lambda r: (r.var_id, r.soc_id)
        ):
            rows = [row for row in rows if row.code != 'NA']
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
                name = row.code
                m = year_pattern.match(row.year or '')
                if m:
                    name += ' ({0})'.format(m.group('year'))
                if row.sub_case:
                    name += ' [{0}]'.format(row.sub_case)

                vid = '{0}-{1}'.format(vsid, i + 1)
                v, k = None, None
                code = codes.get(valid_id('{0}-{1}'.format(var_id, row.code)))
                if code:
                    k = (vsid, code, name)
                    v = dsdata['Datapoint'].get(k)
                    if v:
                        v.frequency += 1
                if not v:
                    try:
                        fv = float(row.code)
                    except (TypeError, ValueError):
                        fv = None
                    v = models.Datapoint(
                        id=vid,
                        valueset=vs,
                        name=name,#row['code'],
                        comment=row.comment,
                        year=int(m.group('year')) if m else None,
                        sub_case=row.sub_case,
                        value_float=fv,
                        frequency=1,
                        domainelement_pk=code)
                if code and k:
                    dsdata['Datapoint'][k] = v
                for ref in row.references:
                    models.DatapointReference(
                        value=v, source_pk=sources[ref.key], description=ref.pages or None)
        transaction.commit()


def color(minval, maxval, val):  # pragma: no cover
    """ Convert val in range minval..maxval to the range 0..120 degrees which
        correspond to the colors Red and Green in the HSV colorspace.
    """
    h = 120 - (float(val-minval) / (maxval-minval)) * 120

    # Convert hsv color (h,1,1) to its rgb equivalent.
    # Note: hsv_to_rgb() function expects h to be in the range 0..1 not 0..360
    return '#' + ''.join("{0:02x}".format(int(255*n)) for n in hsv_to_rgb(h/360, 1., 1.))


def mlog(n):  # pragma: no cover
    return math.log(max([n, 0.0001]))


def prime_cache(args):  # pragma: no cover
    """If data needs to be denormalized for lookup, do that here.
    This procedure should be separate from the db initialization, because
    it will have to be run periodically whenever data has been updated.
    """
    for var in DBSession.query(models.Variable).options(
        joinedload_all(models.Variable.category_assocs, models.VariableCategory.category)
    ):
        var.categories_str = '|'.join(ca.category.name for ca in var.category_assocs)

    socs_by_var = {}
    for var in DBSession.query(models.Variable)\
            .options(joinedload_all(models.Variable.valuesets, common.ValueSet.values)):
        socs_by_var[var.pk] = set(vs.language_pk for vs in var.valuesets)
        if var.type != 'Continuous':
            continue
        values = [v.value_float for v in chain(*[vs.values for vs in var.valuesets])]
        cminimum = minimum = min(values)
        cmaximum = maximum = max(values)

        dist = OrderedDict()  # We compute the distribution of values on equidistant intervals.
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
            # If there are a lot more values in the first bucket in comparison to the last one,
            # we assume a logarithmic scale.
            print(var.name)
            log = True
            cminimum = mlog(minimum)
            cmaximum = mlog(maximum)
        #
        # FIXME: If the distribution is skewed towards the higher values, we may assume an
        # exponential scale!
        #
        incr = (maximum - minimum) / 6
        var.jsondata = {
            'range': [(minimum + i * incr, color(cminimum, cmaximum, (cminimum + i * (cmaximum - cminimum) / 6) if log else minimum + i * incr))
                      for i in range(7)]
        }

        for vs in var.valuesets:
            for v in vs.values:
                v.jsondata = {'color': color(cminimum, cmaximum, mlog(v.value_float) if log else float(v.value_float))}

    for soc1, socset1 in socs_by_var.items():
        for soc2, socset2 in socs_by_var.items():
            if soc1 != soc2 and socset1.intersection(socset2):
                DBSession.add(models.VariableVariable(variable_pk=soc1, comparable_pk=soc2))

    soc_counts = DBSession.query(
            common.ValueSet.contribution_pk, func.count(distinct(common.ValueSet.language_pk))
    ).group_by(common.ValueSet.contribution_pk).all()
    for pk, count in soc_counts:
        models.DplaceDataset.get(pk).count_societies = count

    for ds in DBSession.query(models.DplaceDataset):
        for sspk in DBSession.query(models.Society.societyset_pk).join(common.ValueSet).filter(common.ValueSet.contribution_pk == ds.pk).distinct():
            DBSession.add(models.DatasetSocietyset(dataset_pk=ds.pk, societyset_pk=sspk))

    counts = DBSession.query(
        models.Variable.dataset_pk, func.count(models.Variable.pk)).group_by(models.Variable.dataset_pk).all()
    for pk, count in counts:
        models.DplaceDataset.get(pk).count_variables = count

    for ss in DBSession.query(models.Societyset).options(joinedload(models.Societyset.societies)):
        ss.count_societies = len(ss.societies)

    srs = {
        k: v for k, v in DBSession.execute("""\
select l.pk, array_agg(distinct dpr.source_pk) 
from language as l, valueset as vs, value as v, datapointreference as dpr 
where l.pk = vs.language_pk and vs.pk = v.valueset_pk and v.pk = dpr.value_pk 
group by l.pk""")}
    for lpk, sspks in srs.items():
        for spk in sspks:
            DBSession.add(common.LanguageSource(language_pk=lpk, source_pk=spk))

    for phy in DBSession.query(Phylogeny).options(joinedload_all(Phylogeny.treelabels, TreeLabel.language_assocs)):
        soc_set = defaultdict(list)
        for tl in phy.treelabels:
            for la in tl.language_assocs:
                soc_set[la.language_pk].append(tl.name)

        for spk, labels in soc_set.items():
            DBSession.add(models.SocietyPhylogeny(
                society_pk=spk, phylogeny_pk=phy.pk, label=' / '.join(labels)))

        soc_set = set(soc_set.keys())
        for vpk, socs in socs_by_var.items():
            if soc_set.intersection(socs):
                DBSession.add(models.VariablePhylogeny(variable_pk=vpk, phylogeny_pk=phy.pk))


if __name__ == '__main__':  # pragma: no cover
    initializedb(create=main, prime_cache=prime_cache)
    sys.exit(0)
