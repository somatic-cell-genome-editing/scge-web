<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.dao.implementation.GrantDao" %>
<%@ page import="edu.mcw.scge.process.UI" %>
<%@ page import="edu.mcw.scge.datamodel.Protocol" %>
<%@ page import="edu.mcw.scge.dao.implementation.ProtocolDao" %>

<%
    try {  //  open scope

    ProtocolDao pdao = new ProtocolDao();
    List<Protocol> localProtocols = pdao.getProtocolsForObject(objectId);

    //List<Protocol> localProtocols = (List<Protocol>)request.getAttribute("protocols");
    //String objectId = request.getParameter("objectId");
    //String redirectURL = request.getParameter("requestURL");
    Access localProtocolAccess = new Access();
    Person localProtocolPerson = new UserService().getCurrentUser(request.getSession());
    GrantDao localProtocolGrantDao = new GrantDao();

    boolean hasProtocolsAtCorrectTier = false;
    for (Protocol localProtocol: localProtocols) {
        if (localProtocolAccess.hasProtocolAccess(localProtocol,localProtocolPerson)) {
            hasProtocolsAtCorrectTier = true;
        }
    }

%>



<script>
    $(function() {
        $("#myTable-<%=objectId%>").tablesorter({
            theme : 'blue'

        });
    });

</script>


<%if(localProtocols.size()>0 || localProtocolAccess.isAdmin(localProtocolPerson)){%>
<hr>
<%}%>
<table width="95%"><tr>
    <td>
        <%if(localProtocols.size()>0){%>
        <h4 class="page-header" style="color:grey;">
    <% if ((objectId + "").startsWith("18")) { %>
        Experiment Wide Protocols
    <% } else { %>
    Protocols
    <% } %>

     </h4>
        <%}%>
    </td>
    <% if (localProtocolAccess.isAdmin(localProtocolPerson)) {  %>
        <td align="right"><a href="/toolkit/data/protocols/associate?objectId=<%=objectId%>&redirectURL=<%=redirectURL%>" style="color:white;background-color:#007BFF; padding:10px;">Associate Protocols</a></td>
    <% } %>
</tr>
</table>

<%if(localProtocols.size()>0){%>
<table id="myTable-<%=objectId%>" class="tablesorter">
    <thead>
    <tr>
        <% if (localProtocolAccess.isAdmin(localProtocolPerson)) {  %>
            <th></th>
        <% } %>
        <th>Title</th>
        <th>Description</th>
        <th>File Download</th>
        <th>SCGE ID</th>
    </tr>
    </thead>
    <tbody>
    <% for (Protocol localProtocol: localProtocols) { %>
    <% if (localProtocolAccess.hasProtocolAccess(localProtocol,localProtocolPerson)) { %>
    <tr>
        <% if (localProtocolAccess.isAdmin(localProtocolPerson)) {  %>
            <td><a href="/toolkit/data/protocols/removeAssociation?objectId=<%=objectId%>&protocolId=<%=localProtocol.getId()%>&redirectURL=<%=redirectURL%>" style="color:white;background-color:red; padding:7px;">Remove</a></td>
        <% } %>
        <td><a href="/toolkit/data/protocols/protocol/?id=<%=localProtocol.getId()%>"><%=localProtocol.getTitle()%></a></td>
        <td><%=localProtocol.getDescription()%></td>
        <td><a href="/toolkit/files/protocol/<%=localProtocol.getFilename()%>"><%=localProtocol.getFilename()%></a></td>
        <td><%=localProtocol.getId()%></td>
    </tr>

    <% } %>
    <% } %>
    </tbody>
</table>
<%}%>
<%
    //close scope
} catch (Exception protocolException) {
        protocolException.printStackTrace();
}
%>