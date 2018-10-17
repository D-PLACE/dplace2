<%inherit file="home_comp.mako"/>
<%namespace name="util" file="util.mako"/>
<%! active_menu_item = "about" %>

<%def name="sidebar()">
    <div class="well well-small">
        <h4>Contents</h4>
        <ul class="unstyled">
            <li><a href="#overview">Overview</a></li>
            <li><a href="#howtocite">How to cite</a></li>
            <li><a href="#funding">Funding</a></li>
            <li><a href="#acknowledgements">Acknowledgements</a></li>
            <li><a href="#publications">Publications</a></li>
            <li><a href="#team">The Team</a></li>
            ##<li><a href="#"></a></li>
        </ul>
    </div>
</%def>

<h2>About D-PLACE</h2>


<%util:section title="Overview" level="3" id="overview">
    <p>
        D-PLACE, or the <em>Database of Places, Language, Culture, and Environment</em>, is an attempt to bring together
        the dispersed corpus of information describing human cultural diversity. It aims to make it easy for individuals
        to contrast their own cultural practices with those of other societies, and to consider the factors that may
        underlie cultural similarities and differences.
    </p>
    <p>
        So far, D-PLACE contains cultural, linguistic, environmental and geographic information for over 1400 human
        ‘societies’. A ‘society’ in D-PLACE represents a group of people in a particular locality, who often share a
        language and cultural identity. All cultural descriptions are tagged with the date to which they refer and with
        the ethnographic sources that provided the descriptions. The majority of the cultural descriptions in D-PLACE
        are based on ethnographic work carried out in the 19th and early-20th centuries (pre-1950).
    </p>
    <p>
        In linking societies to a geographic location (using a reported latitude and longitude) and language, D-PLACE
        allows interested users to simultaneously consider how cultural practices relate to linguistic ancestry,
        practices of neighbouring cultures, and the environment. D-PLACE makes visualizing these relationships easy,
        with search results available as a table, on a map, or on a linguistic tree.
    </p>
    <div class="row" style="margin-bottom: 10px;">
        <div class="span4" style="text-align: center">
            <img width="50" src="${req.static_url('dplace2:static/Map_Icon.png')}">
        </div>
        <div class="span4" style="text-align: center">
            <img width="50" src="${req.static_url('dplace2:static/Table_Icon.png')}">
        </div>
        <div class="span4" style="text-align: center">
            <img width="50" src="${req.static_url('dplace2:static/Tree_Icon.png')}">
        </div>
    </div>
    <p>
        While D-PLACE is designed to be expandable, most of the initial cultural data in D-PLACE were originally
        compiled by three anthropologists: George P. Murdock, Lewis R. Binford, Joseph G. Jorgensen, each relying on
        hundreds of individual references. These core datasets are described in more detail on the

        ## FIXME: link!
        Data Sources

        page.
    </p>
</%util:section>


<%util:section title="How to cite" level="3" id="howtocite">

    <p>
        Research that uses data from D-PLACE should cite the following paper:
    </p>

    <blockquote>
        Kathryn R. Kirby, Russell D. Gray, Simon J. Greenhill, Fiona M. Jordan, Stephanie Gomes-Ng, Hans-Jörg Bibiko,
        Damián E. Blasi, Carlos A. Botero, Claire Bowern, Carol R. Ember, Dan Leehr, Bobbi S. Low, Joe McCarter, William
        Divale, and Michael C. Gavin. (2016). D-PLACE: A Global Database of Cultural, Linguistic and Environmental
        Diversity. PLoS ONE, 11(7): e0158391. doi:10.1371/journal.pone.0158391.
    </blockquote>

    <p>Short version:</p>

    <blockquote>
        Kirby, K.R., Gray, R. D., Greenhill, S. J., Jordan, F. M., Gomes-Ng, S., Bibiko, H-J, et al. (2016). D-PLACE: A
        Global Database of Cultural, Linguistic and Environmental Diversity. PLoS ONE, 11(7): e0158391.
        doi:10.1371/journal.pone.0158391.
    </blockquote>

    <p>
        Users should also cite the original <a href="#sources">source(s)</a> of the data.
    </p>
</%util:section>

<%util:section title="Funding" level="3" id="funding">
    <p>
        D-PLACE was developed with generous support from the
        ${h.external_link('http://www.nescent.org', label='National Evolutionary Synthesis Center')}
        and the
        ${h.external_link('https://www.shh.mpg.de/en', label='Max Planck Institute for the Science of Human History')}.
    </p>
