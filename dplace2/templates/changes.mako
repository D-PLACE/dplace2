<%inherit file="home_comp.mako"/>
<%namespace name="util" file="util.mako"/>


<h2>What's new?</h2>

<div class="alert alert-success">
    <p>
        This web application serves the latest
        ${h.external_link('https://github.com/D-PLACE/dplace-data/releases', label='released version')}
        of the D-PLACE data repository.
    </p>
    <p>
        Releases are additionally archived with ZENODO, and the DOI provided by ZENODO should be used when citing
        particular releases of D-PLACE data.
    </p>
</div>


<p>
    D-PLACE is a work in progress. We welcome suggestions for corrections and/or for additional data.
</p>
<p>
    The database was originally described in Kirby et al. 2016, when in contained only two major cross-cultural
    datasets: Murdock’s Ethnographic Atlas and Binford’s Hunter-Gatherer dataset. Since then we have added the
    Standard Cross-Cultural Sample and Jorgensen’s Western-North American database, and we are currently digitizing
    and cleaning other cross-cultural datasets we think could be of broad interest.
</p>
<p>
    To suggest a dataset for inclusion, or to see the datasets we are currently working on adding, please visit our
    ${h.external_link('https://github.com/D-PLACE/dplace-data', label='GitHub <data> repository')}, and look for
    ${h.external_link('https://github.com/D-PLACE/dplace-data/issues?q=is%3Aissue+is%3Aopen+label%3ADataset', label='“Issues” tagged with “Dataset”')}.
    You can also contact us directly.
</p>
<p>
    The D-PLACE GitHub site also allows you to track corrections and other changes made to individual datasets,
    discussions over society-language matches, newly added environmental variables, etc.
</p>


<h3>Publications</h3>

<p>
    You can find a list of papers citing D-PLACE at
    ${h.external_link('https://scholar.google.ca/scholar?cites=6551124656706807015', label='Google Scholar')}.
</p>
