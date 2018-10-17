<%inherit file="${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="util.mako"/>
<%! active_menu_item = "about" %>

<%def name="contextnav()">
    ${util.contextnavitem('changes', label="What's new?")}
    ${util.contextnavitem('datasources', label="Data Sources")}
    ${util.contextnavitem('glossary', label="FAQ")}
    ${util.contextnavitem('legal')}
    ${util.contextnavitem('download')}
    ${util.contextnavitem('contact')}
</%def>
${next.body()}
