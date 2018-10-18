<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "parameters" %>
<%block name="title">${_('Combination')} ${ctx.name}</%block>

<%block name="head">
    <link href="${request.static_url('clld:web/static/css/select2.css')}"
          rel="stylesheet">
    <script src="${request.static_url('clld:web/static/js/select2.js')}"></script>
</%block>

<div class="row-fluid">
    <div class="span9">
        <h3>${_('Combination')} ${' / '.join(h.link(request, p) for p in ctx.parameters)|n}</h3>

        <div>
            <form action="${request.route_url('select_combination')}">
                <fieldset>
                    <p>
                        You may combine these ${_('Parameters').lower()} with another
                        one.
                        Start typing the ${_('Parameter').lower()} name or number in
                        the field below.
                    </p>
                    ${ms(request, combination=ctx).render()}
                    <button class="btn" type="submit">Submit</button>
                </fieldset>
            </form>
        </div>

        <div id="tree-container">
            <p>
                You may display the datapoints for this variable combination on a given
                phylogeny.
            </p>
            <form action="${request.route_url('variable_on_tree')}"
                  method="get"
                  class="form-inline">
                <img src="${req.static_url('dplace2:static/Tree_Icon.png')}" width="35"/>
                % for p in ctx.parameters:
                    <input type="hidden" name="parameter" value="${p.id}"/>
                % endfor
                <select id="ps" name="phylogeny">
                    <label for="ps">Phylogeny</label>
                    % for tree_ in trees:
                        <option value="${tree_.id}"${' selected="selected"' if tree and tree.id == tree_.id else ''}>${tree_.name}</option>
                    % endfor
                </select>
                <button class="btn" type="submit">Submit</button>
            </form>
        </div>

        % if multivalued:
            <div class="alert alert-info">
                <strong>Note:</strong> Languages may have multiple values marked with
                overlapping markers. These languages are additionally marked with a small
                red
                triangle. Clicking on this marker will show all value markers associated
                with the
                language.
            </div>
        % endif

        ${req.map.render()}

        <%util:table items="${res}" args="item">\
        <%def name="head()">
            <th></th>
        % for p in ctx.parameters:
            <th>${p.id}</th>
        % endfor
        </%def>
            <th>${h.link(req, item[0])}</th>
        % for p in ctx.parameters:
            <td>
                <ul class="unstyled">
                % for v in item[1][p.pk]:
                    <li>
                        ${h.map_marker_img(req, v)|n}
                        ${v}
                        <small>
                            ${v.spec()}
                        </small>
                    </li>
                % endfor
                </ul>
            </td>
        % endfor
        </%util:table>
    </div>
    <div class="span3" data-spy="affix" data-offset-top="10" style="right: 0;">
        <div class="accordion" id="sidebar-accordion">
            % for i, p in enumerate(ctx.parameters):
                <%util:accordion_group eid="acc${str(i+1)}" parent="sidebar-accordion" title="${p.name}" open="${True if loop.first else False}">
                    % if p.domain:
                        <table class="table table-condensed">
                            % for de in p.domain:
                                <tr>
                                    <td>${h.map_marker_img(req, de)}</td>
                                    <td>${de.number}</td>
                                    <td>${de}</td>
                                </tr>
                            % endfor
                        </table>
                    % elif 'range' in p.jsondata or {}:
                        <table>
                            % for number, color in p.jsondata['range']:
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
                </%util:accordion_group>
            % endfor
        </div>
    </div>
</div>
