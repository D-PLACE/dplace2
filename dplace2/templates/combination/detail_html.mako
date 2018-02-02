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

        <%util:table items="${res}" args="item">\
        <%def name="head()">
            <th></th>
        % for p, domain in params:
            <th>${p.id}</th>
        % endfor
        </%def>
            <th>${item[0]}</th>
        % for i in range(len(params)):
            <td>
                ${h.map_marker_img(req, item[2*i + 1])|n}
            ${params[i][1][item[2*i + 1].domainelement_pk].name if item[2*i + 1].domainelement_pk in params[i][1] else item[2*i + 1].name}
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
