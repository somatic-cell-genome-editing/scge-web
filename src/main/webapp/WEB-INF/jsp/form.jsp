<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 8/23/2019
  Time: 10:09 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<div class="container">
    <h3>
        Please fill the below  <c:out value="${action}" />..
    </h3>

    <form method="POST" action="${destination}" >

        <div class="form-group">
            <label for="name">Name</label>
            <input type="text" name="name" id="name" value="${fn:escapeXml(userName)}" class="form-control" />
        </div>
        <!--div class="form-group">
            <label for="lastName">Last Name</label>
            <input type="text" name="lastName" id="lastName" value="$-{fn:escapeXml(familyName)}" class="form-control" />
        </div-->

        <div class="form-group">
            <label for="institution">Institution</label>
            <input type="text" name="institution" id="institution" value="${fn:escapeXml(institution)}" class="form-control" />
        </div>
        <!--div class="form-group">
            <label for="address">Address</label>
            <textarea name="address" id="address" class="form-control"></textarea>
        </div-->
        <div class="form-group">
            <label for="email">Email</label>
            <input type="text" name="email" id="email" value="${fn:escapeXml(userEmail)}" class="form-control" />
        </div>
        <div class="form-group">
            <label for="phone">Phone</label>
            <input type="text" name="phone" id="phone" value="${fn:escapeXml(phone)}" class="form-control" />
        </div>

        <!--div class="row form-group">

              <div class="col-md-6"><h4>Role</h4>

                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="checkbox" id="inlineCheckbox1" value="pi">
                    <label class="form-check-label" for="inlineCheckbox1">Principal Investigator</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="checkbox" id="inlineCheckbox2" name="role" value="coChair">
                    <label class="form-check-label" for="inlineCheckbox2">Co-Chair</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="checkbox" id="inlineCheckbox3" name="role" value="contact">
                    <label class="form-check-label" for="inlineCheckbox3">Contact</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="checkbox" id="inlineCheckbox4" name="role" value="votingMember">
                    <label class="form-check-label" for="inlineCheckbox4">Voting Member</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="checkbox" id="inlineCheckbox5" name="role" value="member" >
                    <label class="form-check-label" for="inlineCheckbox5">Member</label>
                </div>

            </div>
        </div-->
        <div class="form-group">
            <label for="work-email">Organization email</label>
            <input type="text" name="workEmail" id="work-email" value="" class="form-control" />
        </div>
        <!--div class="form-group">
            <span>Add More Groups <button class="glyphicon glyphicon-plus"></button> </span>

        </div-->

        <button type="submit" class="btn btn-success">Submit</button>
    </form>
</div>
