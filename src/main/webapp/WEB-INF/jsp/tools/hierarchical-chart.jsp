<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 6/21/2023
  Time: 12:13 PM
  To change this template use File | Settings | File Templates.
--%>
<style>
  /************************/
  ol.organizational-chart,
  ol.organizational-chart ol,
  ol.organizational-chart li,
  ol.organizational-chart li > div {
    position: relative;
  }

  ol.organizational-chart,
  ol.organizational-chart ol {
    list-style: none;
    margin: 0;
    padding: 0;
  }

  ol.organizational-chart {
    text-align: center;
  }

  ol.organizational-chart ol {
    padding-top: 1em;
  }

  ol.organizational-chart ol:before,
  ol.organizational-chart ol:after,
  ol.organizational-chart li:before,
  ol.organizational-chart li:after,
  ol.organizational-chart > li > div:before,
  ol.organizational-chart > li > div:after {
    background-color: #b7a6aa;
    content: '';
    position: absolute;
  }

  ol.organizational-chart ol > li {
    padding: 1em 0 0 1em;
  }

  ol.organizational-chart > li ol:before {
    height: 1em;
    left: 50%;
    top: 0;
    width: 3px;
  }

  ol.organizational-chart > li ol:after {
    height: 3px;
    left: 3px;
    top: 1em;
    width: 50%;
  }

  ol.organizational-chart > li ol > li:not(:last-of-type):before {
    height: 3px;
    left: 0;
    top: 2em;
    width: 1em;
  }

  ol.organizational-chart > li ol > li:not(:last-of-type):after {
    height: 100%;
    left: 0;
    top: 0;
    width: 3px;
  }

  ol.organizational-chart > li ol > li:last-of-type:before {
    height: 3px;
    left: 0;
    top: 2em;
    width: 1em;
  }

  ol.organizational-chart > li ol > li:last-of-type:after {
    height: 2em;
    left: 0;
    top: 0;
    width: 3px;
  }

  ol.organizational-chart li > div {
    background-color: #fff;
    border-radius: 3px;
    min-height: 2em;
    padding: 0.5em;
  }

  /*** PRIMARY ***/
  ol.organizational-chart > li > div {
    background-color: #a2ed56;
    margin-right: 1em;
  }

  ol.organizational-chart > li > div:before {
    bottom: 2em;
    height: 3px;
    right: -1em;
    width: 1em;
  }

  ol.organizational-chart > li > div:first-of-type:after {
    bottom: 0;
    height: 2em;
    right: -1em;
    width: 3px;
  }

  ol.organizational-chart > li > div + div {
    margin-top: 1em;
  }

  ol.organizational-chart > li > div + div:after {
    height: calc(100% + 1em);
    right: -1em;
    top: -1em;
    width: 3px;
  }

  /*** SECONDARY ***/
  ol.organizational-chart > li > ol:before {
    left: inherit;
    right: 0;
  }

  ol.organizational-chart > li > ol:after {
    left: 0;
    width: 100%;
  }

  ol.organizational-chart > li > ol > li > div {
    background-color: #83e4e2;
  }

  /*** TERTIARY ***/
  ol.organizational-chart > li > ol > li > ol > li > div {
    background-color: #fd6470;
  }

  /*** QUATERNARY ***/
  ol.organizational-chart > li > ol > li > ol > li > ol > li > div {
    background-color: #fca858;
  }

  /*** QUINARY ***/
  ol.organizational-chart > li > ol > li > ol > li > ol > li > ol > li > div {
    background-color: #fddc32;
  }

  /*** MEDIA QUERIES ***/
  @media only screen and ( min-width: 64em ) {

    ol.organizational-chart {
      margin-left: -1em;
      margin-right: -1em;
    }

    /* PRIMARY */
    ol.organizational-chart > li > div {
      display: inline-block;
      float: none;
      margin: 0 1em 1em 1em;
      vertical-align: bottom;
    }

    ol.organizational-chart > li > div:only-of-type {
      margin-bottom: 0;
      width: calc((100% / 1) - 2em - 4px);
    }

    ol.organizational-chart > li > div:first-of-type:nth-last-of-type(2),
    ol.organizational-chart > li > div:first-of-type:nth-last-of-type(2) ~ div {
      width: calc((100% / 2) - 2em - 4px);
    }

    ol.organizational-chart > li > div:first-of-type:nth-last-of-type(3),
    ol.organizational-chart > li > div:first-of-type:nth-last-of-type(3) ~ div {
      width: calc((100% / 3) - 2em - 4px);
    }

    ol.organizational-chart > li > div:first-of-type:nth-last-of-type(4),
    ol.organizational-chart > li > div:first-of-type:nth-last-of-type(4) ~ div {
      width: calc((100% / 4) - 2em - 4px);
    }

    ol.organizational-chart > li > div:first-of-type:nth-last-of-type(5),
    ol.organizational-chart > li > div:first-of-type:nth-last-of-type(5) ~ div {
      width: calc((100% / 5) - 2em - 4px);
    }

    ol.organizational-chart > li > div:before,
    ol.organizational-chart > li > div:after {
      bottom: -1em!important;
      top: inherit!important;
    }

    ol.organizational-chart > li > div:before {
      height: 1em!important;
      left: 50%!important;
      width: 3px!important;
    }

    ol.organizational-chart > li > div:only-of-type:after {
      display: none;
    }

    ol.organizational-chart > li > div:first-of-type:not(:only-of-type):after,
    ol.organizational-chart > li > div:last-of-type:not(:only-of-type):after {
      bottom: -1em;
      height: 3px;
      width: calc(50% + 1em + 3px);
    }

    ol.organizational-chart > li > div:first-of-type:not(:only-of-type):after {
      left: calc(50% + 3px);
    }

    ol.organizational-chart > li > div:last-of-type:not(:only-of-type):after {
      left: calc(-1em - 3px);
    }

    ol.organizational-chart > li > div + div:not(:last-of-type):after {
      height: 3px;
      left: -2em;
      width: calc(100% + 4em);
    }

    /* SECONDARY */
    ol.organizational-chart > li > ol {
      display: flex;
      flex-wrap: nowrap;
    }

    ol.organizational-chart > li > ol:before,
    ol.organizational-chart > li > ol > li:before {
      height: 1em!important;
      left: 50%!important;
      top: 0!important;
      width: 3px!important;
    }

    ol.organizational-chart > li > ol:after {
      display: none;
    }

    ol.organizational-chart > li > ol > li {
      flex-grow: 1;
      padding-left: 1em;
      padding-right: 1em;
      padding-top: 1em;
    }

    ol.organizational-chart > li > ol > li:only-of-type {
      padding-top: 0;
    }

    ol.organizational-chart > li > ol > li:only-of-type:before,
    ol.organizational-chart > li > ol > li:only-of-type:after {
      display: none;
    }

    ol.organizational-chart > li > ol > li:first-of-type:not(:only-of-type):after,
    ol.organizational-chart > li > ol > li:last-of-type:not(:only-of-type):after {
      height: 3px;
      top: 0;
      width: 50%;
    }

    ol.organizational-chart > li > ol > li:first-of-type:not(:only-of-type):after {
      left: 50%;
    }

    ol.organizational-chart > li > ol > li:last-of-type:not(:only-of-type):after {
      left: 0;
    }

    ol.organizational-chart > li > ol > li + li:not(:last-of-type):after {
      height: 3px;
      left: 0;
      top: 0;
      width: 100%;
    }

  }
