<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/20/2019
  Time: 1:11 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<link href="https://rgd.mcw.edu/rgdweb/common/tableSorter/css/filter.formatter.css" rel="stylesheet" type="text/css"/>
<link href="https://rgd.mcw.edu/rgdweb/common/tableSorter/css/theme.jui.css" rel="stylesheet" type="text/css"/>
<link href="https://rgd.mcw.edu/rgdweb/common/tableSorter/css/theme.blue.css" rel="stylesheet" type="text/css"/>

<script src="https://rgd.mcw.edu/rgdweb/common/tableSorter/js/tablesorter.js"> </script>
<script src="https://rgd.mcw.edu/rgdweb/common/tableSorter/js/jquery.tablesorter.widgets.js"></script>

<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>
<div class="row">
    <div class="col-sm-2 col-md-2 sidebar">
        <ul class="nav nav-sidebar">
            <li class="active"><a href="success?destination=base" style="font-weight: bold">Filters <span class="sr-only">(current)</span></a></li>

        </ul>

        <ul class="nav nav-sidebar">
            <li><a href="#">Organism</a>
                <ul>
                    <li><a href="">Mouse</a></li>
                    <li><a href="">Pig</a></li>
                    <li><a href="">Marmoset</a></li>
                    <li><a href="">Rhesus Macaque</a></li>
                </ul>
            </li>

            <li><a href="#">Model Creation</a>
                <ul>
                    <li><a href="">Transgenic</a></li>
                    <li><a href="">Knockin</a></li>
                    <li><a href="">Knockout</a></li>
                    <li><a href="">CRISPR/Cas9 System</a></li>
                </ul>
            </li>

            <li><a href="#">Model of Disease</a>
            <ul>
                <li><a href="#">Obesity</a></li>
                <li><a href="#">Parkinson's Disease</a></li>
                <li><a href="#">Muscle Pain</a></li>
                <li><a href="#">Rheumatoid Arthritis</a></li>
            </ul>
            </li>

        </ul>


</div>
    <div class="col-sm-12 ">



            <table id="myTable" class="tablesorter">
                <thead>
                <tr>
                    <th>Reporter Animal Id</th>
                    <th>Organism</th>
                    <th>Strain Symbol</th>
                    <th>Strain ID/Background</th>
                    <th>Allele Id</th>
                    <th>Allele Symbol</th>
                    <th>Common Name</th>
                    <th>Zygosity</th>
                    <th>Age</th>
                    <th>Sex</th>
                    <th>Expression Mechanism</th>
                    <th>Expression Expectation</th>
                    <th>Source</th>
                    <th>Availability</th>

                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>1</td>
                    <td><a href="model/1">Rat</a></td>
                    <td></td>
                    <td><a>Long Evans Hooded</a></td>
                    <td><a>TGRL9660</a></td>
                    <td><a>LEH- Rosa26-TdTomato tm1sage</a></td>
                    <td></td>
                    <td>Homozygous</td>
                    <td>4 weeks</td>
                    <td></td>
                    <td>Cre dependent gene expression</td>
                    <td>ubiquitous</td>
                    <td><a>Horizon</a></td>
                    <td>Yes</td>
                </tr>
                <tr>
                    <td>1</td>
                    <td><a>Rat</a></td>
                    <td></td>
                    <td><a>Long Evans Hooded</a></td>
                    <td><a>TGRL9660</a></td>
                    <td><a>LEH- Rosa26-TdTomato tm1sage</a></td>
                    <td></td>
                    <td>Homozygous</td>
                    <td>4 weeks</td>
                    <td></td>
                    <td>Cre dependent gene expression</td>
                    <td>ubiquitous</td>
                    <td><a>Horizon</a></td>
                    <td>Yes</td>
                </tr>
                <tr>
                    <td>1</td>
                    <td><a>Rat</a></td>
                    <td></td>
                    <td><a>Long Evans Hooded</a></td>
                    <td><a>TGRL9660</a></td>
                    <td><a>LEH- Rosa26-TdTomato tm1sage</a></td>
                    <td></td>
                    <td>Homozygous</td>
                    <td>4 weeks</td>
                    <td></td>
                    <td>Cre dependent gene expression</td>
                    <td>ubiquitous</td>
                    <td><a>Horizon</a></td>
                    <td>Yes</td>
                </tr>
                <tr>
                    <td>1</td>
                    <td><a>Rat</a></td>
                    <td></td>
                    <td><a>Long Evans Hooded</a></td>
                    <td><a>TGRL9660</a></td>
                    <td><a>LEH- Rosa26-TdTomato tm1sage</a></td>
                    <td></td>
                    <td>Homozygous</td>
                    <td>4 weeks</td>
                    <td></td>
                    <td>Cre dependent gene expression</td>
                    <td>ubiquitous</td>
                    <td><a>Horizon</a></td>
                    <td>Yes</td>
                </tr>
                <tr>
                    <td>1</td>
                    <td><a>Rat</a></td>
                    <td></td>
                    <td><a>Long Evans Hooded</a></td>
                    <td><a>TGRL9660</a></td>
                    <td><a>LEH- Rosa26-TdTomato tm1sage</a></td>
                    <td></td>
                    <td>Homozygous</td>
                    <td>4 weeks</td>
                    <td></td>
                    <td>Cre dependent gene expression</td>
                    <td>ubiquitous</td>
                    <td><a>Horizon</a></td>
                    <td>Yes</td>
                </tr>
                <tr>
                    <td>1</td>
                    <td><a>Rat</a></td>
                    <td></td>
                    <td><a>Long Evans Hooded</a></td>
                    <td><a>TGRL9660</a></td>
                    <td><a>LEH- Rosa26-TdTomato tm1sage</a></td>
                    <td></td>
                    <td>Homozygous</td>
                    <td>4 weeks</td>
                    <td></td>
                    <td>Cre dependent gene expression</td>
                    <td>ubiquitous</td>
                    <td><a>Horizon</a></td>
                    <td>Yes</td>
                </tr>
                </tbody>
            </table>

</div>
 </div>
