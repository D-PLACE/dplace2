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

<div class="alert alert-success">
    <button type="button" class="close" data-dismiss="alert" style="float: right;">&times;</button>
    Use the icons on the right to switch between a searchable map vs. searchable table of societies. A “society” in
    D-PLACE can be understood as a group of people whose cultural practices were documented at particular time and
    place, and who generally speak a dialect or language different from that of their neighbours (more details
    <a href="${req.route_url('glossary', _anchor='q4')}">here</a>).
    Selecting a particular society (point)
    <a href="#map-container">on the map</a>
    will take you to a page containing all data available for
    that society. To view the geographic distribution of societies within a particular
    <a href="${req.route_url('glossary', _anchor='q7')}">society set</a>,
    you can select that set from the table below. To search for a society by name, language, focal year, or the
    name of a geographic region, please use the <a href="#table-container">table-based search</a>.
</div>

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
