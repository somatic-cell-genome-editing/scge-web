<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 8/15/2019
  Time: 2:53 PM
  To change this template use File | Settings | File Templates.
--%>
<div class="container" align="center">
    <div class="card" style="width: 65%;text-align: left">
        <div class="card-header">Upload Docs</div>
       <div class="card-body">
        <%@include file="uploadForm.jsp"%>

    <form>
        <div class="form-group">
            <label for="selectStudy">Select Study</label>
            <select class="form-control" id="selectStudy" >
               <c:forEach items="${studies}" var="study">
                <option value="${study.studyId}">${study.study}</option>
               </c:forEach>
            </select>
        </div>
            <div class="form-group form-inline">
                <div class="form-group mb-2">
                    <label for="pi" class="sr-only">PI</label>
                    <input type="text" disabled class="form-control" id="pi" value="Melinda Dwinell">
                </div>
                <div class="form-group mx-sm-3 mb-2">
                    <label for="lab" class="sr-only">Lab</label>
                    <input type="text" disabled class="form-control" id="lab" placeholder="DCC">
                </div>
                <button type="submit" class="btn btn-primary mb-2">View All Uploaded docs</button>
            </div>
        <div class="form-group">
            <label for="selectExperiment">Select one or more experiments</label>
            <select multiple class="form-control" id="selectExperiment">
                <option selected>None</option>

            </select>
        </div>
        <div class="form-group">
            <label for="selectField">Select Field</label>
            <select class="form-control" id="selectField">
                <option selected>None</option>
                <option>Delivery</option>
                <option>Guide</option>
                <option>Editor</option>
                <option>Vector</option>
                <option>Model</option>
                <option>Application</option>
            </select>
        </div>
        <div class="form-group">
            <label for="imageDescription">Image Description</label>
            <textarea class="form-control" id="imageDescription" rows="3"></textarea>
        </div>
        <button type="submit" class="btn btn-primary mb-2">Submit</button>

    </form>
       </div>
    </div>
<!--form>
    Select Study:
    <Select type="" id="study">
        <option value="0">Select Study</option>
        <option value="1000">Change Sequence Reads</option>
        <option value="1001">Cre Control</option>
        <option value="1002">TLR2 Characterization</option>
    </Select>
    <label>
        Principal Investigator:
        <input type="text" value="Mindy Dwinel" disabled name="pi">
    </label>
    <label>
        Institution/Lab:
        <input name="initiative" type="text" value="DCC" disabled/>
    </label-->



    <!--button type="submit">Next</button-->
<!--/form-->

</div>
<!--div class="container">
    <%--@include file="uploadForm.jsp"--%>
</div-->
<script>
    $(function () {
        $('#selectStudy').on('change', function () {
            alert("VALUE:"+this.value);
            
        })
    })
    function populateStudyFields(pi, labName) {
        $('#pi').value=pi;
        $('#lab').value=labName;
    }
</script>