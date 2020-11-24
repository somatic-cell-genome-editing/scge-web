$(function() {
    $("#myTable").tablesorter({
        theme : 'blue'

    });
  /*  $('#groupSelect').change(function(){
        var value= ($(this).val());
        var $div="#group"+value;
       // alert($div);
        $($div).show(2000);
    });*/
});
function changeAccess(_this, studyId) {
     selectObj=$("#select"+studyId);
  //  if(_this.val()==='2')
    if(selectObj.val()==='2')
        $("#tier2Modal"+studyId).modal('toggle');
    else
        $("#tierOtherModal"+studyId).modal('toggle');



}

function saveChanges(_this, studyId) {
       var formId="#editStudy"+studyId;
       $(formId).submit();
}
function showMembers(_this, studyId){
    var value= (_this.val());
    alert("VALUE: "+ value);
    var $div="#group"+value+"-study"+studyId;
    // alert($div);
    $($div).show(2000);
}
function toggleDiv(recId){
    var $div="#collapse"+recId;
    $($div).toggle();
}