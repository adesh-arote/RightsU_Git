$(document).ready(function () {
    var pageNo = pageNo_G;
    if (MsgType_G != null && MsgType_G != '' && MsgType_G == 'S') {
        if (msg_G != null && msg_G != '')
            showAlert('S', msg_G);
    }
    else {
        if (msg_G != null && msg_G != '')
            showAlert('e', msg_G);
    }
    if (RLCode_G != '')
        Call_RefreshRecordReleaseTime(RLCode_G);

    if (ReleaseRecord != '')
        ReleaseRecordLock();

    if (tmp_IsAdvanced == "")
        tmp_IsAdvanced = "N";
    showLD = 'Y';
    if (fullyLoaded == "Y") {
        fullyLoaded = "N";
        LoadDeals(pageNo, tmp_IsAdvanced, 'Y');
        fullyLoaded = "Y";
    }
    $('#srchCommon').focus();
    if (tmp_IsAdvanced == 'N')
        $('#divSearch').hide();
    $('#txtfrom').change(function () {
        SetMinDt();
    });

    $('#txtto').change(function () {
        SetMaxDt();
    });
});
function BindAdvanced_Search_Controls(callfrom) {

    //Here call from PGL - Pageload (document ready), BTC - Button(Search) Click
    if (Is_AllowMultiBUsyndeal != 'Y') {
        var SelectedBU = $("#ddlBUUnit").val();
        $('#ddlSrchBU').val(SelectedBU);
    }
    else {
        var SelectedBUMulti = $("#ddlGenBUMultiSelect").val();
        $('#ddlSrchBUMultiSelect').val(SelectedBUMulti);
    }
    if (callfrom == 'BTC') {
        $('#divSearch').slideToggle(400);
        // OnChangeBindTitle('L');
    }
    var Is_async = true;
    if (tmp_IsAdvanced == 'Y')
        Is_async = false;
    if (parseInt($("#ddlSrchBU option").length) == 0) {
        $.ajax({
            type: "POST",
            url: URL_BindAdvanced_Search_Controls,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                Is_Bind_Control: true
            }),
            async: Is_async,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    $(result.USP_Result).each(function (index, item) {
                        if (this.Data_For == 'DTP' || this.Data_For == 'DTC')
                            $("#ddlSrchDealType").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                        if (this.Data_For == 'DTG')
                            $("#ddlSrchDealTag").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                        if (this.Data_For == 'BUT')
                            if (Is_AllowMultiBUsyndeal != 'Y') {
                                $("#ddlSrchBU").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                            }
                            else {
                                $("#ddlSrchBUMultiSelect").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                            }
                        if (this.Data_For == 'DIR')
                            $("#ddlSrchDirector").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                        if (this.Data_For == 'LAV')
                            $("#ddlSrchLicensor").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                    });
                    $(result.lstWorkFlowStatus).each(function (index, item) {
                        $("#ddlWorkflowStatus").append($("<option>").val(this.Value).text(this.Text));
                    });
                    var obj_Search = $(result.Obj_Acq_Syn_List_Search);
                    $("#ddlSrchDealType").val(obj_Search[0].DealType_Search).attr("selected", "true").trigger("chosen:updated");
                    $("#ddlSrchDealTag").val(obj_Search[0].Status_Search).attr("selected", "true").trigger("chosen:updated");
                    if (Is_AllowMultiBUsyndeal != 'Y') {
                        if ($('#ddlBUUnit').val() == obj_Search[0].BUCodes_Search) {
                            $("#ddlSrchBU").val(obj_Search[0].BUCodes_Search).attr("selected", "true").trigger("chosen:updated");
                            $('#ddlBUUnit').val(obj_Search[0].BUCodes_Search).attr("selected", "true").trigger("chosen:updated");
                        }


                        else {
                            $("#ddlSrchBU").val(SelectedBU).attr("selected", "true").trigger("chosen:updated");
                        }
                    }
                    else {
                        if ($('#ddlGenBUMultiSelect').val() == obj_Search[0].BUCodes_Search) {
                            debugger;
                            $("#ddlSrchBUMultiSelect").val(obj_Search[0].BUCodes_Search)[0].sumo.reload();
                            // $("#ddlSrchBUMultiSelect")[0].sumo.reload();
                        }
                        else {
                            $('#ddlSrchBUMultiSelect').val(SelectedBUMulti);
                            $("#ddlSrchBUMultiSelect")[0].sumo.reload();
                        }

                    }

                    $("#ddlSrchDirector").val(obj_Search[0].DirectorCodes_Search.split(',')).attr("selected", "true")[0].sumo.reload();
                    $("#ddlSrchLicensor").val(obj_Search[0].ProducerCodes_Search.split(',')).attr("selected", "true")[0].sumo.reload();
                    $("#ddlWorkflowStatus").val(obj_Search[0].WorkFlowStatus_Search).attr("selected", "true").trigger("chosen:updated");
                    if (result.strTitleNames != "") {
                        $('#txtTitleSearch').val(result.strTitleNames + "﹐");
                    }
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
}
function Show_Error_Popup(search_Titles, Page_Size, Page_No, Syn_Deal_Code) {
    showLoading();
    var selectedErrorType = $("#ddlErrorType").val();
    $("#hdnSynDealCode").val(Syn_Deal_Code);

    $.ajax({
        type: "POST",
        url: URL_Show_Error_Popup,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            searchForTitles: search_Titles,
            PageSize: Page_Size,
            PageNo: Page_No,
            SynDealCode: Syn_Deal_Code,
            ErrorMsg: selectedErrorType
        }),
        async: false,
        success: function (result) {
            if (result == "true")
                redirectToLogin();
            else {
                $("#BindErrorPopup").html(result);
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
    $('#popupShowError').modal();
    initializeExpander();
    initializeChosen();
    setChosenWidth('#lbTitle_ErrorPopup', '84%');

    if (selectedErrorType != null)
        $("#ddlErrorType").val(selectedErrorType);

    $("#ddlErrorType").trigger("chosen:updated");
    hideLoading();
}
/*Bind the Grid*/
function LoadDeals(pagenumber, isAdvanced, showAll) {

    var BUCode = $('#ddlBUUnit').val();
    if (showLD == 'Y')
        showLoading();
    var tmpTitle = '', tmpDirector = '', tmpLicensor = '', tmpChecked = 'N', tmpArchiveChecked = 'N';
    tmp_pageNo = pagenumber;
    tmp_IsAdvanced = isAdvanced;
    if (isAdvanced == 'N')
        $('#divSearch').hide();
    else if (isAdvanced == 'Y' && parseInt($("#ddlSrchBU option").length) == 0)
        BindAdvanced_Search_Controls('PGL');
    //if ($('#ddlSrchTitle').val())
    //    tmpTitle = $('#ddlSrchTitle').val().join(',');
    if ($('#txtTitleSearch').val())
        tmpTitle = $('#txtTitleSearch').val();
    if ($('#ddlSrchDirector').val())
        tmpDirector = $('#ddlSrchDirector').val().join(',');
    if ($('#ddlSrchLicensor').val())
        tmpLicensor = $('#ddlSrchLicensor').val().join(',');
    if ($('#chkArchiveDeal:checked').val())
        tmpArchiveChecked = $('#chkArchiveDeal:checked').val();
    if (Is_AllowMultiBUsyndeal != 'Y') {
        var BUCode = $('#ddlBUUnit').val();
    }
    else {
        if ($('#ddlGenBUMultiSelect').val())
            BUCode = $('#ddlGenBUMultiSelect').val().join(',');
    }
    $.ajax({
        type: "POST",
        url: URL_PartialDealList,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        async: true,
        data: JSON.stringify({
            Page: pagenumber,
            commonSearch: $('#srchCommon').val(),
            isTAdvanced: isAdvanced,
            strDealNo: $('#txtSrchDealNo').val(),
            strfrom: $('#txtfrom').val(),
            strto: $('#txtto').val(),
            strSrchDealType: $('#ddlSrchDealType').val(),
            strSrchDealTag: $('#ddlSrchDealTag').val(),
            strWorkflowStatus: $('#ddlWorkflowStatus').val(),
            strTitles: tmpTitle,
            strDirector: tmpDirector,
            strLicensor: tmpLicensor,
            strBU: $('#ddlSrchBU').val(),
            strShowAll: ShowAll,
            strIncludeArchiveDeal: tmpArchiveChecked,
            ClearSession: $('#hdnClearAll').val(),
            strBUCode: BUCode//$('#ddlBUUnit').val()
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                $('#dvDealList').html(result);
                $('[title]').tooltip();
                initializeExpander();
                CheckPendingStatus();

                if ($('#srchCommon').val().trim() != '') {
                    var keyword = $("#srchCommon").val();
                    var options = { 'separateWordSearch': true };
                    $(".Highlight").unmark({
                        done: function () {
                            $(".Highlight").mark(keyword, options);
                        }
                    });
                    // $("#lbTitle_Code").on("input", mark);
                    // $("#lbTitle_Code").on("change", mark);
                }

                if (showLD == 'Y')
                    hideLoading();
            }
        },
        error: function (result) {
            var StrErrMessage = ShowMessage.SorryitseemswehavesomeissuePleasetryagainlater;
            hideLoading();
            alert(StrErrMessage);
        }
    });
}

/*Validate Advanced Search*/
function validateSearch() {
    debugger
    var tmpTitle = '', tmpDirector = '', tmpLicensor = '', tmpChecked = 'N', tmpArchiveChecked = 'N';
    $("#srchCommon").val('');
    $('#hdnClearAll').val('N');
    //if ($('#ddlSrchTitle').val())
    //    tmpTitle = $('#ddlSrchTitle').val().join(',');
    if ($("#txtTitleSearch").val())
        tmpTitle = $('#txtTitleSearch').val()
    if ($('#ddlSrchDirector').val())
        tmpDirector = $('#ddlSrchDirector').val().join(',');
    if ($('#ddlSrchLicensor').val())
        tmpLicensor = $('#ddlSrchLicensor').val().join(',');
    var txtSDealNo = $('#txtSrchDealNo').val();
    var txtfrom = $('#txtfrom').val();
    var txtto = $('#txtto').val();
    var ddlTagStatus = $('#ddlSrchDealTag').val();
    var ddlBU = $('#ddlSrchBU').val();
    var ddlDealType = $('#ddlSrchDealType').val();
    if (Is_AllowMultiBUsyndeal == 'Y') {
        var ddlBUMulti = $('#ddlSrchBUMultiSelect').val();
        if (ddlBUMulti.length == 0) {
            showAlert('E', "Business Unit Cannot be Blank.");
            return false;
        }
        $('#ddlGenBUMultiSelect').val(ddlBUMulti);
    }
    if ($('#chkArchiveDeal:checked').val())
        tmpArchiveChecked = $('#chkArchiveDeal:checked').val();

    $('#ddlBUUnit').val(ddlBU).attr("selected", "true").trigger("chosen:updated");

    if (txtSDealNo == "" && txtfrom == "" && txtto == "" && tmpLicensor == "" && tmpDirector == "" && tmpTitle == "" && ddlTagStatus < "0" && ddlBU < "0" && ddlDealType < "0") {
        showAlert('e', ShowMessage.Pleaseselectentersearchcriteria);
        return false;
    }
    else {
        showLD = 'Y';
        LoadDeals(0, 'Y', 'N');
    }
}

function ShowAll() {
    $('#divSearch').hide();
    $('#srchCommon').val('');
    $('#hdnClearAll').val('N');
    $('#txtSrchDealNo').val('');
    $("#chkSubDeal").prop("checked", "checked");
    $('#txtfrom').val('');
    $('#txtto').val('');
    $('#ddlSrchDealType').val(0).trigger("chosen:updated");
    $('#ddlSrchDealTag').val(0).trigger("chosen:updated");
    $('#ddlWorkflowStatus').val(0).trigger("chosen:updated");
    $('#ddlSrchBU').val($("#ddlSrchBU option:first-child").val()).trigger("chosen:updated");
    OnChangeBindTitle();
    $("#ddlGenBUMultiSelect")[0].sumo.unSelectAll();
    $("#ddlSrchBUMultiSelect")[0].sumo.unSelectAll();
    $("#ddlSrchDirector").find("option").attr("selected", false);
    $("#ddlSrchDirector").val('')[0].sumo.reload();
    $("#ddlSrchLicensor").find("option").attr("selected", false);
    $("#ddlSrchLicensor").val('')[0].sumo.reload();
    showLD = 'Y';
    $('#ddlBUUnit').val(BUCode).attr("selected", "true").trigger("chosen:updated");
    LoadDeals(0, 'N', 'Y');
}

function ClearAll() {
    $('#hdnClearAll').val('Y');
    $('#txtSrchDealNo').val('');
    $('#txtfrom').val('');
    $('#txtto').val('');
    $('#txtTitleSearch').val('');
    SetMinDt();
    SetMaxDt();
    $('#ddlSrchDealType').val(0).trigger("chosen:updated");
    $('#ddlSrchDealTag').val(0).trigger("chosen:updated");
    $('#ddlWorkflowStatus').val(0).trigger("chosen:updated");
    $('#ddlSrchBU').val($("#ddlSrchBU option:first-child").val()).trigger("chosen:updated");
    $("#chkArchiveDeal").prop("checked", false);
    $("#chkSubDeal").prop("checked", false);


    OnChangeBindTitle();

    $("#ddlGenBUMultiSelect")[0].sumo.unSelectAll();
    $("#ddlSrchBUMultiSelect")[0].sumo.unSelectAll();

    $("#ddlSrchDirector").find("option").attr("selected", false);
    $("#ddlSrchDirector").val('')[0].sumo.reload();
    $("#ddlSrchLicensor").find("option").attr("selected", false);
    $("#ddlSrchLicensor").val('')[0].sumo.reload();
    showLD = 'Y';
    LoadDeals(0, 'N', 'Y');
    $('#divSearch').show();
}

function SetMaxDt() {
    setMinMaxDates('txtfrom', '', $('#txtto').val());
}

function SetMinDt() {
    setMinMaxDates('txtto', $('#txtfrom').val(), '');
}

function OnChangeBindTitle(callFrom) {
    var dealTypeVal = $('#ddlSrchDealType').val();
    if (Is_AllowMultiBUsyndeal != 'Y') {
        var ddlBU = $('#ddlSrchBU').val();
        if (callFrom != 'L') {
            $('#ddlBUUnit').val(ddlBU).attr("selected", "true").trigger("chosen:updated");
        }
        else {
            dealTypeVal = '0';
            ddlBU = $('#ddlBUUnit').val();
        }
    }
    else {
        var ddlBUMulti = $('#ddlSrchBUMultiSelect').val();
        if (callFrom != 'L') {
            $('#ddlGenBUMultiSelect').val(ddlBUMulti);
            $("#ddlGenBUMultiSelect")[0].sumo.reload();
        }
        else {
            dealTypeVal = '0';
            ddlBUMulti = $('#ddlGenBUMultiSelect').val();
        }
    }

    //$("#ddlSrchTitle").find("option").attr("selected", false);
    //$("#ddlSrchTitle").val('')[0].sumo.reload();

    $.ajax({
        type: "POST",
        url: URL_OnChangeBindTitle,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            dealTypeCode: dealTypeVal,
            BUCode: ddlBU
        }),
        async: true,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {

                $("#txtTitleSearch").val('');
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}

/*Handle Confirmation of Delete/Approve/SendforAuth/Rollback*/
var Command_Name_G = "";
var View_G = '';
var ID = '';
function handleOk() {
    //if (Command_Name_G != "Approve" && Command_Name_G != "SendForAuth") {
    //    ButtonEvents();
    //}
    //if (Command_Name_G == "Approve" || Command_Name_G == "SendForAuth") {
    //    CheckRecordCurrentStatus();
    //}

    debugger;
    if (Command_Name_G != "Approve" && Command_Name_G != "SendForAuth" && Command_Name_G != "Archive" && Command_Name_G != "SendForArchive") {
        ButtonEvents();
    }
    if (Command_Name_G == "Approve" || Command_Name_G == "SendForAuth") {
        CheckRecordCurrentStatus();
    }
    else if (Command_Name_G == "SendForArchive" || Command_Name_G == "Archive") //Command_Name_G == "Archive" ||
    {
        Chk_RecCrntStsForArchive();
    }

}
function ButtonEvents() {
    debugger;
    var remark = $.trim($('#txtArea').val());

    if (Command_Name == "TERMINATION") {
        Command_Name = "";
        LoadDeals(tmp_pageNo, tmp_IsAdvanced, 'N');
        return;
    }

    if (Command_Name == "Approve") {
        if (remark == "") {
            $('#txtArea').val('').attr('required', true);
            return false;
        }
        showLoading();
        $.ajax({
            type: "POST",
            url: URL_Approve,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                Syn_Deal_Code: tmpSynDealCode,
                IsZeroWorkFlow: tmp_IsZeroWorkFlow,
                remarks_Approval: remark
            }),
            async: false,
            success: function (result) {
                hideLoading();

                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    if (result.RedirectTo == 'Index') {
                        if (result.Error == '') {
                            showLD = 'N';
                            LoadDeals(tmp_pageNo, tmp_IsAdvanced, 'N');
                            if (result.strMsgType != null && result.strMsgType != '' && result.strMsgType == 'S') {
                                if (result.Message != '') {
                                    showAlert("S", result.Message);

                                    $('#pop_setRemark').modal('hide');
                                    CloseApprovalRemark();
                                }
                            }
                            else {
                                if (result.Message != '')
                                    showAlert("E", result.Message);
                                $('#pop_setRemark').modal('hide');
                                CloseApprovalRemark();
                            }
                            LoadDeals(tmp_pageNo, tmp_IsAdvanced, 'N');
                        }
                        else
                            showAlert("E", result.Error, "");
                    }
                    else if (result.RedirectTo == 'View') {
                        var URL = URL_Index;
                        URL = URL.replace("Syn_Deal_Code", parseInt(tmpSynDealCode));
                        window.location.href = URL;
                    }
                    else {
                        ShowValidationPopup("", 10, 0);
                        $('#pop_setRemark').modal('hide');
                        $('#pop_setRemark').dialog("close");
                        CloseApprovalRemark();
                        return false;
                    }
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
    else if (Command_Name == "SendForAuth") {
        if (remark == "") {
            $('#txtArea').val('').attr('required', true);
            return false
        }
        showLoading();
        $.ajax({
            type: "POST",
            url: URL_SendForAuthorisation,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                Syn_Deal_Code: tmpSynDealCode,
                remarks_Approval: remark
            }),
            async: false,
            success: function (result) {
                hideLoading();

                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    if (result.RedirectTo != '') {
                        if (result.RedirectTo == 'Index') {
                            showLD = 'N';
                            LoadDeals(tmp_pageNo, tmp_IsAdvanced, 'N');
                            if (result.strMsgType != null && result.strMsgType != '' && result.strMsgType == 'S') {
                                if (result.Message != '')
                                    showAlert("S", result.Message);
                                $('#pop_setRemark').modal('hide');
                                $('#pop_setRemark').dialog("close");
                                CloseApprovalRemark();
                            }
                            else {
                                if (result.Message != '')
                                    showAlert("E", result.Message);
                                $('#pop_setRemark').modal('hide');
                                $('#pop_setRemark').dialog("close");
                                CloseApprovalRemark();
                            }
                        }
                        else
                            ShowValidationPopup("", 10, 0);
                        $('#pop_setRemark').modal('hide');
                        $('#pop_setRemark').dialog("close");
                        CloseApprovalRemark();
                    }
                    else {
                        showAlert('e', result.Message);
                        $('#pop_setRemark').modal('hide');
                        $('#pop_setRemark').dialog("close");
                        CloseApprovalRemark();
                        return false;
                    }
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
    else if (Command_Name == "Delete") {
        showLoading();
        DeleteDeal();
    }
    else if (Command_Name == "Rollback") {
        showLoading();
        RollbackDeal();
    }
    else if (Command_Name == "SendForArchive") {
        debugger;
        if (remark == "") {
            $('#txtArea').val('').attr('required', true);
            return false;
        }
        showLoading();
        $.ajax({
            type: "POST",
            url: URL_SendForArchive,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                Syn_Deal_Code: tmpSynDealCode,
                remarks_Approval: remark
            }),
            async: false,
            success: function (result) {
                debugger;
                hideLoading();
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    showLD = 'N';
                    LoadDeals(tmp_pageNo, tmp_IsAdvanced, 'N');
                    if (result.strMsgType != null && result.strMsgType != '' && result.strMsgType == 'S') {
                        if (result.Message != '')
                            showAlert("S", result.Message);
                        $('#pop_setRemark').modal('hide');
                        CloseApprovalRemark();
                    }
                    else {
                        if (result.Message != '')
                            showAlert("E", result.Message);
                        $('#pop_setRemark').modal('hide');
                        CloseApprovalRemark();
                    }
                    $('.modal - backdrop.in').css("opacity", "0");
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
    else if (Command_Name == "Archive") {
        debugger;
        if (remark == "") {
            $('#txtArea').val('').attr('required', true);
            return false;
        }
        showLoading();
        $.ajax({
            type: "POST",
            url: URL_Archive,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                Syn_Deal_Code: tmpSynDealCode,
                IsZeroWorkFlow: tmp_IsZeroWorkFlow,
                remarks_Approval: remark
            }),
            async: false,
            success: function (result) {

                hideLoading();
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    showLD = 'N';
                    LoadDeals(tmp_pageNo, tmp_IsAdvanced, 'N');
                    if (result.strMsgType != null && result.strMsgType != '' && result.strMsgType == 'S') {
                        if (result.Message != '')
                            showAlert("S", result.Message);
                        $('#pop_setRemark').modal('hide');
                        CloseApprovalRemark();
                    }
                    else {
                        if (result.Message != '')
                            showAlert("E", result.Message);
                        $('#pop_setRemark').modal('hide');
                        CloseApprovalRemark();
                    }
                    $('.modal - backdrop.in').css("opacity", "0");
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
}
function CheckRecordCurrentStatus() {
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_CheckRecordCurrentStatus,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: true,
        data: JSON.stringify({
            CommandName: Command_Name_G,
            Acq_Deal_Code: objSynListCode,
        }),
        success: function (result) {
            hideLoading();
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.Is_Locked == "Y" && result.isValid == "Y") {

                    $('#hdnRecodLockingCode').val(result.Record_Locking_Code);

                    if (Command_Name_G == "Approve" || Command_Name_G == "SendForAuth") {
                        $('#txtArea').val('').removeAttr('required');
                        $('#pop_setRemark').modal();
                        if (Command_Name_G == 'SendForAuth')
                            $('#btnStatus').val('Send for Approval');
                        else
                            $('#btnStatus').val('Approve');
                    }
                    Call_RefreshRecordReleaseTime(result.Record_Locking_Code, URL_Refresh_Lock);
                    return true;
                }
                else {
                    Command_Name_G = "";
                    objSynListCode = 0;
                    HideShow(ID, View_G, 'N');
                    if (result.isValid == "N")
                        showAlert("E", "Cannot send deal for approval as rights are in processing state");
                    else
                        showAlert("E", result.Message);



                    if (result.BindList == "Y")
                        ShowAll();

                    return false;
                }
            }
        },
        error: function (result) {
            hideLoading();
            Command_Name_G = "";
            objSynListCode = 0;
            alert('Error in CheckRecordCurrentStatus() : ' + result.responseText);
        }
    });
}
function CloseApprovalRemark() {

    Command_Name_G = "";
    objSynListCode = 0;
    var recordLockingCode = parseInt($('#hdnRecodLockingCode').val())
    if (recordLockingCode > 0) {
        ReleaseRecordLock(recordLockingCode, URL_Release_Lock);
        $('#hdnRecodLockingCode').val('0');
    }

    $('#txtArea').val('').removeAttr('required');
    handleCancel();
    $('#pop_setRemark').modal('hide');
}
function handleCancel() {
    HideShow(ID, View_G, 'N');
}

function Reprocess() {
    showLoading();

    $.ajax({
        type: "POST",
        url: URL_Reprocess,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Syn_Deal_Code: $("#hdnSynDealCode").val()
        }),
        async: false,
        success: function (result) {
            hideLoading();

            if (result == "true") {
                redirectToLogin();
            }
            else {
                $('#popupShowError').modal('hide');
                $('.modal-backdrop').hide();
                $('.modal-open').removeClass('modal-open');
                if (result.RedirectTo != '') {
                    showLD = 'N';
                    LoadDeals(tmp_pageNo, tmp_IsAdvanced, 'N');
                }
                else {
                    return false;
                }
                if (result.strMsgType != null && result.strMsgType != '' && result.strMsgType == 'S') {
                    if (result.Message != '')
                        showAlert("S", result.Message, "");
                }
                else {
                    if (result.Message != '')
                        showAlert("E", result.Message, "");
                }
            }
        },
        error: function (result) {
            $('#popupShowError').modal('hide');
            $('.modal-backdrop').hide();
            $('.modal-open').removeClass('modal-open');
            showAlert('e', result.responseText)
        }
    });
}

function DeleteDeal() {
    showLoading();

    $.ajax({
        type: "POST",
        url: URL_DeleteDeal,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Syn_Deal_Code: tmpSynDealCode
        }),
        success: function (result) {
            hideLoading();

            if (result == "true") {
                redirectToLogin();
            }
            else {
                showLD = 'N';
                LoadDeals(tmp_pageNo, tmp_IsAdvanced, 'N');

                if (result.strMsgType != null && result.strMsgType != '' && result.strMsgType == 'S') {
                    if (result.Message != '')
                        showAlert("S", result.Message, "");
                }
                else {
                    if (result.Message != '')
                        showAlert("E", result.Message, "");
                }
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}

function RollbackDeal() {
    showLoading();

    $.ajax({
        type: "POST",
        url: URL_Rollback,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Syn_Deal_Code: tmpSynDealCode
        }),
        success: function (result) {
            hideLoading();

            if (result == "true") {
                redirectToLogin();
            }
            else {
                showLD = 'N';
                LoadDeals(tmp_pageNo, tmp_IsAdvanced, 'N');

                if (result.strMsgType != null && result.strMsgType != '' && result.strMsgType == 'S') {
                    if (result.Message != '')
                        showAlert("S", result.Message, "");
                }
                else {
                    if (result.Message != '')
                        showAlert("E", result.Message, "");
                }
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}
function Chk_RecCrntStsForArchive() {
    debugger
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_CheckRecordCurrentStatus,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: true,
        data: JSON.stringify({
            CommandName: Command_Name_G,
            Acq_Deal_Code: objSynListCode,
            Key: "AR"
        }),
        success: function (result) {
            hideLoading();
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.Is_Locked == "Y") {

                    $('#hdnRecodLockingCode').val(result.Record_Locking_Code);
                    if (Command_Name_G == "Archive" || Command_Name_G == "SendForArchive") {
                        $('#txtArea').val('').removeAttr('required');
                        $('#pop_setRemark').modal();
                        if (Command_Name_G == 'SendForArchive')
                            $('#btnStatus').val('Send for Archive');
                        else
                            $('#btnStatus').val('Archive');
                    }
                    Call_RefreshRecordReleaseTime(result.Record_Locking_Code, URL_Refresh_Lock);
                    return true;
                }
                else {
                    Command_Name_G = "";
                    objSynListCode = 0;
                    showAlert("E", result.Message);
                    HideShow(ID, View_G, 'N');
                    if (result.BindList == "Y")
                        ShowAll();

                    return false;
                }
            }
        },
        error: function (result) {
            hideLoading();
            Command_Name_G = "";
            objSynListCode = 0;
            alert('Error in CheckRecordCurrentStatus() : ' + result.responseText);
        }
    });
}
function Ask_Confirmation(commandName, Syn_Deal_Code, IsZeroWorkFlow) {
    debugger;

    var is_Duplicate = "";
    if (commandName == "SendForArchive") {
        $.ajax({
            type: "POST",
            url: URL_Chk_Archive_Validation,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                Syn_Deal_Code: Syn_Deal_Code
            }),
            async: false,
            success: function (result) {
                debugger;
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    if (result.strMsgType == 'E') {
                        is_Duplicate = "DUPLICATE";
                        showAlert("E", result.Message);
                        HideShow(ID, View_G, 'N');
                    }
                    else {
                        is_Duplicate = "VALID";
                        if (result.Message != "") {
                            showAlert("", result.Message);
                        }
                    }
                }
            },
            error: function (result) {
                hideLoading();
            }
        });
    }

    if (is_Duplicate == "" || is_Duplicate == "VALID") {
        Command_Name_G = commandName;
        tmpSynDealCode = Syn_Deal_Code;
        Command_Name = commandName;
        tmp_IsZeroWorkFlow = IsZeroWorkFlow;
        objSynListCode = Syn_Deal_Code;
        if (commandName == "Delete") {
            showAlert("I", ShowMessage.Areyousureyouwanttodeletethisrecord, "OKCANCEL");
        }
        else if (commandName == "Rollback") {
            showAlert("I", ShowMessage.Areyousureyouwanttodrollbackthisrecord, "OKCANCEL");
        }
        else if (commandName == "Approve") {
            showAlert("I", ShowMessage.Areyousureyouwanttodapprovethisdeal, "OKCANCEL");
        }
        else if (commandName == "SendForAuth") {
            showAlert("I", ShowMessage.Areyousureyouwanttosendthisdealforapproval, "OKCANCEL");
        }
        else if (commandName == "SendForArchive") {
            showAlert("I", 'Are you sure, you want to send this deal for Archive?', "OKCANCEL");
        }
        else if (commandName == "Archive") {
            showAlert("I", 'Are you sure, you want to Archive this record?', "OKCANCEL");
        }
    }
}

function CommonSrch() {
    if ($('#srchCommon').val() == '')
        $('#hdnClearAll').val('Y');
    showLD = 'Y';
    LoadDeals(0, 'N', 'N');
}

function TerminateDeal(dealCode, dealTypeCode, agreementNo) {

    showLoading();
    $.ajax({
        type: "POST",
        url: URL_CheckRecordCurrentStatus,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: true,
        data: JSON.stringify({
            Acq_Deal_Code: dealCode,
            Key: "TD"
        }),
        success: function (result) {
            hideLoading();
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.Is_Locked == "Y") {

                    $('#hdnRecodLockingCode').val(result.Record_Locking_Code);
                    $.ajax({
                        type: "POST",
                        url: URL_ValidateTermination,
                        traditional: true,
                        enctype: 'multipart/form-data',
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({
                            dealCode: dealCode
                        }),
                        async: true,
                        success: function (result) {
                            if (result == "true") {
                                redirectToLogin();
                            }
                            else {

                                if (result.Status == "E") {
                                    showAlert('E', result.Message);
                                }
                                else if (result.Status == "S") {
                                    OpenTerminationPopup(dealCode, dealTypeCode, agreementNo)
                                }
                            }
                        },
                        error: function (result) {
                            alert('Error: ' + result.responseText);
                        }
                    });
                    Call_RefreshRecordReleaseTime(result.Record_Locking_Code, URL_Refresh_Lock);
                    return true;
                }
                else {
                    showAlert("E", result.Message);
                    return false;
                }
            }
        },
        error: function (result) {
            hideLoading();
            Command_Name_G = "";
            objSynListCode = 0;
            alert('Error in CheckRecordCurrentStatus() : ' + result.responseText);
        }
    });
    hideLoading();
}

function OpenTerminationPopup(dealCode, dealTypeCode, agreementNo) {
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_OpenTerminationPopup,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            dealCode: dealCode,
            dealTypeCode: dealTypeCode,
            agreementNo: agreementNo
        }),
        async: true,
        success: function (result) {

            if (result == "true") {
                redirectToLogin();
            }
            else {
                $('#popupTermination').empty();
                $('#popupTermination').html(result);
                $('#popupTermination').modal();

                AssignJQuery();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
    hideLoading();
}

function SaveTermination(dealCode, dealTypeCondition) {
    $('.required').removeClass('required');

    var titleList = new Array();
    var tblMovie = $("#tblTermination .trFullRow");
    var dealProgram = dealProgram_G;
    var dealMovie = dealMovie_G;
    var returnVal = true;
    tblMovie.each(function () {
        var _titleCode = 0, _episode_No = 0, _terminationDate = "";
        _titleCode = parseInt($(this).find("span[id*='lblTitleCode_']").text());

        var _strMinDate = $(this).find("span[id*='lblMinDate_']").text();
        var _strMaxDate = $(this).find("span[id*='lblMaxDate_']").text();

        _strMinDate = MakeDateFormate(_strMinDate)
        _strMaxDate = MakeDateFormate(_strMaxDate)
        var minDate, maxDate, terminationDate;
        minDate = new Date(_strMinDate);
        maxDate = new Date(_strMaxDate);
        var Episode_TB_Id = '', Date_TB_Id = '';

        if (dealTypeCondition == dealProgram) {
            var txtTerminateEpisodeNo = $(this).find("input[id*='txtTerminateEpisodeNo_'][type='text']")[0];
            _episode_No = txtTerminateEpisodeNo.value;
            var minEpisode = parseInt($(this).find("span[id*='lblMinEpisode_']").text());
            var maxEpisode = parseInt($(this).find("span[id*='lblMaxEpisode_']").text());

            if ($.trim(_episode_No) == "")
                Episode_TB_Id = txtTerminateEpisodeNo.id;
            else
                _episode_No = parseInt(_episode_No);

            if ((_episode_No < minEpisode || _episode_No > maxEpisode) && Episode_TB_Id == '') {
                returnVal = false;
                showAlert("E", ShowMessage.Pleaseselectepisodenobetween + minEpisode + ShowMessage.To + maxEpisode, txtTerminateEpisodeNo.id);
                return false;
            }
        }

        var txtTerminationFrom = $(this).find("input[id*='txtTerminationFrom_'][type='text']")[0];
        _terminationDate = txtTerminationFrom.value;

        if ($.trim(_terminationDate) == "")
            Date_TB_Id = txtTerminationFrom.id;
        else {
            terminationDate = new Date(MakeDateFormate(_terminationDate));
            if (isNaN(terminationDate)) {
                returnVal = false;
                showAlert("E", ShowMessage.PleaseselectTerminationDate, Date_TB_Id);
                return false;
            }
            if (terminationDate < minDate || terminationDate > maxDate) {
                returnVal = false;
                showAlert("E", ShowMessage.Pleaseselectterminationdatebetween + _strMinDate + ShowMessage.To + _strMaxDate, txtTerminationFrom.id);
                return false;
            }
        }

        if ((Episode_TB_Id != '' && Date_TB_Id != '' && dealTypeCondition == dealProgram)) {
            returnVal = false
            showAlert("E", ShowMessage.PleaseselecteitherEpisodeNoorTerminationDate, Episode_TB_Id);
            return false;
        }
        else if (Date_TB_Id != '' && dealTypeCondition == dealMovie) {
            returnVal = false
            showAlert("E", ShowMessage.PleaseselectTerminationDate, Date_TB_Id);
            return false;
        }
        if (returnVal)
            titleList.push({ Deal_Code: dealCode, Title_Code: _titleCode, Termination_Episode_No: _episode_No, Termination_Date: _terminationDate });
    });

    if (returnVal) {
        Command_Name = "TERMINATION"
        showLoading();
        $.ajax({
            type: "POST",
            url: URL_SaveTermination,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                titleList: titleList
            }),
            async: true,
            success: function (result) {
                if (result == "true") {
                    hideLoading();
                    redirectToLogin();
                }
                else {
                    hideLoading();
                    if (result.Status == "E") {
                        showAlert('E', result.Message);
                    }
                    else if (result.Status == "S") {
                        $('#popupTermination').modal('hide');
                        showAlert('S', result.Message, 'OK');
                    }
                }
            },
            error: function (result) {
                hideLoading();
                alert('Error: ' + result.responseText);
            }
        }
        );
    }
}
function HideShow(id, View, IsHide) {
    ID = id;
    View_G = View;
    var childs = $('#' + id + " > a").not('#' + View).map(function () { return this.id })

    $.each(childs, function (key, value) {
        if (IsHide == 'Y') {
            $('#' + value).hide();
        }
        else {
            if (value.slice(0, 13) == "btnShowError_")
                $('#' + value).hide();
            else
                $('#' + value).show();
        }
    });
}


