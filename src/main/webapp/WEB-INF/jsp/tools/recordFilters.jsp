
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
        opacity: 0.8;
    }

    .sidenav a {
        padding: 8px 8px 8px 8px;
        text-decoration: none;
        font-size: 25px;
        color: #818181;
        display: block;
        transition: 0.3s;
    }

    .sidenav td {
        adding: 8px 8px 8px 30px;
        text-decoration: none;
        font-size: 14px;
        color: white;
        display: block;
        transition: 0.3s;
        opacity:1;
    }

    .sidenav a:hover {
        color: #f1f1f1;
    }

    .sidenav .closebtn {
        position: absolute;
        top: 0px;
        left:0px;
        z-index: 100;
        right: 25px;
        font-size: 36px;
        margin-left: 50px;
        color:orange;
    }
    .filterOptions {
        padding:5px;
        position:fixed;
        top:400px;
        left:0px;
        z-index:100;
        color:orange;
        -webkit-transform: rotate(-90deg);
        -moz-transform: rotate(-90deg);
        transform:rotate(-90deg);
        filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
        background-color:#1A80B6;
        margin-left: -50px;
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
<!--
<span style="font-size:30px;cursor:pointer" onclick="openNav()">&#9776; open</span>
-->
<script>
    function openNav() {
        if (document.getElementById("mySidenav").style.width == "300px") {
            document.getElementById("recordTableContent").style.left="0px";
            document.getElementById("recordTableContent").style.width="100%";

            closeNav();
        }else {
            document.getElementById("mySidenav").style.width = "300px";
            document.getElementById("recordTableContent").style.left="300px";
            document.getElementById("recordTableContent").style.width="80%";
           // document.getElementById("filterButton").innerHTML="&#9776; Close";
        }
    }

    function closeNav() {
        document.getElementById("mySidenav").style.width = "0";
        //document.getElementById("filterButton").innerHTML="&#9776; Filter Options";

    }
</script>



<style>
    .recordFilterBlock {
        eight:250px;
        border: 0px solid #818181;
        padding:5px;
        overflow-y:auto;

    }
    .recordFilterTitle {
        font-size:20px;
        ackground-color:#818181;
        color:#818181;



    }
</style>

<div class="filterOptions">
    <a href="javascript:void(0)" style="color:white;" lass="closebtn" onclick="openNav()"><div id="filterButton">&#9776; Filter Options</div></a>
</div>

<div id="mySidenav" class="sidenav">

    <table align="center" border="0" style="margin-left:35px;">

        <% if (tissueList.size() > 0 ) { %>
        <tr>
        <td valign="top">
            <table>
                <tr>
                    <td ><div class="recordFilterTitle">Tissues</div></td>
                </tr>
                <tr>
                    <td>
                        <div class="recordFilterBlock">
                            <table>
                                <% for (String tissue: tissues) { 
								if(selectedTissue == null || tissue.equalsIgnoreCase(selectedTissue)) {
                                %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=tissue%>" type="checkbox" checked>&nbsp;<%=tissue%>
                                    </td>
                                </tr>
                                <%} else { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)" id="<%=tissue%>" type="checkbox" unchecked>&nbsp;<%=tissue%>
                                    </td>
                                </tr>
                               <% }} %>
                            </table>
                        </div>
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
                    <td  ><div class="recordFilterTitle">Editors</div></td>
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
        </tr>
        <% } %>
        <% if (deliverySystemList.size() > 0 ) { %>
        <tr>
        <td valign="top">
            <table>
                <tr>
                    <td  ><div class="recordFilterTitle">Delivery Systems</div></td>
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
        </tr>
        <% } %>
        <% if (modelList.size() > 0 ) { %>
        <tr>
        <td valign="top">
            <table>
                <tr>
                    <td  ><div class="recordFilterTitle">Models</div></td>
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
        </tr>
        <% } %>
        <% if (resultTypeList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td  ><div class="recordFilterTitle">Result Types</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String resultType: resultTypeList) { 
									if(selectedResultType == null || resultType.contains(selectedResultType)) {
                                %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=resultType%>" type="checkbox" checked>&nbsp;<%=resultType%>
                                    </td>
                                </tr>
                                <%} else { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=resultType%>" type="checkbox" unchecked>&nbsp;<%=resultType%>
                                    </td>
                                </tr>
                                <% }} %>
                                </table>
                            </div></td>
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
                        <td  ><div class="recordFilterTitle">Units</div></td>
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
        </tr>
        <% } %>

        <% if (cellTypeList.size() > 0 ) { %>
        <tr>
        <td valign="top">
            <table>
                <tr>
                    <td  ><div class="recordFilterTitle">Cell Types</div></td>
                </tr>
                <tr>
                    <td>
                        <div class="recordFilterBlock">
                            <table>
                                <% for (String cellType: cellTypeList) { %>
                                <tr>
                                    <td>
                                        <input onclick="applyFilters(this)"  id="<%=cellType%>" type="checkbox" checked>&nbsp;<%=cellType%>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                        </div>
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
                    <td  ><div class="recordFilterTitle">Vectors</div></td>
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
        </tr>
        <% } %>
        <tr>
            <td valign="top">
                <table>

                    <tr>
                        <td ><div class="recordFilterTitle">Conditions</div></td>
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
        </tr>
</table>

</div>