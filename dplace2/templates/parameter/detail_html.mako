<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "parameters" %>
<%block name="title">${_('Parameter')} ${ctx.name}</%block>

<div class="row-fluid">
    <div class="span8">
        <h2>${ctx.name}</h2>

        % if ctx.description:
            <p>${ctx.description}</p>
        % endif
    </div>
    <div class="span4">
            <%util:well title="Values">
            <table class="table table-condensed">
                % for de in ctx.domain:
                    <tr>
                        <td>${de}</td>
                        <td class="right">${len(de.values)}</td>
                    </tr>
                % endfor
            </table>
        </%util:well>
    </div>
</div>

% if map_ or request.map:
    ${(map_ or request.map).render()}
% endif

${request.get_datatable('values', h.models.Value, parameter=ctx).render()}
