import re
import colorsys
import itertools
import collections

from clld.db.models import common
from clld.db.meta import DBSession
from clld.cliutil import Data
from clld_phylogeny_plugin.models import TreeLabel, LanguageTreeLabel
from clldutils.misc import slug
from clldutils.color import qualitative_colors, sequential_colors, diverging_colors
from pycldf import Sources

import dplace2
from dplace2 import models

BIOMES = {
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


def color(minval, maxval, val):  # pragma: no cover
    """ Convert val in range minval..maxval to the range 0..120 degrees which
        correspond to the colors Red and Green in the HSV colorspace.
    """
    h = 120 - (float(val-minval) / (maxval-minval)) * 120

    # Convert hsv color (h,1,1) to its rgb equivalent.
    # Note: hsv_to_rgb() function expects h to be in the range 0..1 not 0..360
    return '#' + ''.join("{0:02x}".format(int(255*n)) for n in colorsys.hsv_to_rgb(h/360, 1., 1.))


def get_batches(codes):  # pragma: no cover
    """
    Make sure the sub-codes for some SCCS variables are batched appropriately.

    $ csvcut -c var_id,code ../dplace-data/datasets/SCCS/codes.csv| grep SCCS1764
    SCCS1764,NA
    SCCS1764,10
    SCCS1764,20
    SCCS1764,21
    SCCS1764,22
    SCCS1764,30
    SCCS1764,31
    SCCS1764,32
    """
    try:
        code_map = {int(code['ord']): code['ord'] for code in codes}
        codes = list(code_map.keys())
    except (ValueError, TypeError):
        return
    codes = sorted(codes, key=lambda n: n or 0)
    if len(codes) > 1 and codes[0] == 10 and codes[1] == 20:
        res = collections.defaultdict(list)
        for code in codes:
            res[code // 10].append(code_map[code])
        if max(len(v) for v in res.values()) <= len(SHAPES):
            return [list(zip(v, SHAPES)) for k, v in sorted(res.items())]


def add_metadata(data):
    dataset = common.Dataset(
        id=dplace2.__name__,
        name="D-PLACE",
        publisher_name="Max Planck Institute for Evolutionary Anthropology",
        publisher_place="Leipzig",
        publisher_url="https://www.eva.mpg.de",
        license="http://creativecommons.org/licenses/by-nc/4.0/",
        contact='dplace@eva.mpg.de',
        domain='dplace2.clld.org',
        jsondata={
            'license_icon': 'cc-by-nc.png',
            'license_name': 'Creative Commons Attribution-NonCommercial 4.0 International License'})

    for i, (id_, name) in enumerate([
        ('chiraangela', 'Angela Chira'),
        ('hrncirvaclav', 'Václav Hrnčíř'),
        ('forkelrobert', 'Robert Forkel'),
        ('greenhillsimon', 'Simon Greenhill'),
        ('grayrussell', 'Russell Gray'),
    ]):
        ed = data.add(common.Contributor, id_, id=id_, name=name)
        common.Editor(dataset=dataset, contributor=ed, ord=i + 1)
    return dataset


def add_society(data, societyset, soc, glangs, societies_by_glottocode, altname_count):
    glang = glangs[soc['Glottocode']]
    s = data.add(
        models.Society,
        soc['ID'],
        id=soc['ID'],
        xid=soc['xd_id'],
        name=soc['Name'],
        latitude=soc['Latitude'],
        longitude=soc['Longitude'],
        region=soc['region'],
        societyset=societyset,
        hraf_id=soc['HRAF_ID'],
        hraf_name=soc['HRAF_name_ID'],
        glottocode=soc['Glottocode'],
        year=soc['main_focal_year'],
        name_in_source=soc['Name_and_ID_in_source'],
        language=glang.name,
        language_family=glangs[glang.lineage[0][1]].name if glang.lineage else None,
    )
    societies_by_glottocode[soc['Glottocode']].append(s)
    if (len(soc['Language_Level_Glottocodes']) == 1
            and soc['Language_Level_Glottocodes'][0] != soc['Glottocode']):
        societies_by_glottocode[soc['Language_Level_Glottocodes'][0]].append(s)
    for n in soc['alt_names_by_society']:
        altname_count += 1
        common.LanguageIdentifier(
            language=s,
            identifier=common.Identifier(
                name=n, type='Other names', id=str(altname_count)))


def add_variable(data, dataset, row, codes_by_variable):
    v = data.add(
        models.Variable,
        row['ID'],
        id=row['ID'],
        name='{0} [{1}]'.format(row['Name'], row['ID']),
        description=row['Description'],
        type=row['type'],
        dataset=dataset,
    )
    for cat in set(row['category']):
        obj = data['Category'].get(slug(cat))
        if not obj:
            obj = data.add(models.Category, slug(cat), id=slug(cat), name=cat)
        DBSession.add(models.VariableCategory(variable=v, category=obj))

    codes = [code for code in codes_by_variable.get(row['ID'], []) if not code['ID'].endswith('-NA')]
    if all(not c['ord'] for c in codes):
        # We must substitute "ord" for the ccmc variable!
        for i, c in enumerate(codes):
            c['ord'] = i + 1
    batches = get_batches(codes)
    ncolors = len(batches) if batches else len(codes)
    colors = qualitative_colors(ncolors)
    if v.type == 'Ordinal':
        codes = sorted(codes, key=lambda c: float(c['ord']))
        if 3 <= ncolors <= 9:
            colors = sequential_colors(ncolors)
        elif 10 <= ncolors <= 11:
            colors = diverging_colors(ncolors)
        elif ncolors > 11:
            colors = [color(float(codes[0]['ord']), float(codes[-1]['ord']), float(c['ord'])) for c in codes]
    if batches:
        icons = {}
        for batch, color_ in zip(batches, colors):
            for c, shape in batch:
                icons[c] = shape + color_[1:]
    else:
        icons = dict(zip([c['ord'] for c in codes], ['c' + c.replace('#', '') for c in colors]))
    assert len(codes) == len({c['ord'] for c in codes}), codes
    for code in codes:
        icon = icons[code['ord']]
        if v.id == 'EcoRegion':
            icon = 'c' + BIOMES[str(code['ord'])[1:3]][1:]
        elif v.id == 'Biome':
            icon = 'c' + BIOMES['{0:02}'.format(code['ord'])][1:]

        try:
            number = int(code['ord'])
        except (ValueError, TypeError):
            number = None

        data.add(
            models.Code,
            code['ID'],
            id=code['ID'],
            number=number,
            abbr=str(code['ord']),
            name=code['Name'],
            description=code['Description'],
            icon=icon,
            parameter=v,
        )


def add_values(var_id, values):
    year_pattern = re.compile('(?P<year>-?[0-9]+)')
    dsdata = Data()
    societies = {k: v for k, v in DBSession.query(models.Society.id, models.Society.pk)}
    sources = {k: v for k, v in DBSession.query(common.Source.id, common.Source.pk)}
    variable = models.Variable.get(var_id)
    codes = {
        k: v for k, v in DBSession.query(models.Code.id, models.Code.pk)
        .filter(common.DomainElement.parameter == variable)}

    for soc_id, rows in itertools.groupby(values, lambda r: r['Soc_ID']):
        rows = [
            row for row in rows
            if (row['Code_ID'] is None or row['Code_ID'] in codes)
               and not (variable.type == 'Continuous' and row['Value'] is None)]
        if not rows:
            continue

        vsid = '{0}-{1}'.format(var_id, soc_id).replace('.', '_')
        vs = dsdata.add(
            common.ValueSet,
            vsid,
            id=vsid,
            contribution_pk=variable.dataset_pk,
            language_pk=societies[soc_id],
            parameter_pk=variable.pk,
        )
        for i, row in enumerate(rows):
            name = str(row['Value'])
            m = year_pattern.match(row['year'] or '')
            if m:
                name += ' ({0})'.format(m.group('year'))
            if row['sub_case']:
                name += ' [{0}]'.format(row['sub_case'])

            vid = '{0}-{1}'.format(vsid, i + 1)
            v, k = None, None
            code = codes.get(row['Code_ID'])
            if code:
                k = (vsid, code, name)
                v = dsdata['Datapoint'].get(k)
                if v:
                    v.frequency += 1
            if not v:
                try:
                    fv = float(row['Value'])
                except (TypeError, ValueError):
                    fv = None
                v = models.Datapoint(
                    id=vid,
                    valueset=vs,
                    name=name,  # row['code'],
                    comment=row['Comment'],
                    year=int(m.group('year')) if m else None,
                    sub_case=row['sub_case'],
                    value_float=fv,
                    frequency=1,
                    domainelement_pk=code)
            if code and k:
                dsdata['Datapoint'][k] = v
            for ref in row['Source']:
                sid, pages = Sources.parse(ref)
                models.DatapointReference(
                    value=v, source_pk=sources[sid], description=pages or None)


def add_phylogeny(row, name, cldftree, languoids, societies_by_glottocode):
    is_glottolog = row['Source'][0] == 'glottolog_glottolog'
    sid = row['ID'].replace('dplace-phylogeny-', '') + '_'

    def rename(n):
        if n.name:
            n.name = n.name.replace(sid, '')

    nwk = cldftree.newick()
    nwk.visit(rename)

    tree = models.DplacePhylogeny(
        id=row['ID'].replace('dplace-phylogeny-', ''),
        name=name,
        description=row['Description'],
        glottolog=is_glottolog,
        newick=nwk.newick,  # FIXME: We should rename nodes from ID to Name!?
        author=row['Contributor'],
        year=None,
        doi=row['DOI'],
        reference=row['Citation'],
    )
    #
    # rename nodes in Newick string to ID - (contrib ID - 'dplace-phylogeny-')
    # use this as TreeLabel name, too!
    #
    for k, taxon in enumerate(languoids):
        label = TreeLabel(
            id=taxon['ID'],
            name=taxon['ID'].replace(sid, ''),
            phylogeny=tree,
            description=taxon['Glottocode'])
        # For Glottolog trees, map all societies with matching language-level Glottocode.
        # For other tree, map all societies with matching Glottocode or matching language-level
        # Glottocode.
        for i, spk in enumerate(societies_by_glottocode.get(taxon['Glottocode'], [])):
            LanguageTreeLabel(ord=i + 1, language_pk=spk, treelabel=label)

    DBSession.add(tree)
