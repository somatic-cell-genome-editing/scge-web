<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 5/14/2020
  Time: 8:05 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<style>
    .jumbotron{
        /*	background:linear-gradient(to bottom, white 0%, #D6EAF8 100%); */
      /* background:linear-gradient(to bottom, white 0%, #D6EAF8 100%);
        background-color: #D1F2EB;*/
    }
    td{
        font-size: 12px;
    }
</style>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link href="https://rgd.mcw.edu/rgdweb/common/tableSorter/css/filter.formatter.css" rel="stylesheet" type="text/css"/>
<link href="https://rgd.mcw.edu/rgdweb/common/tableSorter/css/theme.jui.css" rel="stylesheet" type="text/css"/>
<link href="https://rgd.mcw.edu/rgdweb/common/tableSorter/css/theme.blue.css" rel="stylesheet" type="text/css"/>

<script src="https://rgd.mcw.edu/rgdweb/common/tableSorter/js/tablesorter.js"> </script>
<script src="https://rgd.mcw.edu/rgdweb/common/tableSorter/js/jquery.tablesorter.widgets.js"></script>
<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>

<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>
<div class="container-fluid">
    <div class="jumbotron">
        <%@include file="search.jsp"%>
    </div>
    <!--h3>Experiments</h3>
    <div>
        <table id="myTable" class="table tablesorter">
            <thead>
            <tr>
                <th>Organism</th>
                <th>Animal model</th>
                <th>Editor</th>
                <th>Type of editing</th>
                <th>Delivery vehicle</th>
                <th>Target tissue</th>
                <th>Route of administration</th>



            </tr>
            </thead>
            <tbody>
            <c:forEach items="${sr.hits.hits}" var="hit">
                <tr>
                    <td>${hit.sourceAsMap.organism}</td>
                    <td>${hit.sourceAsMap.animalModels}</td>
                    <td>${hit.sourceAsMap.editor}</td>
                    <td>${hit.sourceAsMap.editTypes}</td>
                    <td>${hit.sourceAsMap.deliveryVehicles}</td>
                    <td>${hit.sourceAsMap.targetTissue}</td>
                    <td>${hit.sourceAsMap.routeOfAdministration}</td>

                </tr>
            </c:forEach>
            <tr>
                <td>Mouse</td>
                <td>Ai9</td>
                <td>SaCas9</td>
                <td>Deletion, NHEJ</td>
                <td>AAV</td>
                <td><a>Muscle</a></td>
                <td>IV injection</td>


            </tr>
            <tr>
                <td>Mouse</td>
                <td>Ai9</td>
                <td>SaCas9</td>
                <td>Deletion, NHEJ</td>
                <td>AAV</td>
                <td><a>Muscle</a></td>
                <td>IV injection</td>
            </tr>
            <tr>
                <td>Mouse</td>
                <td>Ai9</td>
                <td>SaCas9</td>
                <td>Deletion, NHEJ</td>
                <td>AAV</td>
                <td><a>Muscle</a></td>
                <td>IV injection</td>

            </tr>
            <tr>
                <td>Mouse</td>
                <td>Ai9</td>
                <td>SaCas9</td>
                <td>Deletion, NHEJ</td>
                <td>AAV</td>
                <td><a>Muscle</a></td>
                <td>IV injection</td>

            </tr>
            <tr>
                <td>Mouse</td>
                <td>Ai9</td>
                <td>SaCas9</td>
                <td>Deletion, NHEJ</td>
                <td>AAV</td>
                <td><a>Muscle</a></td>
                <td>IV injection</td>

            </tr>
            <tr>
                <td>Mouse</td>
                <td>Ai9</td>
                <td>SaCas9</td>
                <td>Deletion, NHEJ</td>
                <td>AAV</td>
                <td><a>Muscle</a></td>
                <td>IV injection</td>
            </tr>
            </tbody>
        </table>

    </div-->
    <hr>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-4">
                <div class="card" style="width: 25rem;border:0">

                    <div class="card-body">
                        <h5 class="card-title" style="font-weight: bold;font-size: 20px;color:#24619c;">Delivery Systems lookup service ...</h5>
                        <p class="card-text" style="color:grey;text-align: justify;font-size: small"> Help you search innovative approaches to deliver genome editing machinery into somatic cells.</p>
                        <!--a href="#" class="btn btn-primary">Go somewhere</a-->
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card" style="width: 25rem;border:0">

                    <div class="card-body">
                        <h5 class="card-title" style="font-weight: bold;font-size: 20px;color:#24619c;">Other tools</h5>
                        <p class="card-text" style="color:grey;font-size: small"></p>


                        <ul>

                            <li style="color:grey;font-size: small"><a href="">Editors</a></li>
                            <li style="color:grey;font-size: small"><a href="">Bilogical Effects</a> </li>
                            <li style="color:grey;font-size: small"><a href="">Reporter Models</a></li>
                            <li style="color:grey;font-size: small"><a href="">Models Availability</a></li>
                            <li style="color:grey;font-size: small"><a href="">Disease portals</a></li>

                        </ul>


                        <!--a href="#" class="btn btn-primary">Go somewhere</a-->
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card" style="width: 25rem;border:0">

                    <div class="card-body" >
                        <h5 class="card-title" style="font-weight: bold;font-size: 20px;color:#24619c">Links & Resources</h5>
                        <p class="card-text" style="color:grey;font-size: small">

                            <a href="" class="list-group-item" style="font-size: small">Nomenclature</a>
                            <a href="" class="list-group-item" style="font-size: small">Data Submission</a>
                        </p>

                    </div>
                </div>
            </div>

        </div>
    </div>
</div>



