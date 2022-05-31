$(document).ready(function () {
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
    if (IncludeSubDeal_Search_G != 'undefined' && IncludeSubDeal_Search_G == 'N')
        $("#chkSubDeal").removeAttr("checked");
    if (ReleaseRecord_G != '')
        ReleaseRecordLock();
    tmp_IsAdvanced = isAdvanced_G;
    if (tmp_IsAdvanced == "")
        tmp_IsAdvanced = "N";
    showLD = 'Y';
    if (fullyLoaded == "Y") {
        fullyLoaded = "N";
        LoadDeals(PageNo_G, tmp_IsAdvanced, 'Y');
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

/*Bind the Grid*/
var showLD = 'Y';
var tempCount_G = 0;
var View_G = '';
var ID = '';
var IsValid = 'Y';
function BindAdvanced_Search_Controls(callfrom) {
    debugger;
    if ("RTL" == LayoutDirection_G) {

        $('.SumoSelect > .optWrapper.multiple > .options li.opt span, .SumoSelect .select-all > span').css("right", '-3px');
        $('.SumoSelect > .optWrapper > .options li.opt label, .SumoSelect > .CaptionCont, .SumoSelect .select-all > label').css("padding-right", "22px")
        $('.SumoSelect > .optWrapper > .options li.opt label, .SumoSelect > .CaptionCont, .SumoSelect .select-all > label').css("direction", "LTR")
        $('#AdSearch').css("padding-right", "11px");
    }
    else
        $('#AdSearch').css("padding-right", "0px");

    if (Is_AllowMultiBUacqdeal != 'Y') {
        var SelectedBU = $("#ddlBUUnit").val();
        $('#ddlSrchBU').val(SelectedBU);
    }
    else {
        var SelectedBUMulti = $("#ddlGenBUMultiSelect").val();
        $('#ddlSrchBUMultiSelect').val(SelectedBUMulti);
        //$("#ddlSrchBUMultiSelect")[0].sumo.reload();
    }
    //Here call from PGL - Pageload (document ready), BTC - Button(Search) Click
    if (callfrom == 'BTC') {
        $('#divSearch').slideToggle(400);

    }
    if ($('#txtTitleSearch').val())
        tmpTitle = $('#txtTitleSearch').val();
    var Is_async = true;
    if (tmp_IsAdvanced == 'Y')
        Is_async = false
    if (parseInt($("#ddlSrchBU option").length) == 0 || (parseInt($("#ddlSrchBUMultiSelect option").length) == 0)) {
        debugger;
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
                    debugger;
                    $("#ddlSrchBUMultiSelect").empty();
                    $(result.USP_Result).each(function (index, item) {
                        if (this.Data_For == 'DTP' || this.Data_For == 'DTC')
                            $("#ddlSrchDealType").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                        if (this.Data_For == 'DTG')
                            $("#ddlSrchDealTag").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                        if (this.Data_For == 'BUT') {
                            if (Is_AllowMultiBUacqdeal != 'Y') {
                                $("#ddlSrchBU").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                            }
                            else {
                                $("#ddlSrchBUMultiSelect").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                            }
                        }
                        if (this.Data_For == 'DIR')
                            $("#ddlSrchDirector").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                        if (this.Data_For == 'VEN')
                            $("#ddlSrchLicensor").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                    });

                    $(result.lstWorkFlowStatus).each(function (index, item) {
                        $("#ddlWorkflowStatus").append($("<option>").val(this.Value).text(this.Text));
                    });
                    debugger
                    var obj_Search = $(result.Obj_Acq_Syn_List_Search);
                    $("#ddlSrchDealType").val(obj_Search[0].DealType_Search).attr("selected", "true").trigger("chosen:updated");
                    $("#ddlSrchDealTag").val(obj_Search[0].Status_Search).attr("selected", "true").trigger("chosen:updated");
                    if (Is_AllowMultiBUacqdeal != 'Y') {
                        if ($('#ddlBUUnit').val() == obj_Search[0].BUCodes_Search) {
                            debugger;
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
                            $("#ddlGenBUMultiSelect").val(obj_Search[0].BUCodes_Search)[0].sumo.reload();
                        }
                        else {
                            $('#ddlSrchBUMultiSelect').val(SelectedBUMulti)[0].sumo.reload();
                        }
                    }
                    $("#ddlSrchDirector").val(obj_Search[0].DirectorCodes_Search.split(','))[0].sumo.reload();
                    $("#ddlSrchLicensor").val(obj_Search[0].ProducerCodes_Search.split(','))[0].sumo.reload();
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
function LoadDeals(pagenumber, isAdvanced, showAll) {
    debugger;

    if (showLD == 'Y')
        showLoading();
    var tmpTitle = '', tmpDirector = '', tmpLicensor = '', tmpChecked = 'N', tmpArchiveChecked = 'N';
    tmp_pageNo = pagenumber;
    tmp_IsAdvanced = isAdvanced;
    if (isAdvanced == 'N')
        $('#divSearch').hide();
    else {
        if (Is_AllowMultiBUacqdeal != 'Y') {
            if (isAdvanced == 'Y' && parseInt($("#ddlSrchBU option").length) == 0)
                BindAdvanced_Search_Controls('PGL');
        }
        else {
            if (isAdvanced == 'Y' && parseInt($("#ddlSrchBUMultiSelect option").length) == 0)
                BindAdvanced_Search_Controls('PGL');
        }
    }
    //if ($('#ddlSrchTitle').val())
    //    tmpTitle = $('#ddlSrchTitle').val().join(',');

    if ($('#ddlSrchDirector').val())
        tmpDirector = $('#ddlSrchDirector').val().join(',');

    if ($('#ddlSrchLicensor').val())
        tmpLicensor = $('#ddlSrchLicensor').val().join(',');

    if ($('#txtTitleSearch').val())
        tmpTitle = $('#txtTitleSearch').val();

    if ($('#chkSubDeal:checked').val())
        tmpChecked = $('#chkSubDeal:checked').val();

    if ($('#chkArchiveDeal:checked').val())
        tmpArchiveChecked = $('#chkArchiveDeal:checked').val();

    var BUCode = "";
    if (Is_AllowMultiBUacqdeal != 'Y') {
        BUCode = $('#ddlBUUnit').val();
    }
    else {
        if ($('#ddlGenBUMultiSelect').val())
            BUCode = $('#ddlGenBUMultiSelect').val().join(',');
    }
    var strBU = "";
    if (Is_AllowMultiBUacqdeal != 'Y') {
        strBU = $('#ddlSrchBU').val();
    }
    else {
        if ($('#ddlSrchBUMultiSelect').val())
            strBU = $('#ddlSrchBUMultiSelect').val().join(',');
    }

    if (BUCode == "undefined" || BUCode == "" || BUCode == null) {
        debugger;
        showAlert('E', "Business Unit Cannot be Blank.");
        hideLoading();
        return false;
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
            strBU: strBU,
            strShowAll: ShowAll,
            strIncludeSubDeal: tmpChecked,
            strIncludeArchiveDeal: tmpArchiveChecked,
            ClearSession: $('#hdnClearAll').val(),
            strBUCode: BUCode//$('#ddlBUUnit').val()
        }),
        success: function (result) {
            if (result == "true")
                redirectToLogin();

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
            var StrErrMessage = "Please wait....Page is loading";
            alert('Error: ' + StrErrMessage);
        }
    });
}

/*Validaet Advanced Search*/
function validateSearch() {
    debugger;
    $("#srchCommon").val('');
    $('#hdnClearAll').val('N');
    var tmpTitle = '', tmpDirector = '', tmpLicensor = '', tmpChecked = 'N', tmpArchiveChecked = 'N';

    //if ($('#ddlSrchTitle').val())
    //    tmpTitle = $('#ddlSrchTitle').val().join(',');

    if ($("#txtTitleSearch").val())
        tmpTitle = $('#txtTitleSearch').val();

    if ($('#ddlSrchDirector').val())
        tmpDirector = $('#ddlSrchDirector').val().join(',');

    if ($('#ddlSrchLicensor').val())
        tmpLicensor = $('#ddlSrchLicensor').val().join(',');

    if ($('#chkSubDeal:checked').val())
        tmpChecked = $('#chkSubDeal:checked').val();

    if ($('#chkArchiveDeal:checked').val())
        tmpArchiveChecked = $('#chkArchiveDeal:checked').val();


    var txtSDealNo = $('#txtSrchDealNo').val();
    var txtfrom = $('#txtfrom').val();
    var txtto = $('#txtto').val();
    var ddlTagStatus = $('#ddlSrchDealTag').val();
    var ddlBU = $('#ddlSrchBU').val();
    var ddlDealType = $('#ddlSrchDealType').val();
    if (Is_AllowMultiBUacqdeal == 'Y') {
        var ddlBUMulti = $('#ddlSrchBUMultiSelect').val();
        if (ddlBUMulti == null || ddlBUMulti == "") {
            showAlert('E', "Business Unit Cannot be Blank.");
            return false;
        }
        $('#ddlGenBUMultiSelect').val(ddlBUMulti);
    }
    $('#ddlBUUnit').val(ddlBU).attr("selected", "true").trigger("chosen:updated");
    if (txtSDealNo == "" && txtfrom == "" && txtto == "" && tmpLicensor == "" && tmpDirector == "" && tmpTitle == "" && ddlTagStatus < "0" && ddlBU < "0" && ddlDealType < "0") {
        showAlert('e', 'Please select/enter search criteria');
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
    $("#chkSubDeal").prop("checked", "checked");
    $("#chkArchiveDeal").prop("checked", "checked");
    $('#hdnClearAll').val('Y');
    $('#txtSrchDealNo').val('');
    $('#txtfrom').val('');
    $('#txtto').val('');
    $('#ddlSrchDealType').val(0).trigger("chosen:updated");
    $('#ddlSrchDealTag').val(0).trigger("chosen:updated");
    $('#ddlWorkflowStatus').val(0).trigger("chosen:updated");
    $('#ddlSrchBU').val($("#ddlSrchBU option:first-child").val()).trigger("chosen:updated");
    $('#ddlGenBUMultiSelect').val('1');
    $("#ddlGenBUMultiSelect")[0].sumo.reload();
    $('#ddlSrchBUMultiSelect').val('1');
    $("#ddlSrchBUMultiSelect")[0].sumo.reload();
    OnChangeBindTitle('ShowAll');
    //$("#ddlSrchTitle")[0].sumo.unSelectAll();
    $("#ddlSrchDirector")[0].sumo.unSelectAll();
    $("#ddlSrchLicensor")[0].sumo.unSelectAll();
    //$("#ddlGenBUMultiSelect")[0].sumo.unSelectAll();
    //$("#ddlSrchBUMultiSelect")[0].sumo.unSelectAll();

    $('#ddlBUUnit').val(BUCode).attr("selected", "true").trigger("chosen:updated");

    showLD = 'Y';
    LoadDeals(0, 'N', 'Y');

}
function SetMaxDt() {
    setMinMaxDates('txtfrom', '', $('#txtto').val());
}

function SetMinDt() {

    setMinMaxDates('txtto', $('#txtfrom').val(), '');
}

function ClearAll() {
    debugger;
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

    OnChangeBindTitle();
    //$("#ddlSrchTitle")[0].sumo.unSelectAll();
    $("#chkSubDeal").prop("checked", false);
    $("#chkArchiveDeal").prop("checked", false);
    $("#ddlSrchDirector")[0].sumo.unSelectAll();
    $("#ddlSrchLicensor")[0].sumo.unSelectAll();
    $("#ddlGenBUMultiSelect")[0].sumo.unSelectAll();
    $("#ddlSrchBUMultiSelect")[0].sumo.unSelectAll();
    showLD = 'Y';
    LoadDeals(0, 'N', 'Y');
    $('#divSearch').show();
}

/*Bind Title on change of Deal type*/
function OnChangeBindTitle(callFrom) {
    debugger;
    $("#chkArchiveDeal").prop("checked", false);
    $("#chkSubDeal").prop("checked", false);
    var dealTypeVal = $('#ddlSrchDealType').val();

    //var ddlBU = $('#ddlSrchBU').val();
    //$('#ddlBUUnit').val(ddlBU).attr("selected", "true").trigger("chosen:updated");

    if (Is_AllowMultiBUacqdeal != 'Y') {
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
        if (callFrom == 'ShowAll') {
            ddlBUMulti = ["1"];
            $('#ddlGenBUMultiSelect').val('1');
            $("#ddlGenBUMultiSelect")[0].sumo.reload();
        }
        else if (callFrom == 'TP' && ddlBUMulti == null) {
            ddlBUMulti = $('#ddlGenBUMultiSelect').val();
        }
        else if (callFrom != 'L') {
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
            BUCode: ddlBU,
            ddlBUMulti: ddlBUMulti,
            TitleSearch: $('#txtTitleSearch').val()
            //TitleSearch: $('#hdnTitleSearch').val()

        }),
        async: true,
        success: function (result) {

            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (Is_AllowMultiBUacqdeal === 'Y') {
                    $('#txtTitleSearch').val(result.Title_Name);
                    $('#hdnTitleSearch').val(result.Title_Code);

                    //$("#ddlSrchTitle").empty();
                    //$(result).each(function (index, item) {
                    //    $("#ddlSrchTitle").append($("<option>").val(this.Value).text(this.Text));
                    //});
                    //$("#ddlSrchTitle").val('')[0].sumo.reload();
                }
                else {
                    $("#txtTitleSearch").val('');
                }

            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
    if (dealTypeVal == Deal_Type_Content || dealTypeVal == Deal_Type_Format_Program || dealTypeVal == Deal_Type_Event || dealTypeVal == Deal_Type_Documentary_Show || dealTypeVal == Deal_Type_Sports) {
        $("#chkSubDeal").removeAttr("checked");
        $("#chkArchiveDeal").removeAttr("checked");
    }
    //else
    //    $("#chkSubDeal").prop("checked", "checked");
}

/*Handle Confirmation of Delete/Approve/SendforAuth/Rollback*/
var Command_Name_G = "";
function handleOk() {

    debugger
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
    debugger
    var remark = $.trim($('#txtArea').val());

    if (Command_Name == "TERMINATION") {
        Command_Name = "";
        LoadDeals(tmp_pageNo, tmp_IsAdvanced, 'N');
        return;
    }
    if (Command_Name == "Approve") {
        if (remark == "") {
            $('#txtArea').val('').attr('required', true);
            return false
        }
        showLoading();
        $.ajax({
            type: "POST",
            url: URL_Approve,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                Acq_Deal_Code: tmpAcqDealCode,
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
                            if (result.strMsgType != null && result.strMsgType != '' && result.strMsgType == 'S') {
                                if (result.Message != '') {
                                    showAlert("S", result.Message);
                                    $('#pop_setRemark').modal('hide');
                                    //$('#pop_setRemark').dialog("close")
                                    CloseApprovalRemark();
                                }
                            }
                            else {
                                if (result.Message != '')
                                    showAlert("E", result.Message);
                                $('#pop_setRemark').modal('hide');
                                //$('#pop_setRemark').dialog("close")
                                CloseApprovalRemark();
                            }
                            LoadDeals(tmp_pageNo, tmp_IsAdvanced, 'N');
                        }
                        else
                            showAlert("E", result.Error, "");
                    }
                    else if (result.RedirectTo == 'View') {
                        var URL = URL_Index;
                        URL = URL.replace("Acq_Deal_Code", parseInt(tmpAcqDealCode));
                        window.location.href = URL;
                    }
                    else {
                        Show_Validation_Popup("", 10, 0);
                        $('#pop_setRemark').modal('hide');
                        //$('#pop_setRemark').dialog("close")
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
                Acq_Deal_Code: tmpAcqDealCode,
                remarks_Approval: remark
            }),
            async: false,
            success: function (result) {
                debugger
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
                                //$('#pop_setRemark').dialog("close")
                                CloseApprovalRemark();
                            }
                            else {
                                if (result.Message != '')
                                    showAlert("E", result.Message);
                                $('#pop_setRemark').modal('hide');
                                //$('#pop_setRemark').dialog("close")
                                CloseApprovalRemark();
                            }

                        }
                        else
                            Show_Validation_Popup("", 10, 0);
                        $('#pop_setRemark').modal('hide');
                        //$('#pop_setRemark').dialog("close")
                        CloseApprovalRemark();
                    }
                    else {
                        showAlert('E', result.Message);
                        $('#pop_setRemark').modal('hide');
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
    else if (Command_Name == "RollbackWOApprove") {
        showLoading();
        RollbackWOApp();
    }
    else if (Command_Name == "SendForArchive") {
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
                Acq_Deal_Code: tmpAcqDealCode,
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
                Acq_Deal_Code: tmpAcqDealCode,
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
            Acq_Deal_Code: objAcqListCode,
        }),
        success: function (result) {
            hideLoading();
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.Is_Locked == "Y") {

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
                    objAcqListCode = 0;
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
            objAcqListCode = 0;
            alert('Error in CheckRecordCurrentStatus() : ' + result.responseText);
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
            Acq_Deal_Code: objAcqListCode,
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
                    objAcqListCode = 0;
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
            objAcqListCode = 0;
            alert('Error in CheckRecordCurrentStatus() : ' + result.responseText);
        }
    });
}

