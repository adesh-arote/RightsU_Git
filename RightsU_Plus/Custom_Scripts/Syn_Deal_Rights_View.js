var TabType = 'HB'

$(document).ready(function () {
    setChosenWidth('#ROFR_Code', '40%');
    $("#lblCountry").text(ShowMessage.Country);
    if (Record_Locking_Code_SRV_G > 0) {
        var fullUrl = Refresh_Lock_SRV_URL
        Call_RefreshRecordReleaseTime(Record_Locking_Code_SRV_G, fullUrl);
    }
    if (MODE_SR_G == "V") {
        SetRightPeriod(Right_Type_G)
        if (Is_Theatrical_Right_G == "Y") {
            $('#lblTheatrical').show();
            $("#lblCountry").text(ShowMessage.Circuit);
            $('#tree').hide();
        }
        else
            BindPlatform();
        if (Disable_RightType_G == "Y") {
            if (Existing_RightType_G == Milestone) {
                //DISABLE PERP
                $('#tabValidity a[href="#tabCal"]').prop("disabled", true);
                //DISABLE YEARBASE
                $('#tabValidity a[href="#tabPerp"]').prop("disabled", true);
                $('#tabValidity a[href="#tabCal"]').prop("title", ShowMessage.Cannotselectrighttypeyearbasedasrightsalreadysyndicated);
                $('#tabValidity a[href="#tabPerp"]').prop("title", ShowMessage.Cannotselectrighttypeperpetuityasrightsalreadysyndicated);
            }
            else {
                //$('#someTab').tab('show')
                $('#tabValidity a[href="#tabMile"]').prop("disabled", true);
                //DISABLE MILESTONE
                $('#tabValidity a[href="#tabPerp"]').prop("title", ShowMessage.Cannotselectrighttypemilestoneasrightsalreadysyndicated);

            }
        }
    }
    //END
    if (ShowPopup_G == "ERROR") {
        Show_Validation_Popup("", 5, 0);
    }
    else if (Message_SR_G != "") {
        showAlert('S', Message_SR_G, 'OK');
    }
    initializeTooltip();
    Bind_Holdback();
    Bind_BlackOut();
    var dealmode = Obj_Mode_SR_G;

    if (Record_Locking_Code_SRV_G > 0) {
        var fullUrl = Refresh_Lock_SRV_URL
        Call_RefreshRecordReleaseTime(Record_Locking_Code_SRV_G, fullUrl);
    }
});

function OnTabChange(obj) {
    if (obj == 'HB')
        TabType = 'HB';
    else
        if (obj == "BO")
            TabType = 'BO';
        else if (obj == "PR") {
            TabType = 'PR';
            Bind_Promoter();
        }
        else
            TabType = 'RR';
}

function Bind_Holdback() {
    showLoading();
    $.ajax({
        type: "POST",
        url: BindHoldback_URL,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            $('#tabHoldback').html(result);
            if ($('#trAddEdit') != null && $('#trAddEdit') != undefined)
                $('#trAddEdit').hide();
            initializeExpander();
            initializeTooltip();
            hideLoading();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}

function Bind_BlackOut() {
    $.ajax({
        type: "POST",
        url: BindBlackOut_URL,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            $('#tabBlackout').html(result);
            if ($('#trAddEditBO') != null && $('#trAddEditBO') != undefined)
                $('#trAddEditBO').hide();
            hideLoading();
            initializeTooltip();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}
function Bind_Promoter() {
    $("#hdnEditRecord").val('');
    $.ajax({
        type: "POST",
        url: URL_BindPromoter,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            $('#tabPromoter').html(result);
            initializeTooltip();
            hideLoading();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}
function BindPlatform() {
    $.ajax({
        type: "POST",
        url: BindPlatformTreeView_URL,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            strPlatform: $("#hdnTVCodes").val(),
            strTitles: SelectedTitleCodes_G
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            $('#tree').html(result);
        },
        error: function (result) {
        }
    });
}

function handleOk() {
    if (MessageFrom_SR_G == 'SV') {
        window.location.href = Index_SRL_URL;
    }
    if ($('#hdnCommandName').val() != undefined && $('#hdnCommandName').val() != '' && $('#hdnCommandName').val() == "CANCEL") {
        showLoading();
        BindPartialTabs(pageRights_List);
    }
}

function SetRightPeriod(rightType) {
    if (rightType == YearBased && $('#tabValidity a[href="#tabCal"]').prop("disabled")) {
        return false;
    }
    else if (rightType == Perpetuity && $('#tabValidity a[href="#tabPerp"]').prop("disabled")) {
        return false;
    }
    else if (rightType == Milestone && $('#tabValidity a[href="#tabMile"]').prop("disabled")) {
        return false;
    }

    $('#Right_Type').val(rightType)

    if (rightType != YearBased) {
        $('#ROFR_DT').prop("disabled", true);
        $('#ROFR_Days').prop("disabled", true);
        $('#ROFR_DT').val('');
        $('#ROFR_Days').val('');

        if (rightType == Perpetuity)
            $('#ROFR_Code').prop("disabled", true);
        else
            $('#ROFR_Code').prop("disabled", false);
    }
    else {
        $('#ROFR_DT').prop("disabled", false);
        $('#ROFR_Days').prop("disabled", false);
        $('#ROFR_Code').prop("disabled", false);
    }
    $('#ROFR_Code').trigger('chosen:updated');
}

function ClearHidden() {
    $("#hdnTabName").val('');
}

function ValidateSave() {
    showLoading();
    var Isvalid = true;
    // Code for Maintaining approval remarks in session
    if (SaveApprovalRemarks())
        Isvalid = true;
    else
        Isvalid = false;
    //Code end for approval
    if (Isvalid && (dealMode_View == dealMode_View)) {
        hideLoading();
        var tabName = $('#hdnTabName').val();
        BindPartialTabs(tabName);
    }

    hideLoading();
    return Isvalid;
}

function SaveApprovalRemarks() {
    var Isvalid = true;
    var Mode = Obj_Mode_SR_G;
    if (Mode == 'APRV') {
        var approvalremarks = $('#approvalremarks').val();
        $.ajax({
            type: "POST",
            url: SetSynApprovalRemarks_URL,
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
                hideLoading();
            },
            error: function (result) {
                Isvalid = false;
            }
        });

    }
    else
        Isvalid = true;

    return Isvalid;
}
