<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "parameters" %>
<%block name="title">${_('Parameter')} ${ctx.name}</%block>

<div class="row-fluid">
    <div class="span8">
        <h2>${ctx.name}</h2>
        <ul class="nav nav-pills">
            <li class="">
                <a href="#map-container">
                    <img src="${req.static_url('dplace2:static/Map_Icon.png')}" width="35">
                    Map
                </a>
            </li>
            <li class="">
                <a href="#table-container">
                    <img src="${req.static_url('dplace2:static/Table_Icon.png')}" width="35">
                    Table
                </a>
            </li>
        </ul>
        % if ctx.description:
            <p>${ctx.description}</p>
        % endif
    </div>
    <div class="span4">
        % if ctx.domain:
            <%util:well title="Values">
                <table class="table table-condensed">
                    % for de in ctx.domain:
                        <tr>
                            <td>${h.map_marker_img(req, de)}</td>
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

% if map_ or request.map:
    ${(map_ or request.map).render()}
% endif

<div id="table-container">
    ${request.get_datatable('values', h.models.Value, parameter=ctx).render()}
</div>
