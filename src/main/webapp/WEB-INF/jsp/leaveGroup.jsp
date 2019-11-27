<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/11/2019
  Time: 1:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .groups-table{

        border:1px gainsboro;
    }
    .button-cell{
        width:10px
    }
    .groups-table tr td {
       padding:10px;
        text-align:left;
    }
</style>
<h1>Groups you joined..</h1>
<div class="panel panel-default" style="width:50%">
    <table class="table groups-table">
        <tr><td class="button-cell"><a href="#" class="btn btn-warning btn-xs" title="remove">
            <span class="glyphicon glyphicon-minus"></span>
        </a></td><td>animal_reporter_wg</td>  </tr>
        <tr><td class="button-cell"><a href="#" class="btn btn-warning btn-xs" title="remove">
            <span class="glyphicon glyphicon-minus"></span>
        </a></td><td>biological_wg</td></tr>
        <tr><td class="button-cell"><a href="#" class="btn btn-warning btn-xs" title="remove">
            <span class="glyphicon glyphicon-minus"></span>
        </a></td><td>editor_wg</td></tr>
        <tr><td class="button-cell"><a href="#" class="btn btn-warning btn-xs" title="remove">
            <span class="glyphicon glyphicon-minus"></span>
        </a></td><td>animal_reporter_wg</td></tr>

    </table>
</div>