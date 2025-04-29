/*plugin to change the chart background to white in download image*/
Chart.register({
    id: 'customBackground',
    beforeDraw: (chart, args, opts) => {
        const ctx = chart.canvas.getContext('2d');
        ctx.save();
        ctx.globalCompositeOperation = 'destination-over';
        ctx.fillStyle = 'white';
        ctx.fillRect(0, 0, chart.width, chart.height);
        ctx.restore();
    }
})
function drawLegend(filterValues, legendValues, filter){
    var legendDiv = document.getElementById("legend-wrapper")
    if(filterValues.length>0 && filter!='None') {
        filterValues.sort();
        var legendHtml = " <div class='card' style='margin-bottom: 5px'><div class='card-header'>Legend</div><div class='card-body'> <div id='legend'>"
            +   "<div class=row>";
        for (var v in legendValues) {
            // console.log(legendValues[e] + "\t" + colorPalette[e])
            var e= filterValues.indexOf(legendValues[v]);
            var backgroundColor;
            var borderColor;
            if(e>30){
                backgroundColor=colorPalette2[e];
                borderColor=colorPalette2[e];
            }else{
                backgroundColor=colorPalette[e];
                borderColor=colorPalette[e];
            }
            var displayVal;
            if(legendValues[v].toString().length>15){
                displayVal=legendValues[v].toString().substring(0,5)+".."+legendValues[v].toString().substring(legendValues[v].toString().length-10)
            }else {
                displayVal=legendValues[v];
            }

            legendHtml += "<div class='col-2'><div class='row'><div class='col-1' style='padding-top: 5px'><div  style='height:10px;width:20px;border:1px solid gray;background-color:" + backgroundColor + "'></div></div>&nbsp;<div class='col'><small class='text-muted text-nowrap' title='"+legendValues[v]+"'>"
            legendHtml += displayVal
            legendHtml += "</small></div></div></div>"
        }
        legendHtml += "</div></div> </div> </div>"
        legendDiv.innerHTML = legendHtml;
    }else{
        legendDiv.innerHTML = "";
    }
}
function getDetails(recordId) {
    //  var recordId=plotRecordIds[index];
    var table = document.getElementById('myTable');
    var recordIdIndex=0;
    var cellLength=  table.rows[1].cells.length;
    for(var j=0;j<cellLength;j++){
        var cellText= table.rows[1].cells[j].innerHTML;
        if(cellText.includes( "Record ID")){
            recordIdIndex=j;
        }
    }

    var detail = [];
    var rowLength = table.rows.length;
    var avgIndex = table.rows.item(1).cells.length -1-resultTypeRecordsSize;
    for (i = 2; i < rowLength; i++) {
        if (table.rows.item(i).style.display !== 'none') {
            var recordIdColValue = table.rows[i].cells.item(recordIdIndex).innerHTML;
            if (recordIdColValue == recordId) {
                for(k = 1;k < avgIndex;k++){
                    var label = table.rows.item(1).cells.item(k).innerText;
                    var value = table.rows.item(i).cells.item(k).innerText;
                    detail.push("<span style='color:yellow'>"+label+"</span>" + ': ' + value) ;
                }
            }

        }
    }
    return detail;
}
function getRandomColor() {
    var trans = '0.5'; // 50% transparency
    var color = 'rgba(';
    for (var i = 0; i < 3; i++) {
        color += Math.floor(Math.random() * 255) + ',';
    }
    color += trans + ')'; // add the transparency
    return color;
}
$(function () {
    $("#myTable").tablesorter( {sortList: [[9, 0]]}).bind("sortEnd", function (e, t) {
        var table = e.target,
            currentSort = table.config.sortList,
            // target the first sorted column
            columnNum = currentSort[0][0],
            columnName = $(table.config.headerList[columnNum]).text();
        //  console.log(columnName +"\tINDEX:"+ columnNum);

        // if(dualAxis) {
        //     updateAxis();
        // } else {
        console.log("bindSort ....")
        update(false);
        // }
    });
    if(filtersApplied() && !emptyTableRows())
        $('#downloadChartBelow').show();
    else
        $('#downloadChartBelow').hide();

})
function updateChartValues(value){
    update(false, value.toLowerCase())
}
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
function getColumnIndex(table, columnName){
    var cellLength=  table.rows[1].cells.length;
    var index=0
    for(var j=0;j<cellLength;j++){
        var cellText= table.rows[1].cells[j].innerHTML;
        if(cellText.includes(columnName)){
            index=j;
        }
    }
    return index;
}
function applyAllFilters(_this, name, columnName) {
    var elms = document.getElementsByName(name);
    if (_this.checked) {
        elms.forEach(function(ele) {
            ele.checked=true;
            // applyFilters(ele, true,columnName);
        });
    }else {
        elms.forEach(function(ele) {
            ele.checked=false;
            // applyFilters(ele, true,columnName);
        });
    }
    // update(true)
}
function resetFilters() {
    $("input[type='checkbox']").each(function (){
        this.checked=true
    })
    removeAllFiltersApplied();
    update(false) //not the initial load, update plots

}
function removeAllFiltersApplied() {
    var table = document.getElementById('myTable');
    var rowLength = table.rows.length;
    for (i = 2; i < rowLength; i++) {
        table.rows.item(i).style.display = ""

    }

}
function filtersApplied() {
    var table = document.getElementById('myTable');
    var rowLength = table.rows.length;
    for (i = 2; i < rowLength; i++) {
        if( table.rows.item(i).style.display == "none"){
            return true;
        }
    }
    return false;
}
function emptyTableRows() {
    var table = document.getElementById('myTable');
    var rowLength = table.rows.length;
    var hiddenRows=0;

    for (i = 2; i < rowLength; i++) {
        if (table.rows.item(i).style.display == "none") {
            hiddenRows+=1;
        }
    }
    //    console.log("TABLE ROW LENGTH:"+ rowLength +"\thidden rows:"+ hiddenRows)
    return rowLength == hiddenRows + 2;
}
function applyFilters(objects,  columnName) {
    var table = document.getElementById('myTable'); //to remove filtered rows
    var columnIndex=getColumnIndex(table, columnName)
    if(columnIndex>0){
    var rowLength = table.rows.length;
    for (i = 2; i < rowLength; i++) {
        var cells = table.rows.item(i).cells;
        //      for (k = 0; k < cells.length; k++) {
        //    console.log("innser = " + cells.item(k).innerText + "!" + obj.id);
       objects.forEach(function (obj){


        if ((cells.item(columnIndex).innerText.toLowerCase().includes(obj.id.toString().toLowerCase()) && columnName!='Sex' && columnName!='Qualifier') || (cells.item(columnIndex).innerHTML.toLowerCase().search(">" + obj.id.toString().toLowerCase() + "<") > -1 && columnName!='Sex' && columnName!='Qualifier') ||
            cells.item(columnIndex).innerText.toLowerCase().trim()==obj.id.toString().toLowerCase() .trim()) {
            //   if ((cells.item(k).innerText.trim() == obj.id) || (cells.item(k).innerHTML.search(">" + obj.id + "<") > -1)) {
            if (obj.checked) {
                cells.item(columnIndex).off = false;
                var somethingOff = false;
                for (j = 0; j < cells.length; j++) {
                    if (cells.item(j).off == true && j != columnIndex) {
                        somethingOff = true;
                        break;
                    }
                }
                if (somethingOff) {
                    table.rows.item(i).style.display = "none";
                } else {
                    table.rows.item(i).style.display = "";
                }
            } else {
                cells.item(columnIndex).off = true;
                table.rows.item(i).style.display = "none";
            }
        }
       })
       }

    }
    if (filtersApplied() &&  !emptyTableRows())
        $('#downloadChartBelow').show();
    else
        $('#downloadChartBelow').hide();
    if (emptyTableRows()) {
        $('#chart-highlighter').hide();
        table.style.display="none";
    }
    else
    {
        $('#chart-highlighter').show();
        table.style.display="block";
    }

}

