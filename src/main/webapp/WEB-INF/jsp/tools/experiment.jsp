<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 10/20/2020
  Time: 8:40 AM
  To change this template use File | Settings | File Templates.
--%>
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
        $("#samplesTable").tablesorter({
            theme : 'blue'

        });
    });
</script>
<script src="https://d3js.org/d3.v4.js"></script>
<style>
    /* disable text selection */
    svg *::selection {
        background : transparent;
    }

    svg *::-moz-selection {
        background:transparent;
    }

    svg *::-webkit-selection {
        background:transparent;
    }
    rect.selection {
        stroke          : #333;
        stroke-dasharray: 4px;
        stroke-opacity  : 0.5;
        fill            : transparent;
    }

    rect.cell-border {
        stroke: gray;
        stroke-width:0.3px;
    }

    rect.cell-selected {
        stroke: rgb(51,102,153);
        stroke-width:0.5px;
    }

    rect.cell-hover {
        stroke: #F00;
        stroke-width:0.3px;
    }

    text.mono {
        font-size: 9pt;
        font-family: Consolas, courier;
        fill: #aaa;
    }

    text.text-selected {
        fill: #000;
    }

    text.text-highlight {
        fill: red;
    }
    text.text-hover {
        fill: #00C;
    }
    .tooltip {
        position: absolute;
        width: 200px;
        height: auto;
        padding: 10px;
        background-color: white;
        -webkit-border-radius: 10px;
        -moz-border-radius: 10px;
        border-radius: 10px;
        -webkit-box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
        -moz-box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
        box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
        pointer-events: none;
    }

    .tooltip.hidden {
        display: none;
    }

    .tooltip p {
        margin: 0;
        font-family: sans-serif;
        font-size: 12px;
        line-height: 20px;
    }
    .header{
        font-weight: bold;
        font-size: 12px;
        color:steelblue;
    }
</style>

<div>
    <div>
        <table style="width:50%">

            <tbody>
            <tr><td class="header"><strong>Experiment</strong></td><td>${experiment.experimentName}</td></tr>

            </tbody>
        </table>

    </div>
    <hr>
    <div>
<table  style="width:50%">

    <tbody>
    <tr><td class="header"><strong>Model</strong></td><td>${model.type}</td></tr>
    <tr><td class="header"><strong>Name</strong></td><td>${model.name}</td></tr>
    <tr><td class="header"><strong>Short Name</strong></td><td>${model.shortName}</td></tr>
    <tr><td class="header"><strong>Organism</strong></td><td>${model.organism}</td></tr>
    <tr><td class="header"><strong>GenoType</strong></td><td>${model.genotype}</td></tr>
    <tr><td class="header"><strong>Stock Number</strong></td><td>${model.stockNumber}</td></tr>
    <tr><td class="header"><strong>Age</strong></td><td>${model.age}</td></tr>
    <tr><td class="header"><strong>Age Range</strong></td><td>${model.ageRange}</td></tr>
    </tbody>