function BindDealStatusPopup(Syn_Deal_Code) {
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_PartialBindDealStatusPopup,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        data: JSON.stringify({
            Syn_Deal_Code: Syn_Deal_Code
        }),
        success: function (result) {
            if (result == "true")
                redirectToLogin();
            else
                $('#bindDealStatus').html(result);
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
    hideLoading();
}

function CheckPendingStatus() {
    var pendingRecord = 0;
    $(".deal_action").each(function () {
        var SiblingClass = $(this).attr('class').split(' ')[1];
        if (isNaN(SiblingClass.substr(SiblingClass.length - 1))) {
            var dealCode = SiblingClass.slice(12, SiblingClass.length - 1);
            var tempCount = 0;
            if (SiblingClass.substr(SiblingClass.length - 1) == "R") {
                var tc_class = $(this).attr('class').split(' ')[2];
                tempCount = tc_class.slice(3, SiblingClass.length - 1);
            }
            $.ajax({
                type: "POST",
                url: URL_GetSynAsyncStatus,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                async: false,
                data: JSON.stringify({
                    dealCode: dealCode
                }),
                success: function (result) {
                    if (result == "true") {
                        redirectToLogin();
                    }
                    if (result.RecordStatus == "P") {
                        $("#imgLoading_" + dealCode).css("display", '');
                        $(".AT_" + dealCode).css("display", 'none');
                        $("#imgLoading_" + dealCode).removeAttr('data-original-title');
                        $("#imgLoading_" + dealCode).attr('data-original-title', "AT Generation Pending");
                        pendingRecord++;
                    }
                    else if (result.RecordStatus == "W") {
                        $("#imgLoading_" + dealCode).css("display", '');
                        $(".AT_" + dealCode).css("display", 'none');
                        pendingRecord++;
                        $("#imgLoading_" + dealCode).removeAttr('data-original-title');
                        $("#imgLoading_" + dealCode).attr('data-original-title', "In Process");
                        pendingRecord++;
                    }
                    else if (result.RecordStatus == "E") {
                        $("#imgLoading_" + dealCode).css("display", 'none');
                        $(".AT_" + dealCode).css("display", 'none');
                        $("#btnShowError_" + dealCode).css("display", '');
                        $("#btnShowError_" + dealCode).removeAttr('data-original-title');
                        $("#btnShowError_" + dealCode).attr('data-original-title', ShowMessage.ErrorinProcessPleaseContactSystemAdmin);
                        //pendingRecord++;
                    }
                    else if (result.RecordStatus == "D") {
                        $("#imgLoading_" + dealCode).css("display", 'none');
                        $(".AT_" + dealCode).css("display", '');
                        var VNo = result.Version_No;
                        if (SiblingClass.substr(SiblingClass.length - 1) == "R" && result.Button_Visibility != "") {
                            $.ajax({
                                type: "POST",
                                url: URL_ActionButtons,
                                traditional: true,
                                enctype: 'multipart/form-data',
                                contentType: "application/json; charset=utf-8",
                                dataType: "html",
                                async: true,
                                data: JSON.stringify({
                                    tempCount: tempCount,
                                    dealCode: dealCode,
                                    Button_Visibility: result.Button_Visibility
                                }),
                                success: function (result) {
                                    if (result == "true")
                                        redirectToLogin();
                                    else {
                                        $('.VR_' + dealCode).text('V-' + VNo)
                                        $('.' + SiblingClass).empty()
                                        $('.' + SiblingClass).append(result)
                                        initializeTooltip();
                                    }
                                },
                                error: function (result) {
                                    var StrErrMessage = ShowMessage.PleasewaitPageisloading;
                                    alert('Error: ' + StrErrMessage);
                                }
                            });
                        }
                    }
                },
                error: function (result) {
                }
            });
        }
    });

    if (pendingRecord > 0) {
        setTimeout(CheckPendingStatus, 5000);
    }
}


function BindMoreTitles(SynDealCode, agreementNo, tempCount) {
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_SessionTitleList,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            SynDealCode: SynDealCode
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                $("#popAddTitle").modal();
                $("#spnCount_AT").text(tempCount);
                $("#SynDealCode_AT").val(SynDealCode);
                $("#agreementNo_AT").val(agreementNo);
                BindAT("");
                hideLoading();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}

function CloseAT() {
    $("#txtSearch_ATPopup").val("");
    $("#SynDealCode_AT").val("");
    $("#spnCount_AT").text("");
    $("#agreementNo_AT").val("");
    $('#spnAgreementNo_AT').text('');
    $('#divTitleList').empty();
    $('#popAddTitle').modal('hide');
}

function BindAT(searchText) {
    $.ajax({
        type: "POST",
        url: URL_BindAT,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            searchText: searchText
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                var AN = $("#agreementNo_AT").val();
                $("#spnAgreementNo_AT").html(AN);
                $('#divTitleList').empty();
                $('#divTitleList').html(result);

            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}

function btnSearch_ATPopup_OnClick(key) {

    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    var searchText = "";
    if (key == "S") {
        searchText = $.trim($('#txtSearch_ATPopup').val());
        if (searchText == '') {
            $('#txtSearch_ATPopup').val('').attr('required', true)
            return false;
        }
    }
    else
        $('#txtSearch_ATPopup').val('');
    BindAT(searchText);
}
