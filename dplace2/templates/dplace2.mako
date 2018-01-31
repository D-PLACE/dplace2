<%inherit file="app.mako"/>

<%block name="brand">
    <a href="${request.resource_url(request.dataset)}" class="brand" style="padding-top: 0; padding-bottom: 0; margin-top: 0; margin-bottom: 0;">
        <img src="${request.static_url('dplace2:static/logo.png')}" height="40" width="120" style="float: left"/>
    </a>
</%block>

${next.body()}
