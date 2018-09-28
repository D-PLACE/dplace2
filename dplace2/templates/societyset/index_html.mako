<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "societysets" %>
<%block name="title">Society sets</%block>


<h2>Society sets</h2>

<div id="table-container">
    ${ctx.render()}
</div>

${request.get_map('languages').render()}

