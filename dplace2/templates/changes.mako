<%inherit file="home_comp.mako"/>
<%namespace name="util" file="util.mako"/>


<h2>What's new?</h2>

<p>
    D-PLACE is a work in progress. We welcome suggestions for corrections and/or for additional data.
</p>
<p>
    The database was originally described in Kirby et al. 2016, when it contained only two major cross-cultural
    datasets: Murdock’s Ethnographic Atlas and Binford’s Hunter-Gatherer dataset. Since then we have added the
    Standard Cross-Cultural Sample and Jorgensen’s Western-North American database, and we are currently digitizing
    and cleaning other cross-cultural datasets we think could be of broad interest.
</p>
<p>
    To suggest a dataset for inclusion, or to see the datasets we are currently working on adding, please visit
    the issues list at GitHub and look for
    ${h.external_link('https://github.com/D-PLACE/dplace-data/issues?q=is%3Aissue+is%3Aopen+label%3ADataset', label='“Issues” tagged with “Dataset”')}.
</p>
<p>
    The h.external_link('https://github.com/D-PLACE?q=dplace-dataset&type=all&language=&sort=', label='D-PLACE GitHub site'})
    also allows you to track corrections and other changes made to individual datasets,
    discussions over society-language matches, newly added environmental variables, etc.
</p>


<h3>D-PLACE 3.0</h3>
<p>
    Starting with release 3.0, the D-PLACE data served by this web application is disseminated as
    CLDF dataset at  <a href="https://zenodo.org/doi/10.5281/zenodo.3935419">DOI: 10.5281/zenodo.3935419</a>.
</p>
<p>
    For information about accessing older releases, see <a href="${req.route_url('download')}">download</a>
</p>


<h3>Publications</h3>

<p>
    You can find a list of papers citing D-PLACE at
    ${h.external_link('https://scholar.google.ca/scholar?cites=6551124656706807015', label='Google Scholar')}.
</p>
