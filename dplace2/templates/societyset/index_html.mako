<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "societysets" %>
<%block name="title">Society sets</%block>


<ul class="nav nav-pills" style="float: right">
    <li class="">
        <a href="#map-container">
            <img src="${req.static_url('dplace2:static/Map_Icon.png')}"
                 width="35">
            Map
        </a>
    </li>
    <li class="">
        <a href="#table-container">
            <img src="${req.static_url('dplace2:static/Table_Icon.png')}"
                 width="35">
            Table
        </a>
    </li>
</ul>

<h2>Societies</h2>

<div class="well well-small">
    <table class="table table-condensed">
        <thead>
        <tr>
            <th>Society set</th>
            <th>Societies</th>
            <th>Reference</th>
        </tr>
        </thead>
        <tbody>
            % for socset in ctx.get_query():
                <tr>
                    <td>${h.link(req, socset)}</td>
                    <td class="right">${socset.count_societies}</td>
                    <td>${socset.reference}</td>
                </tr>
            % endfor
        </tbody>
    </table>
</div>

${request.get_map('languages').render()}

<div id="table-container">
    ${req.get_datatable('languages', h.models.Language).render()}
</div>
