<%inherit file="../${context.get('request').registry.settings.get('clld.app_template', 'app.mako')}"/>
<%namespace name="util" file="../util.mako"/>
<%! active_menu_item = "contributions" %>

<%def name="sidebar()">
    ${u.citation(req, ctx)|n}
    <div class="well well-small">
        <h4>Focal time period</h4>
        <table class="table table-condensed table-nonfluid">
            <thead>
            <tr>
                <th>Period</th>
                <th>% of datapoints</th>
            </tr>
            </thead>
            <tbody>
                % for label, percent in focal_years:
                <tr>
                    <td>${label}</td>
                    <td class="right">${percent}</td>
                </tr>
                % endfor

            </tbody>
        </table>
    </div>
    <div class="well well-small">
        <h4>Variables by category</h4>
        <table class="table table-condensed table-nonfluid">
            <thead>
            <tr>
                <th>Category</th>
                <th>number of variables</th>
            </tr>
            </thead>
            <tbody>
                % for category, count in categories:
                    <tr>
                        <td>${category}</td>
                        <td class="right">${count}</td>
                    </tr>
                % endfor

            </tbody>
        </table>
    </div>
</%def>


<h2>
    ${_('Contribution')} ${ctx.name}
    <a href="https://github.com/D-PLACE/dplace-data/tree/master/datasets/${ctx.id}"
       title="D-PLACE dataset ${ctx.name} on GitHub">
        <img src="${request.static_url('dplace2:static/GitHub-Mark-32px.png')}" width="30" style="margin-top: -5px">
    </a>
</h2>

% if ctx.description:
    <p>${ctx.description}</p>
% endif

<h4>Variables</h4>

${request.get_datatable('parameters', h.models.Parameter, contribution=ctx).render()}
