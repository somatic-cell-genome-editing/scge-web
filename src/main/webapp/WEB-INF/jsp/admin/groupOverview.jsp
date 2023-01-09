<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.dao.implementation.PersonDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.GroupDAO" %>
<%@ page import="edu.mcw.scge.dao.implementation.GrantDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.StudyDao" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="java.util.HashMap" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<%
try {

    GroupDAO gdao = new GroupDAO();
    StudyDao sdao = new StudyDao();

List<SCGEGroup> groups = gdao.getAllGroups();
%>
    <table style="border:1px solid black;margin:5px; padding:5px;">

<%for (SCGEGroup g: groups) {%>
        <tr>
            <td><hr></td>
            <td><hr></td>
        </tr>
        <tr>
            <td colspan="2"><b>Group:</b> <span style="font-size:20px;"><%=g.getGroupName()%></span></td>
            <td></td>
        </tr>
        <tr><td></td><td></td></tr>
        <tr>
            <td>Studies:</td>
        </tr>
            <%
            List<Study> sList = sdao.getStudiesByGroupId(g.getGroupId());
            if (sList.size()==0) {
                out.print("<tr><td></td><td>NONE</td></tr>");
            }

            HashMap<Integer, String> submitter = new HashMap<Integer, String>();
            HashMap<Integer, String> pi = new HashMap<Integer, String>();

            for (Study s: sList) {
                submitter.put(s.getSubmitterId(),null);
                for(Person i:s.getMultiplePis())
                pi.put(i.getId(),null);
            %>

            <tr>
                <td></td>
                <td><%=s.getStudy()%></td>
            </tr>
            <%} %>
        <tr><td>People:</td></tr>
            <%
            List<Person> people = gdao.getGroupMembersByGroupId(g.getGroupId());
                if (people.size()==0) {
                    out.print("<tr><td></td><td>NONE</td></tr>");
                }
            for (Person p: people) { %>
             <tr>
                 <td></td>
                 <td>
                 <% if (submitter.containsKey(p.getId())) { %>
                     <span style="color:red;">(SUBMITTER)&nbsp;</span>
                 <% } %>
                     <% if (pi.containsKey(p.getId())) { %>
                     <span style="color:blue">(PI)&nbsp;</span>
                     <% } %>

                     <%=p.getName()%>  -- (<%=p.getInstitutionName()%>)
                 </td>


             </tr>
            <% } %>



<% }
} catch (Exception es) {
    es.printStackTrace();
}
%>
    </table>

