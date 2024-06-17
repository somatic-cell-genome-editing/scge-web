<%@ page import="com.google.gson.Gson" %>

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
        background-color: #f8f9fa;
        overflow-x: hidden;
        transition: 0.5s;
        padding-top: 20px;

    }

    .sidenav a {
        padding: 8px 8px 8px 8px;
        text-decoration: none;
        font-size: 25px;
        color: black;
        display: block;
        transition: 0.3s;
    }

    .sidenav td {
        adding: 8px 8px 8px 30px;
        text-decoration: none;
        font-size: 14px;
        color: black;
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
    .recordFilterBlock {
        max-height:250px;
        width: 200px;
        border: 1px solid gainsboro;
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

<div class="filterOptions" id="filterClose">
    <a href="javascript:void(0)" style="color:white;" lass="closebtn" onclick="openNav()">&#9776; Close Options</a>
</div>
<div class="filterOptions" id="filterOpen">
    <a href="javascript:void(0)" style="color:white;" lass="closebtn" onclick="openNav()">&#9776; Open Options</a>
</div>
<div id="mySidenav" class="sidenav">
    <%
        boolean filtersAvailable=false;
        for(String key: tableColumns.keySet()){
            if(!key.equalsIgnoreCase("injectionFrequency") && !key.equalsIgnoreCase("dosage") && !key.equalsIgnoreCase("units")){
                List<String> values=tableColumns.get(key);
                if(values!=null && values.size()>1 ){
                    filtersAvailable=true;
     }}}
        if(filtersAvailable){
    %>
    <div class="row sticky-top " style="background-color: white; box-shadow: 5px 5px gainsboro;border:1px solid gainsboro; padding-bottom: 10px; padding-top: 10px">
        <div class="col-lg-5 pt-10" >
            <h5 style="margin-left: 20px;">Filters .. <i class="fa-solid fa-down"></i></h5>
        </div>
        <div class="col pt-10">
            <div class="row">
                <div class="col-5">
                    <button class="btn btn-secondary btn-sm" onclick="load(false)">Apply</button>
                </div>
                <div class="col">
                    <button class="btn btn-secondary btn-sm" onclick="resetFilters()">Select All</button>
                </div>
            </div>
        </div>

    </div>
    <%}%>
    <table align="center" border="0" style="margin-left:35px;">

        <% if (tissueList!=null && tissueList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td ><div class="recordFilterTitle">
                            <% if (tissueList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'tissue', 'Tissue')" id="allTissues"  type="checkbox" checked>&nbsp;
                            <%}%>
                            Tissues</div></td>
                    </tr>
                    <tr>
                        <td><%@include file="tissueFilters.jsp"%>

                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <% } %>
        <% if (qualifierList!=null && qualifierList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td  ><div class="recordFilterTitle">
                            <% if (qualifierList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkqualifier', 'Qualifier')" id="allQualifiers"  type="checkbox" checked>&nbsp;
                            <%}%>Qualifier</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String qualifier: qualifierList) {
                                        //if(qualifier.length()>1){
                                    %>

                                    <tr>
                                        <td>
                                            <% if (qualifierList.size() > 1) { %>
                                            <input  name="checkqualifier" id="<%=qualifier.trim()%>" type="checkbox" checked><%}%>&nbsp;<%=qualifier%>
                                        </td>
                                    </tr>
                                    <%// }
                                    } %>
                                </table>
                            </div>
                        </td>
                    </tr>
                </table>

            </td>
        </tr>
        <% } %>
        <% if (timePointList!=null && timePointList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td  ><div class="recordFilterTitle">
                            <% if (timePointList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkTimePoint', 'Time Point')" id="allTimePoints"  type="checkbox" checked>&nbsp;
                            <%}%>Time Point</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String timePoint: timePointList) {%>

                                    <tr>
                                        <td>
                                            <% if (timePointList.size() > 1) { %>
                                            <input  name="checkTimePoint" id="<%=timePoint%>" type="checkbox" checked><%}%>&nbsp;<%=timePoint%>
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


        <% if (cellTypeList!=null && cellTypeList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td  ><div class="recordFilterTitle">
                            <% if (cellTypeList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkcelltype', 'Cell Type')" id="allCellTypes"  type="checkbox" checked>&nbsp;
                            <%}%>Cell Types</div></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String cellType: cellTypeList) {
                                        if(selectedCellType == null || cellType.equalsIgnoreCase(selectedCellType)) {
                                    %>
                                    <tr>
                                        <td>
                                            <% if (cellTypeList.size() > 1) { %>
                                            <input   name="checkcelltype" id="<%=cellType%>" type="checkbox" checked><%}%>&nbsp;<%=cellType%>
                                        </td>
                                    </tr>
                                    <%} else { %>
                                    <tr>
                                        <td>
                                            <% if (cellTypeList.size() > 1) { %>
                                            <input  name="checkcelltype" id="<%=cellType%>" type="checkbox" checked><%}%>&nbsp;<%=cellType%>
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

        <% if (editorList!=null && editorList.size() > 0) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td  ><div class="recordFilterTitle">
                            <% if (editorList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkeditor', 'Editor')" id="alleditors"  type="checkbox" checked>&nbsp;
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
                                            <% if (editorList.size() > 1) { %>
                                            <input  name="checkeditor" id="<%=editor%>" type="checkbox" checked><%}%>&nbsp;<%=editor%>
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
        <% if (guideTargetLocusList!=null && guideTargetLocusList.size() > 0) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td  ><div class="recordFilterTitle">
                            <% if (guideTargetLocusList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checktargetlocus', 'Target Locus')" id="allTargetLocus"  type="checkbox" checked>&nbsp;
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
                                            <% if (guideTargetLocusList.size() > 1) { %>
                                            <input  name="checktargetlocus" id="<%=locus%>" type="checkbox" checked><%}%>&nbsp;<%=locus%>
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
        <% if (guideList!=null && guideList.size() > 0) { %>

        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td><div class="recordFilterTitle">
                            <% if (guideList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkguide', 'Guide')" id="allGuides"  type="checkbox" checked>&nbsp;
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
                                            <% if (guideList.size() > 1) { %>
                                            <input  name="checkguide" id="<%=guide%>" type="checkbox" checked><%}%>&nbsp;<%=guide%>
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
        <% if (deliverySystemList !=null && deliverySystemList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td  ><div class="recordFilterTitle">
                            <% if (deliverySystemList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkdelivery', 'Delivery')" id="allDeliveries"  type="checkbox" checked>&nbsp;
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
                                            <% if (deliverySystemList.size() > 1) { %>
                                            <input  name="checkdelivery" id="<%=system%>" type="checkbox" checked><%}%>&nbsp;<%=system%>
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
        <% if (modelList!=null && modelList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td  ><div class="recordFilterTitle">
                            <% if (modelList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkmodel', 'Model')" id="allModels"  type="checkbox" checked>&nbsp;
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
                                            <% if (modelList.size() > 1) { %>
                                            <input  name="checkmodel"  id="<%=model%>" type="checkbox" checked><%}%>&nbsp;<%=model%>
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
        <% if (hrdonorList!=null && hrdonorList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td  ><div class="recordFilterTitle">
                            <% if (hrdonorList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkhrdonor', 'HR Donor')" id="allHrdonors"  type="checkbox" checked>&nbsp;
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
                                            <% if (hrdonorList.size() > 1) { %>
                                            <input  name="checkhrdonor"  id="<%=hrdonor%>" type="checkbox" checked><%}%>&nbsp;<%=hrdonor%>
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
        <% if (sexList !=null && sexList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td ><div class="recordFilterTitle">
                            <% if (sexList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checksex','Sex')" id="allSex"  type="checkbox" checked>&nbsp;
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
                                            <% if (sexList.size() > 1) { %>
                                            <input  name="checksex"  id="<%=sex%>" type="checkbox" checked><%}%>&nbsp;<%=sex%>
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


        <% if (vectorList!=null && vectorList.size() > 0 ) { %>
        <tr>
            <td valign="top">
                <table>
                    <tr>
                        <td  ><div class="recordFilterTitle">
                            <% if (vectorList.size() > 1) { %>
                            <input onchange="applyAllFilters(this, 'checkvector', 'Vector')" id="allVectors"  type="checkbox" checked>&nbsp;
                            <%}%>
                            Vectors</div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="recordFilterBlock">
                                <table>
                                    <% for (String vector: vectorList) { %>
                                    <tr>
                                        <td>
                                            <% if (vectorList.size() > 1) { %>
                                            <input  name="checkvector" id="<%=vector%>" type="checkbox" checked><%}%>&nbsp;<%=vector%>
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

    </table>

</div>
<script>
    setTimeout(openNav,1000);

</script>