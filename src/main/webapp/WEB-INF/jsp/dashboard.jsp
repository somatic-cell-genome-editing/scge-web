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

<div class="container" style="align-content: center;text-align: center">
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
            <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" width="75" height="75" alt="" />
            <div style="text-align: center;"><p>Delivery Systems Data</p></div>
        </div>
        <div class="col-md-2" style="text-align: center">
            <img src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" width="75" height="75" alt="" />
            <div style="text-align: center;"><p>Genome Editor Data</p></div>
        </div>
    </div>

<!--div class="fusion-column content-box-column content-box-column-1 col-lg-2 col-md-2 col-sm-2 fusion-content-box-hover content-box-column-first-in-row">
    <div class="col content-box-wrapper content-wrapper-background content-wrapper-boxed link-area-box link-type-button-bar icon-hover-animation-pulsate fusion-animated" style="background-color:#1a80b6;" data-link="https://scge.mcw.edu/animal_reporter/" data-link-target="_self" data-animationType="fadeInLeft" data-animationDuration="1.0" data-animationOffset="100%">
        <div class="heading heading-with-icon icon-left"><a class="heading-link" href="https://scge.mcw.edu/animal_reporter/" target="_self">
            <div style="margin-left:-37.5px;top:-87.5px;text-align: center" class="image"><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/mouse.png" width="75" height="75" alt="" />
            </div><h2 class="content-box-heading" style="font-size:18px;line-height:23px;color:white;text-align: center;">Animal Reporter and Testing Centers</h2></a></div>
        <div class="fusion-clearfix"></div>
        <a class="fusion-read-more fusion-read-more-button fusion-content-box-button fusion-button button-default button-large button-square button-flat" href="https://scge.mcw.edu/animal_reporter/" target="_self">Read More</a><div class="fusion-clearfix"></div></div></div><div class="fusion-column content-box-column content-box-column-2 col-lg-2 col-md-2 col-sm-2 fusion-content-box-hover "><div class="col content-box-wrapper content-wrapper-background content-wrapper-boxed link-area-box link-type-button-bar icon-hover-animation-pulsate fusion-animated" style="background-color:#1a80b6;" data-link="https://scge.mcw.edu/biologicalsystems/" data-link-target="_self" data-animationType="fadeInLeft" data-animationDuration="1.0" data-animationOffset="100%"><div class="heading heading-with-icon icon-left"><a class="heading-link" href="https://scge.mcw.edu/biologicalsystems/" target="_self"><div style="margin-left:-37.5px;top:-87.5px;" class="image"><img src="https://scge.mcw.edu/wp-content/uploads/2019/06/biological-rev.png" width="75" height="75" alt="" /></div><h2 class="content-box-heading" style="font-size:18px;line-height:23px;">Biological Systems Projects</h2></a></div><div class="fusion-clearfix"></div><a class="fusion-read-more" class="fusion-read-more-button fusion-content-box-button fusion-button button-default button-large button-square button-flat" href="https://scge.mcw.edu/biologicalsystems/" target="_self">Read more</a><div class="fusion-clearfix"></div></div>
</div-->
      </div>

<div  class="form-inline container">
<div class="panel panel-default" >
    <div class="panel-heading" style="background-color:#4c91cd;color:white;font-weight: bold">My Group Associations</div>

    <div class="panel panel-body">
        <table class="table">
            <tr><th>Group</th><th>Role</th></tr>
            <tr><td><a href="members?group=consortium group">Consortium Group</a></td><td>member</td></tr>
            <c:forEach items="${groupSubgroupRoleMap}" var="sg">

                <c:if test="${sg.key!='working group'}">
                    <c:forEach items="${sg.value}" var="g1">
                        <c:if test="${g1.key!='Dissemination and Coordinating Center'}">
                    <tr><td ><a href="members?group=${g1.key}">${g1.key}</a></td>
                        <td>
                            <c:set var="first" value="true"/>
                            <c:forEach items="${g1.value}" var="r1">
                                <c:choose>
                                    <c:when test="${first=='true'}">
                                        ${r1}
                                        <c:set var="first" value="false"/>
                                    </c:when>
                                    <c:otherwise>
                                        ;${r1}
                                    </c:otherwise>
                                </c:choose>

                            </c:forEach>
                        </td></tr>
                </c:if>
                    </c:forEach>
                </c:if>
            </c:forEach>

        </table>
    </div>
    <div class="panel panel-body">
        <table class="table">
            <tr><th>Working Group</th><th>Role</th></tr>
            <c:forEach items="${groupSubgroupRoleMap}" var="wg">
                <c:if test="${wg.key=='working group'}">
                    <c:forEach items="${wg.value}" var="g2">
                        <c:if test="${g2.key!='Dissemination and Coordinating Center'}">
                            <tr><td ><a href="members?group=${g2.key}">${g2.key}</a></td>
                                <td>
                                    <c:set var="first" value="true"/>
                                    <c:forEach items="${g2.value}" var="r2">
                                        <c:choose>
                                            <c:when test="${first=='true'}">
                                                ${r2}
                                                <c:set var="first" value="false"/>
                                            </c:when>
                                            <c:otherwise>
                                                ;${r2}
                                            </c:otherwise>
                                        </c:choose>

                                    </c:forEach>
                                </td></tr>
                        </c:if>
                    </c:forEach>
                </c:if>
            </c:forEach>

        </table>
    </div>
</div>
    <div class="panel panel-default" >
        <div class="panel-heading" style="background-color:#4c91cd;color:white;font-weight: bold">SCGE Groups</div>
        <div class="panel panel-body">


                <c:forEach items="${groupsMap}" var="m">
                    <p><a href="members?group=${m.key}" style="font-weight:bold">${m.key}</a></p>
                    <ul>
                        <c:forEach items="${m.value}" var="sg">
                            <li><a href="members?group=${sg}">${sg}</a></li>
                        </c:forEach>
                    </ul>

                </c:forEach>



        </div>
    </div>
<!--div class="panel panel-default" >
    <div class="panel-heading" style="background-color:#4c91cd;color:white;font-weight: bold">SCGE Groups</div>
    <div class="panel panel-body">
        <table class="table">
            <tr><th>Group</th></tr>
            <c:forEach items="${consortiumGroups}" var="sg">
                <tr><td><a href="groups?group=${sg}">${sg}</a></td></tr>
            </c:forEach>


        </table>
    </div>
</div-->
</div>


<!--div class="panel panel-default" style="width:50%;">
    <div class="panel-heading" style="background-color:#4c91cd;color:white;font-weight: bold">Experiments</div>
    <div class="panel panel-body">
        <table class="table">
            <tr><th>Experiment</th><th>Owner</th></tr>
            <tr><td><a href="#">Cancer cell line</a></td><td>animal_reporter_wg</td></tr>
            <tr><td><a href="#">Conditionally immortalized cell line</a></td><td>editor_wg</td></tr>
            <tr><td><a href="#">Embryonic stem cell</a></td><td>animal_reporter_wg</td></tr>
            <tr><td><a href="#">Finite cell line</a></td><td>animal_reporter_wg</td></tr>
        </table>
    </div>
</div-->