<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! from clld.web.util import glottolog %>
<%! active_menu_item = "languages" %>
<%block name="title">${_('Language')} ${ctx.name}</%block>

<h2>${_('Language')}: ${ctx.name} (${ctx.id})</h2>

<div class="well well-small">
    <table class="table table-nonfluid table-condensed">
        <tbody>
        <tr>
            <td>Name in ${h.link(req, ctx.dataset)}:</td>
            <td>${ctx.name_in_source}</td>
        </tr>
        <tr>
            <td>Language family:</td>
            <td>${ctx.language_family}</td>
        </tr>
        <tr>
            <td>Language or dialect:</td>
            <td>${glottolog.link(request, ctx.glottocode, label=ctx.language)}</td>
        </tr>
        <tr>
            <td>Principal year to which data refer:</td>
            <td>${ctx.year}</td>
        </tr>
            % if ctx.hraf_id:
                <tr>

                    <td>eHRAF:</td>
                    <td>
                        <a href="${ctx.hraf_url}">
                            <img width="18" style="margin-top: -2px" src="${request.static_url('dplace2:static/hrafLogoBlue_inverted.png')}">
                            ${'{0} ({1})'.format(ctx.hraf_name, ctx.hraf_id)}
                        </a>
                    </td>
                </tr>
            % endif
            % if ctx.related:
                <tr>
                    <td>Related societis in D-PLACE:</td>
                    <td>
                        <ul class="unstyled">
                            % for soc in ctx.related:
                                <li>${h.link(request, soc)} (${h.link(request, soc.dataset)})</li>
                            % endfor
                        </ul>
                    </td>
                </tr>
            % endif
        </tbody>
    </table>
</div>

${request.get_datatable('values', h.models.Value, language=ctx).render()}

<%def name="sidebar()">
    ${util.language_meta()}
</%def>
