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
</style>

<div>
    <div>
        <table style="width:50%">

            <tbody>
            <tr><td><strong>Experiment</strong></td><td>${experiment.experimentName}</td></tr>

            </tbody>
        </table>

    </div>
    <hr>
    <div>
<table  style="width:50%">

    <tbody>
    <tr><td><strong>Model</strong></td><td>${model.type}</td></tr>
    <tr><td><strong>Name</strong></td><td>${model.name}</td></tr>
    <tr><td><strong>Short Name</strong></td><td>${model.shortName}</td></tr>
    <tr><td><strong>Organism</strong></td><td>${model.organism}</td></tr>
    <tr><td><strong>GenoType</strong></td><td>${model.genotype}</td></tr>
    <tr><td><strong>Stock Number</strong></td><td>${model.stockNumber}</td></tr>
    <tr><td><strong>Age</strong></td><td>${model.age}</td></tr>
    <tr><td><strong>Age Range</strong></td><td>${model.ageRange}</td></tr>
    </tbody>
</table>
    </div>
    <hr>
    <div>
        <table style="width:50%">

            <tbody>
            <c:forEach items="${reporterElements}" var="reporter">
            <tr><td><strong>Reporter Name</strong></td><td>${reporter.reporterName}</td></tr>
            <tr><td><strong>Reporter Type</strong></td><td>${reporter.reporterType}</td></tr>
            <tr><td><strong>Reporter Protein Id</strong></td><td>${reporter.reporterProteinId}</td></tr>
            <tr><td><strong>Organism</strong></td><td>${reporter.organism}</td></tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <hr>
    <div>
        <table style="width:50%">

            <tbody>
            <c:forEach items="${deliveryList}" var="d">
                <tr><td><strong>Delivery System</strong></td><td>${d.deliverySystemType}</td></tr>
                <tr><td><strong>Delivery System Subtype</strong></td><td>${d.deliverySystemSubtype}</td></tr>

            </c:forEach>
            </tbody>
        </table>
    </div>
    <hr>
    <div>
        <table style="width:50%">

            <tbody>
            <c:forEach items="${applicationMethod}" var="a">
                <tr><td><strong>Application Method</strong></td><td>${a.applicationType}</td></tr>
                <tr><td><strong>Application Site</strong></td><td>${a.siteOfApplication}</td></tr>
                <tr><td><strong>Dosage</strong></td><td>${a.dosage}</td></tr>
                <tr><td><strong>Time Course</strong></td><td>${a.timeCourse}</td></tr>
                <tr><td><strong>Days post injection</strong></td><td>${a.daysPostInjection}</td></tr>

            </c:forEach>
            </tbody>
        </table>
    </div>
    <hr>
    <div>
        <table style="width:50%">
            <tr><td><strong>Sample Preparation</strong></td><td>${experiment.samplePrep}</td></tr>
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

    <!-- Create a div where the graph will take place -->
    <div id="my_dataviz"></div>


    <script>

        // set the dimensions and margins of the graph
        var margin = {top: 30, right: 30, bottom: 30, left: 30},
            /*  width = 650 - margin.left - margin.right,
              height = 650 - margin.top - margin.bottom;*/
           width = ${fn:length(regionListJson)} ,
            height =12 ;


        // append the svg object to the body of the page
        var svg = d3.select("#my_dataviz")
            .append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom+400)
            .append("g")
            .attr("transform",
                "translate(" + margin.left + "," + margin.top + ")");

        // Labels of row and columns
        /*  var myGroups = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
          var myVars = ["v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9", "v10"]*/

        var myGroups =["A"];
        var myVars =${regionListJson};

        // Build X scales and axis:
        var x = d3.scaleBand()
            .range([ 0, width ])
            .domain(myVars)
            .padding(0.01);
        svg.append("g")
            .attr("transform", "translate(0," + height + ") ")
            .call(d3.axisBottom(x))
            .selectAll("text")
            .attr("y", 0)
            .attr("x", 9)
            .attr("dy", ".35em")
            .attr("transform", "rotate(90)")
            .attr("class", function (d,i) { return "colLabel mono r"+i;} )
            .on("mouseover", function(d) {d3.select(this).classed("text-hover",true);})
            .on("mouseout" , function(d) {d3.select(this).classed("text-hover",false);})
            .style("text-anchor", "start");

        // Build X scales and axis:
        var y = d3.scaleBand()
            .range([ height, 0 ])
            .domain(myGroups)
            .padding(0.01);
        svg.append("g")
            .call(d3.axisLeft(y))
            .selectAll("text")
            .attr("class", function (d,i) { return "rowLabel mono r"+i;} )
            .on("mouseover", function(d) {d3.select(this).classed("text-hover",true);})
            .on("mouseout" , function(d) {d3.select(this).classed("text-hover",false);});

        // Build color scale
        var myColor = d3.scaleLinear()
            .range(["white", "#0000cc"])
            .domain([1,1000]);
        var tooltip = d3.select("#my_dataviz")
            .append("div")
            .style("opacity", 0)
            .attr("class", "tooltip")
            .style("background-color", "white")
            .style("border", "solid")
            .style("border-width", "2px")
            .style("border-radius", "5px")
            .style("padding", "5px");
        var mouseover = function(d) {
            d3.select(this).classed("cell-hover",true);
           /* d3.selectAll("text").classed("text-highlight",function(r,ri){ return ri==(d.sample-1);});
            d3.selectAll("text").classed("text-highlight",function(c,ci){ return ci==(d.gene-1);});*/
            tooltip.style("opacity", 1)
        };
        var mousemove = function(d) {
            tooltip
                .html("<br>Gene: "+d.gene+"<br>Samples: " + d.value)
                .style("left", (d3.mouse(this)[0]+70) + "px")
                .style("top",(d3.mouse(this)[1]) + "px")
        };
        var mouseleave = function(d) {
            d3.select(this).classed("cell-hover",false);
            d3.selectAll(".rowLabel").classed("text-highlight",false);
            d3.selectAll(".colLabel").classed("text-highlight",false);
            tooltip.style("opacity", 0)
        };
      /*  var onClick = function(d) {
            navigate(d.gene,d.sample);
        }*/
        //Read the data
        //  d3.csv("https://raw.githubusercontent.com/holtzy/D3-graph-gallery/master/DATA/heatmap_data.csv", function(data) {
        //  d3.json(jsonData, function(data) {

        svg.selectAll()
            .data(${json}, function(d) {return d.gene+':'+d.sample;})
            .enter()
            .append("rect")
            .attr("x", function(d) { return x(d.gene) })
            .attr("y", function(d) { return y(d.sample) })
            .attr("width", 12 )
            .attr("height", 12 )
            .attr("class", function(d){return "cell cell-border cr"+(d.sample-1)+" cc"+(d.gene-1);})
            .style("fill", function(d) { return myColor(d.value*100)} )
            .on("mouseover", mouseover)
            .on("mousemove", mousemove)
            .on("mouseleave", mouseleave)
           // .on("click", onClick)

        //  }
        //)



    </script>
</div>