<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 10/21/2020
  Time: 8:21 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Create a div where the graph will take place -->
<div id="my_dataviz">

</div>


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
        .attr("height", height + margin.top + margin.bottom+300)
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
        .domain([1,6]);
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
            .html("<br><span style='font-weight: bold'>Tissue:</span> "+d.gene+"<br><span style='font-weight: bold'>Signal present:</span> " + d.value)
           .style("left", (d3.event.pageX+70) + "px")
            .style("top",(d3.event.pageY+16) + "px")
           // .offset([0, 0])
    };
    var mouseleave = function(d) {
        d3.select(this).classed("cell-hover",false);
        d3.selectAll(".rowLabel").classed("text-highlight",false);
        d3.selectAll(".colLabel").classed("text-highlight",false);
        tooltip.style("opacity", 0)
    };
      var onClick = function(d) {
          var divId='#'+d.gene;
          $('.satcResults').not('"' +divId+'"').hide();
          var info = document.getElementById(""+d.gene+ "");
       //   console.log(info);
          if (info.style.display === "none") {
              info.style.display = "block";
          } else {
              info.style.display = "none";
          }
      };
    //Append a defs (for definition) element to your SVG
    var defs = svg.append("defs");

    //Append a linearGradient element to the defs and give it a unique id
    var linearGradient = defs.append("linearGradient")
        .attr("id", "linear-gradient");
    //Horizontal gradient
    linearGradient
        .attr("x1", "0%")
        .attr("y1", "0%")
        .attr("x2", "100%")
        .attr("y2", "0%");
    //Set the color for the start (0%)
    linearGradient.append("stop")
        .attr("offset", "0%")
        .attr("stop-color", "white");
    //Set the color for the end (100%)
    linearGradient.append("stop")
        .attr("offset", "100%")
        .attr("stop-color", "#0000cc");
    var legendsvg = svg.append("g")
        .attr("class", "legendWrapper")
        .attr("transform", "translate(" + (width/2) + "," + (height + 300) + ")");

    legendsvg.append("g")
        .append("rect")
        .attr("x", -(200/2))
        .attr("y", 0)
        .attr("width", 200)
        .attr("height", 10)
        .style("fill", "url(#linear-gradient)");
     legendsvg.append("text")
        .attr("class", "legendTitle")
        .attr("x", 0)
        .attr("y", -10)
        .style("text-anchor", "middle")
        .text("Number of Animals");
    //Set scale for x-axis
   var xScale = d3.scaleBand()
        .range([-200/2, 200/2]);
   //     .domain([ 0,2,4, 6] );

    //Define x-axis
    var xAxis = d3.axisBottom()
        .scale(xScale);
      /*  .orient("bottom")
        .ticks(5)
        //.tickFormat(formatPercent)
        .scale(xScale);*/
    //Set up X axis
    legendsvg.append("g")
        .attr("class", "axis")
        .attr("transform", "translate(0," + (10) + ")")
        .call(xAxis);
    legendsvg.append("text")
        .attr("x", -100)
        .attr("y", 0)
        .text("0");
    legendsvg.append("text")
        .attr("x",100)
        .attr("y", 0)
        .text("6");
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
        .style("fill", function(d) { return myColor(d.value)} )
        .on("mouseover", mouseover)
        .on("mousemove", mousemove)
        .on("mouseleave", mouseleave)
    .on("click", onClick)

    //  }
    //)



</script>