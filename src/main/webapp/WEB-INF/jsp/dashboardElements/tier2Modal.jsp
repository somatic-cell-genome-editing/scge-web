<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 11/13/2020
  Time: 2:06 PM
  To change this template use File | Settings | File Templates.
--%>
<div class="modal" id="tier2Modal${rec.studyId}">
    <div class="modal-dialog">
        <div class="modal-content">

            <!-- Modal Header -->
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>

            <!-- Modal body -->
            <div class="modal-body">
                <%@include file="../edit/access.jsp"%>
            </div>

            <!-- Modal footer -->

            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id= "SaveChangesTier2">Save changes</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>

        </div>
    </div>
</div>
