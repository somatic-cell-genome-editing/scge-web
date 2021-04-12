<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 4/9/2021
  Time: 11:03 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    #updates td{
        background-color: #f0f9ff;
    }
</style>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>
<h4 style="color: green">${message}</h4>
<table id="myTable" class="tablesorter">
    <thead>
    <tr>

        <td>studyId</td>
        <td>Updates</td>
        <td>action</td>
    </tr>
    </thead>
    <tbody>

        <c:forEach items="${tierUpdates}" var="u">
            <tr>
                <td><a href="/toolkit/data/experiments/study/${u.key}">${u.key}</a></td>
                <td>
                    <table id="updates">
                        <thead >
                        <tr>
                            <td>studyTierUpdateId</td>
                            <td>associatedGroupId</td>
                            <td>tier</td>
                            <td>modifiedDate</td>
                            <td>modifiedTime</td>
                            <td>modifiedBy</td>
                            <td>status</td>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${u.value}" var="record">
                            <tr>
                                <td>${record.studyTierUpdateId}</td>
                                <td>${record.associatedGroupId}</td>
                                <td>${record.tier}</td>
                                <td>${record.modifiedDate}</td>
                                <td>${record.modifiedTime}</td>
                                <td>${record.modifiedBy}</td>
                                <td>${record.status}</td>

                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </td>
                <td>
                    <div class="btn-group">

                        <form action="commitUpdates">
                            <input type="hidden" name="studyId" value="${u.key}"/>
                            <button type="submit" class="btn btn-outline-secondary btn-sm">Commit</button>
                        </form>
                        <form action="revertUpdates?studyId=${u.key}">
                            <input type="hidden" name="studyId" value="${u.key}"/>
                            <button type="submit" class="btn btn-outline-secondary btn-sm">Revert</button>
                        </form>

                    </div>
                </td>
            </tr>

        </c:forEach>


    </tbody>
</table>
