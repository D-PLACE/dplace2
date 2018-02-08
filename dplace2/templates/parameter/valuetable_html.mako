                    % if ctx.description:
                    <div class="alert">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
                        <small><i>${ctx.description}</i></small>
                    </div>
                    % endif

                    % if ctx.domain:
                        <table class="table table-condensed">
                            % for de in ctx.domain:
                                <tr>
                                    <td>${h.map_marker_img(req, de, height=12, width=12)}</td>
                                    <td>${de.number}</td>
                                    <td>${de}</td>
                                    <td class="right">${len(de.values)}</td>
                                </tr>
                            % endfor
                        </table>
                    % elif 'range' in ctx.jsondata or {}:
                        <table>
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
                        </table>
                    % endif
