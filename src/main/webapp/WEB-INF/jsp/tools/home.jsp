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
    }
    .object-count {
        font-size:30px;
        font-weight:700;
    }
</style>

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
<br>

<% StatsDao sdao = new StatsDao(); %>


<table width="100%">
    <tr>
        <td valign="top">



<div class="container" >
    <div class="panel panel-default" style="border-color: white;"  >


        <div class="row"  >
            <div class="col-md-6">
                <table>
                    <tr>
                        <td><i class="far fa-file-alt" style="font-size: 50px;color:steelblue"></i></td>
                        <td>&nbsp;&nbsp;</td>
                        <td width=40 align="center" class="object-count"><a href="/toolkit/data/studies/search"><%=sdao.getStudyCount()%></a></td>
                        <td style="font-weight:700;"><a href="/toolkit/data/studies/search">Study Submissions</a></td>
                    </tr>
                </table>
            </div>
            <div class="col-md-6">
                <table >
                    <tr>
                        <td><img src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" width="50" height="50" alt="" /></td>
                        <td>&nbsp;&nbsp;</td>
                        <td width=40 align="center" class="object-count"><a href="/toolkit/data/editors/search"><%=sdao.getEditorCount()%></a></td>
                        <td><a href="/toolkit/data/editors/search"><strong>Genome&nbsp;Editors</strong></td>
                    </tr>
                </table>
            </div>
        </div>

        <div class="row" >
            <div class="col-md-6">
                <table  >
                    <tr>
                        <td><img src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" width="50" height="50" alt="" /></td>
                        <td>&nbsp;&nbsp;</td>
                        <td width=40 align="center" class="object-count"><a href="/toolkit/data/models/search"><%=sdao.getModelCount()%></a></td>
                        <td><a href="/toolkit/data/models/search"><strong>Model&nbsp;Systems</strong></a></td>
                        </td>
                    </tr>
                </table>
            </div>

            <div class="col-md-6">
                <table>
                    <tr>
                        <td><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" width="50" height="50" alt="" /></td>
                        <td>&nbsp;&nbsp;</td>
                        <td width=40 align="center" class="object-count"><a href="/toolkit/data/delivery/search"><%=sdao.getDeliveryCount()%></a></td>
                        <td><a href="/toolkit/data/delivery/search"><strong>Delivery Systems</strong></a></td>
                    </tr>
                </table>
            </div>
        </div>

        <div class="row"  >
        <div class="col-md-6">
            <table  >
                <tr>
                    <td><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" width="50" height="50" alt="" /></td>
                    <td>&nbsp;&nbsp;</td>
                    <td width="40" align="center" class="object-count"><a href="/toolkit/data/guide/search"><%=sdao.getGuideCount()%></a></td>
                    <td><a href="/toolkit/data/guide/search"><strong>Guides</strong></a></td>
                </td>
                </tr>
            </table>
        </div>
            <div class="col-md-6">
                <table>
                    <tr>
                        <td><img src="https://scge.mcw.edu/wp-content/uploads/2019/06/biological-rev.png" width="50" height="50" alt="" /></td>
                        <td>&nbsp;&nbsp;</td>
                        <td width="40" align="center" class="object-count"><a href="/toolkit/data/guide/search"><%=sdao.getExperimentCount()%></a></td>
                        <td><a href="/toolkit/data/guide/search"><strong>Experiment Records</strong></a> </td>
                    </tr>
                </table>
            </div>

        </div>

    </div>
</div>


        </td>
        <!--
        <td>

            <a class="twitter-timeline" data-width="250" data-height="800" href="https://twitter.com/somaticediting?ref_src=twsrc%5Etfw">Tweets by somaticediting</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

        </td>
        -->
    </tr>
</table>




<!--
<div class="row"  >
<div class="col-md-6">
<table  class='borderless'>
<tr>
<td><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" width="50" height="50" alt="" /><a href="/toolkit/data/delivery/search"><strong>Delivery Vehicles</strong></a></td>
</tr>
</table>
</div>
<div class="col-md-6">
<table  class='borderless' >
<tr>
<td><img src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" width="50" height="50" alt="" /><a href="/toolkit/data/models/search"><strong>Model Systems</strong></a>
</td>
</tr>
</table>
</div>
</div>
-->
<!--
<div class="row"  >

<div class="col-md-6">
<table  class='borderless' >
<tr>
<td><i class="far fa-file-alt" style="font-size: 50px;color:steelblue"></i><a><strong>Protocols</strong></a>
</td>
</tr>
</table>
</div>
</div>
-->

<!--
<div class="col-md-6">
<table  class='borderless'>
<tr>
<td><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/mouse.png" width="50" height="50" alt="" /></td>
<td>&nbsp;&nbsp;&nbsp;</td>
<td><a href="/toolkit/data/animalReporter/search"><span class="object-count"><%=sdao.getModelCount()%></span><strong>Animal Reporters Models</strong></a></td>
</tr>
</table>
</div>
-->
<!--
<div class="col-md-6">
<table  class='borderless'>
<tr>
<td><img src="https://scge.mcw.edu/wp-content/uploads/2019/06/biological-rev.png" width="50" height="50" alt="" /><a  href="/toolkit/data/vitro/search"><strong>Biological Effects - In vitro</strong></a></td>
</tr>
</table>
</div>
-->


