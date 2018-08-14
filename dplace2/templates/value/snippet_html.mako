<%inherit file="../snippet.mako"/>
<%namespace name="util" file="../util.mako"/>

% if ctx.valueset.description:
<p>${h.text2html(h.Markup(ctx.valueset.markup_description) if ctx.valueset.markup_description else ctx.valueset.description)}</p>
% endif

% for line in (ctx.comment or '').split('\n'):
    <p>${u.link_sources(request, ctx, s=line)|n}</p>
% endfor