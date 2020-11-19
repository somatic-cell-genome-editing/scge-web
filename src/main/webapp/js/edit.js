$(function() {
    $("#myTable").tablesorter({
        theme : 'blue'

    });
    $('#groupSelect').change(function(){
        var value= ($(this).val());
        var $div="#group"+value;
       // alert($div);
        $($div).show(2000);
    });
});
function changeAccess(_this, studyId) {
    if(_this.val()==='2')
        $("#tier2Modal"+studyId).modal('toggle');
    else
        $("#tierOtherModal"+studyId).modal('toggle');

    $("#saveChanges").on("click", function () {
        saveChanges(_this,studyId)
    })
    $("#saveChangesTier2").on("click", function () {
        saveChanges(_this,studyId)
    })
  /*  var selectedVal=_this.val();
    var formId="#editStudy"+studyId;
    $(formId).submit();*/

}
function saveChanges(_this, studyId) {
      var selectedVal=_this.val();
       var formId="#editStudy"+studyId;
       $(formId).submit();
}
