<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.dao.implementation.StudyDao" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>

<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link href="/common/tableSorter/css/filter.formatter.css" rel="stylesheet" type="text/css"/>
<link href="/common/tableSorter/css/theme.jui.css" rel="stylesheet" type="text/css"/>
<link href="/common/tableSorter/css/theme.blue.css" rel="stylesheet" type="text/css"/>

<script src="/common/tableSorter/js/tablesorter.js"> </script>
<script src="/common/tableSorter/js/jquery.tablesorter.widgets.js"></script>
<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<style>
   #scge-details td{
       white-space: nowrap;
   }
    .desc {
        font-size:14px;
    }
   .scge-details-label{
       color:#2a6496;
         font-weight: bold;
   }
</style>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>
<%
    Access access = new Access();
    StudyDao sdao = new StudyDao();
    Person p = access.getUser(request.getSession());
    List<Experiment> experiments = (List<Experiment>) request.getAttribute("experiments");
    Study study = null;
    if (request.getAttribute("study") != null) {
        study = (Study) request.getAttribute("study");
    }

%>
<div class="row">
<div class="col-md-3 sidenav">


        <div class="card">
            <div class="card-header scge-details-label">Study - SCGE:<%=study.getStudyId()%></div>
            <div class="card-body">
                <table id="scge-details">
                    <tr ><td class="scge-details-label">PI</td><td>: <%=study.getPi()%></td></tr>
                    <tr ><td class="scge-details-label">Submission Date</td><td>: <%=study.getSubmissionDate()%></td></tr>
                    <tr ><td class="scge-details-label" >Publication ID</td><td>: <%=study.getReference()%></td></tr>
                    <tr ><td class="scge-details-label">Status</td><td>
                        <select class="form-control" id="statusControlSelect">
                            <option selected>Completed</option>
                            <option>Received</option>
                            <option>In Processing</option>
                            <option>DCC Review</option>
                            <option>PI Review</option>
                        </select></td></tr>
                    <tr ><td class="scge-details-label">Last Updated Date</td><td>: <%=study.getSubmissionDate()%></td></tr>

                </table>
            </div>
        </div>


    </div>
    <main role="main" class="col-md-9 ml-sm-auto px-4 bg-light"  >

        <% if (study != null) { %>

        <table width="95%">
        <tr>
            <td align="right">
                <input class="btn btn-primary" type="button" value="Download Submitted Data" onclick="javascript:location.href='/toolkit/download/<%=study.getStudyId()%>'"/>
            </td>
        </tr>
    </table>

    <% } %>

        <h4 class="page-header" style="color:grey;">Study Overview</h4>
        <%if(study.getStudyId()==1026){%>
        <div class="card" style="border:1px solid white">
            Specific aims: 1) to predict which unintended editing sites have biological effects on human T-cells by integrating large-scale genome-wide activity and epigenomic profiles with state-of-the-art deep learning models and 2) to develop a human primary T-cell platform to detect functional effects of genome editing by measuring clonal representation, off-target mutation frequencies, immunogenicity, or gene expression.
            <div class="container">
            <div class="card" style="border:1px solid white">
                <div class="card-body" style="align-content: center">
                    <table class="scge-details" >
                        <tr ><td class="scge-details-label">Model</td><td>: CD4/CD8 Human Primary T cell</tr>
                        <tr ><td class="scge-details-label">Editor</td><td>: SpCas9</td></tr>
                        <tr ><td class="scge-details-label" >Delivery System</td><td>: P3 Nucleofection Kit</td></tr>
                        <tr ><td class="scge-details-label">Target Locus</td><td>: AAVS1,
                            B2M,
                            CBLB,
                            CCR5,
                            CTLA4,
                            CXCR4,
                            FAS,
                            LAG3,
                            PDCD1,
                            PTPN2,
                            PTPN6,
                            TRAC,
                            TRBC1</td>

                        </tr>
                        <tr><td class="scge-details-label">Observation</td><td>: Editing Efficiency</td></tr>

                    </table>
                </div>
            </div>
            </div>
        </div>

            <hr>
        <%}%>
        <h4 class="page-header" style="color:grey;">Experiments</h4>

    <table class="table tablesorter table-striped">
    <thead>
    <tr>
        <th>Tier</th>

    <th>Name</th>
    <th>Type</th>
        <th>Contact PI</th>
        <th>SCGE ID</th>
    </tr>
    </thead>

        <% for (Experiment exp: experiments) {
            System.out.println(exp.getStudyId());
            Study s = sdao.getStudyById(exp.getStudyId()).get(0);
        %>

        <% if (access.hasStudyAccess(s,p)) { %>

    <tr>
        <td width="10"><%=s.getTier()%></td>
        <td><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>"><%=exp.getName()%></a></td>
        <td><%=exp.getType()%></td>
        <td><%=s.getPi()%></td>
        <td><%=exp.getExperimentId()%></td>
    </tr>
        <% } %>
        <% } %>
    </table>

    </main>
</div>