var dualAxis = false;
function load(initialLoad) {
    console.log("in load");
    if(!initialLoad || filtersApplied() || selectedTissueListSize>0) {
       var objects=[]
            var elms = document.getElementsByName("tissue");
            elms.forEach(function (ele) {
               objects.push(ele)
            });
        applyFilters(objects, 'Tissue');

        var objects=[]
        var elms = document.getElementsByName( 'checkTimePoint');
        elms.forEach(function (ele) {
            objects.push(ele)
        });
        applyFilters(objects, 'Time Point');

        var objects=[]
        var elms = document.getElementsByName("checkqualifier");
        elms.forEach(function (ele) {
            objects.push(ele)
        });
        applyFilters(objects, 'Qualifier');
        var objects=[]
        var elms = document.getElementsByName("checkcelltype");
        elms.forEach(function (ele) {
            objects.push(ele)
        });
        applyFilters(objects,  'Cell Type');
        var objects=[]
        var elms = document.getElementsByName("checkeditor");
        elms.forEach(function (ele) {
            objects.push(ele)
        });
        applyFilters(objects,  'Editor');
        var objects=[]
        var elms = document.getElementsByName("checktargetlocus");
        elms.forEach(function (ele) {
            objects.push(ele)
        });
        applyFilters(objects, 'Target Locus');
        var objects=[]
        var elms = document.getElementsByName("checkguide");
        elms.forEach(function (ele) {
            objects.push(ele)
        });
        applyFilters(objects,  'Guide');
        var objects=[]
        var elms = document.getElementsByName("checkdelivery");
        elms.forEach(function (ele) {
            objects.push(ele)
        });
        applyFilters(objects, 'Delivery');
        var objects=[]
        var elms = document.getElementsByName("checkmodel");
        elms.forEach(function (ele) {
            objects.push(ele)
        });
        applyFilters(objects,  'Model');

        var elms = document.getElementsByName("checksex");
        var objects=[]
        elms.forEach(function (ele) {
            console.log("SEX:"+ ele.id)
            objects.push(ele)
        });
        applyFilters(objects,  'Sex');

        var objects=[]
        var elms = document.getElementsByName("checkvector");
        elms.forEach(function (ele) {
            objects.push(ele)
        });
        applyFilters(objects,  'Vector');

        var objects=[]
        var elms = document.getElementsByName("checkhrdonor");
        elms.forEach(function (ele) {
            objects.push(ele)
        });
        applyFilters(objects,  'HR Donor');

        // if(elms.length==0){
        //     if (document.getElementById("graphFilter") != null) {
        //         filter = document.getElementById("graphFilter").value;
        //         if (filter != 'None' || filtersApplied())
        //             update(true)
        //     }
        // }
    }
    if(plotsSize>0) {
        if (initialLoad)
            update(true) // creates new chart
        else
            update(false) // updates chart data

    document.getElementById("charts").style.visibility="visible"

    document.getElementById("spinner").style.visibility = "hidden";
    }

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



function drawResultChart(tickLabels,dataSets,i,tickDisplay,plotTitle, yAxisLabel, titleColor ) {

    var ctx= document.getElementById("resultChart"+i);
    return  new Chart(ctx, {
        type: 'bar',
        data: {
            labels: tickLabels,
            datasets: dataSets
        },
        options: {
            responsive: true,
            scaleShowValues: true,
            maintainAspectRatio: false,

            scales: {
                x: {
                    grid: {
                        color: "rgba(0, 0, 0, 0)"
                    },

                    scaleLabel: {
                        display: true,
                        fontSize: 14,
                        fontStyle: 'bold',
                        fontFamily: 'Calibri'
                    },


                    ticks: {
                        minRotation: 70,// angle in degrees
                        fontSize: 10,
                        autoSkip: false,
                        display:tickDisplay,
                        callback: function (val, index) {
                            // Hide every 2nd tick label
                            var t = this.getLabelForValue(val);
                            var maxLabelLength = 30;
                            if (t.length > maxLabelLength) {
                                var tokenLength = t.length / 3;
                                var token1 = t.substr(0, t.indexOf(" "));
                                var token2 = '';
                                if (t.indexOf(",") > 0)
                                    token2 = t.substr(t.indexOf(",") + 1, t.substr(t.indexOf(",") + 1).trim().indexOf("(") + 1).trim();
                                var token3 = '';
                                if (t.indexOf("(") > 0) {
                                    var tmp = t.substr(t.indexOf("(") + 1, t.substr(t.indexOf("(") + 1).indexOf(")"));
                                    var tmp1 = tmp;
                                    if (tmp.indexOf('/') > 0) {
                                        tmp1 = tmp.substr(0, tmp.indexOf('/'))
                                    }
                                    if (tmp1.indexOf(" ") > 0)
                                        tmp1 = tmp1.substr(0, tmp1.indexOf(" "));
                                    token3 = tmp1;
                                }
                                var token4 = '';
                                if (t.indexOf("/") > 0) {
                                    token4 = t.substr(t.indexOf("/") + 1, t.substr(t.indexOf("/") + 1).indexOf(")"));
                                }

                                /*  console.log("TICK:"+t +"\tLENGTH:"+tokenLength);
                                  console.log("TOKEN1:"+token1);
                                  console.log("TOKEN2:"+token2);

                                  console.log("TOKEN3:"+token3);
                                  console.log("TOKEN4:"+token4);*/
                                var newLabel = token1;
                                if (typeof token2 != 'undefined' && token2 != '')
                                    newLabel += "..." + token2;
                                if (typeof token3 != 'undefined' && token3 != '')
                                    newLabel += "..." + token3;
                                if (typeof token4 != 'undefined' && token4 != '')
                                    newLabel += "..." + token4;
                                //  console.log("NEW LABEL:"+ newLabel);
                                //  return t.substr(0, maxLabelLength) + '...';
                                return newLabel
                            }
                            return t;
                        }
                    }
                },
                y: {
                    ticks: {
                        beginAtZero: true
                    },
                    title: {
                        display: true,
                        text: [yAxisLabel]


                    }
                }
            },


            hover: {
                mode: 'index',
                intersect: false
            },
            plugins: {
                legend: {
                    display: false
                }
                ,
                title: {
                    display: true,

                    //  text: [<%--=plot.getTitle()--%>],
                    text: plotTitle,
                    color: titleColor,
                    font: {
                        size: 16
                    }
                },

                tooltip: {
                    enabled: false,

                    external: function (context) {
                        let tooltipEl = document.getElementById('chartjs-tooltip');

                        // Create element on first render
                        if (!tooltipEl) {
                            tooltipEl = document.createElement('div');
                            tooltipEl.id = 'chartjs-tooltip';
                            tooltipEl.innerHTML = '<table></table>';
                            document.body.appendChild(tooltipEl);
                        }

                        // Hide if no tooltip
                        const tooltipModel = context.tooltip;
                        if (tooltipModel.opacity === 0) {
                            tooltipEl.style.opacity = 0;
                            return;
                        }

                        // Set caret Position
                        tooltipEl.classList.remove('above', 'below', 'no-transform');
                        if (tooltipModel.yAlign) {
                            tooltipEl.classList.add(tooltipModel.yAlign);
                        } else {
                            tooltipEl.classList.add('no-transform');
                        }

                        function getBody(bodyItem) {
                            return bodyItem.lines;
                        }

                        // Set Text
                        if (tooltipModel.body) {
                            const titleLines = tooltipModel.title || [];
                            const bodyLines = tooltipModel.body.map(getBody);
                            var details = "";

                            if (tooltipModel.dataPoints.length) {
                                var index = tooltipModel.dataPoints[0].dataIndex;
                                var recordIds = tooltipModel.dataPoints[0].dataset.recordIds;
                                if (typeof recordIds != 'undefined') {
                                    var recordId = tooltipModel.dataPoints[0].dataset.recordIds[index];
                                    details = getDetails(recordId);
                                }
                            }
                            let innerHtml = '<thead>';

                            titleLines.forEach(function (title) {
                                innerHtml += '<tr><th>' + title + '</th></tr>';
                            });
                            innerHtml += '</thead><tbody>';

                            bodyLines.forEach(function (body, i) {
                                const colors = tooltipModel.labelColors[i];
                                let style = 'background:' + colors.backgroundColor;
                                style += '; border-color:' + colors.borderColor;
                                style += '; border-width: 2px';
                                const span = '<span style="' + style + '">' + body + '</span>';
                                innerHtml += '<tr><td>' + span + '</td></tr>';

                                for (var item = 0; item < details.length; item++)
                                    innerHtml += '<tr><td >' + details[item] + '</td></tr>';
                                //innerHtml += '</tbody>';
                            });
                            innerHtml += '</tbody>';

                            let tableRoot = tooltipEl.querySelector('table');
                            tableRoot.innerHTML = innerHtml;
                        }

                        const position = context.chart.canvas.getBoundingClientRect();
                        const bodyFont = Chart.helpers.toFont(tooltipModel.options.bodyFont);

                        // Display, position, and set styles for font
                        tooltipEl.style.opacity = 1;
                        tooltipEl.style.position = 'absolute';
                        tooltipEl.style.left = position.left + window.pageXOffset + tooltipModel.caretX + 'px';
                        tooltipEl.style.top = position.top + window.pageYOffset + tooltipModel.caretY + 'px';
                        tooltipEl.style.font = bodyFont.string;
                        tooltipEl.style.padding = tooltipModel.padding + 'px ' + tooltipModel.padding + 'px';
                        tooltipEl.style.pointerEvents = 'none';
                        tooltipEl.style.color = 'white';
                        tooltipEl.style.backgroundColor = 'rgba(0, 0, 0, 0.7)';
                    }
                }
            }
            ,
            animation: {
                onComplete: function (context) {
                    var a = document.getElementById("image"+i)
                    a.href = context.chart.toBase64Image();
                    a.download = '\''+plotTitle.replaceAll(" ", "_")+'.png'
                }
            }
        }
    });

}
