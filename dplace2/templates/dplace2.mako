<%inherit file="app.mako"/>

<%block name="brand">
    <a href="${request.resource_url(request.dataset)}" class="brand"
       style="padding-top: 0; padding-bottom: 0; margin-top: 0; margin-bottom: 0;">
        <img src="${request.static_url('dplace2:static/logo.png')}" height="40" width="120" style="float: left"/>
    </a>
</%block>

<%block name="footer">
    <div class="row-fluid" style="padding-top: 15px; background-color: black; color: white;">
        <div class="span2" style="text-align: center">
            <a href="${request.dataset.publisher_url}"
               title="${request.dataset.publisher_name}, ${request.dataset.publisher_place}">
                    <img width="80" src="${request.static_url('dplace2:static/minerva_white.png')}"/>
            </a>
        </div>
        <div class="span2" style="vertical-align: middle;">
            <a href="http://nescent.org/"
               title="The National Evolutionary Synthesis Center">
                <img style="width: 100%;" src="${request.static_url('dplace2:static/nescent_white.png')}"/>
            </a>
        </div>
        <div class="span3" style="text-align: center;">
            <% license_icon = h.format_license_icon_url(request) %>
            <a rel="license" href="${request.dataset.license}">
                <img alt="License" style="border-width:0" src="${license_icon}"/>
            </a>
            <br/>
            D-PLACE is licensed under a
            <a rel="license" href="${request.dataset.license}" style="color: white">
                ${request.dataset.jsondata.get('license_name', request.dataset.license)}</a>.
        </div>
        <div class="span2" style="text-align: right;">
            <a href="https://github.com/D-PLACE/dplace-data"
               title="D-PLACE data repository on GitHub">
                <img width="130" src="${request.static_url('dplace2:static/GitHub_Logo_White.png')}" style="margin-bottom: -10px;"/>
                <br/>
                <span style="color: red; font-family: monospace; font-size: larger;">&lt;data&gt;</span>
            </a>
        </div>
        <div class="span2" style="text-align: right;">
            <a href="https://github.com/${request.registry.settings['clld.github_repos']}"
               title="">
                <img width="130" src="${request.static_url('dplace2:static/GitHub_Logo_White.png')}" style="margin-bottom: -10px;"/>
                <br/>
                <span style="color: red; font-family: monospace; font-size: larger;">&lt;code ${request.registry.settings['clld.git_tag']}&gt;</span>
            </a>
        </div>
        <div class="span1" style="text-align: right; padding-right: 1em;">
            <a class="clld-privacy-policy"
               style="color: white;"
               href="${request.registry.settings['clld.privacy_policy_url']}">${_('Privacy Policy')}</a><br/>
            <a class="clld-disclaimer" style="color: white" href="${request.route_url('legal')}">${_('Disclaimer')}</a>
        </div>
    </div>

</%block>


${next.body()}
