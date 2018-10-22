<%def name="codes_table(variable, title_attr='description', with_icon=False, with_repr=False, with_head=True)">
    <table class="table table-condensed table-nonfluid">
        % if with_head:
            <thead>
            <tr>
                % if with_icon:
                    <th></th>
                % endif
                <th>Code #</th>
                <th>Code</th>
                % if with_repr:
                    <th># Societies</th>
                % endif
            </tr>
            </thead>
        % endif
    <tbody>
        % for de in variable.domain:
            <tr>
                % if with_icon:
                    <td>${h.map_marker_img(req, de, height=12, width=12)}</td>
                % endif
                <td>${de.number}</td>
                <td>${getattr(de, title_attr)}</td>
                % if with_repr:
                    <td class="right">${len(de.values)}</td>
                % endif
            </tr>
        % endfor
    </tbody>
</table>
</%def>
