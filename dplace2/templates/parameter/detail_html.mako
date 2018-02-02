<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "parameters" %>
<%block name="title">${_('Parameter')} ${ctx.name}</%block>
<%! import json %>

<%block name="head">
    % if tree:
        <link rel="stylesheet" href="${req.static_url('dplace2:static/phylotree.css')}">
        <script src="//d3js.org/d3.v3.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js" charset="utf-8"></script>
        <script type="text/javascript" src="${req.static_url('dplace2:static/phylotree.js')}"></script>
    % endif
</%block>

<div class="row-fluid">
    <div class="span8">
        <h2>
            % if tree:
                <img src="${req.static_url('dplace2:static/Tree_Icon.png')}"
                     width="35">
            % endif
            ${ctx.name}
        </h2>
        <ul class="nav nav-pills">
            <li class="">
                <a href="${req.resource_url(ctx) if tree else ''}#map-container">
                    <img src="${req.static_url('dplace2:static/Map_Icon.png')}"
                         width="35">
                    Map
                </a>
            </li>
            <li class="">
                <a href="${req.resource_url(ctx) if tree else ''}#table-container">
                    <img src="${req.static_url('dplace2:static/Table_Icon.png')}"
                         width="35">
                    Table
                </a>
            </li>
            % if not tree:
                <li class="">
                    <a href="#tree-container">
                        <img src="${req.static_url('dplace2:static/Tree_Icon.png')}"
                             width="35">
                        Tree
                    </a>
                </li>
            % endif
        </ul>
        % if ctx.description:
            <p>${ctx.description}</p>
        % endif
        <div id="tree-container">
            % if not tree:
                <p>
                    You may display the datapoints for this variable on a given
                    phylogeny.
                </p>
            % endif
            <form action="${request.resource_url(ctx)}"
                  method="get"
                  class="form-inline">
                <select id="ps" name="phylogeny">
                    <label for="ps">Phylogeny</label>
                    % for tree_ in trees:
                        <option value="${tree_.id}"${' selected="selected"' if tree and tree.id == tree_.id else ''}>${tree_.name}</option>
                    % endfor
                </select>
                <button class="btn" type="submit">Submit</button>
            </form>
        </div>
        % if tree:
            <h3>${h.link(req, tree)}</h3>
            <div class="alert alert-info">
                The tree has been pruned to only contain leaf nodes with values for the
                given variable.
            </div>
            <svg id="tree_display"></svg>
        % endif
    </div>
    <div class="span4"${' data-spy="affix" data-offset-top="10" style="right: 0;"' if tree else ''|n}>
        % if ctx.domain:
            <%util:well title="Values">
                <table class="table table-condensed">
                    % for de in ctx.domain:
                        <tr>
                            <td>${h.map_marker_img(req, de)}</td>
                            <td>${de.number}</td>
                            <td>${de}</td>
                            <td class="right">${len(de.values)}</td>
                        </tr>
                    % endfor
                </table>
            </%util:well>
        % elif 'range' in ctx.jsondata or {}:
            <%util:well title="Values">
                <table>
                    % for number, color in ctx.jsondata['range']:
                        <tr>
                            <td>
                                % if loop.first or loop.last:
                                    ${number}
                                % endif
                                &nbsp;
                            </td>
                            <td style="background-color: ${color}">&nbsp;&nbsp;&nbsp;</td>
                        </tr>
                    % endfor
                </table>
            </%util:well>
        % endif
    </div>
</div>

% if not tree:
    % if map_ or request.map:
        ${(map_ or request.map).render()}
    % endif

    <div id="table-container">
        ${request.get_datatable('values', h.models.Value, parameter=ctx).render()}
    </div>
% endif

<%block name="javascript">
% if tree:
    DPLACE2.labels_in_dplace = ${json.dumps({l.name: [sa.society.name for sa in l.society_assocs] for l in tree.labels if l.society_assocs})|n};
    DPLACE2.labelColor = ${json.dumps(color_by_label)|n};
    $(function() {
    var example_tree = "${newick}";
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
% endif
</%block>
