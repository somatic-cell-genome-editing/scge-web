$(function() {

    $("#myTable").tablesorter({
        theme : 'blue'

    });


});
var studyId;
function changeAccess1(_this, studyId) {
     selectObj=$("#select"+studyId);
    if(selectObj.val()==='2')
        $("#tier2Modal"+studyId).modal('toggle');
    else
        $("#tierOtherModal"+studyId).modal('toggle');
}
function changeAccess(_this, studyId,tier) {
    this.studyId=studyId;
    enableGroupSelect(studyId, tier);
    $("#tier2Modal" + studyId).modal('toggle');
}

function saveChanges(studyId) {
      //appendGroups(studyId);
    appendGroupIds(studyId);
       var formId="#editStudy"+studyId;
       $(formId).submit();
}
function showMembers(_this, studyId){
    var value= (_this.val());
    var $div="#group"+value+"-study"+studyId;
    // alert($div);
    $($div).show(2000);
}
function toggleDiv(recId){
    var $div="#collapse"+recId;
    $($div).toggle();
}
function toggleSelectedGroupMembers(groupId,studyId){
    var _name='member-group'+groupId+'-study'+studyId;
    var checkBoxes= $('input[name='+_name+']');
    checkBoxes.prop("checked", !checkBoxes.prop("checked"));
}