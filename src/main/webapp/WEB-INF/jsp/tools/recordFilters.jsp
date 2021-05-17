<div>Filter Options</div>
<table style="margin-left:150px;">
    <tr>
        <td valign="top">
            <table>

                <tr>
                    <td style="font-size:18px; background-color:#F7F7F7;">Conditions</td>
                </tr>
                <% for (String condition: conditionList) { %>
                <tr>
                    <td><input onclick="applyFilters(this)" id="<%=condition%>" type="checkbox" checked>&nbsp;<%=condition%></td>
                </tr>
                <% } %>

            </table>

        </td>
        <td>
            &nbsp;
        </td>
        <% if (tissueList.size() > 0 ) { %>
        <td valign="top">
            <table>
                <tr>
                    <td style="font-size:18px; background-color:#F7F7F7;">Tissues</td>
                </tr>
                <% for (String tissue: tissues) { %>
                <tr>
                    <td><input onclick="applyFilters(this)"  id="<%=tissue%>" type="checkbox" checked>&nbsp;<%=tissue%></td>
                </tr>
                <% } %>

            </table>

        </td>
        <td>
            &nbsp;
        </td>
        <% } %>
        <% if (editorList.size() > 0) { %>
        <td valign="top">
            <table>
                <tr>
                    <td style="font-size:18px; background-color:#F7F7F7;">Editors</td>
                </tr>
                <% for (String editor: editorList) { %>
                <tr>
                    <td><input onclick="applyFilters(this)"  id="<%=editor%>" type="checkbox" checked>&nbsp;<%=editor%></td>
                </tr>
                <% } %>

            </table>

        </td>
        <td>
            &nbsp;
        </td>
        <% } %>
        <% if (deliverySystemList.size() > 0 ) { %>
        <td valign="top">
            <table>
                <tr>
                    <td style="font-size:18px; background-color:#F7F7F7;">Delivery Systems</td>
                </tr>
                <% for (String system: deliverySystemList) { %>
                <tr>
                    <td><input onclick="applyFilters(this)"  id="<%=system%>" type="checkbox" checked>&nbsp;<%=system%></td>
                </tr>
                <% } %>

            </table>

        </td>
        <td>
            &nbsp;
        </td>
        <% } %>
        <% if (modelList.size() > 0 ) { %>
        <td valign="top">
            <table>
                <tr>
                    <td style="font-size:18px; background-color:#F7F7F7;">Models</td>
                </tr>
                <% for (String model: modelList) { %>
                <tr>
                    <td><input onclick="applyFilters(this)"  id="<%=model%>" type="checkbox" checked>&nbsp;<%=model%></td>
                </tr>
                <% } %>

            </table>

        </td>
        <td>
            &nbsp;
        </td>
        <% } %>
        <% if (guideList.size() > 0 ) { %>
        <td valign="top">
            <table>
                <tr>
                    <td style="font-size:18px; background-color:#F7F7F7;">Guides</td>
                </tr>
                <% for (String guide: guideList) { %>
                <tr>
                    <td><input onclick="applyFilters(this)"  id="<%=guide%>" type="checkbox" checked>&nbsp;<%=guide%></td>
                </tr>
                <% } %>

            </table>

        </td>
        <td>
            &nbsp;
        </td>
        <% } %>
        <% if (vectorList.size() > 0 ) { %>
        <td valign="top">
            <table>
                <tr>
                    <td style="font-size:18px; background-color:#F7F7F7;">Vectors</td>
                </tr>
                <% for (String vector: vectorList) { %>
                <tr>
                    <td><input onclick="applyFilters(this)"  id="<%=vector%>" type="checkbox" checked>&nbsp;<%=vector%></td>
                </tr>
                <% } %>

            </table>

        </td>
        <td>
            &nbsp;
        </td>
        <% } %>
        <% if (resultTypeList.size() > 0 ) { %>
        <td valign="top">
            <table>
                <tr>
                    <td style="font-size:18px; background-color:#F7F7F7;">Result Types</td>
                </tr>
                <% for (String resultType: resultTypeList) { %>
                <tr>
                    <td><input onclick="applyFilters(this)"  id="<%=resultType%>" type="checkbox" checked>&nbsp;<%=resultType%></td>
                </tr>
                <% } %>

            </table>

        </td>
        <td>
            &nbsp;
        </td>
        <% } %>
        <% if (unitList.size() > 0 ) { %>
        <td valign="top">
            <table>
                <tr>
                    <td style="font-size:18px; background-color:#F7F7F7;">Units</td>
                </tr>
                <% for (String unit: unitList) { %>
                <tr>
                    <td><input onclick="applyFilters(this)"  id="<%=unit%>" type="checkbox" checked>&nbsp;<%=unit%></td>
                </tr>
                <% } %>

            </table>

        </td>
        <% } %>
    </tr>
</table>

