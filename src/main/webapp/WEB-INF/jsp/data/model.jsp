<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/23/2019
  Time: 2:59 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .label1{
        background-color:grey;
        color:white;
        font-weight: bold;
        width:40%
    }
    .table tr {
        border: 1px solid #e3ecfa;;
    }
    .table tr td{
       border: 1px solid #e3ecfa;;
    }
</style>
<div class="row" style="background-color: #e3ecfa;">
    <div class="col-sm-6">
    <h2 style="color:#24609c">tdTomato Reporter Rat </h2>
    <table class="table">
        <tr>
           <td class="label1">Animal Model: </td> <td>tdTomato Reporter Rat </td></tr>
          <tr>  <td  class="label1">Allele Symbol:</td><td>LEH- Rosa26-TdTomato tm1sage </td></tr>
        <tr><td class="label1">Allele Id: </td><td>TGRL9660</td></tr>
            <tr><td class="label1">Background Strain: </td><td>Long Evans Hooded</td></tr>
          <tr>  <td class="label1">Zygosity:</td><td>Homozygous</td></tr>
          <tr>  <td class="label1">Sex: </td><td>Male</td></tr>
           <tr> <td class="label1">Age: </td><td>4 weeks</td></tr>
           <tr> <td class="label1">Availability: </td><td>Yes</td></tr>
           <tr> <td class="label1">Source: </td><td><a href="https://www.horizondiscovery.com/tdtomato-reporter-rat-tgrl9660">Horizon</a></td>
        </tr>
    </table>
    </div>
    <div class="col-sm-3">

    </div>
    <div class="col-sm-3">
        <h2 style="color:#24609c"> </h2>
        <div class="panel panel-default">
            <div class="panel-heading" style="background-color:#24609c;color:white;font-weight: bold">External Links</div>
            <div class="panel panel-body">
               <p>Genbank ID:&nbsp;########### </p>
            </div>
        </div>
        <div class="panel panel-default">
            <div class="panel-heading" style="background-color:#24609c;color:white;font-weight: bold">Model Information</div>
            <div class="panel panel-body">
                <p>SCGE ID:&nbsp;########### </p>
                <p>Creation Date:&nbsp;########### </p>
                <p>Last Modified Date:&nbsp;########### </p>
                <p>Status:&nbsp;ACTIVE </p>
            </div>
        </div>

    </div>
</div>

<div>
    <h2>Results</h2>
    <div class="panel panel-default">
        <div class="panel-heading" style="background-color:#4c91cd;color:white;font-weight: bold">Cre-dependent expression of tdTomato</div>
        <div class="panel panel-body">

            <img src="/scgeweb/images/tdtomato_results.png" alt="results"/>
        </div>
    </div>
</div>