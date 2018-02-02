<%inherit file="${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="util.mako"/>


${len(res)}

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
