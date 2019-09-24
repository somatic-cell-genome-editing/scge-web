<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 8/15/2019
  Time: 2:53 PM
  To change this template use File | Settings | File Templates.
--%>


<div class="panel panel-default" >

    <div class="panel panel-body">
      <ul>
          <li>Add new experiment
              <div class="form-group">
              <form class="form form-inline" method="post">
              <label for="experiment-group">Select Group: </label>&nbsp;<select class="form-control" id="experiment-group">
                  <c:forEach items="${groupRoleMap}" var="g">
                      <option>${g.key}</option>
                  </c:forEach>
                  </select>
              <label for="create-experiment">Experiment Name:</label>&nbsp;<input class="form-control" type="text" name="createExperiment" id="create-experiment" placeholder="Enter new experiment name">
                  <button type="submit" class="btn btn-success">Create</button>
              </form>
              </div>
          </li>
          <li>Update existing experiment
              <div class="form-group">
                  <form class="form form-inline">

                      <label for="update-experiment">Select Experiment:</label>&nbsp;<select class="form-control"  name="updateExperiment" id="update-experiment">
                     <option>Expriment1</option>
                      <option>Expriment4</option>
                      <option>Expriment2</option>
                      <option>Expriment7</option>
                      </select>
                      <button type="submit" class="btn btn-success">Update</button>
                  </form>
              </div>

          </li>
          <li>Upload data file ..
              <div class="form-group" >
                  <form class="form form-inline">


                      <button type="submit" class="btn btn-classic">Choose file..</button> <button type="submit" class="btn btn-success">Upload</button>
                  </form>
              </div>

          </li>
      </ul>
    </div>
</div>