</style>

  <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <script type="text/javascript">
    google.charts.load('current', {packages:["orgchart"]});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
      var data = new google.visualization.DataTable();
      data.addColumn('string', 'Name');
      data.addColumn('string', 'Manager');
      data.addColumn('string', 'ToolTip');

      // For each orgchart box, provide the name, manager, and tooltip to show.
      data.addRows([
        [{'v':'SCGE Toolkit', 'f':'<span style="white-space: nowrap" class="card-label">Browse</span><br><img src="/toolkit/images/scge-logo-200w.png" width="150" style="padding-top: 0;margin-top: 0" alt="SCGE"/><br>'},
          '', 'SCGE Toolkit'],
        [{'v':'SCGE Consortium Projects', 'f':'<a href="/toolkit/data/search/results/Project?searchTerm="><span style="font-weight:bold;white-space: nowrap" class="card-label">SCGE Consortium Projects</span></a><br><a href="/toolkit/data/search/results/Project?searchTerm=&facetSearch=true&unchecked=&selectedFiltersJson=%7B%7D&selectedView=list&initiative=Collaborative+Opportunity+Fund"><span style="font-weight:bold;white-space: nowrap" class="card-label">Collaborative Opportunity Fund Projects</span></a><br><a href="/toolkit/data/search/results/Project?searchTerm=&facetSearch=true&unchecked=&selectedFiltersJson=%7B%7D&selectedView=list&initiative=AAV+tropism"><span style="font-weight:bold;white-space: nowrap" class="card-label">AAV Tropism Projects</span></a>'},
          'SCGE Toolkit', 'SCGE Consortium Projects'],

        [{'v':'Experiments', 'f':'<a class="nav-link text-secondary" href="/toolkit/data/search/results/Experiment?searchTerm="><img src="/toolkit/images/studies.png" class="card-image" alt=""/><br><span style="white-space: nowrap" class="card-label">Experiments</span></a>'}, 'SCGE Consortium Projects', 'Experiments'],
        ['<a class="nav-link text-secondary" href="/toolkit/data/search/results/Genome%20Editor?searchTerm="><img src="/toolkit/images/Editor-rev.png"  class="card-image" alt=""/><span style="white-space: nowrap" class="card-label">Genome Editors</span><br>Novel technologies or tools for genome editing.</a>', 'Experiments', 'Genome Editors'],
        ['<a class="nav-link text-secondary" href="/toolkit/data/search/results/Guide?searchTerm="><img src="/toolkit/images/guide.png"   class="card-image" alt=""/><br><span style="white-space: nowrap" class="card-label">Guides</span><br>Guide RNAs function as guide for targeting enzymes</a>', 'Experiments', 'Guide RNAs'],
        ['<a class="nav-link text-secondary" href="/toolkit/data/search/results/Model%20System?searchTerm="><img src="/toolkit/images/mouse.png"  class="card-image" alt=""/><br><span style="white-space: nowrap" class="card-label">Model Systems</span><br>Model Systems include animal models (Mouse, Pig, etc.,), cell lines, organoids</a>', 'Experiments', 'Model Systems'],
        ['<a class="nav-link text-secondary" href="/toolkit/data/search/results/Delivery%20System?searchTerm="><img src="/toolkit/images/Delivery.png"  class="card-image"  alt=""/><span style="white-space: nowrap" class="card-label">Delivery Systems</span><br>Novel gene delivery systems</a>', 'Experiments', 'Delivery Systems'],
        ['<a class="nav-link text-secondary" href="/toolkit/data/search/results/Vector?searchTerm="><img src="/toolkit/images/vector.png"  class="card-image"  alt=""/><br><span style="white-space: nowrap" class="card-label">Vectors</span><br>Vectors include adenovirus, adeno-associated virus, retrovirus, and lentivirus.</a>', 'Experiments', 'Vectors'],
        ['<a class="nav-link text-secondary" href="/toolkit/data/protocols/search"><img src="/toolkit/images/protocols.png"  class="card-image"  alt=""/><br><span style="white-space: nowrap" class="card-label">Protocols</span><br>The procedures or rules that are being used in somatic cell genome editing techniques.</a>', 'Experiments', 'Protocols'],


      ]);

      // Create the chart.
      var chart = new google.visualization.OrgChart(document.getElementById('chart_div'));
      // Draw the chart, setting the allowHtml option to true for the tooltips.
      chart.draw(data, {'allowHtml':true});
    }
  </script>

