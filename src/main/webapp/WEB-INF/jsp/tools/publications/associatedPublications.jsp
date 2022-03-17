



<script>
    $(function() {
        $("#myTable-1").tablesorter({
            theme : 'blue'

        });
    });

    function addProtocol() {
        alert("adding protocol");
    }

</script>

<hr>
<table width="95%">
    <tr><td><h4 class="page-header" style="color:grey;">Associated Publications</h4></td>

    <td align="right"><a href="/toolkit/data/publications/associate?objectId=<%=objectId%>&redirectURL=<%=redirectURL%>" style="color:white;background-color:#007BFF; padding:10px;">Associate Publications</a></td>

</tr>
</table>
<c:choose>
    <c:when test="${fn:length(publications)>0}">
        <table>
            <thead>
            <tr>
                <th>Title</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${publications}" var="pub">
                <tr>
                    <td>${pub.reference.title}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

    </c:when>
    <c:otherwise>
        &nbsp;&nbsp;None Associated

    </c:otherwise>
</c:choose>
<hr>
<%@include file="relatedPublications.jsp"%>


&nbsp;&nbsp;

