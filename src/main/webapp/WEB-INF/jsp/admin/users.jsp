<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.dao.implementation.PersonDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.GroupDAO" %>
<%@ page import="edu.mcw.scge.datamodel.PersonInfo" %>
<%@ page import="edu.mcw.scge.datamodel.SCGEGroup" %>
<%@ page import="edu.mcw.scge.datamodel.Institution" %>
<%@ page import="edu.mcw.scge.dao.InstitutionDAO" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="java.security.acl.Group" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>







<% try { %>

<% GroupDAO gdao = new GroupDAO();
    PersonDao pdao = new PersonDao();
    List<Person> people = (List<Person>)request.getAttribute("people");
    Person person = (Person) request.getAttribute("person");
    InstitutionDAO idao = new InstitutionDAO();
    List<Institution> iList = idao.getAll();

    try {

        if (request.getParameter("a").equals("b")) {
            GroupDAO grdao = new GroupDAO();
            for (Person pers : pdao.getAllActiveMembers()) {
                pdao.insertPersonInfo(pers.getId(), 1, 1411);
            }
        }
    }catch(Exception e) {
        e.printStackTrace();
        }
%>

<%
    String msg = (String) request.getAttribute("msg");
    if (msg !=null) {
%>
        <div style="font-size:20px;color:blue;"><%=msg%></div>
<% } %>

<br>
<form action="/toolkit/admin/addUser">
    <table border="0" class="table tablesorter table-striped">
        <tr>
            <td></td>
            <td>Name</td>
            <td>Institution</td>
            <td>Google Account Email</td>
            <td>Other Email</td>
            <td></td>

        <%
        try {
        %>
                        <tr>
            <td>Add User:&nbsp;</td>
            <td><input name="name" type="text" /></td>
            <td>
                <select name="institution">
                <% for (Institution i:iList) { %>
                        <option value="<%=i.getId()%>"><%=i.getName()%></option>
                <% } %>

                </select>
            </td>
            <% }catch (Exception e) {
            e.printStackTrace();
            }
            %>


            <td><input name="gEmail" type="text" /></td>
            <td><input name="oEmail" type="text" /></td>
            <td><input type="submit" value="Add User"/></td>
        </tr>
    </table>
</form>

<style>
    .adminInput {
        color:black;
    }

    table {
        border: 1px solid #ddd;
        width: 100%;
    }

    td {
        color:black;
        text-align: right;
    }

    input {
        color:black;
    }

</style>
<br>
<script>
    $(function() {
        $("#users").tablesorter({
            theme : 'blue'

        });
    });
</script>

<table id="users" border="1" cellpadding="4" cellspacing="4" class="table tablesorter table-striped">
    <tr>
        <td>ID</td>
        <td>Name/Institution</td>
        <td>Email Accounts</td>
        <td>Account Status</td>
        <td>Action</td>
        <td style="font-size:8px;"></td>


    </tr>
    <% for (Person p: people) {
    %>
        <tr>
            <form action="#">
            <input type="hidden" value="<%=p.getId()%>" name="id" />
            <td><%=p.getId()%></td>
            <td align="left"><input name="name" type="text" value="<%=p.getName()%>" width="150" class="adminInput" style="margin-bottom:10px;"/>


                    <select name="institution">
                        <% for (Institution i:iList) { %>
                        <option value="<%=i.getId()%>" <% if (i.getId() == p.getInstitution()) out.print("selected");%>><%=i.getName()%></option>
                        <% } %>
                    </select>
            </td>

            <!--<td><input name="institutionName" type="text" value="<%=p.getInstitution()%>"  width="150" class="adminInput"/></td>-->
            <td>
                <input name="gEmail" type="text" value="<%=p.getEmail()%>" width="150" class="adminInput"/>
                <input name="oEmail" type="text" value="<%=SFN.parse(p.getOtherId())%>" width="150" class="adminInput" style="margin-top:10px;"/>
            </td>
            <td><select name="status">

                <% if (p.getStatus().equals("ACTIVE")) { %>
                <option value="ACTIVE" selected>ACTIVE</option>
                <% } else { %>
                <option value="ACTIVE">ACTIVE</option>
                <% } %>
                <% if (p.getStatus().equals("INACTIVE")) { %>
                <option value="INACTIVE" selected>INACTIVE</option>
                <% } else { %>
                <option value="INACTIVE">INACTIVE</option>
                <% } %>

            </select>
            </td>
            <td align="left">
                <input style="width:100px;" type="button" value="Update User" onclick="this.form.action='/toolkit/admin/updateUser'; this.form.submit();" /><br>
                <input type="button" value="Delete User" onclick="if (confirm('Permanently Delete User?')) {this.form.action='/toolkit/admin/removeUser'; this.form.submit();}" style="margin-top:10px;"/><br>
                <input type="button" value="Manage Groups" onclick="this.form.action='/toolkit/admin/groups'; this.form.submit();" style="margin-top:10px;"/>
            </td>
            </form>
            <td width="300">

                <% List<PersonInfo> piList = pdao.getPersonInfo(p.getId()); %>

                <% if (piList != null) { %>
                    <table border="1" cellspacing="0">
                    <% for (PersonInfo pi: piList) { %>
                        <tr><td><span style="padding: 0;font-size:14px" class="text-muted"><%=pi.getGroupName()%></span></td></tr>

                    <% } %>
                    </table>
                <% } %>



            </td>



     </tr>
    <% } %>


</table>


<% } catch (Exception e) {
    System.out.println(e.getStackTrace());
}
%>






