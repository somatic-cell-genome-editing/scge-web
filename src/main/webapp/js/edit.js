$(function() {

    $("#myTable").tablesorter({
        theme : 'blue'

    });


});
function buildModel(study, valArr , updatedTier){
    var studyDiv="#groupSelect-study"+study
    $(studyDiv).multiselect({
        buttonWidth: '100%',
        onChange: function(option, checked, select) {
            $('#SaveChangesTier2-study'+study).prop('disabled', false)
            var value= ($(option).val());
            var $div="#group"+value+"-study"+study;
            //  $($div).show(2000);
            $($div).toggle()
        },
        enableCollapsibleOptGroups: true,
        buttonContainer: '<div id="groupSelect-study'+study+ '-container" class="btn-group" />'
    });
    $('#groupSelect-study'+study+'-container .caret-container').click();

    var i = 0, size = valArr.length;
    for (i; i < size; i++) {
        $("#groupSelect-study"+study).multiselect('select', valArr[i]);
        var $div="#group"+valArr[i]+"-study"+study;
        $($div).show()
    }
    $('input:radio[name="tier'+study+'"]').filter('[value='+updatedTier+']').attr('checked', true)

    $('input[name=tier'+study+']').on('change', function () {
        var tier=$(this).val();
        setParameters(study, tier)
        enableSaveChanges(study, tier.trim());

    })
}
function changeAccess1(_this, studyId) {
     selectObj=$("#select"+studyId);
    if(selectObj.val()==='2')
        $("#tier2Modal"+studyId).modal('toggle');
    else
        $("#tierOtherModal"+studyId).modal('toggle');
}
function changeAccess(_this, studyId,tier) {
//    this.studyId=studyId;
        enableGroupSelect(studyId, tier);
        $("#tier2Modal" + studyId).modal('toggle');
}

function saveChanges(studyId) {
      //appendGroups(studyId);

    var msg = "By changing the study tier I certify that:\n\n" +
        "I verified that the files found in “Download Submitted Files” can be shared at the final tier and do not contain proprietary data.\n\n" +
        "The data and representative images are accurate\n\n" +
        "All descriptions including experiment descriptions, assay descriptions, experimental and metadata details, and figure titles and legends (where shown) are accurate and appropriate\n\n" +
        "Select OK to continue with the change or Cancel to return to the prior screen.";
    if (confirm(msg)) {

       alert("An email has been sent to the study PI and Point of Contact.  Changes to study tier will take effect in 24 hours.")
       appendGroupIds(studyId);
       var formId="#editStudy"+studyId;
       $(formId).submit();
    }

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

function enableGroupSelect(studyId, tier){
    var selectBtn='#groupSelect-study'+studyId
    if(tier===2) {
        $(selectBtn).multiselect('enable')
    }
}
function enableSaveChanges(studyId, tier){
    $('#SaveChangesTier2-study'+studyId).prop('disabled', false)
    if(tier==='2')
        $('#groupSelect-study'+studyId).multiselect('enable')
    else{
        $('#groupSelect-study'+studyId).multiselect('disable')

    }
}
function setParameters(studyId,tier){
    $('#tier-study-'+studyId).val(tier);
}
function appendGroups(studyId){
    var values=$('#groupSelect-study'+studyId).val() || [];
    // alert(values.join(","))
    var json="{\"selected\":[";
    var flag=true;
    $.each(values, function( index, value ) {
        //  alert( index + ": " + value );
        if(flag){
            flag=false;
            json=json+"{\"groupId\":\""+value+"\", \"members\":["
        }else{
            json=json+",{\"groupId\":\""+value+"\", \"members\":["
        }
        var first=true;
        var _name='member-group'+value+'-study'+studyId;
        $.each($('input[name='+_name+']:checked'), function() {
            //   console.log("GROUP-"+ value+":\t"+$(this).val());
            if(first) {
                json = json + $(this).val() ;
                first=false;
            }
            else
                json=json+","+$(this).val();

        });

        json=json+"]}"
    });
    json=json+"]}"
    $('#study-'+studyId+'-memberJson').val(json);
    console.log(json);
}
function appendGroupIds(studyId){
    var values=$('#groupSelect-study'+studyId).val() || [];
    // alert(values.join(","))
    var json="{\"selected\":[";
    var flag=true;
    $.each(values, function( index, value ) {
        //  alert( index + ": " + value );
        if(flag){
            flag=false;
            json=json+value
        }else{
            json=json+","+value
        }

    });
    json=json+"]}"
    $('#study-'+studyId+'-groupIdsJson').val(json);
    console.log(json);
}