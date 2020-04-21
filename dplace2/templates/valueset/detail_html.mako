<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "contributions" %>


<h2>${_('Value Set')} ${h.link(request, ctx.language)}/${h.link(request, ctx.parameter)}</h2>

% if ctx.description:
${h.text2html(h.Markup(ctx.markup_description) if ctx.markup_description else ctx.description, mode='p')}
% endif

<h3>${_('Values')}</h3>
<ul class="unstyled">
% for i, value in enumerate(ctx.values):
    <li>
        <h4>
            ${h.map_marker_img(request, value)}
            ${value}
            % if value.frequency > 1:
                (${int(value.frequency)} estimates)
            % endif
        </h4>
        <dl class="dl-horizontal">
            % if value.year:
                <dt>${_('Year')}:</dt>
                <dd>${value.year}</dd>
            % endif
            % if value.sub_case:
                <dt>${_('Subcase')}:</dt>
                <dd>${value.sub_case}</dd>
            % endif
            % if value.comment:
                <dt>${_('Comment')}:</dt>
                <dd>${value.comment}</dd>
            % endif
            % if value.confidence:
                    <dt>${_('Confidence')}:</dt>
                    <dd>${value.confidence}</dd>
            % endif
            % if value.references:
                <dt>Sources</dt>
                <dd>
                    ${h.linked_references(request, value)}
                </dd>
            % endif
        </dl>
    </li>
% endfor
</ul>
<%def name="sidebar()">
<div class="well well-small">
<dl>
    <dt class="contribution">${_('Contribution')}:</dt>
    <dd class="contribution">
        ${h.link(request, ctx.contribution)}
        by
        ${h.linked_contributors(request, ctx.contribution)}
        ${h.button('cite', onclick=h.JSModal.show(ctx.contribution.name, request.resource_url(ctx.contribution, ext='md.html')))}
    </dd>
    <dt>${_('Language')}:</dt>
    <dd>${h.link(request, ctx.language)}</dd>
    <dt class="parameter">${_('Parameter')}:</dt>
    <dd class="parameter">${h.link(request, ctx.parameter)}</dd>
    % if ctx.references or ctx.source:
    <dt class="source">${_('Source')}:</dt>
        % if ctx.source:
        <dd>${ctx.source}</dd>
        % endif
        % if ctx.references:
        <dd class="source">${h.linked_references(request, ctx)|n}</dd>
        % endif
    % endif
    ${util.data(ctx, with_dl=False)}
</dl>
</div>
</%def>
