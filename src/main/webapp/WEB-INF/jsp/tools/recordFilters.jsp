
<style>
    body {
        font-family: "Lato", sans-serif;
    }

    .sidenav {
        height: 100%;
        width: 0;
        position: fixed;
        z-index: 1;
        top: 0;
        left: 0;
        background-color: #111;
        overflow-x: hidden;
        transition: 0.5s;
        padding-top: 60px;
    }

    .sidenav a {
        padding: 8px 8px 8px 32px;
        text-decoration: none;
        font-size: 25px;
        color: #818181;
        display: block;
        transition: 0.3s;
    }

    .sidenav td {
        padding: 8px 8px 8px 32px;
        text-decoration: none;
        font-size: 12px;
        color: #818181;
        display: block;
        transition: 0.3s;
    }

    .sidenav a:hover {
        color: #f1f1f1;
    }

    .sidenav .closebtn {
        position: absolute;
        top: 0;
        right: 25px;
        font-size: 36px;
        margin-left: 50px;
    }

    @media screen and (max-height: 450px) {
        .sidenav {padding-top: 15px;}
        .sidenav a {font-size: 18px;}
    }
</style>

<!--
<div id="mySidenav" class="sidenav">
    <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">&times;</a>
    <a href="#">About</a>
    <a href="#">Services</a>
    <a href="#">Clients</a>
    <a href="#">Contact</a>
</div>
-->

<span style="font-size:30px;cursor:pointer" onclick="openNav()">&#9776; open</span>

<script>
    function openNav() {
        document.getElementById("mySidenav").style.width = "400px";
    }

    function closeNav() {
        document.getElementById("mySidenav").style.width = "0";
    }
</script>



<style>
    .recordFilterBlock {
        height:250px;
        border: 2px solid #F7F7F7;
        padding:5px;
        overflow-y:scroll;

    }
    .recordFilterTitle {
        font-size:16px;
        ackground-color:#F7F7F7;


    }
</style>

<div>Filter Options</div>

<div id="mySidenav" class="sidenav">
    <a href="javascript:void(0)" class="closebtn" onclick="closeNav()">&times;</a>

    <table align="center" border="0">
    <tr>
        <td valign="top">
            <table>

                <tr>
                    <td class="recordFilterTitle">Conditions</td>
                </tr>
                <tr>
                    <td>
                        <table>
                        <% for (String condition: conditionList) { %>
                            <tr>
                                <td><input onclick="applyFilters(this)" id="<%=condition%>" type="checkbox" checked>&nbsp;<%=condition%> &nbsp;</td>
                            </tr>
                        <% } %>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <% if (tissueList.size() > 0 ) { %>
        <tr>
        <td valign="top">
            <table>
                <tr>
                    <td class="recordFilterTitle">Tissues</td>
                </tr>
                <tr>
                    <td>
                            <table>
                                <% for (String tissue: tissues) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=tissue%>" type="checkbox" checked>&nbsp;<%=tissue%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                    </td>
                </tr>
            </table>
        </td>
        </tr>
        <% } %>
        <% if (editorList.size() > 0) { %>
        <tr>
        <td valign="top">
            <table>
                <tr>
                    <td  class="recordFilterTitle">Editors</td>
                </tr>
                <tr>
                    <td>
                            <table>
                                <% for (String editor: editorList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=editor%>" type="checkbox" checked>&nbsp;<%=editor%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                    </td>
                </tr>
            </table>
        </td>
        </tr>
        <% } %>
        <% if (deliverySystemList.size() > 0 ) { %>
        <tr>
        <td valign="top">
            <table>
                <tr>
                    <td  class="recordFilterTitle">Delivery Systems</td>
                </tr>
                <tr>
                    <td>
                            <table>
                                <% for (String system: deliverySystemList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=system%>" type="checkbox" checked>&nbsp;<%=system%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                    </td>
                </tr>
            </table>
        </td>
        </tr>
        <% } %>
        <% if (modelList.size() > 0 ) { %>
        <tr>
        <td valign="top">
            <table>
                <tr>
                    <td  class="recordFilterTitle">Models</td>
                </tr>
                <tr>
                    <td>
                            <table>
                                <% for (String model: modelList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=model%>" type="checkbox" checked>&nbsp;<%=model%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                    </td>
                </tr>
            </table>

        </td>
        </tr>
        <% } %>
        <% if (guideList.size() > 0 ) { %>
        <tr>
        <td valign="top">
            <table>
                <tr>
                    <td  class="recordFilterTitle">Guides</td>
                </tr>
                <tr>
                    <td>
                            <table>
                                <% for (String guide: guideList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=guide%>" type="checkbox" checked>&nbsp;<%=guide%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                    </td>
                </tr>
            </table>

        </td>
        </tr>
        <% } %>
        <% if (vectorList.size() > 0 ) { %>
        <tr>
        <td valign="top">
            <table>
                <tr>
                    <td  class="recordFilterTitle">Vectors</td>
                </tr>
                <tr>
                    <td>
                            <table>
                                <% for (String vector: vectorList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=vector%>" type="checkbox" checked>&nbsp;<%=vector%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                    </td>
                </tr>
            </table>

        </td>
        </tr>
        <% } %>
        <% if (resultTypeList.size() > 0 ) { %>
        <tr>
        <td valign="top">
            <table>
                <tr>
                    <td  class="recordFilterTitle">Result Types</td>
                </tr>
                <tr>
                    <td>
                            <table>
                                <% for (String resultType: resultTypeList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=resultType%>" type="checkbox" checked>&nbsp;<%=resultType%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                    </td>
                </tr>
            </table>

        </td>
        </tr>
        <% } %>
        <% if (unitList.size() > 0 ) { %>
        <tr>
        <td valign="top">
            <table>
                <tr>
                    <td  class="recordFilterTitle">Units</td>
                </tr>
                <tr>
                    <td>
                            <table>
                                <% for (String unit: unitList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=unit%>" type="checkbox" checked>&nbsp;<%=unit%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                    </td>
                </tr>
            </table>

        </td>
        </tr>
        <% } %>

</table>

</div>