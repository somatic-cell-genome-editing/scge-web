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
    .img-td{
        text-align:left;
        width: 50px;
        height:50px;
    }
    .object-row{
       padding-top:10%;
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




<div class="container" align="center" style="width: 70%;">
<div>
    <table>
            <tr class="object-row">
                <td>
                <table>
                    <tr>
                        <td ><i class="far fa-file-alt" style="font-size: 30px;color:steelblue"></i></td>
                        <td ><a href="/toolkit/data/studies/search"><span class="object-count"><%=sdao.getStudyCount()%></span></a></td>
                        <td style="font-weight:700;"><a href="/toolkit/data/studies/search">Study Submissions</a></td>
                    </tr>
                </table>
                </td>
                <td>&nbsp;</td>
                <td >
                    <table >
                        <tr>
                            <td  class="img-td"><img src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" width="auto" height="auto" alt="" /></td>
                            <td ><a href="/toolkit/data/editors/search"><span class="object-count"><%=sdao.getEditorCount()%></span></a></td>
                            <td><a href="/toolkit/data/editors/search"><strong>Genome&nbsp;Editors</strong></a></td>
                        </tr>
                    </table>
                </td>
            </tr>
        <tr class="object-row" >
            <td >
                <table  >
                    <tr>
                        <td class="img-td"><img src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" width="auto" height="auto" alt="" /></td>
                        <td><a href="/toolkit/data/models/search"><span class="object-count "><%=sdao.getModelCount()%></span></a></td>
                        <td><a href="/toolkit/data/models/search"><strong>Model&nbsp;Systems</strong></a></td>

                    </tr>
                </table>
            </td>
            <td>&nbsp;</td>
            <td>
                <table>
                    <tr>
                        <td class="img-td"><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" alt="" /></td>
                        <td><a href="/toolkit/data/delivery/search"><span class="object-count"><%=sdao.getDeliveryCount()%></span></a></td>
                        <td><a href="/toolkit/data/delivery/search"><strong>Delivery Systems</strong></a></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr class="object-row">
            <td >
                <table>
                    <tr>
                        <td class="img-td"><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" alt="" /></td>
                        <td><a href="/toolkit/data/guide/search"><span class="object-count"><%=sdao.getGuideCount()%></span></a></td>
                        <td><a href="/toolkit/data/guide/search"><strong>Guides</strong></a></td>
                    </tr>
                </table>
            </td>
            <td>&nbsp;</td>
            <td >
                <table>
                    <tr>
                        <td class="img-td"><img src="https://scge.mcw.edu/wp-content/uploads/2019/06/biological-rev.png" alt="" /></td>
                        <td><a href="/toolkit/data/guide/search"><span class="object-count"><%=sdao.getExperimentCount()%></span></a></td>
                        <td><a href="/toolkit/data/guide/search"><strong>Experiment Records</strong></a></td>
                    </tr>
                </table>
            </td>
        </tr>
        </table>





</div>
</div>







