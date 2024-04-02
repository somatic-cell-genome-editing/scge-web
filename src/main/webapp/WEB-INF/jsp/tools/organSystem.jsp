<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 2/2/2024
  Time: 4:14 PM
  To change this template use File | Settings | File Templates.
--%>
<div style="text-align: center"><h4>Organ&nbsp;System&nbsp;Overview</h4></div>
<div style="margin-top: 10%">

  <table align="center">
    <tr>
      <td>
        <table align="center">
          <tr>
            <td>
              <table >
                <tr>
                  <td width="40">&nbsp;</td>
                  <td>

                    <%
                      boolean first = true;
                      for (String tissue: rootTissues.keySet()) {
                        String tissueTerm=rootTissues.get(tissue);
                        String displayTissue= "";
                        if(tm.getChildTerms().get(tissue)!=null && !tm.getChildTerms().get(tissue).isEmpty()){
                          displayTissue="<a href='#"+tissue+"'>"+tissue+"</a>";
                        }else displayTissue=tissue;
                    %>
                    <% if (first) { if(targetTissues.contains(tissueTerm)){ %>
                    <div class="tissue-control-header-first" style="color:orangered"><%=displayTissue%></div>
                    <%}else{%>
                    <div class="tissue-control-header-first"><%=displayTissue%></div>
                    <%}%>
                    <% first = false; %>
                    <% } else { if(targetTissues.contains(tissueTerm)) {%>
                    <div class="tissue-control-header" style="color:orangered"><%=displayTissue%></div>

                    <%}else{%>
                    <div class="tissue-control-header"><%=displayTissue%></div>
                    <% }} %>
                    <%  } %>
                  </td>
                </tr>
              </table>

            </td>
          </tr>
          <tr>
            <td>
              <table style="margin-top:50px;">

                <% for (String condition: conditions) { %>
                <tr>
                  <td  width="65"></td>

                  <% for (String tissueKey: rootTissues.keySet()) {
                    String tissue=rootTissues.get(tissueKey);
                    String border="";
                    if(targetTissues.contains(tissue)) {
                      border += "border:5px dashed red";
                    }
                  %>
                  <td width="40" style="<%=border%>">
                    <div class="tissue-control-cell">
                      <div class="tissue-control-cell-2">
                        <% if (tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                && !tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                && !tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                        <div class="triangle-d" ></div>
                        <% } %>
                        <% if (tissueEditingMap.containsKey(tissue + "-" + condition)
                                && !tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                && !tissueDeliveryMap.containsKey(tissue + "-" + condition)) { %>
                        <div class="triangle-e"></div>
                        <% } %>
                        <% if (tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                && !tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                && !tissueEditingMap.containsKey(tissue + "-" + condition)
                        ) { %>
                        <div class="triangle-b"></div>
                        <% } %>
                        <% if (tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                && tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                && !tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                        <div class="triangle-db"></div>
                        <% } %>
                        <% if (tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                && tissueEditingMap.containsKey(tissue + "-" + condition)
                                && !tissueDeliveryMap.containsKey(tissue + "-" + condition)) { %>
                        <div class="triangle-eb"></div>
                        <% } %>
                        <% if (!tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                && tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                && tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                        <div class="triangle-ed"></div>
                        <% } %>
                        <% if (tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                && tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                && tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                        <div class="triangle-edb"></div>
                        <% } %>
                      </div>
                    </div>
                  </td>

                  <% }%>
                  <td style="font-size: small">

                    <%=condition%>
                  </td>
                </tr>
                <% } // end conditions %>
              </table>

            </td>
          </tr>
        </table>
        <table style="border:1px solid black;margin-top: 10%"  align="center">
          <tr>
            <td style="padding:10px;">
              <table>
                <tr>
                  <td>Legend:</td>
                  <td>&nbsp;</td>
                  <td align="center">
                    <table>
                      <tr>
                        <td><div style="border:1px solid black;"> <div class="legend-delivery"></div></div></td><td>Delivery Efficiency</td>

                        <td><div style="border:1px solid black;"><div class="legend-editing"></div></div></td><td>Editing Efficiency</td>

                        <td><div style="border:1px solid black;"><div class="legend-biomarker"></div></div></td><td>Biomarker Detection</td>

                        <td><div style="border:3px dashed red;background-color: white;width:15px;height:15px "></div></td><td>Target Tissue</td>

                        <td><div style="border:1px solid black;background-color: #F7F7F7;width:15px;height:15px "></div></td><td>Not Available</td>
                      </tr>

                    </table>

                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</div>
