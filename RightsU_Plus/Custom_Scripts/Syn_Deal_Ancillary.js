function Validate_Save_Ancillary() {
    debugger;
    var IsValid = true;
    if ($("#lbTitle_Popup").val() == null) {
        $("#divlbTitle_Popup").addClass("required");
        IsValid = false;
    }
    else {
        $("#divlbTitle_Popup").removeClass("required");
    }
    if ($("#ddlAncillary_Type").val() == "0") {
        $("#ddlAncillary_Type").addClass('required');
        IsValid = false;
    }
    else
        $("#ddlAncillary_Type").removeClass('required');



    //if ($("#lbRights_Popup").val() == null) {
    //    $("#divlbRights_Popup").addClass("required");
    //    IsValid = false;
    //}
    //else {
    //    $("#divlbRights_Popup").removeClass("required");
    //}
    if (isCatchUpright != "Y") {
        if (($("#lbMedium_Popup").val() == null && $("#lbMedium_Popup option").length > 1)) {
            $("#divlbMedium_Popup").addClass("required");
            IsValid = false;
        }
        else
            $("#divlbMedium_Popup").removeClass('required');

        $('#hdnMedium').val($("select#lbMedium_Popup").val() == null ? '' : $("select#lbMedium_Popup").val().join(","));
    }
    else
        $('#hdnMedium').val('');

    $('#hdnTitles').val($("select#lbTitle_Popup").val().join(","));
    if ($("select#lbRights_Popup").val() != null) {
        $('#hdnAncillaryRightCode').val($("select#lbRights_Popup").val().join(","));
    }
    return IsValid;
}


function Validate_Save_Ancillary_Adv() {
    debugger;
    var IsValid = true;
    if ($("#lbTitle_Popup").val() == null) {
        $("#divlbTitle_Popup").addClass("required");
        IsValid = false;
    }
    else {
        //$("#divlbTitle_Popup").removeClass("required");

        //if ($("#hdnTVCodes").val() == null || $("#hdnTVCodes").val() == "0" || $("#hdnTVCodes").val() == "") {
        //    $("#divlbTree_Popup").addClass("required");
        //    IsValid = false;
        //}
        //else
        {
            $("#divlbTree_Popup").removeClass("required");
        }
    }
    if ($("#ddlAncillary_Type").val() == "0") {
        $("#ddlAncillary_Type").addClass('required');
        IsValid = false;
    }
    else
        $("#ddlAncillary_Type").removeClass('required');

    if (isCatchUpright != "Y") {
        if (($("#lbMedium_Popup").val() == null && $("#lbMedium_Popup option").length > 1)) {
            $("#divlbMedium_Popup").addClass("required");
            IsValid = false;
        }
        else
            $("#divlbMedium_Popup").removeClass('required');

        $('#hdnMedium').val($("select#lbMedium_Popup").val() == null ? '' : $("select#lbMedium_Popup").val().join(","));
    }
    else
        $('#hdnMedium').val('');

    $('#hdnTitles').val($("select#lbTitle_Popup").val().join(","));
    if ($("select#lbRights_Popup").val() != null) {
        $('#hdnAncillaryRightCode').val($("select#lbRights_Popup").val().join(","));
    }
    return IsValid;
}


$(document).ready(function () {
    $('.modal').modal({
        backdrop: 'static',
        keyboard: false,
        show: false
    })
    initializeChosen();
    $('#txtDay').numeric();
    $('#txtDuration').numeric();
    if (recordMode_G == "EDIT") {
        if (acqDealAncillaryCode_G > 0) {
            var txtRemark = document.getElementById('txtRemarks');
            countChar(txtRemark);
        }
    }
    $('#Ancillary_Mode').val(recordMode_G);

    $("#ddlAncillary_Type").change(function () {
        var Selected_AncillaryTypeCode = $('#ddlAncillary_Type').val();
        $.ajax({
            type: "POST",
            url: URL_BindAncillary_Right,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                selected_Ancillary_Type_Code: Selected_AncillaryTypeCode
            }),
            success: function (result) {
                if (isCatchUpright != "Y") {
                    $("#lbMedium_Popup").empty();
                    $('#lbMedium_Popup').SumoSelect();
                    $('#lbMedium_Popup')[0].sumo.reload();
                }
                $("#lbRights_Popup").empty();
                $.each(result, function () {
                    $("#lbRights_Popup").append($("<option />").val(this.Value).text(this.Text));
                });
                $('#lbRights_Popup').SumoSelect();
                $('#lbRights_Popup')[0].sumo.reload();
            },

            error: function (result) {
                alert('E' + result.responseText);
            }
        });
    });
    if (isCatchUpright != "Y") {
        $("#lbRights_Popup").change(function () {
            var Selected_Ancillary_Right_Code = "";
            $("#lbRights_Popup option:selected").each(function () {
                Selected_Ancillary_Right_Code += $(this).val() + ",";
            });
            $.ajax({
                type: "POST",
                url: URL_BindAncillary_Medium,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    Selected_Ancillary_Right_Code: Selected_Ancillary_Right_Code.trim()
                }),
                success: function (result) {
                    if (result == "true") {
                        redirectToLogin();
                    }
                    $("#lbMedium_Popup").empty();
                    $.each(result, function () {
                        $("#lbMedium_Popup").append($("<option />").val(this.Value).text(this.Text));
                    });
                    $('#lbMedium_Popup').SumoSelect();
                    $('#lbMedium_Popup')[0].sumo.reload();
                },
                error: function (result) {
                    alert('Error: ' + result.responseText);
                }
            });
        });
    }
});

function Save_OnSuccess(result) {
    if (result == "true") {
        redirectToLogin();
    }
    hideLoading();
    if (result.Status == "U" || result.Status == "A") {
        $('#popEditRevHB').modal('hide');
        var msg = result.Status == "A" ? "Ancillary rights added successfully" : "Ancillary rights updated successfully";
        showAlert("S", msg);
        var page_Index = $('#hdnpage_index').val();
        Bind_Grid(page_Index, 'N');
    }
    if (result.Status == 'D') {
        showAlert('E', 'Combination conflicts with other ancillary rights');
        IsValid = false;
    }
}
function OnBegin() {
    showLoading();
}