var validateSaveCalledManually = false;
$(document).ready(function () {
    showLoading();
    if (URL_Refresh_Lock > 0) {
        var fullUrl = URL_Refresh_Lock
        Call_RefreshRecordReleaseTime(URL_Refresh_Lock, fullUrl);
    }
    var meesage = Message_G
    if (meesage != '') {
        showAlert('S', meesage);
        $.ajax({
            type: "POST",
            url: URL_ResetMessageSession,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            async: false,
            data: JSON.stringify({}),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }

    var runTitles = Run_Titles_G.split(',');
    $("select#Title_Code").val(runTitles)[0].sumo.reload();
});

$(function () {
    $('#txtPageSize').numeric({
        max: 100
    });
    $('#txtPageSize').val(Run_PageSize_G);
    LoadGrid(Run_PageNo_G);
    //if ($('#Pagination'))
    // SetPaging();
    var dealmode = Mode_G;
});
function searchClick() {
    if ($('#txtPageSize').val() != "") {
        if ($("select#Title_Code").val() === null)
            showAlert('E', ShowMessage.Selecttitletosearch);
        else
            LoadGrid(0);
    }
}

function showAllClick() {
    if ($('#txtPageSize').val() != "") {
        $("select#Title_Code").val('')[0].sumo.reload();
        LoadGrid(0);
    }
}

function ValidateAdd() {
    debugger;
    if ($('#txtPageSize').val() != "") {
        var IsRightsAdded = IsRightsAdded_G
        if (IsRightsAdded == 'N') {
            validateSaveCalledManually = false;
            showAlert("E", ShowMessage.MSGPleaseAddRight);
            hideLoading();
            return false;
        }
        else
            if (!ValidateSave()) {
                return false;
            }
            else {
                return true;
            }
    }
    else {
        return false;
    }
}

function ValidateDelete(NoOfRunsScheduled, Syn_Deal_Run_Code) {
    if ($('#txtPageSize').val() != "") {
        $('#Syn_Deal_Run_Code').val(Syn_Deal_Run_Code);
        showAlert('I', ShowMessage.MSGAreYouSureYouwantToDeletethisRun, 'OKCANCEL');
    }
}

function handleOk() {
    showLoading();
    var synDealRunCode = $('#Syn_Deal_Run_Code').val();

    $.ajax({
        type: "POST",
        url: URL_Delete,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        //async: false,
        data: JSON.stringify({
            id: synDealRunCode
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            LoadGrid(0);
            showAlert("S", ShowMessage.MSGRunDefinitionDeleted);
            hideLoading();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });

}

function handleCancel() { }
function pageBinding() {
    LoadGrid(0);
}
function LoadGrid(page_index) {
    showLoading();
    var searchText = '';
    var txtPageSize = $('#txtPageSize').val();

    if ($("select#Title_Code").val() != null)
        searchText = $("select#Title_Code").val().join(',');

    $.ajax({
        type: "POST",
        url: URL_BindRun,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: true,
        data: JSON.stringify({
            hdnTitleCode: searchText,
            PageNumber: page_index,
            PageSize: txtPageSize
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            $('#grdRun').html(result);
            SetPaging();
            initializeExpander();
            hideLoading();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}
function ValidateSave() {
    if ($('#txtPageSize').val() != "") {
        showLoading();
        var Mode = Mode_G;
        var Isvalid = true;
        // Code for Maintaining approval remarks in session
        if (Mode == 'APRV') {
            var approvalremarks = $('#approvalremarks').val();
            $.ajax({
                type: "POST",
                url: URL_SetSynApprovalRemarks,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                async: false,
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
        if (Isvalid && !validateSaveCalledManually) {
            hideLoading();
            var tabName = $('#hdnTabName').val();
            BindPartialTabs(tabName);
        }
        hideLoading();
        //Code end for approval
        return Isvalid;
    }
    else {
        return false;
    }
}
function ButtonEvents(id) {  //
    debugger;
    validateSaveCalledManually = true;
    if (ValidateAdd() && CheckTitlesForRun()) {

        $.ajax({
            type: "POST",
            url: URL_ButtonEvents,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            async: false,
            data: JSON.stringify({
                id: id
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    validateSaveCalledManually = true;
                    BindPartialTabs(result.TabName);
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
}

function CheckTitlesForRun() {
    debugger;
    var EnableAddButton = true
    $.ajax({
        type: "POST",
        url: URL_CheckTitlesForRun,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: '',
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.EnableAddButton == false) {
                    showAlert("E", "Rights Are in Error Stage Or No Linear Rights Assigned To The Particular Rights.");
                    EnableAddButton = false;
                }
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });

    return EnableAddButton;

}