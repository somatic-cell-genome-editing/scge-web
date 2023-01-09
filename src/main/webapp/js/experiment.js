$(function () {
    $("#myTable").tablesorter({
        theme : 'blue',
        widgets: ['zebra','resizable', 'stickyHeaders'],
    });
    $("#myTable").tablesorter( {sortList: [[9, 0]]}).bind("sortEnd", function (e, t) {
        var table = e.target,
            currentSort = table.config.sortList,
            // target the first sorted column
            columnNum = currentSort[0][0],
            columnName = $(table.config.headerList[columnNum]).text();

        console.log(columnName);
        if(dualAxis) {
            updateAxis();
        } else {
            update(false, );
        }
    });
    if(filtersApplied())
        $('#downloadChartBelow').show();
    else
        $('#downloadChartBelow').hide();
})
function download(){
    $("#myTable").tableToCSV();
}
function downloadSelected(){
    $("#myTable").tableSelectionToCSV();
}
function resizeImages() {
    var count=1;
    while(true) {
        var img = document.getElementById("img" + count);
        if (img) {
            //get the height to 60
            var goal=75;
            var height = img.naturalHeight;
            var diff = height - goal;
            var percentDiff = 1 - (diff / height);
            img.height=goal;
            img.width=parseInt(img.naturalWidth * percentDiff);
        }else {
            break;
        }
        count++;
    }
}
function imageMouseOver(img, legend, title) {
    var sourceImage = document.createElement('img'),
        imgContainer = document.getElementById("imageViewer");
    sourceImage.src = img.src;
    //resizeThis(sourceImage);
    if (title != "") {
        imgContainer.innerHTML = "<div style='padding:8px;font-weight:700;font-size:18px;'>" + title + "</div>"
    }
    imgContainer.appendChild(sourceImage);
    //imgContainer.style.width=img.naturalWidth;
    if (legend != "") {
        imgContainer.innerHTML = imgContainer.innerHTML + "<div style='border:1px solid black;padding:8px;'>" + decodeHtml(legend) + "</div>";
    }
    imgContainer.style.visibility="visible";
}
function resizeThis(img) {
    if (img) {
        //get the height to 60
        var goal = 700;
        var width = img.naturalWidth;
        if (width < goal) {
            return;
        }
        var diff = width - goal;
        var percentDiff = 1 - (diff / width);
        img.width = goal;
        img.height = parseInt(img.naturalHeight * percentDiff);
    }
}
function imageMouseOut(img) {
    document.getElementById("imageViewer").innerHTML="";
    document.getElementById("imageViewer").style.visibility="hidden";
}
function decodeHtml(html) {
    var txt = document.createElement("textarea");
    txt.innerHTML = html;
    return txt.value;
}
setTimeout("resizeImages()",500);
for(var chart=0;chart<resultTypes.length;chart++) {
    var ctx = document.getElementById("resultChart"+chart);
    var colorArray = [];
    var filterValues = [];
    if (ctx != null) {
        var myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: chartLabels,
                datasets: generateData()
            },
            options: {
                responsive: true,
                scaleShowValues: true,
                scales: {
                    xAxes: [{
                        gridLines: {
                            color: "rgba(0, 0, 0, 0)"
                        },
                        scaleLabel: {
                            display: true,
                            labelString: 'Experiment Conditions',
                            fontSize: 14,
                            fontStyle: 'bold',
                            fontFamily: 'Calibri'
                        },
                        ticks: {
                            /*   fontColor: "rgb(0,75,141)",*/
                            fontSize: 10,
                            autoSkip: false,
                            callback: function (t) {
                                var maxLabelLength = 40;
                                if (t.length > maxLabelLength) return t.substr(0, maxLabelLength - 20) + '...';
                                else return t;
                            }
                        }
                    }],
                    yAxes: [{
                        id: 'delivery',
                        type: 'linear',
                        position: 'left',
                        ticks: {
                            beginAtZero: true
                        },
                        scaleLabel: {
                            display: true,
                            labelString: getLabelString(null),
                            fontSize: 14,
                            fontStyle: 'bold',
                            fontFamily: 'Calibri'
                        }
                    }, {
                        id: 'editing',
                        display: false,
                        type: 'linear',
                        position: 'right',
                        ticks: {
                            beginAtZero: true
                        },
                        scaleLabel: {
                            display: true,
                            labelString: getLabelString(null),
                            fontSize: 14,
                            fontStyle: 'bold',
                            fontFamily: 'Calibri'
                        }
                    }]
                },
                tooltips: {
                    callbacks: {
                        title: function (tooltipItem) {
                            return this._data.labels[tooltipItem[0].index];
                        },
                        afterLabel: function (tooltipItem) {
                            var index = tooltipItem.index;
                            return getDetails(index);
                        }
                    }
                },
                hover: {
                    mode: 'index',
                    intersect: false
                },
                legend: {
                    display: true
                }
            }
        });
    }
}
function getRandomColor() {
    var letters = 'BCDEF'.split('');
    var color = '#';
    for (var i = 0; i < 6; i++ ) {
        color += letters[Math.floor(Math.random() * letters.length)];
    }
    return color;
}
function getDetails(index) {
    var table = document.getElementById('myTable');
    var j = 0;
    var detail = [];
    var rowLength = table.rows.length;
    var avgIndex = table.rows.item(0).cells.length -2;
    for (i = 1; i < rowLength; i++) {
        if (table.rows.item(i).style.display !== 'none') {
            if (j === index) {
                for(k = 1;k < avgIndex-2;k++){
                    var label = table.rows.item(0).cells.item(k).innerText;
                    var value = table.rows.item(i).cells.item(k).innerText;
                    detail.push(label + ':' + value) ;
                }
            }
            j++;
        }
    }
    return detail;
}
function update(updateColor){
    for(var chart=0;i<resultTypes.length;chart++) {
        if (document.getElementById("chartDiv"+chart) != null) {
            var table = document.getElementById('myTable'); //to remove filtered rows
            var xArray = [];
            var yArray = [];
            var rowLength = table.rows.length;
            var j = 0;
            var selected = 0;
            var count = 0;
            count = optionsSize
            var filter = 'None';
            /* var colors = ['rgba(255, 140, 102,0.5)','rgba(140, 255, 102,0.5)','rgba(102, 217, 255,0.5)','rgba(217, 102, 255,0.5)',
             'rgba(255, 179, 102,0.5)','rgba(102, 255, 102,0.5)','rgba(102, 179, 255,0.5)','rgba(255, 102, 255,0.5)',
             'rgba(255, 217, 102,0.5)', 'rgba(102, 255, 140,0.5)', 'rgba(102, 140, 255,0.5)','rgba(255, 102, 217,0.5)',
             'rgba(255, 255, 102,0.5)', 'rgba(102, 255, 179,0.5)', 'rgba(102, 102, 255,0.5)', 'rgba(255, 102, 179,0.5)',
             'rgba(217, 255, 102,0.5)', 'rgba(102, 255, 217,0.5)', 'rgba(140, 102, 255,0.5)', 'rgba(255, 102, 140,0.5)',
             'rgba(179, 255, 102,0.5)','rgba(102, 255, 255,0.5)','rgba(179, 102, 255,0.5)','rgba(255, 102, 102,0.5)'
             ];*/
            var colors = [
                'rgba(230, 159, 0, 0.5)', 'rgba(86, 180, 233, 0.5)', 'rgba(0, 158, 115, 0.5)', 'rgba(240, 228, 66, 0.5)',
                'rgba(0, 114, 178, 0.5)', 'rgba(213, 94, 0, 0.5)', 'rgba(204, 121, 167, 0.5)', 'rgba(0, 0, 0, 0.5)',
                'rgba(233, 150, 122, 0.5)', 'rgba(139, 0, 139, 0.5)', 'rgba(169, 169, 169, 0.5)', 'rgba(220, 20, 60, 0.5)',
                'rgba(100, 149, 237, 0.5)', 'rgba(127, 255, 0, 0.5)', 'rgba(0, 0, 128, 0.5)', 'rgba(255, 222, 173, 0.5)',
                'rgba(128, 0, 0, 0.5)', 'rgba(224, 255, 255, 0.5)', 'rgba(32, 178, 170, 0.5)', 'rgba(160, 82, 45, 0.5)',
                'rgba(238, 130, 238, 0.5)', 'rgba(154, 205, 50, 0.5)', 'rgba(219, 112, 147, 0.5)', 'rgba(199, 21, 133, 0.5)',
                'rgba(102, 205, 170, 0.5)', 'rgba(240, 128, 128, 0.5)', 'rgba(222, 184, 135, 0.5)', 'rgba(95, 158, 160, 0.5)',
                'rgba(189, 183, 107, 0.5)', 'rgba(0, 100, 0, 0.5)', 'rgba(0, 191, 255, 0.5)', 'rgba(255, 0, 255, 0.5)',
                'rgba(218, 165, 32, 0.5)', 'rgba(75, 0, 130, 0.5)'
            ];

            var aveIndex = table.rows.item(0).cells.length - 2;
            var cells = table.rows.item(0).cells;
            if (count != 1) {
                if (document.getElementById("graphFilter") != null)
                    filter = document.getElementById("graphFilter").value;
                for (var i = 0; i < cells.length; i++) {
                    if (cells.item(i).innerText.includes(filter)) { //check the column of selected filter
                        selected = i;
                    }
                }
            }
            if (updateColor == true && count != 1) {
                filterValues = [];
                for (var i = 1; i < rowLength; i++) {
                    var cells = table.rows.item(i).cells;
                    var value = cells.item(selected).innerText;
                    if (filterValues.length == 0 || filterValues.indexOf(value) == -1) {
                        filterValues.push(value);
                    }
                }
            }
            var replicate = [];
            for (var i = 1; i < rowLength; i++) {
                if (table.rows.item(i).style.display != 'none') {
                    var cells = table.rows.item(i).cells;
                    //  if (cells.item(aveIndex - 1).innerText.toLowerCase() != "signal") {
                    var cellLength = cells.length - 1;
                    var column = cells.item(0); //points to condition column
                    for (var rt = 0; rt < resultTypes.length; rt++) {

                        avg = cells.item(aveIndex - rt);
                        if (avg.innerHTML.trim() != null && avg.innerHTML.trim() != '' && !containsAnyLetters(avg.innerHTML)) {

                            xArray[j] = column.innerText;
                            yArray[j] = avg.innerHTML;

                            //console.log(xArray[j] + "\t" + yArray[j])
                            j++;
                        }
                    }
                    var index = filterValues.indexOf(cells.item(selected).innerText);
                    if (filter != 'None') {
                        if (filterValues.length <= colors.length)
                            colorArray[j] = colors[index];
                        else colorArray[j] = colors[0];
                    } else colorArray[j] = colors[0];
                    for (var k = aveIndex + 1; k < cellLength; k++) {
                        var arr = [];
                        if (j != 0 && replicate[k - aveIndex - 1] != null)
                            arr = replicate[k - aveIndex - 1];
                        arr.push(cells.item(k).innerHTML);
                        replicate[k - aveIndex - 1] = arr;
                    }

                    // }
                }
            }
            if (xArray.length > 0) {
                var data = {
                    label: "Mean",
                    data: yArray,
                    yAxisID: 'delivery',
                    backgroundColor: colorArray,
                    borderWidth: 1
                };
                myChart.data.labels = xArray;
                myChart.data.datasets[0] = data;
                for (var i = 0; i < replicate.length; i++) {
                    var dataSet = {
                        data: replicate[i],
                        label: "Replicate: " + (i + 1),
                        yAxisID: 'delivery',
                        backgroundColor: 'rgba(255,99,132,1)',
                        borderColor: 'rgba(255,99,132,1)',
                        type: "scatter",
                        showLine: false
                    };
                    myChart.data.datasets[i + 1] = dataSet;
                }
                myChart.options.scales.yAxes[1].display = false;
                myChart.options.scales.yAxes[0].scaleLabel.labelString = getLabelString(null);
                myChart.options.legend.display = false;
                myChart.update();
                document.getElementById("chartDiv"+chart).style.display = "block";
                document.getElementById("resultChart"+chart).style.display = "block";
            } else {
                document.getElementById("chartDiv"+chart).style.display = "none";
                document.getElementById("resultChart"+chart).style.display = "none";
            }
        }
    }
}

