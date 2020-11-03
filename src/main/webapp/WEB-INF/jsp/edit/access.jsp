<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 11/2/2020
  Time: 8:03 AM
  To change this template use File | Settings | File Templates.
--%>
<div class="wrapper" align="center">
<div class="card"  style=" border:1px solid gainsboro;padding:0" align="left">
    <div class="card-header text-white" style="background-color: #00AA9E;text-align: center;font-weight: bold">
        Change Access Teir
    </div>
    <div class="card-body">
    <form>
        Selected Experiment: <input type="text" value="My Experiment" disabled/>
    <div class="row">
        <div class="col">
            <label>
                Lab:
                <input type="text" class="form-control" placeholder="Dwinell's Lab">
            </label>
        </div>
        <div class="col">
            <label>
                Principal Investigator:
                <input type="text" class="form-control" placeholder="Mindy Dwinell">
            </label>
        </div>
    </div>

    Access Tier: <div class="form-check form-check-inline">
    <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio1" value="option1" disabled>
    <label class="form-check-label" for="inlineRadio1">1</label>
</div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio2" value="option2" checked>
        <label class="form-check-label" for="inlineRadio2">2</label>
    </div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio3" value="option3" disabled>
        <label class="form-check-label" for="inlineRadio3">3 </label>
    </div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio4" value="option3" disabled>
        <label class="form-check-label" for="inlineRadio3">4 </label>
    </div>
        <div class="form-group">
            <label for="inputState">Select Group</label>
            <select id="inputState" class="form-control">
                <option selected>Choose...</option>
                <option>Group1</option>
                <option>Group2</option>
                <option>Group3</option>
                <option>Group4</option>
            </select>
        </div>
       <div class="form-group">
        Select Members:<div class="form-check form-check-inline">
           <input class="form-check-input" type="checkbox" id="inlineCheckbox7" value="option7" checked>
           <label class="form-check-label" for="inlineCheckbox1" >All</label>
       </div><br>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="checkbox" id="inlineCheckbox1" value="option1">
            <label class="form-check-label" for="inlineCheckbox1">Member1</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="checkbox" id="inlineCheckbox2" value="option2">
            <label class="form-check-label" for="inlineCheckbox2">Member2</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="checkbox" id="inlineCheckbox3" value="option3" >
            <label class="form-check-label" for="inlineCheckbox3">Member3</label>
        </div>
       </div>
        <div class="form-group">

            <div class="form-check form-check-inline">
                <input class="form-check-input" type="checkbox" id="inlineCheckbox4" value="option1">
                <label class="form-check-label" for="inlineCheckbox1">Member4</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="checkbox" id="inlineCheckbox5" value="option2">
                <label class="form-check-label" for="inlineCheckbox2">Member5</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="checkbox" id="inlineCheckbox6" value="option3" >
                <label class="form-check-label" for="inlineCheckbox3">Member6</label>
            </div>
        </div>
        <!--div class="form-group">
        <button>Submit</button>
        </div-->
    </form>
    </div>
</div>
</div>