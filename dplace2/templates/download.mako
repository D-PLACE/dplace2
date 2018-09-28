<%inherit file="home_comp.mako"/>

<h3>Downloads</h3>

<div class="alert alert-success">
    <p>
        The D-PLACE data is curated in a repository on Github - ${h.external_link('https://github.com/D-PLACE/dplace-data')}
        with this web application serving the latest
        ${h.external_link('https://github.com/D-PLACE/dplace-data/releases', label='released version')}.
        So for access to the full data, please clone this repository or download one of the releases.
    </p>
    <p>
        Releases are additionally archived with ZENODO, and the DOI provided by ZENODO should be used when citing
        particular releases of D-PLACE data.
    </p>
</div>
