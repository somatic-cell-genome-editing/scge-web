<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 2/2/2024
  Time: 4:12 PM
  To change this template use File | Settings | File Templates.
--%>
<div>
  <div style="text-align: center">
    <h5>Analyze Data Sets Available for this Experiment</h5>
  </div>
  <hr>
  <div>
    <div class="row">
      <div class="col-5">
        <%if (access.isAdmin(p) && !SCGEContext.isProduction()) {%>
        <form id="updateTargetTissueForm" action="/toolkit/data/experiments/update/experiment/<%=ex.getExperimentId()%>">
          <input type="hidden" name="experimentRecordIds" id= "experimentRecordIds" value=""/>
          <button class="btn btn-warning btn-sm" onclick="updateTargetTissue()">Update Target Tissue</button>
        </form>
        <% } %>
      </div>
      <div class="col-7" style="border:1px solid grey;padding-top: 2px;padding-bottom: 2px">
        <div class="row">
          <div class="col-6 text-no-wrap" >
            View Tissues:
          </div>
          <div class="col-2" >
            <a href="/toolkit/data/experiments/experiment/<%=ex.getExperimentId()%>?resultType=all"><button class="btn btn-primary btn-sm">All</button></a>
          </div>
          <div class="col-4" >
            <form id="viewSelectedTissues" action="/toolkit/data/experiments/experiment/<%=ex.getExperimentId()%>">
              <input type="hidden" name="selectedTissues" id= "selectedTissues" value=""/>
              <button class="btn btn-primary btn-sm" onclick="viewSelectedTissues()">Selected</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
  <% for (String organ: tm.getChildTerms().keySet()) {
    if (!tm.getChildTerms().get(organ).isEmpty()) {
  %>
  <span  style=";padding-top:10px;" id="<%=organ%>"><input id="<%=organ%>" type="checkbox" onchange="checkTissues('<%=organ%>', this)">&nbsp;<%=organ%></span>

  <% for (String childTerm: tm.getChildTerms().get(organ).keySet()) {
    String upCaseChildTerm = childTerm.substring(0,1).toUpperCase() + childTerm.substring(1,childTerm.length());
    String tissueTermExtracted=null;
    if(upCaseChildTerm.indexOf("(")>0){
      tissueTermExtracted=upCaseChildTerm.substring(0,upCaseChildTerm.indexOf("(")).trim().toLowerCase();
    }else{
      tissueTermExtracted=upCaseChildTerm.trim().toLowerCase();
    }
  %>
  <li style="list-style-type: none;margin-left:5%">
    <table style="width: 100%">
      <tr>
        <td style="width: 70%;"><input type="checkbox" name="<%=organ%>" class="selectedTissue" value="<%=tissueTermExtracted%>">
          <a href="/toolkit/data/experiments/experiment/<%=ex.getExperimentId()%>?tissue=<%=tissueTermExtracted%>"><%=upCaseChildTerm%></a>
          <% if (targetTissues2.containsKey(childTerm)) { %>
          &nbsp;<span style="color:red;font-weight: bold">(TARGET)</span>
          <%} %>
        </td>

        <td>
          <% if (access.isAdmin(p) && !SCGEContext.isProduction()) {
            if (targetTissues2.containsKey(childTerm)) { %>
          <input type="checkbox" name="targetTissue" value="<%=targetTissues2.get(childTerm)%>" checked>Target Check
          <% } else { %>
          <input type="checkbox" name="targetTissue" value="<%=nonTargetTissues2.get(childTerm)%>">Target Check
          <% }}%>

        </td>
      </tr>
    </table>
  </li>

  <% } %>
  <%}} %>



</div>