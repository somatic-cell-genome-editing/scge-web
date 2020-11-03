$(function() {
    $("#myTable").tablesorter({
        theme : 'blue'

    });

});
function changeAccess(_this, studyId) {
    if(_this.val()==='2')
        $("#editAccessControlModal").modal('toggle');
    else
        $("#accessControlModal").modal('toggle');

    $("#saveChanges").on("click", function () {
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