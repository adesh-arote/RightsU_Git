$(document).ready(function () {
    if (MsgType_G != null && MsgType_G != '' && MsgType_G == 'S') {
        if (msg_G != null && msg_G != '')
            showAlert('S', msg_G);
    }
    else {
        if (msg_G != null && msg_G != '')
            showAlert('e', msg_G);
    }
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
    var chkAcq = '', chkSyn = '', Type = '';
    chkAcq = $('#chkAcq').val();
    chkSyn = $('#chkSyn').val();
    if ($('#chkAcq').is(':checked') && $('#chkSyn').is(':checked')) {
        Type = chkAcq + ',' + chkSyn;

    }
    else if ($('#chkAcq').is(':checked')) {
        Type = chkAcq;
    }
    else if ($('#chkSyn').is(':checked')) {
        Type = chkSyn;
    }

    if (callfrom == 'BTC') {
        $('#divSearch').slideToggle(400);

    }
    if ($('#ddlSrchTitle').val())
        tmpTitle = $('#ddlSrchTitle').val();
    var Is_async = true;
    if (tmp_IsAdvanced == 'Y')
        Is_async = false
        debugger;
        $.ajax({
            type: "POST",
            url: URL_BindAdvanced_Search_Controls,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                Is_Bind_Control: true,
                Type : Type
            }),
            async: Is_async,
            success: function (result) {

                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    debugger;
                    $("#ddlObjectionStatus").empty();
                    $("#ddlSrchObjectionType").empty();
                    BindObjectionType();
                    $(result.USP_Result).each(function (index, item) {
                        //if (this.Data_For == 'OBT')
                        //    $("#ddlSrchObjectionType").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                        if (this.Data_For == 'OBS')
                            $("#ddlObjectionStatus").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                        if (this.Data_For == 'TOV')
                            $("#ddlSrchLicensor").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                        if (this.Data_For == 'TOB')
                            $("#ddlSrchTitle").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                    });

                    var obj_Search = $(result.Title_Objection_List_Search);
                    //$("#ddlSrchObjectionType").val(obj_Search[0].DealType_Search).attr("selected", "true").trigger("chosen:updated");
                    $("#ddlObjectionStatus").val(obj_Search[0].WorkFlowStatus_Search).attr("selected", "true").trigger("chosen:updated");
                    $("#ddlSrchLicensor").val(obj_Search[0].ProducerCodes_Search.split(','))[0].sumo.reload();
                    $("#ddlSrchTitle").val(obj_Search[0].ProducerCodes_Search.split(','))[0].sumo.reload();
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    
}
function BindObjectionType() {

    $.ajax({
        type: "POST",
        url: URL_BindObjectionType,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        success: function (result) {
            if (result === "true") {
                redirectToLogin();
            }
            else {
                debugger;
                $("#ddlSrchObjectionType").empty();

                $("#ddlSrchObjectionType").append($("<option>").val(""));
                var lstObj_Type_Group = result.lstObjType.map(item => item.Obj_Type_Group)
                    .filter((value, index, self) => self.indexOf(value) === index);

                $(lstObj_Type_Group).each(function (index, item) {
                    $("#ddlSrchObjectionType").append('<optgroup label="' + item + '">');
                    $(result.lstObjType).each(function (index, itemOT) {
                        if (this.Obj_Type_Group === item) {
                            $("#ddlSrchObjectionType").children('optgroup[label="' + item + '"]').append($("<option>").val(this.Code).text(this.Obj_Type_Name));
                        }
                    });
                });
            }
            $("#ddlSrchObjectionType").trigger("chosen:updated");
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}
function LoadDeals(pagenumber, isAdvanced, showAll) {
    debugger;

    if (showLD == 'Y')
        showLoading();
    var tmpTitle = '', tmpLicensor = '', chkAcq = '', chkSyn = '', Type = '';//, strTitleObjectionType = '', strTitleObjectionStatus = '';
    tmp_pageNo = pagenumber;
    tmp_IsAdvanced = isAdvanced;
    chkAcq = $('#chkAcq').val();
    chkSyn = $('#chkSyn').val();
    if ($('#chkAcq').is(':checked') && $('#chkSyn').is(':checked')) {
        Type = chkAcq + ',' + chkSyn;

    }
    else if ($('#chkAcq').is(':checked')) {
        Type = chkAcq;
    }
    else if ($('#chkSyn').is(':checked')) {
        Type = chkSyn;
    }
    if (isAdvanced == 'N')
        $('#divSearch').hide();

    if ($('#ddlSrchTitle').val())
        tmpTitle = $('#ddlSrchTitle').val().join(',');

    if ($('#ddlSrchLicensor').val())
        tmpLicensor = $('#ddlSrchLicensor').val().join(',');

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
            Type: Type,
            commonSearch: $('#srchCommon').val(),
            isTAdvanced: isAdvanced,
            strDealNo: $('#txtSrchDealNo').val(),
            strTitleObjectionType: $('#ddlSrchObjectionType').val(),
            strTitleObjectionStatus: $('#ddlObjectionStatus').val(),
            strTitles: tmpTitle,
            strLicensor: tmpLicensor,
            strShowAll: ShowAll,
            ClearSession: $('#hdnClearAll').val()
        }),
        success: function (result) {
            if (result == "true")
                redirectToLogin();

            else {

                $('#dvDealList').html(result);
                $('[title]').tooltip();
                initializeExpander();
                if ($('#srchCommon').val().trim() != '') {
                    var keyword = $("#srchCommon").val();
                    var options = { 'separateWordSearch': true };
                    $(".Highlight").unmark({
                        done: function () {
                            $(".Highlight").mark(keyword, options);
                        }
                    });
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
    
    if ($("#ddlObjectionStatus").val())
        tmpStatus =  $('#ddlSrchTitle').val();

    if ($("#ddlSrchTitle").val())
        tmpTitle = $('#ddlSrchTitle').val();

    if ($('#ddlSrchLicensor').val())
        tmpLicensor = $('#ddlSrchLicensor').val().join(',');
    var txtSDealNo = $('#txtSrchDealNo').val();
    var ddlDealType = $('#ddlSrchObjectionType').val();

    if (txtSDealNo == "" && tmpLicensor == "" && tmpTitle == "" && ddlDealType < "0") {
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
    $('#ddlSrchObjectionType').val(0).trigger("chosen:updated");
    $('#ddlObjectionStatus').val(0).trigger("chosen:updated");
    $("#ddlSrchTitle")[0].sumo.unSelectAll();
    $("#ddlSrchLicensor")[0].sumo.unSelectAll();
    $('#chkAcq').prop('checked', true);
    $('#chkSyn').prop('checked', true);
    LoadDeals(0, 'N', 'Y');

}
function ClearAll() {
    debugger;
    $('#hdnClearAll').val('Y');
    $('#txtSrchDealNo').val('');
    $('#txtTitleSearch').val('');
    $('#ddlSrchObjectionType').val(0).trigger("chosen:updated");
    $('#ddlSrchDealTag').val(0).trigger("chosen:updated");
    $('#ddlObjectionStatus').val(0).trigger("chosen:updated");
    $("#chkSubDeal").prop("checked", false);
    $("#chkArchiveDeal").prop("checked", false);
    //$('#chkAcq').prop('checked', true);
    //$('#chkSyn').prop('checked', true);
    $("#ddlSrchTitle")[0].sumo.unSelectAll();
    $("#ddlSrchLicensor")[0].sumo.unSelectAll();
    showLD = 'Y';
    LoadDeals(0, 'N', 'Y');
    $('#divSearch').show();
}

/*Bind Title on change of Deal type*/


/*Handle Confirmation of Delete/Approve/SendforAuth/Rollback*/
var Command_Name_G = "";

function handleCancel() {
    HideShow(ID, View_G, 'N');
}
/*Confirmation Alert*/

function CommonSrch() {
    debugger;
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required"); 

    if (!($('#chkAcq').is(':checked')) && !($('#chkSyn').is(':checked'))) {
        $('#IsAcqSyn').addClass('required');
        return false;
    }

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

/*END : Release Content Popup*/


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
