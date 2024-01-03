<%inherit file="home_comp.mako"/>

<h3>Downloads</h3>

<div class="alert alert-success">
    <p>
        The D-PLACE data is curated in a repository on Github - ${h.external_link('https://github.com/D-PLACE/dplace-cldf')}
        with this web application serving the latest
        ${h.external_link('https://github.com/D-PLACE/dplace-cldf/releases', label='released version')}.
        So for access to the full data, please clone this repository or download one of the releases.
    </p>
    <p>
        Releases are additionally archived with ZENODO at
        <a href="https://zenodo.org/doi/10.5281/zenodo.3935419">DOI: 10.5281/zenodo.3935419</a>, and
        the <a href="https://help.zenodo.org/faq/#versioning">version DOI</a> provided by ZENODO should be
        used when citing particular releases of D-PLACE data.
    </p>
    <p>
        D-PLACE data aggregated as CLDF dataset is only available since version 3.0.
        Earlier releases of aggregated D-PLACE data - in a non-CLDF format - are available at
        <a href="https://zenodo.org/doi/10.5281/zenodo.596376">DOI: 10.5281/zenodo.596376</a>.
    </p>
</div>