<div id="chart_div"></div>



<!--div id="wrapper">
  <div id="container">

    <ol class="organizational-chart">
      <li>
        <div>
          <h1>Toolkit</h1>
        </div>
        <ol>
          <li>
            <div>
              <h3>SCGE Consortium Projects</h3>
            </div>
          </li>
          <li>
            <div>
              <h3>Collaborative Opportunity Fund Projects</h3>
            </div>
          </li>
          <li>
            <div>
              <h3>AAV Tropism Projects</h3>
            </div>
          </li>
        </ol>
        <ol>
          <li>
            <div><h3>Experiments</h3></div>
          </li>
        </ol>
      </li>
      <li>
        <div>
          <h1>Experiments</h1>
        </div>
        <ol>
          <li>
            <div>
              <h2>Genome Editors</h2>
            </div>
          </li>
          <li>
            <div>
              <h2>Guides</h2>
            </div>

          </li>
          <li>
            <div>
              <h2>Model Systems</h2>
            </div>
            <ol>
              <li>
                <div>
                  <h3>Mouse</h3>
                </div>
              </li>
              <li>
                <div>
                  <h3>Human</h3>
                </div>
              </li>
              <li>
                <div>
                  <h3>Cell lines</h3>
                </div>
              </li>
            </ol>
          </li>
          <li>
            <div>
              <h2>Delivery Systems</h2>
            </div>
          </li>
          <li>
            <div>
              <h2>Vectors</h2>
            </div>

          </li>
          <li>
            <div>
              <h2>Protocols</h2>
            </div>

          </li>
        </ol>
      </li>
    </ol>

  </div>
</div-->