</table>
    </div>
    <hr>
    <div>
        <table style="width:50%">

            <tbody>
            <c:forEach items="${reporterElements}" var="reporter">
            <tr><td class="header"><strong>Reporter Name</strong></td><td>${reporter.reporterName}</td></tr>
            <tr><td class="header"><strong>Reporter Type</strong></td><td>${reporter.reporterType}</td></tr>
            <tr><td class="header"><strong>Reporter Protein Id</strong></td><td>${reporter.reporterProteinId}</td></tr>
            <tr><td class="header"><strong>Organism</strong></td><td>${reporter.organism}</td></tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <hr>
    <div>
        <table style="width:50%">

            <tbody>
            <c:forEach items="${deliveryList}" var="d">
                <tr><td class="header"><strong>Delivery System</strong></td><td>${d.deliverySystemType}</td></tr>
                <tr><td class="header"><strong>Delivery System Subtype</strong></td><td>${d.deliverySystemSubtype}</td></tr>

            </c:forEach>
            </tbody>
        </table>
    </div>
    <hr>
    <div>
        <table style="width:50%">

            <tbody>
            <c:forEach items="${applicationMethod}" var="a">
                <tr><td class="header"><strong>Application Method</strong></td><td>${a.applicationType}</td></tr>
                <tr><td class="header"><strong>Application Site</strong></td><td>${a.siteOfApplication}</td></tr>
                <tr><td class="header"><strong>Dosage</strong></td><td>${a.dosage}</td></tr>
                <tr><td class="header"><strong>Time Course</strong></td><td>${a.timeCourse}</td></tr>
                <tr><td class="header"><strong>Days post injection</strong></td><td>${a.daysPostInjection}</td></tr>

            </c:forEach>
            </tbody>
        </table>
    </div>
    <hr>
    <div>
        <table style="width:50%">
            <tr><td class="header"><strong>Sample Preparation</strong></td><td>${experiment.samplePrep}</td></tr>
        </table>
    </div>
    <hr>
    <h3>Results Summary:</h3>
    <div>
        <table id="myTable" class="table tablesorter table-striped" style="width:50%">
            <thead><tr>
                <th>Parent_tissue_term</th>
                <th>tissue_term</th>
                <th>number_of_samples</th>


                <th>signal</th>
                <th>signal_present</th>
                <th>signal_description</th>
                <th>image_link</th>
                <th>percent_cells_in_roi_with_sginal</th>
                <th>roi</th>
                <th>roi_coordinates</th>

            </tr></thead>
            <tbody>

            <c:forEach items="${results}" var="r">
                <tr>
                    <td>${r.parentTissueTerm}</td>
                    <td>${r.tissueTerm}</td>
                    <td>${r.numberOfSamples}</td>

                    <td>${r.signal}</td>
                    <td>${r.signalPresent}</td>
                    <td>${r.signalDescription}</td>
                    <td>${r.imageLink}</td>
                    <td>${r.percentCellsInROIWithSginal}</td>
                    <td>${r.roi}</td>
                    <td>${r.ROICoordinates}</td>
                </tr>

            </c:forEach>
            </tbody>
        </table>
    </div>
    <hr>

    <%@include file="graph.jsp"%>

    <div >
        <c:forEach items="${results}" var="r">
        <div class="satcResults  card" id="${r.tissueTerm}" style="display: none">
        <div  class="container">
           <table>
               <tr>
                <td class="header">Parent Tissue</td>   <td><h3>${r.parentTissueTerm}</h3></td>
               </tr>
               <tr>
                   <td class="header">Tissue</td> <td>${r.tissueTerm}</td></tr>
               <tr>
                <td class="header">Number of samples</td>                    <td>${r.numberOfSamples}</td>

               </tr>
<tr>
                <td class="header">Signal</td>                    <td>${r.signal}</td>

</tr>
               <tr>
                <td class="header">Signal Present</td>                    <td>${r.signalPresent}</td>

               </tr>
               <tr>
                <td class="header">Signal Description</td>                    <td>${r.signalDescription}</td>

               </tr>
               <tr>
                <td class="header">Image Link</td>                    <td>${r.imageLink}</td>

               </tr>
               <tr>
                <td class="header">Percent cells in ROI with sginal</td>                    <td>${r.percentCellsInROIWithSginal}</td>

               </tr>
               <tr>
                <td class="header">ROI</td>                    <td>${r.roi}</td>

               </tr>
               <tr>
                <td class="header">ROI Coordinates</td>                    <td>${r.ROICoordinates}</td>

               </tr>







           </table>
        </div>
            <hr>
        <table id="samplesTable" class="table tablesorter">
            <thead>
            <tr><th>Sample</th><th>Sex</th><th>Signal</th></tr>
            </thead>
            <tbody>
            <c:forEach items="${r.samples}" var="s">
            <tr>

                <td>${s.sampleId}</td> <td>${s.sex}</td> <td>${s.signal}</td>

            </tr>
            </c:forEach>
            </tbody>
        </table>

        </div>
        </c:forEach>
    </div>
</div>
