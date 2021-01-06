<%@ page import="edu.mcw.scge.dao.spring.CountQuery" %>
<%@ page import="edu.mcw.scge.dao.implementation.StatsDao" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 5/8/2020
  Time: 2:05 PM
  To change this template use File | Settings | File Templates.
--%>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<style>
    .borderless tbody tr td {
        padding: 1%;
        vertical-align: top;
    }
   .row{
       margin-top: 2%;
   }
    td{
        font-size: 16px;
        text-align: left;


    }
    .object-count {
        font-size:30px;
        font-weight:700;
    }
    .tool-img{
        max-width: 480px;
    }
    @media screen and (max-width: 480px) {
        img {
            width: 400px;
        }
    }


</style>
<div class="container" align="center">
<table align="center">
    <tr>
        <td align="center"><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/logo-png-1.png" border="0"/></td>
        <td align="center">
            <form class="form-inline my-2 my-lg-0">
                <input size=60 class="form-control " type="search" placeholder="Search SCGE (Models, Editors, Delivery, Guides)" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </td>
    </tr>
</table>
</div>
<br>

<% StatsDao sdao = new StatsDao(); %>

<div class="container" style="width: 50%" align="center">
    <div class="row">
        <div class="col">
            <div class="row">
                <div class="col-sm-3" > <i class="fas fa-arrow-to-right" style="font-size: 50px;color:steelblue"></i></div>
                <div class="col-md-auto" style="text-align: left"> <a href="/toolkit/data/studies/search"><span class="object-count"><%=sdao.getStudyCount()%></span>&nbsp;<strong style="text-align: left">Study Submissions</strong></a></div>
            </div>

        </div>
        <div class="col">
            <div class="row">
                <div class="col-sm-3" ><img src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" class="tool-img" alt="" /></div>
                <div class="col-md-auto" style="text-align: left;"><a href="/toolkit/data/editors/search"><span class="object-count"><%=sdao.getEditorCount()%></span>&nbsp;<strong>Genome Editors</strong></a></div>
            </div>
        </div>
    </div>
    <div class="row" >
        <div class="col">
            <div class="row">
                <div class="col-sm-3" ><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/mouse.png" class="tool-img" alt="" /></div>
                <div class="col-md-auto" style="text-align: left"><a href="/toolkit/data/animalReporter/search"><span class="object-count "><%=sdao.getModelCount()%></span>&nbsp;<strong style="text-align: left">Model&nbsp;Systems</strong></a></div>
            </div>
        </div>
        <div class="col">
            <div class="row">
                <div class="col-sm-3" ><img src="https://scge.mcw.edu/wp-content/uploads/2019/06/biological-rev.png"  class="tool-img" alt="" /></div>
                <div class="col-md-auto" style="text-align: left"><a  href="/toolkit/data/vitro/search"><span class="object-count"><%=sdao.getExperimentCount()%></span>&nbsp;<strong>Experiment Records</strong></a> </div>
            </div>

        </div>
    </div>
    <div class="row">
        <div class="col">
            <div class="row">
                <div class="col-sm-3" ><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" class="tool-img" alt="" /></div>
                <div class="col-md-auto" style="text-align: left" ><a href="/toolkit/data/delivery/search"><span class="object-count"><%=sdao.getDeliveryCount()%></span>&nbsp;<strong>Delivery Vehicles</strong></a></div>
            </div>

        </div>
        <div class="col">
            <div class="row">
                <div class="col-sm-3" ><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" class="tool-img" alt="" /></div>
                <div class="col-md-auto" style="text-align: left"><a href="/toolkit/data/guide/search"><span class="object-count"><%=sdao.getGuideCount()%></span>&nbsp;<strong>Guides</strong></a></div>
            </div>

        </div>
    </div>



</div>








