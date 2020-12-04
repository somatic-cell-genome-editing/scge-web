<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/9/2019
  Time: 12:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<style>
    h4{
        color:grey;
    }
</style>

<!--div class="container" style="align-content: center;text-align: center">
    <div class="row">
        <div class="col-md-2" style="text-align: center">

        </div>
        <div class="col-md-2" style="text-align: center">
            <a href="data/animalReporter" style="text-decoration: none">
            <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/mouse.png" width="75" height="75" alt="" />
            <div style="text-align: center;"><p >Animal Reporter and Testing Centers Data</p></div>
            </a>
        </div>
        <div class="col-md-2" style="text-align: center">

            <img src="https://scge.mcw.edu/wp-content/uploads/2019/06/biological-rev.png" width="75" height="75" alt="" />
            <div style="text-align: center;"><p>Biological Effects</p></div>

        </div>
        <div class="col-md-2" style="text-align: center">
            <a href="toolkit/delivery/search">
            <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" width="75" height="75" alt="" />
            <div style="text-align: center;"><p>Delivery Systems Data</p></div>
            </a>
        </div>
        <div class="col-md-2" style="text-align: center">
            <img src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" width="75" height="75" alt="" />
            <div style="text-align: center;"><p>Genome Editor Data</p></div>
        </div>
    </div>
      </div-->

<!--div  class="form-inline container">
<div class="panel panel-default" >
    <%--@include file="dashboardElements/myGroupAssociations.jsp"--%>
   <%--@include file="dashboardElements/workingGroups.jsp"--%>
</div>
    <div class="panel panel-default" >
        <%--@include file="dashboardElements/consortiumGroups.jsp"--%>
    </div>

</div-->
<div class="container-fluid wrapper">
    <div>
        <c:if test="${tier!=null && tier!=''}">
            <p style="color:green">Selected study tier changed to TIER ${tier}</p>
        </c:if>
        <!--p style="color:green;font-weight: bold">$-{message} </p-->
        <div class="row">

            <div class="col-lg-10">
               <%@include file="tools/studies.jsp"%>
                <!--div class="card ">
                    <div class="card-header">
                        <div class="card-title">
                            <h4 style="color:steelblue">Studies pending PI action</h4>
                        </div>
                    </div>
                    <div class="card-body">
                        <%--@include file="dashboardElements/pendingPIAction.jsp"--%>
                    </div>
                </div-->
            </div>

            <div class="card sidebar-wrapper col-lg-2" style="background-color:#ffffff">
                <div class="sidebarItemDiv">
            <%@include file="dashboardElements/myGroupAssociations.jsp"%>
                </div>
                <div class="sidebarItemDiv">
            <%@include file="dashboardElements/workingGroups.jsp"%>
                </div>
                <div class="sidebarItemDiv">
                <%@include file="dashboardElements/consortiumGroups.jsp"%>
                </div>
            </div>

        </div>

    </div>
</div>