function containsAnyLetters(str) {
    return /[a-zA-Z]/.test(str);
}

function getLabelString(result){
    var table = document.getElementById('myTable'); //to remove filtered rows
    var labelString;
    var aveIndex = table.rows.item(0).cells.length -2;
    var rowLength = table.rows.length;
    for (var i = 1; i < rowLength; i++) {
        if (table.rows.item(i).style.display !== "none") {
            var cells = table.rows.item(i).cells;
            if(result != null) {
                if( cells.item(aveIndex - 2).innerText.includes(result)) {
                    labelString = cells.item(aveIndex - 2).innerText + ' in ' + cells.item(aveIndex - 1).innerText;
                    break;
                }
            } else {
                labelString = cells.item(aveIndex - 2).innerText + ' in ' + cells.item(aveIndex - 1).innerText;
                break;
            }
        }
    }
    return labelString;
}
function applyAllFilters(_this, name) {
    var elms = document.getElementsByName(name);
    if (_this.checked) {
        elms.forEach(function(ele) {
            ele.checked=true;
            applyFilters(ele);
        });
    }else {
        elms.forEach(function(ele) {
            ele.checked=false;
            applyFilters(ele);
        });
    }
}
function filtersApplied() {
    var table = document.getElementById('myTable');
    var rowLength = table.rows.length;
    for (i = 1; i < rowLength; i++) {
        if( table.rows.item(i).style.display == "none"){
            return true;
        }
    }
    return false;
}
function applyFilters(obj)  {
    var table = document.getElementById('myTable'); //to remove filtered rows
    var rowLength = table.rows.length;
    for (i = 1; i < rowLength; i++){
        var cells = table.rows.item(i).cells;
        for (k=0; k<cells.length;k++ ) {
            //console.log("innser = " + cells.item(k).innerText + "!");
            //if (cells.item(k).innerText.includes( obj.id) || (cells.item(k).innerHTML.search(">" + obj.id + "<") > -1)) {
            if ((cells.item(k).innerText == obj.id) || (cells.item(k).innerHTML.search(">" + obj.id + "<") > -1)) {
                if (obj.checked) {
                    cells.item(k).off=false;
                    var somethingOff = false;
                    for (j=0; j<cells.length;j++ ) {
                        if (cells.item(j).off==true && j !=k) {
                            somethingOff = true;
                            break;
                        }
                    }
                    if (somethingOff) {
                        table.rows.item(i).style.display = "none";
                    }else {
                        table.rows.item(i).style.display = "";
                    }
                }else {
                    cells.item(k).off = true;
                    table.rows.item(i).style.display = "none";
                }
            }
        }

    }
    if(filtersApplied())
        $('#downloadChartBelow').show();
    else
        $('#downloadChartBelow').hide();
    if(resultTypes!=null && resultTypes.length > 1){
        //   dualAxis = true;
        for (var i = 0; i < resultTypes.length; i++) {
            if(document.getElementById((resultTypes[i])).checked == false){
                dualAxis = false;
            }
        }
    }
    if(dualAxis) {
        updateAxis();
    }else {
        update(true);
    }




}
function generateData() {
    var noOfDatasets=dataSetsSize;
    var dataSet = replicateDataSet;
    var data=[];
    data.push({
        label: "Mean",
        data: meanPlotData,
        yAxisID: 'delivery',
        backgroundColor: 'rgba(255, 206, 99, 0.6)',
        borderColor:    'rgba(255, 206, 99, 0.8)',
        borderWidth: 1
    });
    for(var i=0;i< noOfDatasets;i++){
        data.push({
            data: dataSet[i],
            label: "Replicate: "+(i+1),
            yAxisID: 'delivery',
            backgroundColor: 'rgba(220,220,220,0.5)',
            borderColor: 'rgba(255,99,132,1)',
            type: "scatter",
            showLine: false
        });
    }
    return data;
}

