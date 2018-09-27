<%inherit file="../snippet.mako"/>
<%namespace name="util" file="../util.mako"/>

% if ctx.comment:
    % for line in (ctx.comment or '').split('\n'):
        <p>${u.link_sources(request, ctx, s=line)|n}</p>
    % endfor
% endif

% if ctx.references:
    <p>
        <strong>Sources:</strong>
        ${h.linked_references(request, ctx)}
    </p>
% endif

