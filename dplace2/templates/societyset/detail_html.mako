<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "societysets" %>

<div class="row-fluid">
    <div class="span8">
<h2>
    Society set ${ctx.name}
    <a href="https://github.com/D-PLACE/dplace-data/tree/master/datasets/${ctx.id}"
       title="D-PLACE dataset ${ctx.name} on GitHub">
        <img src="${request.static_url('dplace2:static/GitHub-Mark-32px.png')}" width="30" style="margin-top: -5px">
    </a>
</h2>

% if ctx.description:
    <p>${ctx.description}</p>
% endif
    </div>
    <div class="span4">
        ${u.citation(req, ctx)|n}
    </div>
</div>
<div class="row-fluid">
    <div class="span12">

${request.get_map('languages', societyset=ctx.id).render()}

${request.get_datatable('languages', h.models.Language, societyset=ctx).render()}
    </div>
</div>