<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "phylogenys" %>
<%block name="title">Phylogeny ${ctx.name}</%block>
<%! from clld_phylogeny_plugin.interfaces import ITree %>
<% tree = req.registry.queryUtility(ITree)(ctx, req) %>

<%block name="head">
    ${req.registry.queryUtility(ITree)(ctx, req).head(req)|n}
</%block>

<div class="row-fluid">
    <div class="span8">
        <h2>
            <img src="${req.static_url('dplace2:static/Tree_Icon.png')}"
                 width="35">
            ${title()}
        </h2>
        % if tree.parameter:
            <h3>${h.link(req, tree.parameter)}</h3>
            <div class="alert alert-info">
                The tree has been pruned to only contain leaf nodes with values for the
                given variable.
            </div>
        % endif
        ${tree.render()}
    </div>
    <div class="span4">
        <div class="well well-small">
            <blockquote>
                ${ctx.reference}
            </blockquote>
            % if ctx.url:
                ${u.ext_link(ctx.url)}
            % endif
        </div>
        % if tree.parameter:
            <div class="well-small well" data-spy="affix" data-offset-top="0" style="margin-right: 10px;">
                <h3>Values</h3>
                % if tree.parameter.domain:
                    <table class="table table-condensed">
                        % for de in tree.parameter.domain:
                            <tr>
                                <td>${h.map_marker_img(req, de)}</td>
                                <td>${de.number}</td>
                                <td>${de}</td>
                                <td class="right">${len(de.values)}</td>
                            </tr>
                        % endfor
                    </table>
                % elif 'range' in tree.parameter.jsondata or {}:
                    <table>
                        % for number, color in tree.parameter.jsondata['range']:
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
                % endif
            </div>
        % endif
    </div>
</div>
