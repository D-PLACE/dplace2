<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "phylogenys" %>
<%block name="title">Phylogeny ${ctx.name}</%block>
<%! import json %>

<%block name="head">
    <link rel="stylesheet" href="${req.static_url('dplace2:static/phylotree.css')}">
    <script src="//d3js.org/d3.v3.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js" charset="utf-8"></script>
    <script type="text/javascript" src="${req.static_url('dplace2:static/phylotree.js')}"></script>
</%block>

<%def name="sidebar()">
    <div class="well well-small">
        <blockquote>
           ${ctx.reference}
        </blockquote>
        % if ctx.url:
            ${u.ext_link(ctx.url)}
        % endif
    </div>
</%def>

<h2>${title()}</h2>

<svg id="tree_display"></svg>

<%block name="javascript">
    DPLACE2.labels_in_dplace = ${json.dumps({l.name: [sa.society.name for sa in l.society_assocs] for l in ctx.labels if l.society_assocs})|n};
    $(function() {
    var example_tree = "${ctx.newick}";
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
