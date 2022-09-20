<%@ page import="com.google.gson.Gson" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    body {
        font-family: "Roboto","Lato", sans-serif;
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
        left:5px;
        z-index:100;
        color:orange;
        -webkit-transform: rotate(-90deg);
        -moz-transform: rotate(-90deg);
        transform:rotate(-90deg);
        filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
        background-color:#1A80B6;
        margin-left: -50px;
        visibility:hidden;
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
            //document.getElementById("recordTableContent").style.left="0px";
            //document.getElementById("recordTableContent").style.width="100%";
            document.getElementById("site-wrapper").style.left="0px";
            document.getElementById("site-wrapper").style.width="100%";
            document.getElementById("filterOpen").style.visibility="visible";
            document.getElementById("filterClose").style.visibility="hidden";
            closeNav();
        }else {
            document.getElementById("mySidenav").style.width = "300px";
            //document.getElementById("recordTableContent").style.left="300px";
            //document.getElementById("recordTableContent").style.width="75%";
            document.getElementById("site-wrapper").style.left="300px";
            document.getElementById("site-wrapper").style.width="75%";
            document.getElementById("filterClose").style.visibility="visible";
            document.getElementById("filterOpen").style.visibility="hidden";
        }
    }

    function closeNav() {
        document.getElementById("mySidenav").style.width = "0";
        //document.getElementById("filterButton").innerHTML="&#9776; Filter Options";

    }
</script>



<style>
    .recordFilterBlock {
        max-height:250px;
        width: 200px;
        border: 1px solid #4A4A4A;
        padding-left:5px;
        padding-right:5px;
        padding-top:7px;
        padding-bottom:6px;
        overflow-y:auto;

    }
    .recordFilterTitle {
        padding-top:6px;
        font-size:20px;
        ackground-color:#818181;
        color:#818181;



    }
</style>

<div class="filterOptions" id="filterClose">
    <a href="javascript:void(0)" style="color:white;" lass="closebtn" onclick="openNav()">&#9776; Close Options</a>
</div>
<div class="filterOptions" id="filterOpen">
    <a href="javascript:void(0)" style="color:white;" lass="closebtn" onclick="openNav()">&#9776; Open Options</a>
