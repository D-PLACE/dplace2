<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "parameters" %>
<%block name="title">${_('Parameter')} ${ctx.name}</%block>
<%! import json %>

<div class="row-fluid">
    <div class="span7">
        <h2>${ctx.name}</h2>
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
            <li class="">
                <a href="#tree-container">
                    <img src="${req.static_url('dplace2:static/Tree_Icon.png')}"
                         width="35">
                    Tree
                </a>
            </li>
        </ul>
        <div id="tree-container" class="well well-small">
            <p>
                You may display the datapoints for this variable on a given
                phylogeny.
            </p>
            <form action="${request.route_url('variable_on_tree')}"
                  method="get"
                  class="form-inline">
                <input type="hidden" name="parameter" value="${ctx.id}"/>
                <select id="ps" name="phylogeny">
                    <label for="ps">Phylogeny</label>
                    % for tree_ in trees:
                        <option value="${tree_.id}"${' selected="selected"' if tree and tree.id == tree_.id else ''}>${tree_.name}</option>
                    % endfor
                </select>
                <button class="btn" type="submit">Submit</button>
            </form>
        </div>
    </div>
    <div class="span5">
        <div class="vtable ${ctx.dataset.type}">
            <dl>
                <dt>Dataset:</dt>
                <dd>${h.link(request, ctx.dataset)}</dd>
                % if ctx.description:
                    <dt>Description:</dt>
                    <dd>${ctx.description}</dd>
                % endif
                <dt>Values:</dt>
                <dd>
                    % if ctx.domain:
                        <table class="table table-condensed">
                            % for de in ctx.domain:
                                <tr>
                                    <td>${h.map_marker_img(req, de, width=25, height=25)}</td>
                                    <td>${de.number}</td>
                                    <td>${de}</td>
                                    <td class="right">${len(de.values)}</td>
                                </tr>
                            % endfor
                        </table>
                    % elif 'range' in ctx.jsondata or {}:
                        <table>
                            % for number, color in ctx.jsondata['range']:
                                <tr>
                                    <td style="background-color: ${color}; padding-right: 10px;">&nbsp;&nbsp;&nbsp;</td>
                                    <td style="padding-left: 10px;">
                                        % if loop.first or loop.last:
                                            ${'{0:,}'.format(number)}
                                        % endif
                                    </td>
                                </tr>
                            % endfor
                        </table>
                    % endif
                </dd>
            </dl>

        </div>
    </div>
</div>

% if map_ or request.map:
    ${(map_ or request.map).render()}
% endif

<div id="table-container">
    ${request.get_datatable('values', h.models.Value, parameter=ctx).render()}
</div>
