<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "contributions" %>

<%def name="sidebar()">
    <div class="well well-small">
        <h4>Source</h4>
        <p>${ctx.reference}</p>
    </div>
</%def>


<h2>${_('Contribution')} ${ctx.name}</h2>

% if ctx.description:
    <p>${ctx.description}</p>
% endif

<div class="tabbable">
    <ul class="nav nav-tabs">
        <li class="active"><a href="#variables" data-toggle="tab">Variables</a></li>
        <li><a href="#societies" data-toggle="tab">Societies</a></li>
    </ul>
    <div class="tab-content">
        <div id="variables" class="tab-pane active">
            ${request.get_datatable('parameters', h.models.Parameter, contribution=ctx).render()}
        </div>
        <div id="societies" class="tab-pane">
            ${request.get_datatable('languages', h.models.Language, contribution=ctx).render()}
        </div>
    </div>
    <script>
$(document).ready(function() {
    if (location.hash !== '') {
        $('a[href="#' + location.hash.substr(2) + '"]').tab('show');
    }
    return $('a[data-toggle="tab"]').on('shown', function(e) {
        return location.hash = 't' + $(e.target).attr('href').substr(1);
    });
});
    </script>
</div>
