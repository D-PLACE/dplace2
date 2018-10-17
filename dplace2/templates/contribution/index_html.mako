<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "contributions" %>
<%block name="title">${_('Contributions')}</%block>


<h2>${_('Contributions')}</h2>

<p>
    Datasets consist of one or more variables that describe a set of societies. Click on an individual dataset to view
    more details about it. You can also search for individual <a href="${req.route_url('parameters')}">variables</a> of
    interest using keywords, and read an overview of <a href="${req.route_url('datasources')}">D-PLACE data sources</a>.
</p>

${ctx.render()}
