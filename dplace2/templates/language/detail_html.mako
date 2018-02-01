<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "languages" %>
<%block name="title">${_('Language')} ${ctx.name}</%block>

<h2>${_('Language')} ${ctx.name}</h2>

${request.get_datatable('values', h.models.Value, language=ctx).render()}

<%def name="sidebar()">
    ${util.language_meta()}
    <div class="well well-small">
        <h4>Sources</h4>
        <ul class="unstyled">
            % for src in sources:
                <li>${h.link(req, src)}</li>
            % endfor
        </ul>
    </div>
</%def>
