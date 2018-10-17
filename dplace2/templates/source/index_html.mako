<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "sources" %>
<%block name="title">${_('Sources')}</%block>

<h2>${_('Sources')}</h2>
<p>
    The ethnographic articles and books upon which D-PLACE and its component cross-cultural datasets rely can be
    explored here. An overview of D-PLACE data sources is provided <a href="${req.route_url('datasources')}">here</a>.
</p>
<div>
    ${ctx.render()}
</div>
