import math
import itertools
import collections

from tqdm import tqdm
import transaction
from sqlalchemy import func, distinct
from sqlalchemy.orm import joinedload
from clld.cliutil import Data, bibtex2source
from clld.db.meta import DBSession
from clld.db.models import common
from clld.lib.bibtex import Database
from clldutils.color import qualitative_colors
from pyglottolog import Glottolog
from pycldf.trees import TreeTable
from clld_phylogeny_plugin.models import TreeLabel, Phylogeny

from dplace2 import models
from .util import add_metadata, add_society, add_variable, color, add_values, add_phylogeny

SSID_MAP = {
    'dplace-dataset-ea': 'EA',
    'dplace-dataset-binford': 'Binford',
    'dplace-dataset-sccs': 'SCCS',
    'dplace-dataset-wnai': 'WNAI',
}


def nname(s):
    return (s.replace('D-PLACE dataset derived from ', '')
            .replace('Phlorest phylogeny derived from ', ''))


def main(args):  # pragma: no cover
    data = Data()
    cldf = args.cldf

    assert args.glottolog
    glottolog = Glottolog(args.glottolog)

    DBSession.add(add_metadata(data))

    for rec in Database.from_file(args.cldf.bibpath):
        data.add(common.Source, rec.id, _obj=bibtex2source(rec))

    societies_by_dataset = {
        dsid: list(rows) for dsid, rows in itertools.groupby(
            itertools.takewhile(lambda r: r['type'] == 'society', cldf['LanguageTable']),
            lambda r: r['Contribution_ID'])}
    variables_by_dataset = {
        dsid: list(rows) for dsid, rows in itertools.groupby(
            cldf['ParameterTable'], lambda r: r['Contribution_ID'])}
    codes_by_variable = {
        vid: list(rows) for vid, rows in itertools.groupby(
            cldf['CodeTable'], lambda r: r['Var_ID'])}
    glangs = {lg.id: lg for lg in glottolog.languoids()}
    societies_by_glottocode = collections.defaultdict(list)
    dscolors = qualitative_colors(
        sum(1 for x in cldf['ContributionTable'] if x['type'] == 'dataset'))
    altname_count = 0
    for i, ds in enumerate(sorted(
            cldf['ContributionTable'],
            key=lambda d: (d['type'], d['ID'] if d['ID'] != 'EA' else 'AA'))):
        if ds['ID'] in societies_by_dataset:
            societyset = data.add(
                models.Societyset,
                ds['ID'],
                id=SSID_MAP.get(ds['ID'], ds['ID']),
                name=nname(ds['Name']),
                description=ds['Description'],
                reference=ds['Citation'],
                doi=ds['DOI'],
                color=dscolors[i])
            for soc in societies_by_dataset[ds['ID']]:
                add_society(data, societyset, soc, glangs, societies_by_glottocode, altname_count)

        if ds['ID'] in variables_by_dataset:
            dataset = data.add(
                models.DplaceDataset,
                ds['ID'],
                id=SSID_MAP.get(ds['ID'], ds['ID']),
                name=nname(ds['Name']),
                description=ds['Description'],
                doi=ds['DOI'],
                reference=ds['Citation'])
            for row in variables_by_dataset[ds['ID']]:
                add_variable(data, dataset, row, codes_by_variable)

    DBSession.flush()
    societies_by_glottocode = {
        gc: [s.pk for s in vals] for gc, vals in societies_by_glottocode.items()}

    transaction.commit()

    #
    # Load Values in one transaction per variable.
    #
    # We rely on ValueTable being sorted by Var_ID, Soc_ID!
    for var_id, values in tqdm(itertools.groupby(cldf['ValueTable'], lambda r: r['Var_ID'])):
        transaction.begin()
        add_values(var_id, values)
        transaction.commit()

    languoids_by_phylogeny = {
        dsid: list(rows) for dsid, rows in itertools.groupby(
            itertools.dropwhile(lambda r: r['type'] == 'society', cldf['LanguageTable']),
            lambda r: r['Contribution_ID'])}
    trees = {t.row['Contribution_ID']: t for t in TreeTable(cldf)}
    for row in itertools.dropwhile(
            lambda r: r['type'] == 'dataset',
            sorted(cldf['ContributionTable'], key=lambda d: (d['type'], d['ID']))
    ):
        transaction.begin()
        add_phylogeny(
            row, nname(row['Name']), trees[row['ID']], languoids_by_phylogeny[row['ID']], societies_by_glottocode)
        transaction.commit()


def mlog(n):  # pragma: no cover
    return math.log(max([n, 0.0001]))


def prime_cache(args):  # pragma: no cover
    """If data needs to be denormalized for lookup, do that here.
    This procedure should be separate from the db initialization, because
    it will have to be run periodically whenever data has been updated.
    """
    args.log.info('processing prime cache')
    for var in DBSession.query(models.Variable).options(
        joinedload(models.Variable.category_assocs).joinedload(models.VariableCategory.category)
    ):
        var.categories_str = '|'.join(ca.category.name for ca in var.category_assocs)

    socs_by_var = {}
    for var in DBSession.query(models.Variable)\
            .options(joinedload(models.Variable.valuesets).joinedload(common.ValueSet.values)):
        socs_by_var[var.pk] = set(vs.language_pk for vs in var.valuesets)
        if var.type != 'Continuous':
            continue
        values = [v.value_float for v in itertools.chain(*[vs.values for vs in var.valuesets])]
        cminimum = minimum = min(values)
        cmaximum = maximum = max(values)

        dist = collections.OrderedDict()  # We compute the distribution of values on equidistant intervals.
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
            DBSession.add(models.DatasetSocietyset(dataset_pk=ds.pk, societyset_pk=sspk[0]))

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

    for phy in DBSession.query(Phylogeny).options(
            joinedload(Phylogeny.treelabels).joinedload(TreeLabel.language_assocs)):
        soc_set = collections.defaultdict(list)
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
