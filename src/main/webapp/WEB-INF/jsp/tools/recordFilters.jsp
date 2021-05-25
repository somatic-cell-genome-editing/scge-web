<style>
    .recordFilterBlock {
        height:250px;
        border: 2px solid #F7F7F7;
        padding:5px;
        overflow-y:scroll;

    }
    .recordFilterTitle {
        font-size:18px;
        background-color:#F7F7F7;


    }
</style>

<div>Filter Options</div>
<table align="center" border="0">
    <tr>
        <td valign="top">
            <table>

                <tr>
                    <td class="recordFilterTitle">Conditions</td>
                </tr>
                <tr>
                    <td>
                        <div class="recordFilterBlock">
                        <table>
                        <% for (String condition: conditionList) { %>
                            <tr>
                                <td><input onclick="applyFilters(this)" id="<%=condition%>" type="checkbox" checked>&nbsp;<%=condition%> &nbsp;</td>
                            </tr>
                        <% } %>
                        </table>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
        <% if (tissueList.size() > 0 && selectedTissue == null) { %>
        <td valign="top">
            <table>
                <tr>
                    <td class="recordFilterTitle">Tissues</td>
                </tr>
                <tr>
                    <td>
                        <div class="recordFilterBlock">
                            <table>
                                <% for (String tissue: tissues) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=tissue%>" type="checkbox" checked>&nbsp;<%=tissue%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
        <% } %>
        <% if (editorList.size() > 0) { %>
        <td valign="top">
            <table>
                <tr>
                    <td  class="recordFilterTitle">Editors</td>
                </tr>
                <tr>
                    <td>
                        <div class="recordFilterBlock">
                            <table>
                                <% for (String editor: editorList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=editor%>" type="checkbox" checked>&nbsp;<%=editor%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
        <% } %>
        <% if (deliverySystemList.size() > 0 ) { %>
        <td valign="top">
            <table>
                <tr>
                    <td  class="recordFilterTitle">Delivery Systems</td>
                </tr>
                <tr>
                    <td>
                        <div class="recordFilterBlock">
                            <table>
                                <% for (String system: deliverySystemList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=system%>" type="checkbox" checked>&nbsp;<%=system%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
        <% } %>
        <% if (modelList.size() > 0 ) { %>
        <td valign="top">
            <table>
                <tr>
                    <td  class="recordFilterTitle">Models</td>
                </tr>
                <tr>
                    <td>
                        <div class="recordFilterBlock">
                            <table>
                                <% for (String model: modelList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=model%>" type="checkbox" checked>&nbsp;<%=model%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                        </div>

                    </td>
                </tr>
            </table>

        </td>
        <% } %>
        <% if (guideList.size() > 0 ) { %>
        <td valign="top">
            <table>
                <tr>
                    <td  class="recordFilterTitle">Guides</td>
                </tr>
                <tr>
                    <td>
                        <div class="recordFilterBlock">
                            <table>
                                <% for (String guide: guideList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=guide%>" type="checkbox" checked>&nbsp;<%=guide%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>

        </td>
        <% } %>
        <% if (vectorList.size() > 0 ) { %>
        <td valign="top">
            <table>
                <tr>
                    <td  class="recordFilterTitle">Vectors</td>
                </tr>
                <tr>
                    <td>
                        <div class="recordFilterBlock">
                            <table>
                                <% for (String vector: vectorList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=vector%>" type="checkbox" checked>&nbsp;<%=vector%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                        </div>
                    </td>
                </tr>
            </table>

        </td>
        <% } %>
        <% if (resultTypeList.size() > 0 && selectedResultType == null) { %>
        <td valign="top">
            <table>
                <tr>
                    <td  class="recordFilterTitle">Result Types</td>
                </tr>
                <tr>
                    <td>
                        <div class="recordFilterBlock">
                            <table>
                                <% for (String resultType: resultTypeList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=resultType%>" type="checkbox" checked>&nbsp;<%=resultType%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                        </div></td>
                </tr>
            </table>

        </td>
        <% } %>
        <% if (unitList.size() > 0 ) { %>
        <td valign="top">
            <table>
                <tr>
                    <td  class="recordFilterTitle">Units</td>
                </tr>
                <tr>
                    <td>
                        <div class="recordFilterBlock">
                            <table>
                                <% for (String unit: unitList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=unit%>" type="checkbox" checked>&nbsp;<%=unit%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                        </div></td>
                </tr>
            </table>

        </td>
        <% } %>
    </tr>
</table>

