<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/9/2019
  Time: 8:14 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>



    <form method="POST" action="${destination}" >

        <div class="form-group">
            <label for="name">Name</label>
            <input type="text" name="name" id="name" value="${fn:escapeXml(member.name)}" class="form-control input-xs" />
        </div>
        <!--div class="form-group">
            <label for="lastName">Last Name</label>
            <input type="text" name="lastName" id="lastName" value="$-{fn:escapeXml(familyName)}" class="form-control" />
        </div-->

        <div class="form-group">
            <label for="institution">Institution</label>
            <input type="text" name="institution" id="institution" value="${fn:escapeXml(member.institution)}" class="form-control" />
        </div>
        <div class="form-group">
            <label for="pi">Principal investigator</label>
            <input type="text" name="pi" id="pi" value="${fn:escapeXml(member.pi)}" class="form-control" />
        </div>
        <div class="form-group">
            <label for="address">Address</label>
            <textarea name="address" id="address" class="form-control">${fn:escapeXml(member.address)}</textarea>
        </div>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="text" name="email" id="email" value="${fn:escapeXml(member.email)}" class="form-control" />
        </div>
        <div class="form-group">
            <label for="phone">Phone</label>
            <input type="text" name="phone" id="phone" value="${fn:escapeXml(member.phone)}" class="form-control" />
        </div>

        <div class="row form-group">

            <div class="col-md-6"><h4>Role</h4>

                <!--div class="form-check form-check-inline">
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
                </div-->
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="checkbox" id="inlineCheckbox5" name="role" value="member" checked>
                    <label class="form-check-label" for="inlineCheckbox5" >Member</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="checkbox" id="inlineCheckbox6" name="role" value="admin" >
                    <label class="form-check-label" for="inlineCheckbox6">General Admin</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="checkbox" id="inlineCheckbox7" name="role" value="groupadmin" >
                    <label class="form-check-label" for="inlineCheckbox7">Group Admin</label>
                </div>
            </div>
        </div>
        <div class="form-group">
            <h4>Groups</h4>
           <table class="table">
               <tr><th>Group Name</th><th>Created By</th></tr>
               <tr><td>animal_reporter_wg_member</td><td>Marek</td></tr>
               <tr><td>editor_wg_admin</td><td>Jennifer</td></tr>
           </table>
        </div>
        <!--div class="form-group">
            <span>Add More Access Levels <button class="glyphicon glyphicon-plus"></button> </span>

        </div-->

        <button type="submit" class="btn btn-success">Update</button>
    </form>


