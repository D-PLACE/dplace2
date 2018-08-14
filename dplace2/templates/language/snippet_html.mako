<%inherit file="../snippet.mako"/>
<%namespace name="util" file="../util.mako"/>

% if request.params.get('parameter'):
    ## called for the info windows on parameter maps
    ##<% valueset = h.DBSession.query(h.models.ValueSet).filter(h.models.ValueSet.parameter_pk == int(request.params['parameter'])).filter(h.models.ValueSet.language_pk == ctx.pk).first() %>
    <% valueset = h.get_valueset(request, ctx) %>
    <h3>${h.link(request, ctx)}</h3>
    % if valueset:
        <h4>${h.link(request, valueset, label='Datapoints')}</h4>
        <ul class="unstyled">
            % for i, value in enumerate(valueset.values):
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
    % endif
% else:
<h3>${h.link(request, ctx)}</h3>
    % if ctx.description:
        <p>${ctx.description}</p>
    % endif
${h.format_coordinates(ctx)}
% endif
