<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! from clld.web.util import glottolog %>
<%! active_menu_item = "languages" %>
<%block name="title">${_('Language')} ${ctx.name}</%block>

<%def name="society_meta()">
    <div class="accordion" id="sidebar-accordion">
        % if getattr(request, 'map', False):
            <%util:accordion_group eid="acc-map" parent="sidebar-accordion" title="Map" open="${True}">
                ${request.map.render()}
                ${h.format_coordinates(ctx)}
            </%util:accordion_group>
        % endif
        % if ctx.sources:
            <%util:accordion_group eid="sources" parent="sidebar-accordion" title="Sources">
                <ul>
                    % for source in ctx.sources:
                        <li>${h.link(request, source, label=source.description)}<br/>
                            <small>${h.link(request, source)}</small>
                        </li>
                    % endfor
                </ul>
            </%util:accordion_group>
        % endif
        % if ctx.identifiers:
            <%util:accordion_group eid="acc-names" parent="sidebar-accordion" title="${_('Alternative names')}">
                <dl>
                    % for type_, identifiers in h.groupby(sorted(ctx.identifiers, key=lambda i: i.type), lambda j: j.type):
                        <dt>${type_}:</dt>
                    % for identifier in identifiers:
                        <dd>${h.language_identifier(request, identifier)}</dd>
                    % endfor
                    % endfor
                </dl>
            </%util:accordion_group>
        % endif
        % if ctx.phylogeny_assocs:
            <%util:accordion_group eid="acc-phy" parent="sidebar-accordion" title="${_('Phylogenies')}">
                <ul>
                    % for pa in ctx.phylogeny_assocs:
                        <li><strong>${pa.label}</strong> on ${h.link(req, pa.phylogeny)}</li>
                    % endfor
                </ul>
            </%util:accordion_group>
        % endif
    </div>
</%def>


<h2>${_('Language')}: ${ctx.name} (${ctx.id})</h2>

<div class="well well-small">
    <table class="table table-nonfluid table-condensed">
        <tbody>
        <tr>
            <td>Name and ID in ${h.link(req, ctx.societyset)}:</td>
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
        <tr>
            <td><a href="${req.route_url('glossary', _anchor='q9')}">Cross-societyset id</a>:</td>
            <td>${ctx.xid}</td>
        </tr>
            % if ctx.hraf_id:
                <tr>

                    <td>eHRAF:</td>
                    <td>
                        <a href="${ctx.hraf_url}">
                            <img width="18" style="margin-top: -2px"
                                 src="${request.static_url('dplace2:static/hrafLogoBlue_inverted.png')}">
                            ${'{0} ({1})'.format(ctx.hraf_name, ctx.hraf_id)}
                        </a>
                    </td>
                </tr>
            % endif
            % if ctx.related:
                <tr>
                    <td>Related societies in D-PLACE:</td>
                    <td>
                        <ul class="unstyled">
                            % for soc in ctx.related:
                                <li>${h.link(request, soc)} (${h.link(request, soc.societyset)})</li>
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
    ${society_meta()}
</%def>
