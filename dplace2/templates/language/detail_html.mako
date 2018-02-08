<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "languages" %>
<%block name="title">${_('Language')} ${ctx.name}</%block>

<h2>${_('Language')}: ${ctx.name} (${ctx.id})</h2>

<dl class="dl-horizontal">
    <dt>Name in ${h.link(req, ctx.dataset)}:</dt>
    <dd>${ctx.name_in_source}</dd>
    <dt>Language family:</dt>
    <dd>${ctx.language_family}</dd>
    <dt>Language or dialect:</dt>
    <dd>${h.external_link('http://glottolog.org/resource/languoid/id/' + ctx.glottocode, label=ctx.language)}</dd>
    <dt>Principal year to which data refer:</dt>
    <dd>${ctx.year}</dd>
    % if ctx.hraf_id:
        <dt>eHRAF:</dt>
        <dd>${h.external_link(ctx.hraf_url, label='{0} ({1})'.format(ctx.hraf_name, ctx.hraf_id))}</dd>
    % endif
</dl>

${request.get_datatable('values', h.models.Value, language=ctx).render()}

<%def name="sidebar()">
    ${util.language_meta()}
</%def>
