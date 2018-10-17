<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "parameters" %>
<%block name="title">${_('Parameters')}</%block>

<h2>${title()}</h2>

<p>
    Explore variables across D-PLACE datasets. Search by keyword (e.g., “subsistence”, “marriage”) or variable ID.
    The ‘filter’ functions at the top of many columns allow you to limit your search to variables of a particular type,
    theme, or from a particular <a href="${req.route_url('contributions')}">source dataset</a>.
    ## FIXME: implement first!
    ##You can also limit your search to variables that have been coded for societies in a language family of interest,
    ##or for societies in a particular society set [hyperlink to society set page].
    Once you have selected a variable, you will have the option to view codes for individual societies in a table, on a
    map, or on a phylogeny.
</p>

<div>
    ${ctx.render()}
</div>
