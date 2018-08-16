<%inherit file="../home_comp.mako"/>

<%def name="sidebar()">
    <div>
        <img src="${request.static_url('dplace2:static/D-PLACE_Logo.png')}"/>
    </div>
</%def>

<h2>Database of Places, Language, Culture and Environment</h2>

<p class="lead">
    From the foods we eat, to who we can marry, to the types of games we teach our children, the diversity of cultural practices in the world is astounding. Yet, our ability to visualize and understand this diversity is often limited by the ways it traditionally has been documented and shared: on a culture-by-culture basis, in locally-told stories or difficult-to-access books and articles.
</p>

<p>
D-PLACE, which stands for ‘Database of Places, Language, Culture, and Environment,’ represents an attempt to bring together this dispersed corpus of information. It aims to make it easy for individuals to contrast their own cultural practices with those of other societies, and to consider the factors that may underlie cultural similarities and differences.
</p>

<p>
So far, D-PLACE contains cultural, linguistic, environmental and geographic information for over 1400 human ‘societies’. A ‘society’ in D-PLACE represents a group of people in a particular locality, who often share a language and cultural identity. All cultural descriptions are tagged with the date to which they refer and with the ethnographic sources that provided the descriptions. The majority of the cultural descriptions in D-PLACE are based on ethnographic work carried out in the 19th and early-20th centuries (pre-1950).
</p>

<p>
In linking societies to a geographic location (using a reported latitude and longitude) and language, D-PLACE allows interested users to simultaneously consider how cultural practices relate to linguistic ancestry, practices of neighbouring cultures, and the environment. D-PLACE makes visualizing these relationships easy, with search results available as a table, on a map, or on a linguistic tree.
</p>

<p>
While D-PLACE is designed to be expandable, most of the initial cultural data in D-PLACE were originally compiled by two anthropologists, George P. Murdock and Lewis R. Binford, each relying on hundreds of individual references. Murdock and Binford’s core datasets are described in more detail in the Data Source section.
</p>

<p>
    The
    <a href="${req.route_url('about', _anchor='team')}">D-PLACE team</a>
    is made up of scientists with a broad range of interests who share a passion for interdisciplinary inquiry.
</p>

<p>
    More information on: <a href="${req.route_url('about', _anchor='howtocite')}">citing D-PLACE</a> and
    <a href="${req.route_url('about', _anchor='publications')}">related publications</a>.
</p>

<p>
D-PLACE is a work in progress. We welcome suggestions for corrections and/or for additional data.
</p>