</div>
<div id="mySidenav" class="sidenav">

    <table align="center" border="0" style="margin-left:35px;">

        <% if (tissueList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td ><div class="recordFilterTitle">
                            <% if (tissueList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'tissue')" id="allTissues"  type="checkbox" checked>&nbsp;
                            <%}%>
                            Tissues</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String tissue: tissues) {
                                        String title="";
                                        String color="";
                                        if(tissuesTarget.contains(tissue)){
                                            title="Target Tissue";
                                            color="#DA70D6";
                                        }
                                        if(selectedTissue == null || tissue.equalsIgnoreCase(selectedTissue)) {

                                    %>
                                    <tr>
                                        <td  title="<%=title%>" style="color:<%=color%>">
                                            <input onclick="applyFilters(this)" name="tissue"  id="<%=tissue%>" type="checkbox" checked>&nbsp;<%=tissue%>
                                        </td>
                                    </tr>
                                    <%} else { %>
                                    <tr>
                                        <td  title="<%=title%>" style="color:<%=color%>">
                                            <input onclick="applyFilters(this)" name="tissue" id="<%=tissue%>" type="checkbox" unchecked>&nbsp;<%=tissue%>
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

        <% if (cellTypeList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td  ><div class="recordFilterTitle">
                            <% if (cellTypeList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkcelltype')" id="allCellTypes"  type="checkbox" checked>&nbsp;
                            <%}%>Cell Types</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String cellType: cellTypeList) { if(selectedCellType == null || cellType.equalsIgnoreCase(selectedCellType)) {
                                    %>
                                    <tr>
                                        <td>
                                            <input onclick="applyFilters(this)"  name="checkcelltype" id="<%=cellType%>" type="checkbox" checked>&nbsp;<%=cellType%>
                                        </td>
                                    </tr>
                                    <%} else { %>
                                    <tr>
                                        <td>
                                            <input onclick="applyFilters(this)" name="checkcelltype" id="<%=cellType%>" type="checkbox" unchecked>&nbsp;<%=cellType%>
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
                        <td  ><div class="recordFilterTitle">
                            <% if (editorList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkeditor')" id="alleditors"  type="checkbox" checked>&nbsp;
                            <%}%>
                            Editors</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String editor: editorList) { %>
                                    <tr>
                                        <td>
                                            <input onclick="applyFilters(this)" name="checkeditor" id="<%=editor%>" type="checkbox" checked>&nbsp;<%=editor%>
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
        <% if (guideList.size() > 0) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td  ><div class="recordFilterTitle">
                            <% if (guideList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checktargetlocus')" id="allTargetLocus"  type="checkbox" checked>&nbsp;
                            <%}%>
                            Guide Target Locus
                        </div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String locus: guideTargetLocusList) { %>
                                    <tr>
                                        <td>
                                            <input onclick="applyFilters(this)" name="checktargetlocus" id="<%=locus%>" type="checkbox" checked>&nbsp;<%=locus%>
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
        <% if (guideList.size() > 0) { %>

        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td><div class="recordFilterTitle">
                            <% if (guideList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkguide')" id="allGuides"  type="checkbox" checked>&nbsp;
                            <%}%>
                            Guides</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String guide: guideList) { %>
                                    <tr>
                                        <td>
                                            <input onchange="applyFilters(this)" name="checkguide" id="<%=guide%>" type="checkbox" checked>&nbsp;<%=guide%>
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
                        <td  ><div class="recordFilterTitle">
                            <% if (deliverySystemList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkdelivery')" id="allDeliveries"  type="checkbox" checked>&nbsp;
                            <%}%>
                            Delivery Systems</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String system: deliverySystemList) { %>
                                    <tr>
                                        <td>
                                            <input onclick="applyFilters(this)" name="checkdelivery" id="<%=system%>" type="checkbox" checked>&nbsp;<%=system%>
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
                        <td  ><div class="recordFilterTitle">
                            <% if (modelList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkmodel')" id="allModels"  type="checkbox" checked>&nbsp;
                            <%}%>
                            Models</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String model: modelList) { %>
                                    <tr>
                                        <td>
                                            <input onclick="applyFilters(this)" name="checkmodel"  id="<%=model%>" type="checkbox" checked>&nbsp;<%=model%>
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
        <% if (hrdonorList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td  ><div class="recordFilterTitle">
                            <% if (hrdonorList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkhrdonor')" id="allHrdonors"  type="checkbox" checked>&nbsp;
                            <%}%>
                            Hr Donors</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String hrdonor: hrdonorList) { %>
                                    <tr>
                                        <td>
                                            <input onclick="applyFilters(this)" name="checkhrdonor"  id="<%=hrdonor%>" type="checkbox" checked>&nbsp;<%=hrdonor%>
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
        <% if (sexList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td ><div class="recordFilterTitle">
                            <% if (sexList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checksex')" id="allSex"  type="checkbox" checked>&nbsp;
                            <%}%>
                            Sex</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String sex: sexList) { %>
                                    <tr>
                                        <td>
                                            <input onclick="applyFilters(this)" name="checksex"  id="<%=sex%>" type="checkbox" checked>&nbsp;<%=sex%>
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
                        <td  ><div class="recordFilterTitle">
                            <% if (resultTypeList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkresulttype')" id="allResultTypes"  type="checkbox" checked>&nbsp;
                            <%}%>
                            Result Types</div></td>
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
                                            <input onclick="applyFilters(this)" name="checkresulttype" id="<%=resultType%>" type="checkbox" checked>&nbsp;<%=resultType%>
                                        </td>
                                    </tr>
                                    <%} else { %>
                                    <tr>
                                        <td>
                                            <input onclick="applyFilters(this)"  name="checkresulttype" id="<%=resultType%>" type="checkbox" unchecked>&nbsp;<%=resultType%>
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
                        <td  ><div class="recordFilterTitle">
                            <% if (unitList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkunits')" id="allUnits"  type="checkbox" checked>&nbsp;
                            <%}%>
                            Units</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String unit: unitList) { %>
                                    <tr>
                                        <td>
                                            <input onclick="applyFilters(this)" name="checkunits"  id="<%=unit%>" type="checkbox" checked>&nbsp;<%=unit%>
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

        <% if (vectorList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td  ><div class="recordFilterTitle">
                            <% if (vectorList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkvector')" id="allVectors"  type="checkbox" checked>&nbsp;
                            <%}%>
                            Vectors</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String vector: vectorList) { %>
                                    <tr>
                                        <td>
                                            <input onclick="applyFilters(this)" name="checkvector" id="<%=vector%>" type="checkbox" checked>&nbsp;<%=vector%>
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
        <!--tr>
            <td valign="top">
                <table>

                    <tr>
                        <td ><div class="recordFilterTitle">Conditions</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                  <!--c:forEach items="${experiments}" var="condition"-->
        <!--tr>
                                        <td><input onclick='applyFilters(${condition})' id='${fn:replace(condition,"\"", "")}' type="checkbox" checked>&nbsp;${fn:replace(condition,"\"", "")} &nbsp;</td>
                                    </tr-->
        <!--/c:forEach-->
        <!--/table>
    </div>
</td>
</tr>
</table>
</td>
</tr-->
    </table>

</div>
<script>
    setTimeout(openNav,1000);
    /*   $(document).ready(function()
        {
            $("#allGuides").on("change", function()
            {
            //    var table = document.getElementById('myTable'); //to remove filtered rows
              $('input[name=checkguide]').attr('checked', $(this).prop('checked'));
             /*       $.each(guideList, function (i,g) {
                        table.rows.item(g).style.display = "none";
                    })
    */
    /*         applyAllFilters()
            });
        });*/
    /*  function toggleFilters( objectType, _this) {
          var checked= _this.prop('checked');
          alert("checked:"+ checked);

          $('input[name=checkguide]').attr('checked', checked);


      }*/
</script>