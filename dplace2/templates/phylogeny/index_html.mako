<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "phylogenys" %>
<%block name="title">${_('Phylogenys')}</%block>

<h2>${title()}</h2>

<p>
    Select a phylogeny or classification from the list below. You will then have the option to map cultural or
    environmental variables onto the phylogeny.
    ## FIXME: implement or link to repository?
    ##You will also have the option of downloading the phylogeny as a nexus file.
</p>
<div>
    ${ctx.render()}
</div>
