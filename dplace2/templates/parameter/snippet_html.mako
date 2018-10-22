<%namespace name="dplace" file="../dplace_util.mako"/>
% if ctx.domain:
    ${dplace.codes_table(ctx, with_icon=True, with_repr=True)}
% elif 'range' in ctx.jsondata or {}:
    <table>
        <thead>
        <tr>
            <th colspan="2">Range:</th>
        </tr>
        </thead>
        <tbody>
        % for number, color in ctx.jsondata['range']:
            <tr>
                <td>
                    % if loop.first or loop.last:
                        ${number}
                    % endif
                    &nbsp;
                </td>
                <td style="background-color: ${color}">&nbsp;&nbsp;&nbsp;</td>
            </tr>
        % endfor
        </tbody>
    </table>
% endif
