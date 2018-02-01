<%inherit file="../home_comp.mako"/>

<%block name="head">
    <link rel="stylesheet" href="${req.static_url('dplace2:static/phylotree.css')}">
    <script src="//d3js.org/d3.v3.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js" charset="utf-8"></script>
    <script type="text/javascript" src="${req.static_url('dplace2:static/phylotree.js')}"></script>
    <style>
        #tree_display {width: 500px; height: auto;}
    </style>
</%block>



<%def name="sidebar()">
    <div>
        <img src="${request.static_url('dplace2:static/D-PLACE_Logo.png')}"/>
    </div>
    <svg id="tree_display" width="200"></svg>
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
The D-PLACE team is made up of scientists with a broad range of interests who share a passion for interdisciplinary inquiry.
</p>

<p>
More information on: citing D-PLACE, related publications, and the technology and source code.
</p>

<p>
D-PLACE is a work in progress. We welcome suggestions for corrections and/or for additional data.
</p>

<%block name="javascript">
    $(function() {
        var example_tree = "(('Mer {Bench} [merr1238]':1,'Nuclear Bench [nucl1433]':1,'She {Ethiopia} [shee1239]':1)'Bench [benc1235][bcq]-l-':1,('Anfillo [anfi1235][myo]-l-':1,('Amuru [amur1243]':1,'Gamila [gami1244]':1,'Guba {Ethiopia} [guba1244]':1,'Wembera [wemb1240]':1)'Boro {Ethiopia} [boro1277][bwo]-l-':1,(('Bosha [bosh1241]':1,'Nuclear Kafa [nucl1434]':1)'Kafa [kafa1242][kbr]-l-':1,'Shekkacho [shek1244][moy]-l-':1)'South Gonga [sout2835]':1)'Kefoid [gong1256]':1,('Chara [char1269][cra]-l-':1,(('Ganjule [ganj1241]':1,'Ganta [gant1243]':1,'Kachama [kach1285]':1)'Kachama-Ganjule-Haro [kach1284][kcx]-l-':1,'Koorete [koor1239][kqy]-l-':1,('Zayse [zays1236]':1,'Zergulla [zerg1235]':1)'Zayse-Zergulla [zays1235][zay]-l-':1)'East Ometo [east2423]':1,('Basketo [bask1236][bst]-l-':1,(('Dawro [dawr1236][dwr]-l-':1,'Gamo [gamo1243][gmv]-l-':1,'Gofa [gofa1235][gof]-l-':1)'Dawro-Gofa-Gamo [dawr1235]':1,'Dorze [dorz1235][doz]-l-':1,'Melo [melo1242][mfx]-l-':1,'Oyda [oyda1235][oyd]-l-':1,('Zala [zala1240]':1)'Wolaytta [wola1242][wal]-l-':1)'Central Ometo [cent2046]':1,'Male {Ethiopia} [male1284][mdy]-l-':1)'North-West Ometo [nort3161]':1)'Ometo [omet1238]':1,('Fuga of Jimma [fuga1235]':1,'Toba {Ethiopia} [toba1264]':1)'Yemsa [yems1235][jnj]-l-':1)'Ta-Ne-Omotic [gong1255]':1";
        var tree = d3.layout.phylotree().svg(d3.select("#tree_display"))
        .options({
            'reroot': false,
            'brush': false,
            'align-tips': true,
            'show-scale': false
        })
        .style_nodes(DPLACE2.nodeStyler);
        tree(example_tree).layout();
});
</%block>
