<%inherit file="../snippet.mako"/>
<%namespace name="util" file="../util.mako"/>

% if ctx.description:
<p>${h.text2html(ctx.description)}</p>
% endif

<h3>${_('Values')}</h3>
<ul class="unstyled">
    % for i, value in enumerate(ctx.values):
        <li>
            <h4>
                ${h.map_marker_img(request, value)}
                ${value.__unicode__()}
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
