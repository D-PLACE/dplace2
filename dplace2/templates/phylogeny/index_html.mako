<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "phylogenys" %>
<%block name="title">${_('Phylogenys')}</%block>

<h2>${title()}</h2>

<p>
    Select a phylogeny or classification from the list below. You will then have the option to map cultural or
    environmental variables onto the phylogeny.
    Note that if a variable has not been coded for any societies on this phylogeny, it will not be available.
    If you would like to download the phylogeny and work with the data on your own system, please visit our
    ${h.external_link('https://github.com/D-PLACE/dplace-data/tree/master/phylogenies', label='repository of trees')}.
</p>
<div>
    ${ctx.render()}
</div>
