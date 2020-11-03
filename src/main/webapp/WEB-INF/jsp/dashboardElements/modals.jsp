<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 10/30/2020
  Time: 4:32 PM
  To change this template use File | Settings | File Templates.
--%>
<div class="container">
    <!-- Button to Open the Modal -->
    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myGroupModal">
        My Group
    </button>
    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myWorkingGroupModal">
        My Working Groups
    </button>
    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myConsortiumModal">
        Consortium Groups
    </button>
    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myPOCModal">
        Point of contact
    </button>
    <!-- The Modal -->
    <div class="modal" id="myGroupModal">
        <div class="modal-dialog">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">My Group</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                    <%@include file="myGroupAssociations.jsp"%>
                </div>

                <!-- Modal footer -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-primart" data-dismiss="modal">Close</button>
                </div>

            </div>
        </div>
    </div>
    <div class="modal" id="myWorkingGroupModal">
        <div class="modal-dialog">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">Working Groups</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                    <%@include file="workingGroups.jsp"%>
                </div>

                <!-- Modal footer -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-primart" data-dismiss="modal">Close</button>
                </div>

            </div>
        </div>
    </div>
    <div class="modal" id="myConsortiumModal">
        <div class="modal-dialog">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">Consortium Groups</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                    <%@include file="consortiumGroups.jsp"%>
                </div>

                <!-- Modal footer -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-primart" data-dismiss="modal">Close</button>
                </div>

            </div>
        </div>
    </div>
    <div class="modal" id="myPOCModal">
        <div class="modal-dialog">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">Modal Heading</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                    <%@include file="myGroupAssociations.jsp"%>
                </div>

                <!-- Modal footer -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-primart" data-dismiss="modal">Close</button>
                </div>

            </div>
        </div>
    </div>

</div>