</%util:section>

<%util:section title="Acknowledgements" level="3" id="acknowledgements">
    <p>
        D-PLACE would not exist without the cultural datasets upon which it relies;
        we would like to acknowledge the years of work by George P. Murdock and Lewis R. Binford,
        and the enormous contributions made by other scholars in the field towards their maintenance and updating.
    </p>
    <p>
        Robert Colwell, Karen Cranston, Michael Dunn, Robert Dunn, Robert Forkel, Harald Hammarström, Amber Johnson
        and Carl Simon provided valuable insights into the data or structure of D-PLACE.
    </p>
    <p>
        We would also like to thank all researchers and groups who made a Bayesian phylogenetic tree available
        for inclusion in D-PLACE, including Quentin Atkinson, Remco Bouckaert, Rebecca Grollemund, Thiago Chacon,
        Mattis List, Sean Lee, Toshikazu Hasegawa, Mark Sicoli, and Gary Holton.
    </p>
    <p>
        Finally, a number of people provided assistance in preparing data for inclusion in D-PLACE, including
        Christopher Blackford, Kaylin Clements, Anna Kellogg, Hannah Haynie, Patrick Kavanagh, Ameena Khan,
        Beata Opalinska, Anum Rafiq, Anastasia Stellato, and George Tsourounis.
    </p>
    <p>
        We are grateful to the Max Planck Institute for its commitment to provide long-term hosting for D-PLACE.
    </p>
</%util:section>

<%util:section title="Publications" level="3" id="publications">

    <ul>
        <li>Kirby, K.R., Gray, R. D., Greenhill, S. J., Jordan, F. M., Gomes-Ng, S., Bibiko, H-J, et al. (2016).
            D-PLACE: A Global Database of Cultural, Linguistic and Environmental Diversity. PLoS ONE, 11(7): e0158391.
            <a href="https://doi.org/10.1371/journal.pone.0158391">doi:10.1371/journal.pone.0158391</a>.
        </li>
        <li>Botero, C. A., Gardner, B., Kirby, K. R., Bulbulia, J., Gavin, M. C., & Gray, R. D. (2014). The ecology of
            religious beliefs. Proceedings of the National Academy of Sciences, 111(47), 16784-16789.
        </li>
    </ul>

</%util:section>





