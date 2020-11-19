<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 10/30/2020
  Time: 1:29 PM
  To change this template use File | Settings | File Templates.
--%>

<div class="card">
    <table>
        <tr><th>Consortium Groups</th></tr>
        <c:forEach items="${groupsMap}" var="m">
        <tr><td>
            <button type="button" class="btn btn-secondary-outline btn-sm" style="padding:0;text-align: left"
                    data-toggle="modal" data-target="#modal${m.key.groupId}"><span style="color:steelblue">${m.key.groupName}</span>
            </button>

            <!--a href="members?group=$-{m.key}">$-{m.key}</a-->
            <div  class="modal" id="modal${m.key.groupId}" style="display: none">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title"> ${m.key.groupName}</h4>
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body">
                <ul>
                    <c:forEach items="${m.value}" var="sg">
                        <li><span style="color:#24609c;font-weight:bold ">${sg.groupName}</span>

                            <ul>
                                <c:forEach items="${sg.members}" var="mem">
                                    <li>${mem.name}</li>
                                </c:forEach>
                            </ul>
                        </li>

                    </c:forEach>
                </ul>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primart" data-dismiss="modal">Close</button>
                        </div>
            </div>
                </div>
            </div>
        </td></tr>
        </c:forEach>
    </table>

</div>