function CloseApprovalRemark() {
    debugger
    Command_Name_G = "";
    objAcqListCode = 0;
    var recordLockingCode = parseInt($('#hdnRecodLockingCode').val())
    if (recordLockingCode > 0) {
        ReleaseRecordLock(recordLockingCode, URL_Release_Lock);
        $('#hdnRecodLockingCode').val('0');
    }

    $('#txtArea').val('').removeAttr('required');
    $('#pop_setRemark').modal('hide');
    HideShow(ID, View_G, 'N');
}
function handleCancel() {
    HideShow(ID, View_G, 'N');
}
function handleCancelValidationPopup() {
    $('#BindValidationPopup').empty();
    $('#popupValidationError').modal('hide');

    HideShow(ID, View_G, 'N');
}
function Show_Validation_Popup(search_Titles, Page_Size, Page_No) {
    hideLoading();
    $.ajax({
        type: "POST",
        url: URL_Show_Validation_Popup,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            searchForTitles: search_Titles,
            PageSize: Page_Size,
            PageNo: Page_No
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                $('#BindValidationPopup').empty();
                $("#BindValidationPopup").html(result);
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
    $('#popupValidationError').modal();
    initializeChosen();
    initializeExpander();
}

/*Delete Deal*/
function DeleteDeal() {
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_DeleteDeal,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Acq_Deal_Code: tmpAcqDealCode
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
/*Rollback Deal*/
function RollbackDeal() {

    showLoading();
    $.ajax({
        type: "POST",
        url: URL_Rollback,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Acq_Deal_Code: tmpAcqDealCode
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

function RollbackWOApp() {

    showLoading();
    $.ajax({
        type: "POST",
        url: URL_RollbackWOApp,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Acq_Deal_Code: tmpAcqDealCode

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

/*Confirmation Alert*/
function Ask_Confirmation(commandName, Acq_Deal_Code, IsZeroWorkFlow) {
    debugger;
    var is_Duplicate = "";
    if (commandName == "SendForAuth") {
        $.ajax({
            type: "POST",
            url: URL_ChkRightsDuplication,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                acqDealCode: Acq_Deal_Code,
            }),
            async: false,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    if (result != "Err") {
                        is_Duplicate = result;
                        if (result == "DUPLICATE") {
                            Show_Validation_Popup("", 10, 0)
                        }
                    }
                    else {
                        showAlert("E", "Cannot send deal for approval as rights are in processing state");
                        IsValid = "N";
                        HideShow(ID, View_G, 'N');
                        return false;
                    }
                }
            },
            error: function (result) {
                hideLoading();
            }
        });
    }

    if (commandName == "SendForArchive") {
        $.ajax({
            type: "POST",
            url: URL_Chk_Archive_Validation,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                Acq_Deal_Code: Acq_Deal_Code
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

    if ((is_Duplicate == "" || is_Duplicate == "VALID") && commandName != "AddAmendmentHistory") {
        Command_Name_G = commandName;
        tmpAcqDealCode = Acq_Deal_Code;
        Command_Name = commandName;
        tmp_IsZeroWorkFlow = IsZeroWorkFlow;
        objAcqListCode = Acq_Deal_Code;
        if (commandName == "Rollback") {
            showAlert("I", 'Are you sure, you want to rollback this record?', "OKCANCEL");
        }
        else if (commandName == "Approve") {
            showAlert("I", 'Are you sure, you want to approve this deal?', "OKCANCEL");
        }
        else if (commandName == "SendForAuth" && IsValid == "Y") {
            //ShowRemark('Approve');
            showAlert("I", 'Are you sure, you want to send this deal for approval?', "OKCANCEL");
        }
        else if (commandName == "RollbackWOApprove") {
            showAlert("I", 'Are you sure, you want to rollback this record?', "OKCANCEL");
        }
        else if (commandName == "Delete") {
            showAlert("I", 'Are you sure, you want to delete this record?', "OKCANCEL");
        }
        else if (commandName == "SendForArchive") {
            showAlert("I", 'Are you sure, you want to send this deal for Archive?', "OKCANCEL");
        }
        else if (commandName == "Archive") {
            showAlert("I", 'Are you sure, you want to Archive this record?', "OKCANCEL");
        }
    }
}

function AddAmendmentHistory(commandName, Acq_Deal_Code, IsZeroWorkFlow) {

   
        $.ajax({
            type: "POST",
            url: URL_AddAmendmentHistory,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                acqDealCode: Acq_Deal_Code,
            }),
            async: false,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    $('#popDealAmendmentHistoryPopup').modal();
                    $('#pupupHtml').empty();
                    $('#pupupHtml').html(result);
                }
            },
            error: function (result) {
                hideLoading();
            }
        });
    
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

function CommonSrch() {

    if ($('#srchCommon').val() == '')
        $('#hdnClearAll').val('Y');
    showLD = 'Y';
    LoadDeals(0, 'N', 'N');

}

/*START : Release Content Popup*/
function addNumeric() {
    $(".pagingSize").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        max: 99,
        min: 1
    });
}
function SetPaging_ReleaseContentPopup() {

    IsCall = 'N';
    var pageNo = parseInt($('#hdnPageNo_RCPopup').val());
    var recordCount = parseInt($('#hdnRecordCount_RCPopup').val());
    var pagePerBatch = parseInt($('#hdnPagePerBatch_RCPopup').val());
    var recordPerPage = parseInt($('#txtPageSize_RCPopup').val());
    var cnt = pageNo * recordPerPage;
    if (cnt >= recordCount) {
        var v1 = parseInt(recordCount / recordPerPage);
        if ((v1 * recordPerPage) == recordCount)
            pageNo = v1;
        else
            pageNo = v1 + 1;
    }
    if (pageNo == 0)
        pageNo = 1;

    var index = pageNo - 1;
    $('#hdnPageNo_RCPopup').val(pageNo);
    var opt = null;
    opt = { callback: PageChange_ReleaseContent };
    opt["items_per_page"] = recordPerPage;
    opt["num_display_entries"] = pagePerBatch;
    opt["num"] = 10;
    opt["prev_text"] = "<<";
    opt["next_text"] = ">>";
    opt["current_page"] = index;
    $("#Pagination_popup").pagination(recordCount, opt);
}
function PageChange_ReleaseContent(page_index, jq) {
    $('.required').removeClass('required');

    if (!ValidatePageSize_ReleaseContentPopup())
        return false;

    var pageNo = page_index + 1
    $('#hdnPageNo_RCPopup').val(pageNo);
    if (IsCall == 'Y') {
        var acqDealCode = $("#acqDealCode").val();
        var agreementNo = $("#agreementNo").val();
        BindReleaseContent(acqDealCode, agreementNo)
    }
    else {
        IsCall = 'Y';
    }
}
function ReleaseContent(acqDealCode, agreementNo, tempCount) {


    $.ajax({
        type: "POST",
        url: URL_CheckRecordCurrentStatus,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: true,
        data: JSON.stringify({
            Acq_Deal_Code: acqDealCode,
            Key: "RC"
        }),
        success: function (result) {
            hideLoading();
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.Is_Locked == "Y") {

                    $('#hdnRecodLockingCode').val(result.Record_Locking_Code);

                    tempCount_G = tempCount;
                    $("#acqDealCode").val(acqDealCode);
                    $("#agreementNo").val(agreementNo);
                    SearchReleaseContent("");

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
            objAcqListCode = 0;
            alert('Error in CheckRecordCurrentStatus() : ' + result.responseText);
        }
    });

    $('#txtSearch_RCPopup').keypress(function (e) {
        if (e.keyCode == 13) {
            btnSearch_OnClick()
            return false;
        }
    });
}
function txtPageSize_RCPopup_OnChange() {
    $("[required='required']").removeAttr("required");
    $('.required').removeClass('required');

    if (!ValidatePageSize_ReleaseContentPopup())
        return false;
    var acqDealCode = $("#acqDealCode").val();
    var agreementNo = $("#agreementNo").val();
    BindReleaseContent(acqDealCode, agreementNo)
    SetPaging_ReleaseContentPopup();
}
function ValidatePageSize_ReleaseContentPopup() {
    var recordPerPage = $('#txtPageSize_RCPopup').val()
    if ($.trim(recordPerPage) != '') {
        var pageSize = parseInt(recordPerPage);
        if (pageSize > 0)
            return true;
    }
    $('#txtPageSize_RCPopup').attr('required', true)
    return false
}

//function Validate_PagingReleaseContentPopup() {
//    debugger
//    var pageSize = $('#txtPageSize_RCPopup').val();
//    if (pageSize < 1) {
//        $('#txtPageSize_RCPopup').val('10')
//        var acqDealCode = $("#acqDealCode").val();
//        var agreementNo = $("#agreementNo").val();
//        BindReleaseContent(acqDealCode, agreementNo)
//        SetPaging_ReleaseContentPopup();
//    }
//}
function pageBinding() {
    var acqDealCode = $("#acqDealCode").val();
    var agreementNo = $("#agreementNo").val();
    BindReleaseContent(acqDealCode, agreementNo)
    SetPaging_ReleaseContentPopup();
}

function btnSearch_RCPopup_OnClick(key) {
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");

    if (!ValidatePageSize_ReleaseContentPopup())
        return false;

    var searchText = "";
    if (key == "S") {
        searchText = $.trim($('#txtSearch_RCPopup').val());
        if (searchText == '') {
            $('#txtSearch_RCPopup').val('').attr('required', true)
            return false;
        }
    }
    else
        $('#txtSearch_RCPopup').val('');

    SearchReleaseContent(searchText);
}
function SearchReleaseContent(searchText) {
    var acqDealCode = $("#acqDealCode").val();
    if (acqDealCode == "")
        acqDealCode = "0";

    selectedTitleCodes = $("#hdnSelectedTitleCodes").val();

    showLoading();
    $.ajax({
        type: "POST",
        url: URL_SearchReleaseContent,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            searchText: searchText,
            acqDealCode: acqDealCode,
            selectedTitleCodes: selectedTitleCodes
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                var acqDealCode = $("#acqDealCode").val();
                var agreementNo = $("#agreementNo").val();

                $('#hdnPageNo_RCPopup').text(1);
                $('#lblRecordCount_RCPopup').text(result.Record_Count);
                $("#hdnRecordCount_RCPopup").val(result.Record_Count);
                $("#hdnAllTitleCodes").val(result.AllTitleCodes);
                $("#hdnSelectedTitleCodes").val(result.SelectedTitleCodes);
                BindReleaseContent();
                SetPaging_ReleaseContentPopup()
                hideLoading();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}
function BindReleaseContent() {
    var pageNo = $('#hdnPageNo_RCPopup').val();
    var recordPerPage = $('#txtPageSize_RCPopup').val();
    if (recordPerPage == "") {
        recordPerPage = 10;
        $('#txtPageSize_RCPopup').val("10");
    }
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_BindReleaseContentList,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            pageNo: pageNo,
            recordPerPage: recordPerPage
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                var AN = $("#agreementNo").val();
                $("#spnAgreementNo").html(AN);
                $('#divReleaseContentList').empty();
                $('#divReleaseContentList').html(result);
                if ($("input:checkbox[id*='chkContent_']").length > 0) {
                    $('#divPopupReleaseContent').modal();
                    addNumeric();
                    BindCheckboxEventForReleaseContent();
                }
                else {
                    showAlert("I", "Content has been processed")
                }
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });

    hideLoading();
}
function BindCheckboxEventForReleaseContent() {
    var arrSelectedCodes = $("#hdnSelectedTitleCodes").val().split(',');
    var allCodes = $("#hdnAllTitleCodes").val();

    var newSelectedCodes = ",";
    var count = 0;
    for (i = 0; i < arrSelectedCodes.length; i++) {
        var code = arrSelectedCodes[i].trim();
        if (code != "") {
            if (allCodes.indexOf("," + code + ",") > -1) {
                count++;
                newSelectedCodes = newSelectedCodes + code + ",";
            }
        }
    }

    $("#hdnSelectedTitleCodes").val(newSelectedCodes);

    $("input[id*='chkContent']:checkbox").each(function () {
        var code = $(this).val();
        if (newSelectedCodes.indexOf("," + code + ",") > -1)
            $(this).prop('checked', true);
    });

    var totalLength = $("input[id*='chkContent']:checkbox").length;
    var checkedLength = $("input[id*='chkContent']:checkbox:checked").length;
    $("#chkAllContent").prop('checked', (totalLength == checkedLength && checkedLength > 0));

    $("input[id*='chkContent']:checkbox").click(function () {
        var code = $(this).val();
        var selectedCodes = $("#hdnSelectedTitleCodes").val().trim();
        if (selectedCodes == '')
            selectedCodes = ","
        if ($(this).is(':checked')) {
            selectedCodes = selectedCodes + code + ",";
            $("#hdnSelectedTitleCodes").val(selectedCodes);
        }
        else {
            selectedCodes = selectedCodes.replace("," + code + ",", ",");
            $("#hdnSelectedTitleCodes").val(selectedCodes);
        }

        var totalLength = $("input[id*='chkContent']:checkbox").length;
        var checkedLength = $("input[id*='chkContent']:checkbox:checked").length;
        $("#chkAllContent").prop('checked', (totalLength == checkedLength && checkedLength > 0));
    });

    $("#chkAllContent").click(function () {
        var chkAll_Checked = $(this).is(':checked');
        var selectedCodes = $("#hdnSelectedTitleCodes").val().trim();
        $("input[id*='chkContent']:checkbox").each(function () {
            var code = $(this).val();
            if (chkAll_Checked)
                selectedCodes = selectedCodes + code + ",";
            else
                selectedCodes = selectedCodes.replace("," + code + ",", ",");

            $(this).prop('checked', chkAll_Checked);
        });

        $("#hdnSelectedTitleCodes").val(selectedCodes);
    });
}
function SaveReleaseContent() {
    if ($("input:checkbox[id*='chkContent_']:checked").length > 0) {
        var titleCodes = $("input:checkbox[id*='chkContent_']:checked").map(function () { return this.value; }).get().join(',')
        var acqDealCode = $('#acqDealCode').val();
        showLoading();
        $.ajax({
            type: "POST",
            url: URL_SaveReleasedContent,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                acqDealCode: acqDealCode,
                titleCodes: titleCodes
            }),
            async: false,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    if (result.Status == "S") {

                        if (result.Released_Content_Count > 0) {
                            var deleteLen = $('.delete_' + tempCount_G).length;
                            if (deleteLen == 1) {
                                var countBefore = $('#extend_' + tempCount_G + ' a').length;
                                $('.delete_' + tempCount_G).remove();
                                var countAfter = $('#extend_' + tempCount_G + ' a').length;
                                if (countAfter == countBefore && countAfter > 0) {
                                    var firstOption = $('#extend_' + tempCount_G + ' a')[0];
                                    $('#divAction_' + tempCount_G).append(firstOption);
                                    countAfter--;
                                }

                                if (countAfter == 0 && countBefore > 0) {
                                    $('#show_hide_' + tempCount_G).remove();
                                    $('#extend_' + tempCount_G).remove();
                                }
                            }
                            tempCount_G = 0;
                        }
                        showAlert("S", result.Message);
                        CloseReleaseContent();
                    }
                    else
                        showAlert("E", result.Message);
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
        hideLoading();
    }
    else
        showAlert("E", "Please select content", 'chkAllContent')
}
function CloseReleaseContent() {
    $("#acqDealCode").val("");
    $("#agreementNo").val("");
    $('#spnAgreementNo').text('');
    $('#divReleaseContentList').empty();
    $('#divPopupReleaseContent').modal('hide');
}
/*END : Release Content Popup*/

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
            objAcqListCode = 0;
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
    debugger
    $('.required').removeClass('required');

    var titleList = new Array();
    var SynErrorList = new Array();
    var tblMovie = $("#tblTermination .trFullRow");
    var returnVal = true;
    var Is_valid_Error = 'N';
    tblMovie.each(function () {
        var _titleCode = 0, _episode_No = 0, _terminationDate = "", txtTerminateEpisodeNo, Syn_Epi_No, Syn_End_date, Sch_Epi_No, Sch_End_date;

        _titleCode = parseInt($(this).find("span[id*='lblTitleCode_']").text());

        var _strMinDate = $(this).find("span[id*='lblMinDate_']").text();
        var _strMaxDate = $(this).find("span[id*='lblMaxDate_']").text();

        _strMinDate = MakeDateFormate(_strMinDate)
        _strMaxDate = MakeDateFormate(_strMaxDate)
        var minDate, maxDate, terminationDate;
        minDate = new Date(_strMinDate);
        maxDate = new Date(_strMaxDate);

        if ($(this).find("input[id*='txtTerminateEpisodeNo_'][type='text']")[0] != undefined) {
            txtTerminateEpisodeNo = $(this).find("input[id*='txtTerminateEpisodeNo_'][type='text']")[0];
            _episode_No = txtTerminateEpisodeNo.value;
            Sch_Epi_No = parseInt($(this).find("span[id*='lblSchEpsNo_']").text());
            Syn_Epi_No = parseInt($(this).find("span[id*='lblSynEpsNo_']").text());
        }

        var txtTerminationFrom = $(this).find("input[id*='txtTerminationFrom_'][type='text']")[0];

        if (_episode_No != "")
            _episode_No = parseInt(_episode_No);
        _terminationDate = txtTerminationFrom.value;
        terminationDate = new Date(MakeDateFormate(_terminationDate));

        Syn_End_date = new Date($(this).find("span[id*='lblSynEndDate_']").text());
        Sch_End_date = new Date($(this).find("span[id*='lblSchEndDate_']").text());
        var minEpisode = parseInt($(this).find("span[id*='lblMinEpisode_']").text());
        var maxEpisode = parseInt($(this).find("span[id*='lblMaxEpisode_']").text());

        if ($.trim(_episode_No) == "" && $.trim(_terminationDate) == "") {
            $('#' + txtTerminateEpisodeNo.id).attr('required', true);
            returnVal = false;
            return false;
        }
        else if ($.trim(_terminationDate) == "" && $(this).find("input[id*='txtTerminateEpisodeNo_'][type='text']")[0] == undefined) {
            $('#' + txtTerminationFrom.id).attr('required', true);
            returnVal = false;
            return false;
        }
        else if (_episode_No != "" && (_episode_No < minEpisode || _episode_No > maxEpisode)) {
            returnVal = false;
            showAlert("E", "Please select episode no. between " + minEpisode + " To " + maxEpisode, txtTerminateEpisodeNo.id);
            return false;
        }
        else if ($('.trFullRow td:nth(1)').html() == '' && $('.trFullRow td:nth(2)').html() == '') {

            returnVal = false;
            showAlert("E", "Please set Milestone start date first");
            return false;
        }
        else if (terminationDate < minDate || terminationDate > maxDate) {
            returnVal = false;
            showAlert("E", "Please select termination date between " + _strMinDate + " To " + _strMaxDate, txtTerminationFrom.id);
            return false;
        }
        else if ((_episode_No < Sch_Epi_No && _episode_No > 0) || Sch_End_date > terminationDate) {
            var msg = 'Date';
            if (dealTypeCondition == DealProgram_G) {
                msg = 'Episode No / Date';
            }
            returnVal = false;
            if (_episode_No != "" && _episode_No < Sch_Epi_No)
                showAlert("E", "Termination " + msg + " must be greater than or equal to Scheduled " + msg, txtTerminateEpisodeNo.id);
            else
                showAlert("E", "Termination " + msg + " must be greater than or equal to Scheduled " + msg, txtTerminationFrom.id);
            return false;
        }
        else if ((_episode_No < Syn_Epi_No && _episode_No > 0) || Syn_End_date > terminationDate) {
            var msg = 'Date';
            if (dealTypeCondition == DealProgram_G) {
                msg = 'Episode No / Date';
            }

            returnVal = true;
            if (_episode_No != "" && _episode_No < Syn_Epi_No)
                showAlert("E", "Termination " + msg + " must be greater than or equal to Syndicated " + msg, txtTerminateEpisodeNo.id);
            else
                showAlert("E", "Termination " + msg + " must be greater than or equal to Syndicated " + msg, txtTerminationFrom.id);

            $(this).addClass('synerror');
            Is_valid_Error = 'Y';
            SynErrorList.push({ Deal_Code: dealCode, Title_Code: (_titleCode == 0 ? null : _titleCode), Termination_Episode_No: _episode_No, Termination_Date: _terminationDate });
        }

        if (returnVal)
            titleList.push({ Deal_Code: dealCode, Title_Code: _titleCode, Termination_Episode_No: _episode_No, Termination_Date: _terminationDate });
    });

    if (returnVal) {
        showLoading();
        Command_Name = "TERMINATION"
        var tablehtml = $('#tblTermination');
        var AnySynError = $(tablehtml).find('.synerror');
        $.ajax({
            type: "POST",
            url: URL_SaveTermination,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                titleList: (SynErrorList.length > 0 ? SynErrorList : titleList),
                Syn_Error_Body: '',
                Is_Validate_Error: Is_valid_Error
            }),
            async: true,
            success: function (result) {
                $(tablehtml).find('.synerror').removeClass('synerror');
                if (result == "true") {
                    hideLoading();
                    redirectToLogin();
                }
                else {
                    hideLoading();
                    if (result.Status == "E") {
                        return false;
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
function ShowTerminateError() {
    $.ajax({
        type: "POST",
        url: URL_ShowTerminateError,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
        }),
        async: true,
        success: function (result) {

            if (result == "true") {
                redirectToLogin();
            }
            else {
                $('#popupTerminationError').empty();
                $('#popupTerminationError').html(result);
                $('#popupTerminationError').modal();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
    hideLoading();
}
function BindDealStatusPopup(Acq_Deal_Code) {
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_PartialBindDealStatusPopup,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        data: JSON.stringify({
            Acq_Deal_Code: Acq_Deal_Code
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                $('#bindDealStatus').html(result);
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
    hideLoading();
}
function BindLinearStatusPopup(Acq_Deal_Code) {
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_PartialBindLinearStatusPopup,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        data: JSON.stringify({
            Acq_Deal_Code: Acq_Deal_Code
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                $('#bindLinearStatus').html(result);
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
    hideLoading();
}
function BindMilestonePopup(Acq_Deal_Code) {
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_PartialBindMilestonePopup,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        data: JSON.stringify({
            Acq_Deal_Code: Acq_Deal_Code
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            if (result.indexOf("This record") > -1) {
                showAlert('e', result);
            }
            else {
                $('#BindMilestonePopup').html(result);
                $('#popSetMileStone').modal();
                initializeDatepicker();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
    hideLoading();
}
function SetPaging() {
    var PageNo, recordCnt;
    IsCall = 'N';
    if (PageNo_PVG != null)
        PageNo = PageNo_PVG;
    if (RecordCount_PVG != null)
        recordCnt = RecordCount_PVG;
    PageNo = PageNo - 1;
    var opt = { callback: pageselectCallback };
    opt["items_per_page"] = 10;
    opt["num_display_entries"] = 5;
    opt["num"] = 10;
    opt["prev_text"] = "<<";
    opt["next_text"] = ">>";
    opt["current_page"] = PageNo;
    $("#Pagination_List").pagination(recordCnt, opt);
}
function pageselectCallback(page_index, jq) {
    if (IsCall == 'Y')
        LoadDeals(page_index, isAdvanced_G, 'N');
    else
        IsCall = 'Y';
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
                url: URL_GetAcqAsyncStatus,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                async: false,
                data: JSON.stringify({
                    dealCode: dealCode
                }),
                success: function (result) {
                    debugger
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
                        $("#btnShowError_" + dealCode).attr('data-original-title', "Error in Process Please Contact System Admin");
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
                                    var StrErrMessage = "Please wait....Page is loading";
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
function BindMoreTitles(acqDealCode, agreementNo, tempCount) {
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_SessionTitleList,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            acqDealCode: acqDealCode
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                $("#popAddTitle").modal();
                $("#spnCount_AT").text(tempCount);
                $("#acqDealCode_AT").val(acqDealCode);
                $("#agreementNo_AT").val(agreementNo);
                BindAT("", acqDealCode);
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
    $("#acqDealCode_AT").val("");
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

function Show_Error_Popup(search_Titles, Page_Size, Page_No, Acq_Deal_Code) {
    debugger;
    showLoading();
    var selectedErrorType = $("#ddlErrorType").val();
    $("#hdnAcqDealCode").val(Acq_Deal_Code);

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
            AcqDealCode: Acq_Deal_Code,
            ErrorMSG: selectedErrorType
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

function Reprocess() {
    debugger;
    showLoading();

    $.ajax({
        type: "POST",
        url: URL_Reprocess,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Acq_Deal_Code: $("#hdnAcqDealCode").val()
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
            showAlert('e', result.responseText);
        }
    });
}