<%util:section title="The Team" level="3" id="team">
    <div class="row-fluid">
        <div class="span3" style="text-align: right">
            <img class="img-polaroid" width="150px" src="${req.static_url('dplace2:static/team/team_bibiko.jpg')}">
        </div>
        <div class="span3" style="text-align: left">
            <ul class="unstyled">
                <li><strong>Hans-Jörg Bibiko</strong></li>
                <li>${h.external_link('https://www.shh.mpg.de/employees/42541/55811')}</li>
                <li>${h.external_link('http://www.bibiko.de')}</li>
            </ul>
        </div>
        <div class="span3" style="text-align: right">
            <img class="img-polaroid" width="150px" src="${req.static_url('dplace2:static/team/team_blasi.jpg')}">

        </div>
        <div class="span3" style="text-align: left">
            <ul class="unstyled">
                <li><strong>Damián Blasi</strong></li>
                <li>${h.external_link('http://sites.google.com/site/damianblasi/')}</li>
            </ul>
        </div>
    </div>
    <div class="row-fluid">

        <div class="span3" style="text-align: right">
            <img class="img-polaroid" width="150px" src="${req.static_url('dplace2:static/team/team_botero.jpg')}">

        </div>
        <div class="span3" style="text-align: left">
            <ul class="unstyled">
                <li><strong>Carlos Botero</strong></li>
                <li>${h.external_link('http://pages.wustl.edu/botero')}</li>
            </ul>
        </div>

        <div class="span3" style="text-align: right">
            <img class="img-polaroid" width="150px" src="${req.static_url('dplace2:static/team/team_bowern.jpg')}">

        </div>
        <div class="span3" style="text-align: left">
            <ul class="unstyled">
                <li><strong>Claire Bowern</strong></li>
                <li>${h.external_link('http://ling.yale.edu/people/claire-bowern')}</li>
            </ul>
        </div>
    </div>
    <div class="row-fluid">
        <div class="span3" style="text-align: right">
            <img class="img-polaroid" width="150px" src="${req.static_url('dplace2:static/team/team_ember.jpg')}">

        </div>
        <div class="span3" style="text-align: left">
            <ul class="unstyled">
                <li><strong>Carol Ember</strong></li>
                <li>${h.external_link('http://hraf.yale.edu/about/staff/carol-r-ember/')}</li>
            </ul>
        </div>
        <div class="span3" style="text-align: right">
            <img class="img-polaroid" width="150px" src="${req.static_url('dplace2:static/team/team_forkel.jpg')}">

        </div>
        <div class="span3" style="text-align: left">
            <ul class="unstyled">
                <li><strong>Robert Forkel</strong></li>
                <li>${h.external_link('http://www.shh.mpg.de/employees/45369/55811')}</li>
            </ul>
        </div>
    </div>
    <div class="row-fluid">
        <div class="span3" style="text-align: right">
            <img class="img-polaroid" width="150px" src="${req.static_url('dplace2:static/team/team_gavin.jpg')}">

        </div>
        <div class="span3" style="text-align: left">
            <ul class="unstyled">
                <li><strong>Michael Gavin</strong></li>
                <li>${h.external_link('http://www.michaelcgavin.com')}</li>
            </ul>
        </div>
        <div class="span3" style="text-align: right">
            <img class="img-polaroid" width="150px" src="${req.static_url('dplace2:static/team/team_ng.jpg')}">

        </div>
        <div class="span3" style="text-align: left">
            <ul class="unstyled">
                <li><strong>Stephanie Gomes-Ng</strong></li>
            </ul>
        </div>
    </div>
    <div class="row-fluid">
        <div class="span3" style="text-align: right">
            <img class="img-polaroid" width="150px" src="${req.static_url('dplace2:static/team/team_gray.jpg')}">

        </div>
        <div class="span3" style="text-align: left">
            <ul class="unstyled">
                <li><strong>Russell Gray</strong></li>
                <li>${h.external_link('http://www.shh.mpg.de/2923/russellgray')}</li>
                <li>${h.external_link('http://www.psych.auckland.ac.nz/people/rd-gray')}</li>
            </ul>
        </div>
        <div class="span3" style="text-align: right">
            <img class="img-polaroid" width="150px" src="${req.static_url('dplace2:static/team/team_greenhill.jpg')}">

        </div>
        <div class="span3" style="text-align: left">
            <ul class="unstyled">
                <li><strong>Simon Greenhill</strong></li>
                <li>${h.external_link('http://researchers.anu.edu.au/researchers/greenhill-s')}</li>
                <li>${h.external_link('http://simon.net.nz/')}</li>
            </ul>
        </div>
    </div>
    <div class="row-fluid">
        <div class="span3" style="text-align: right">
            <img class="img-polaroid" width="150px" src="${req.static_url('dplace2:static/team/team_jordan.jpg')}">
        </div>
        <div class="span3" style="text-align: left">
            <ul class="unstyled">
                <li><strong>Fiona Jordan</strong></li>
                <li>${h.external_link('http://www.bristol.ac.uk/school-of-arts/')}</li>
                <li>${h.external_link('http://people/fiona-m-jordan/')}</li>
            </ul>
        </div>
        <div class="span3" style="text-align: right">
            <img class="img-polaroid" width="150px" src="${req.static_url('dplace2:static/team/team_kirby.jpg')}">
        </div>
        <div class="span3" style="text-align: left">
            <ul class="unstyled">
                <li><strong>Kate Kirby</strong></li>
                <li>${h.external_link('http://krkirby.wordpress.com/')}</li>
            </ul>
        </div>
    </div>
    <div class="row-fluid">
        <div class="span3" style="text-align: right">
            <img class="img-polaroid" width="150px" src="${req.static_url('dplace2:static/team/team_leehr.jpg')}">
        </div>
        <div class="span3" style="text-align: left">
            <ul class="unstyled">
                <li><strong>Dan Leehr</strong></li>
            </ul>
        </div>
        <div class="span3" style="text-align: right">
            <img class="img-polaroid" width="150px" src="${req.static_url('dplace2:static/team/team_low.jpg')}">
        </div>
        <div class="span3" style="text-align: left">
            <ul class="unstyled">
                <li><strong>Bobbi Low</strong></li>
                <li>${h.external_link('http://snre.umich.edu/profile/bobbilow')}</li>
            </ul>
        </div>
    </div>
</%util:section>

