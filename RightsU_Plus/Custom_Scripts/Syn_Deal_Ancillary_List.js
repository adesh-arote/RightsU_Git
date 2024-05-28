$(document).ready(function () {

    if (recordLockingCode_G > 0)
        Call_RefreshRecordReleaseTime(recordLockingCode_G, URL_Global_Refresh_Lock);

    var page_index = 0;

    //$('#txtPageSize').numeric();
    Bind_Grid(page_index, 'N');
});
function ValidatePageSize() {
    var recordPerPage = $('#txtPageSize').val()
    if ($.trim(recordPerPage) != '') {
        var pageSize = parseInt(recordPerPage);
        if (pageSize > 0)
            return true;
    }
    $('#txtPageSize').addClass("required");
    return false;
}
function PageSize_OnChange() {
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    var IsValid = ValidatePageSize();
    if (IsValid) {
        Bind_Grid(0, 'Y');
    }
    else
        return false;
}
function pageBinding() {
    Bind_Grid(0, 'Y');
}
function OpenPopup(id) {
    $('#' + id).modal('show');
}
function Edit_Ancillary(obj, Mode) {
    debugger;
    var Acq_Deal_Ancillary_Code = $("#" + obj + "_hdnAcq_Deal_Ancillary_Code").val();
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_Edit_Ancillary,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            selected_Syn_Deal_Ancillary_Code: Acq_Deal_Ancillary_Code,
            Mode: Mode
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            
            $('#popEditRevHB').html(result);
            
            $('#lbTitle_Popup').SumoSelect();
            //if ($('#lbRights_Popup option').val() == 0) {
            //    $("#lbRights_Popup").empty();
            //}
            $('#lbTitle_Popup')[0].sumo.reload();
            //$('#lbRights_Popup')[0].sumo.reload();

            if (isCatchUpright != "Y") {
                $('#lbMedium_Popup').SumoSelect();
                if ($('#lbMedium_Popup option').val() == 0) {
                    $("#lbMedium_Popup").empty();
                }
                $('#lbMedium_Popup')[0].sumo.reload();
            }

            OpenPopup('popEditRevHB');
            hideLoading();
        },
        error: function (result) {
            alert('Error');
        }
    });
}
function ValidateDelete(obj) {
    if (!ValidatePageSize())
        return false;
    $('#hdnCurrentID').val(obj);
    $('#hdnCommandName').val('DELETE');
    showAlert('I', "Are you sure you want to delete this ancillary?", 'OKCANCEL');
}
function handleCancel() {
}
function handleOk() {
    showLoading();
    if ($('#hdnCommandName').val() != undefined && $('#hdnCommandName').val() != '' && $('#hdnCommandName').val() == "DELETE") {
        var obj = $('#hdnCurrentID').val();
        var Acq_Deal_Ancillary_Code = $("#" + obj + "_hdnAcq_Deal_Ancillary_Code").val();
        var txtpageSize = $("#txtPageSize").val();
        $.ajax({
            type: "POST",
            url: URL_Delete_Ancillary,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                Syn_Deal_Ancillary_Code: Acq_Deal_Ancillary_Code
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                if (result.Status) {
                    hideLoading();
                    Bind_Grid(0, 'N');
                    SetPaging(txtpageSize);
                    showAlert('S', 'Ancillary rights deleted successfully');
                }
            },
            error: function (result) {
                alert('Error');
            }
        });
    }
}
function Add_Ancillary(id) {
    debugger;
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_Add_Ancillary,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }

            $('#popEditRevHB').html(result);
            //$('#lbRights_Popup').empty();
            $('#lbTitle_Popup').SumoSelect();

            $('#lbTitle_Popup')[0].sumo.reload();
            //$('#lbRights_Popup')[0].sumo.reload();

            if (isCatchUpright != "Y") {
                $("#lbMedium_Popup").empty();
                $('#lbMedium_Popup').SumoSelect();
                $('#lbMedium_Popup')[0].sumo.reload();
            }
            OpenPopup('popEditRevHB');
            hideLoading();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}
function Bind_Grid(page_index, IsCallFromPaging) {
    showLoading();
    var txtpageSize = $("#txtPageSize").val();
    $.ajax({
        type: "POST",
        url: URL_Bind_Grid_List,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        data: JSON.stringify({
            txtpageSize: $("#txtPageSize").val(),
            page_index: page_index,
            IsCallFromPaging: IsCallFromPaging
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            $('#dvAcq_Ancillary_List').html(result);
            SetPaging(txtpageSize);
            initializeTooltip();
            setNumericForPagingSize();
            hideLoading();

        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}
function ValidateSave() {
    showLoading();
    var Isvalid = true;
    if (dealMode_G == 'APRV') {
        var approvalremarks = $('#approvalremarks').val();
        $.ajax({
            type: "POST",
            url: URL_Global_SetApprovalRemarks,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            async: true,
            data: JSON.stringify({
                approvalremarks: $('#approvalremarks').val()
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                Isvalid = true;
            },
            error: function (result) {
                Isvalid = false;
            }
        });

    }
    else
        Isvalid = true;

    if (Isvalid) {
        hideLoading();
        var tabName = $('#hdnTabName').val();
        BindPartialTabs(tabName);
    }
    hideLoading();
    return Isvalid;
}