var dualAxis = false;
function load() {
    console.log("in load");
    var elms = document.getElementsByName("tissue");
    elms.forEach(function(ele) {
        applyFilters(ele);
    });
    var elms = document.getElementsByName("checkcelltype");
    elms.forEach(function(ele) {
        applyFilters(ele);
    });
    var elms = document.getElementsByName("checkeditor");
    elms.forEach(function(ele) {
        applyFilters(ele);
    });
    var elms = document.getElementsByName("checktargetlocus");
    elms.forEach(function(ele) {
        applyFilters(ele);
    });
    var elms = document.getElementsByName("checkguide");
    elms.forEach(function(ele) {
        applyFilters(ele);
    });
    var elms = document.getElementsByName("checkdelivery");
    elms.forEach(function(ele) {
        applyFilters(ele);
    });
    var elms = document.getElementsByName("checkmodel");
    elms.forEach(function(ele) {
        applyFilters(ele);
    });
    var elms = document.getElementsByName("checksex");
    elms.forEach(function(ele) {
        applyFilters(ele);
    });
    var elms = document.getElementsByName("checkresulttype");
    elms.forEach(function(ele) {
        applyFilters(ele);
    });
    var elms = document.getElementsByName("checkunits");
    elms.forEach(function(ele) {
        applyFilters(ele);
    });
    var elms = document.getElementsByName("checkvector");
    elms.forEach(function(ele) {
        applyFilters(ele);
    });
    var elms = document.getElementsByName("checkhrdonor");
    elms.forEach(function(ele) {
        applyFilters(ele);
    });
    /*
     <div id="graphOptions">
     3 different Units displayed in table<br>
     <li><a href='javascript:void(0)'>Graph Unit 1</a></li>
     <li>Graph Unit 2</li>
     <li>Graph Unit 2</li>
     <li>Display All Records (Mix Units)</li>
     </div>
     */
    var elms = document.getElementsByName("checkunits");
    var count=0;
    var graphOps = "";
    elms.forEach(function(ele) {
        if (ele.id.toLowerCase() != "signal") {
            count++
            graphOps += "<li><a href='javascript:graphUnit(\"" + ele.id + "\")'>Graph " + ele.id + "</a></li>";
        }
    });
    //  graphOps+="<li><a href='javascript:graphUnit(\"all\")'>Graph All Records (Mixed Units)</a></li>";
    if(count > 1) {
        document.getElementById("graphOptions").innerHTML=count + " Different Units Exist in Dataset<br>" + graphOps;
        document.getElementById("barChart").style.display="none";
        document.getElementById("graphOptions").style.display="block";
    }
}
function graphUnit(unit) {
    var elms = document.getElementsByName("checkunits");
    elms.forEach(function(ele) {
        if (ele.id === unit || unit==="all") {
            ele.checked=true;
        }else {
            ele.checked=false;
        }
        applyFilters(ele)
        document.getElementById("barChart").style.display="block";
    });
}
function updateAxis(){
    if(document.getElementById("chartDiv")!=null){
        var table = document.getElementById('myTable'); //to remove filtered rows
        var labels=[];
        var editing=[];
        var delivery=[];
        var rowLength = table.rows.length;
        var j = 0;
        var aveIndex = table.rows.item(0).cells.length -2;
        for (var i = 1; i < rowLength; i++){
            if(table.rows.item(i).style.display != 'none') {
                var cells = table.rows.item(i).cells;
                if (cells.item(aveIndex - 1).innerText.toLowerCase() != "signal") {
                    // var cellLength = cells.length-1;
                    var column = cells.item(0); //points to condition column
                    var avg = cells.item(aveIndex);
                    labels[j] = column.innerText;
                    if (cells.item(aveIndex - 2).innerText == "Delivery Efficiency") {
                        delivery[j] = avg.innerHTML;
                        editing[j] = null;
                        j++;
                    } else {
                        editing[j] = avg.innerHTML;
                        delivery[j] = null;
                        j++;
                    }
                }
            }
        }
        if(labels.length > 0) {
            var data = [];
            data.push({
                label: "delivery",
                data: delivery,
                yAxisID: 'delivery',
                backgroundColor: 'rgba(255,99,132,1)',
                borderColor: 'rgba(255,99,132,1)',
                borderWidth: 1
            });
            data.push({
                label: "editing",
                data: editing,
                yAxisID: 'editing',
                backgroundColor: 'rgba(54, 162, 235, 1)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            });
            myChart.data.labels = labels;
            myChart.data.datasets = data;
            myChart.options.scales.yAxes[1].display = true;
            myChart.options.scales.yAxes[0].scaleLabel.labelString = getLabelString('Delivery');
            myChart.options.scales.yAxes[1].scaleLabel.labelString = getLabelString('Editing');
            myChart.options.legend.display = true;
            myChart.update();
            document.getElementById("chartDiv").style.display = "block";
            document.getElementById("resultChart").style.display = "block";
        } else {
            document.getElementById("chartDiv").style.display = "none";
            document.getElementById("resultChart").style.display = "none";
        }
    }
}
var quantitative = 0;
quantitative =quantitativeSize;
console.log(quantitative);
if(quantitative == 0) {
    if(document.getElementById("chartDiv")!=null)
        document.getElementById("chartDiv").style.display = "none";
    if(document.getElementById("resultChart")!=null)
        document.getElementById("resultChart").style.display = "none";
}
setTimeout("load()",500);