var Command_Name = "", CommandName_G = "";
var PDCode_G = "", key_G = "", Mode_G = "";

function AssignTimeJquery_Edit() {
    $('#txtEndNPrimeTime_Edit').timeEntry();
    $('#txtStartNPrimeTime_Edit').timeEntry();
    $('#txtStartPrimeTime_Edit').timeEntry();
    $('#txtEndPrimeTime_Edit').timeEntry();

    $('.PrimetimeRange').timeEntry().change(function (input) {
        debugger;
        if (input.currentTarget.id === 'txtEndPrimeTime_Edit') {
            if ($('#txtEndPrimeTime_Edit').timeEntry('getTime').getMinutes() + 1 >= 60) {
                var minutes = $('#txtEndPrimeTime_Edit').timeEntry('getTime').getMinutes() + 1;
                var hours = $('#txtEndPrimeTime_Edit').timeEntry('getTime').getHours() + 1;

                if ($('#txtEndPrimeTime_Edit').timeEntry('getTime').getHours() + 1 >= 24)
                    $('#txtStartNPrimeTime_Edit').timeEntry('setTime', new Date(0, 0, 0, hours - 24, minutes - 60, 0));
                else
                    $('#txtStartNPrimeTime_Edit').timeEntry('setTime', new Date(0, 0, 0, hours, minutes - 60, 0));

            }
            else {
                var minute = $('#txtEndPrimeTime_Edit').timeEntry('getTime').getMinutes() + 1;
                var hour = $('#txtEndPrimeTime_Edit').timeEntry('getTime').getHours();
                $('#txtStartNPrimeTime_Edit').timeEntry('setTime', new Date(0, 0, 0, hour, minute, 0));
            }
        }
        else
            if (input.currentTarget.id === 'txtStartPrimeTime_Edit') {
                if ($('#txtStartPrimeTime_Edit').timeEntry('getTime').getMinutes() - 1 <= 0) {
                    var minutes = $('#txtStartPrimeTime_Edit').timeEntry('getTime').getMinutes() - 1;
                    var hours = $('#txtStartPrimeTime_Edit').timeEntry('getTime').getHours();
                    if (minutes === -1)
                        $('#txtEndNPrimeTime_Edit').timeEntry('setTime', new Date(0, 0, 0, hours - 1, 59, 0));
                    else
                        $('#txtEndNPrimeTime_Edit').timeEntry('setTime', new Date(0, 0, 0, hours, 0, 0));
                }
                else {
                    var minute = $('#txtStartPrimeTime_Edit').timeEntry('getTime').getMinutes() - 1;
                    var hour = $('#txtStartPrimeTime_Edit').timeEntry('getTime').getHours();
                    $('#txtEndNPrimeTime_Edit').timeEntry('setTime', new Date(0, 0, 0, hour, minute, 0));
                }
            }
    });
}
function AssignTimeJquery() {
    $('#txtStartNPrimeTime').timeEntry();
    $('#txtEndNPrimeTime').timeEntry();
    $('.PrimetimeRange').timeEntry();
    $('.PrimetimeRange').timeEntry().change(function (input) {
        if (input.currentTarget.id === 'txtEndPrimeTime') {
            if ($('#txtEndPrimeTime').timeEntry('getTime').getMinutes() + 1 >= 60) {
                var minutes = $('#txtEndPrimeTime').timeEntry('getTime').getMinutes() + 1;
                var hours = $('#txtEndPrimeTime').timeEntry('getTime').getHours() + 1;

                if ($('#txtEndPrimeTime').timeEntry('getTime').getHours() + 1 >= 24)
                    $('#txtStartNPrimeTime').timeEntry('setTime', new Date(0, 0, 0, hours - 24, minutes - 60, 0));
                else
                    $('#txtStartNPrimeTime').timeEntry('setTime', new Date(0, 0, 0, hours, minutes - 60, 0));

            }
            else {
                var minute = $('#txtEndPrimeTime').timeEntry('getTime').getMinutes() + 1;
                var hour = $('#txtEndPrimeTime').timeEntry('getTime').getHours();
                $('#txtStartNPrimeTime').timeEntry('setTime', new Date(0, 0, 0, hour, minute, 0));
            }
        }
        else
            if (input.currentTarget.id === 'txtStartPrimeTime') {
                if ($('#txtStartPrimeTime').timeEntry('getTime').getMinutes() - 1 <= 0) {
                    var minutes = $('#txtStartPrimeTime').timeEntry('getTime').getMinutes() - 1;
                    var hours = $('#txtStartPrimeTime').timeEntry('getTime').getHours();
                    if (minutes === -1)
                        $('#txtEndNPrimeTime').timeEntry('setTime', new Date(0, 0, 0, hours - 1, 59, 0));
                    else
                        $('#txtEndNPrimeTime').timeEntry('setTime', new Date(0, 0, 0, hours, 0, 0));
                }
                else {
                    var minute = $('#txtStartPrimeTime').timeEntry('getTime').getMinutes() - 1;
                    var hour = $('#txtStartPrimeTime').timeEntry('getTime').getHours();
                    $('#txtEndNPrimeTime').timeEntry('setTime', new Date(0, 0, 0, hour, minute, 0));
                }
            }
    });
}
function initializeSubMenu2() {
    $('.RightPanel li.has-sub>a').on('click', function () {
        $(this).removeAttr('href');
        var element = $(this).parent('li');
        if (element.hasClass('open')) {
            element.removeClass('open');
            element.find('li').removeClass('open');
            element.find('ul').slideUp(200);
        }
        else {
            element.addClass('open');
            element.children('ul').slideDown(200);
            element.siblings('li').children('ul').slideUp(200);
            element.siblings('li').removeClass('open');
            element.siblings('li').find('li').removeClass('open');
            element.siblings('li').find('ul').slideUp(200);
        }
    });
}
function AllsubmenuHide() {
    if (LayoutDirection_G == 'RTL') {
        $('.RightPanel').css('left', LeftpanelHideCss);
        $('.leftPanel').css('right', panelHideCss);
        $('#sideNavi').show();
    }
    else {
        $('.RightPanel').css('right', RightpanelHideCss);
        $('.leftPanel').css('left', panelHideCss);
        $('.MoreActionDiv').hide('slow');
        $('#sideNavi').show();
    }
}
function SearchOrShowAll(commandName, callOnSerach) {
    debugger;
    SearchCommand_G = commandName;
    if (callOnSerach)
        $('#hdnPageNo').val(1);

    if (commandName == "SHOW_ALL" || commandName == "CLEAR_ALL" || commandName == "") {
        if (commandName != "") {
            $('#txtSearchCommon, #txtAgreementNo, #txtStartDate, #txtEndDate').val('');
            _LayoutSetMinDt();
            _LayoutSetMaxDt();
            $('#ddlDealType').val('0').trigger("chosen:updated");
            $('#ddlLicensor').val('')[0].sumo.reload();
            $('#ddlTitle').val('')[0].sumo.reload();
            $('#ddlBusinessUnit').val($("#ddlBusinessUnit option:first-child").val()).trigger("chosen:updated");
        }

        SearchCommand_G = ""
        BindMusicDealList('', '', null, null, 0, 0, '', '', 'N');
    }
    else if (commandName == "SEARCH_COMMON") {
        var SearchText = $.trim($('#txtSearchCommon').val());
        if (SearchText == "") {
            $('#txtSearchCommon').val('').attr("required", true);
        }
        else {
            BindMusicDealList(SearchText, '', null, null, 0, 0, '', '', 'N');
        }
    }
    else if (commandName == "SEARCH_ADVANCE") {
        var isValid = true;
        var Agreement_No = $.trim($('#txtAgreementNo').val());
        var StartDate = $.trim($('#txtStartDate').val());
        var EndDate = $.trim($('#txtEndDate').val());
        var Deal_Type_Code = $('#ddlDealType').val();
        var Business_Unit_Code = $('#ddlBusinessUnit').val();
        var Vendor_Codes = $('#ddlLicensor').val();
        var Titles_Codes = $('#ddlTitle').val();
        var IsAdvance_Search = 'Y';

        if (StartDate != "") {
            StartDate = new Date(MakeDateFormate(StartDate));
            if (isNaN(StartDate)) {
                showAlert("E", 'Invalid Start Date', 'txtStartDate');
                isValid = false;
            }
        }
        if (EndDate != "") {
            EndDate = new Date(MakeDateFormate(EndDate));
            if (isNaN(EndDate)) {
                showAlert("E", 'Invalid End Date', 'txtEndDate');
                isValid = false;
            }
        }

        if (Vendor_Codes == null)
            Vendor_Codes = "";
        else
            Vendor_Codes = Vendor_Codes.join(',');

        if (Titles_Codes == null)
            Titles_Codes = "";
        else
            Titles_Codes = Titles_Codes.join(',');
        BindMusicDealList('', Agreement_No, StartDate, EndDate, Deal_Type_Code, Business_Unit_Code, Vendor_Codes, Titles_Codes, 'Y');
    }
}
function BindMusicDealList(SearchText, Agreement_No, StartDate, EndDate, Deal_Type_Code, Business_Unit_Code, Vendor_Codes, Titles_Codes, IsAdvance_Search) {
    debugger;

    var pageNo = $('#hdnPageNo').val();
    var recordPerPage = $('#txtPageSize').val();
    if (recordPerPage == "") {
        return false;
    }
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_BindMusicDealList,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        async: true,
        data: JSON.stringify({
            pageNo: pageNo,
            recordPerPage: recordPerPage,
            SearchText: SearchText,
            Agreement_No: Agreement_No,
            StartDate: StartDate,
            EndDate: EndDate,
            Deal_Type_Code: Deal_Type_Code,
            Business_Unit_Code: Business_Unit_Code,
            Vendor_Codes: Vendor_Codes,
            Title_Codes: Titles_Codes,
            IsAdvance_Search: IsAdvance_Search
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                debugger;
                $('#dvDealList').empty();
                $('#dvDealList').html(result);
                if (LayoutDirection_G == "RTL") {
                    $('.deal_action').css("width", "28%");
                }
                initializeExpander();
                initializeTooltip();
                hideLoading();
            }
        },
        error: function (result) {
            alert('Error in BindMusicDealList(): ' + result.responseText);
        }
    });
}
function BindAdvanceSearch(callFrom) {
    debugger;
    /* 
        Value fro 'callFrom' parameter.
        PGL : Called from Page Load $(document).ready event
        BTC : Called from Button Click (Advance Search Button)
    */
    if (callFrom == 'BTC')
        $('#divSearch').slideToggle(400);

    if ("RTL" == LayoutDirection_G) {
        $('#AdSearch').css("padding-right", "11px");
        $('.SumoSelect > .optWrapper.multiple > .options li.opt span, .SumoSelect .select-all > span').css("right", '-3px');
        $('.SumoSelect > .optWrapper > .options li.opt label, .SumoSelect > .CaptionCont, .SumoSelect .select-all > label').css("padding-right", "22px");
        $('.SumoSelect > .optWrapper > .options li.opt label, .SumoSelect > .CaptionCont, .SumoSelect .select-all > label').css("direction", "RTL");

    }
    else
        $('#AdSearch').css("padding-right", "0px");

    if (parseInt($("#ddlDealType option").length) == 0) {
        $.ajax({
            type: "POST",
            url: URL_BindAdvanceSearch,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            async: true,
            data: JSON.stringify({
                CallFrom: callFrom
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    debugger;
                    $(result.Deal_Type_List).each(function (index, item) {
                        $("#ddlDealType").append($("<option>").val(this.Value).text(this.Text));
                    });
                    $(result.Business_Unit_List).each(function (index, item) {
                        $("#ddlBusinessUnit").append($("<option>").val(this.Value).text(this.Text));
                    });

                    $(result.Vendor_List).each(function (index, item) {
                        $("#ddlLicensor").append($("<option>").val(this.Value).text(this.Text));
                    });

                    $(result.Title_List).each(function (index, item) {
                        $("#ddlTitle").append($("<option>").val(this.Value).text(this.Text));
                    });


                    $('#ddlDealType,#ddlBusinessUnit').trigger("chosen:updated");
                    $('#ddlLicensor')[0].sumo.reload();
                    $("#ddlTitle")[0].sumo.reload();


                    if (callFrom == "PGL") {
                        $('#txtAgreementNo').val(result.objPro_Deal_Search.Agreement_No);
                        $('#txtStartDate').val(result.objPro_Deal_Search.StartDate);
                        $('#txtEndDate').val(result.objPro_Deal_Search.EndDate);
                        $('#ddlDealType').val(result.objPro_Deal_Search.Deal_Type_Code).trigger("chosen:updated");

                        if (result.objPro_Deal_Search.Vendor_Codes != "") {
                            var arrSelectedVal = result.objPro_Deal_Search.Vendor_Codes.split(',')
                            $('#ddlLicensor').val(arrSelectedVal)[0].sumo.reload();
                        }
                        if (result.objPro_Deal_Search.Titles_Codes != "") {
                            var arrSelectedVal_Title = result.objPro_Deal_Search.Titles_Codes.split(',')
                            $('#ddlTitle').val(arrSelectedVal_Title)[0].sumo.reload();
                        }

                        if (result.objPro_Deal_Search.Business_Unit_Code > 0) {
                            $('#ddlBusinessUnit').val(result.objPro_Deal_Search.Business_Unit_Code).trigger("chosen:updated");
                        }

                        SearchOrShowAll("SEARCH_ADVANCE", false);
                    }
                }
            },
            error: function (result) {
                alert('Error in BindAdvanceSearch() : ' + result.responseText);
            }
        });
    }


}

//paging
function SetPaging() {
    IsCall = 'N';
    var pageNo = parseInt($('#hdnPageNo').val());
    var recordCount = parseInt($('#hdnRecordCount').val());
    var pagePerBatch = parseInt($('#hdnPagePerBatch').val());
    var recordPerPage = parseInt($('#txtPageSize').val());

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
    $('#hdnPageNo').val(pageNo);

    var opt = null;
    opt = { callback: pageselectCallback };
    opt["items_per_page"] = recordPerPage;
    opt["num_display_entries"] = pagePerBatch;
    opt["num"] = 10;
    opt["prev_text"] = "<<";
    opt["next_text"] = ">>";
    opt["current_page"] = index;
    $("#Pagination").pagination(recordCount, opt);
}
function pageselectCallback(page_index, jq) {
    $("[required='required']").removeAttr("required");
    $('.required').removeClass('required');

    if (!ValidatePageSize())
        return false;

    var pageNo = page_index + 1
    $('#hdnPageNo').val(pageNo);
    if (IsCall == 'Y')
        SearchOrShowAll(SearchCommand_G, false);
    else
        IsCall = 'Y';
}
function txtPageSize_OnChange() {
    $("[required='required']").removeAttr("required");
    $('.required').removeClass('required');
    if (!ValidatePageSize())
        return false;

    SearchOrShowAll(SearchCommand_G, false)
}
function pageBinding() {
    SearchOrShowAll(SearchCommand_G, false)
}
function ValidatePageSize() {
    var recordPerPage = $('#txtPageSize').val()
    if ($.trim(recordPerPage) != '') {
        var pageSize = parseInt(recordPerPage);
        if (pageSize > 0)
            return true;
    }
    $('#txtPageSize').attr('required', true)
    return false
}

//popup methods
function BindRunDef(DummyCode, key, is_AddEdit, isClone) {
    debugger;
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    if (is_AddEdit == "ADD") {
        $('#Multiple_Title').css("display", "");
        $('#Single_Title').css("display", "none");
        $('#hdn_Current_Action').val("")
        BindRunDefTitle();
        $('#divRunDefTitle').removeClass("required");
        $('#txtStartPrimeTime').val("")
        $('#txtEndPrimeTime').val("")
        $('#txtStartNPrimeTime').val("")
        $('#txtEndNPrimeTime').val("")
    }
    else if (is_AddEdit == "EDIT") {
        $('#Multiple_Title').css("display", "none");
        $('#Single_Title').css("display", "");
        $('#hdn_Current_Action').empty().val("EDIT_RD_MOVIE")
    }
    if (key == "DELETE_RD" && isClone == "Y")
        $('#hdnAction').val("")

    if (key == "DELETE_RD" || key == "CLONE_RD") {
        if (!checkCurrentAction()) {
            return false;
        }
    }
    if (key == "CLONE_RD")
        $('#hdnAction').val("EDIT_RC")
    if (key == "SHOW_ALL")
        $('#hdnAction').val("")
    showLoading();
    $('#popup').modal();
    $.ajax({
        type: "POST",
        url: URL_BindRunDef,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        data: JSON.stringify({
            DummyCode: DummyCode,
            key: key,
            is_AddEdit: is_AddEdit
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                debugger;
                $('#pupupHtml').empty();
                $('#pupupHtml').html(result);
                initializeChosen();
                initializeTooltip();
                hideLoading();
            }
        },
        error: function (result) {
            hideLoading();
            alert('Error: ' + result.responseText);
        }
    });
}

function BindSingleTitle(DummyCode,esp_From,esp_To) {
    debugger;
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    var isError = false;
    if ($('#' + esp_From).val() == "") {
        $('#' + esp_From).addClass("required");
        isError = true;
    }
    if ($('#' + esp_To).val() == "") {
        $('#' + esp_To).addClass("required");
        isError = true;
    }
    if (isError) {
        return false;
    }
    $('#Multiple_Title').css("display", "none");
    $('#Single_Title').css("display", "");
    $('#hdn_Current_Action').val("EDIT_RD_MOVIE")

    $.ajax({
        type: "POST",
        url: URL_BindSingleTitle,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            DummyCode: DummyCode
        }),
        async: false,
        success: function (result) {
            debugger;
            $('#hdn_minDate').val(result.Right_Start_date.substr(0, 10))
            $('#hdn_maxDate').val(result.Right_End_date.substr(0, 10))
            $('#hdn_UniqueID').text(result.Unique_ID)
            $('#Title_Name').text(result.Title_Name)
            $('#Title_Start_Date').text(result.Right_Start_date.substr(0, 10))
            $('#Title_End_Date').text(result.Right_End_date.substr(0, 10))
            $('#txtStartPrimeTime_Edit').val(result.Prime_Start_Time)
            $('#txtEndPrimeTime_Edit').val(result.Prime_End_Time)
            $('#txtStartNPrimeTime_Edit').val(result.Off_Prime_Start_Time)
            $('#txtEndNPrimeTime_Edit').val(result.Off_Prime_End_Time)
            $('#hdn_Title_dummycode').val(result.dummyTitleCode)
            BindRunDef(DummyCode, 'EDIT_RD_MOVIE', 'EDIT');
        },
        error: function (result) { }
    });
}

function CancelSaveDeal(key) {
    debugger;
    if (key =="VIEW") {
        BindPartialView("LIST", 0, 'B');
    }
    else {
        CommandName_G = "LIST_PAGE";
        showAlert("I", 'All Unsaved Data Will Be Lost Still Want To Go Ahead?', "OKCANCEL");
    }
}

function Save_Update_Run_Defination() {
    debugger;
    if (!checkCurrentAction()) {
        return false
    }

    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    $('#divRunDefTitle').removeClass("required");

    var formData = new FormData();
    var isEdit_rundefn = $('#hdn_Current_Action').val();
    if (isEdit_rundefn == "EDIT_RD_MOVIE") {
        if (!Validate_Save_RD("EDIT_RD_MOVIE")) {
            return false;
        }
        var Unique_ID = $('#hdn_UniqueID').text()
        var Prime_Start_Time = $('#txtStartPrimeTime_Edit').val()
        var Prime_End_Time = $('#txtEndPrimeTime_Edit').val()
        var Off_Prime_Start_Time = $('#txtStartNPrimeTime_Edit').val()
        var Off_Prime_End_Time = $('#txtEndNPrimeTime_Edit').val()

        formData.append("Unique_ID", Unique_ID);
        formData.append("Prime_Start_Time", Prime_Start_Time);
        formData.append("Prime_End_Time", Prime_End_Time);
        formData.append("Off_Prime_Start_Time", Off_Prime_Start_Time);
        formData.append("Off_Prime_End_Time", Off_Prime_End_Time);
        formData.append("isEdit_rundefn", "EDIT_RD_MOVIE");
    }
    else {
        if (!Validate_Save_RD("")) {
            return false;
        }
        var ddlRunDefTitle = $.trim($('#ddlRunDefTitle').val());
        var Prime_Start_Time = $('#txtStartPrimeTime').val()
        var Prime_End_Time = $('#txtEndPrimeTime').val()
        var Off_Prime_Start_Time = $('#txtStartNPrimeTime').val()
        var Off_Prime_End_Time = $('#txtEndNPrimeTime').val()

        formData.append("ddlRunDefTitle", ddlRunDefTitle);
        formData.append("Prime_Start_Time", Prime_Start_Time);
        formData.append("Prime_End_Time", Prime_End_Time);
        formData.append("Off_Prime_Start_Time", Off_Prime_Start_Time);
        formData.append("Off_Prime_End_Time", Off_Prime_End_Time);
        formData.append("isEdit_rundefn", "");
    }
    $.ajax({
        type: "POST",
        url: URL_Save_Update_Run_Defination,
        traditional: true,
        enctype: 'multipart/form-data',
        data: formData,
        dataType: 'json',
        contentType: false,
        processData: false,
        success: function (result) {
            debugger;
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.Status == "S") {
                    showAlert("S", result.Message);
                    ClosePopup();
                    BindRunDefTitle();
                }
                else {
                    showAlert("E", result.Message);
                }
            }
        },
        error: function (result) { }
    });
}

function ClosePopup() {
    debugger;
    //var recordLockingCode = parseInt($('#hdnRecodLockingCode').val())
    //if (recordLockingCode > 0)
    //    ReleaseRecordLock(recordLockingCode, URL_Release_Lock);
    if (!checkCurrentAction()) {
        return false
    }
    $('#txtStartPrimeTime').val("")
    $('#txtEndPrimeTime').val("")
    $('#txtStartNPrimeTime').val("")
    $('#txtEndNPrimeTime').val("")
    $('#hdnAction').val('')
    $.ajax({
        type: "POST",
        url: URL_Cancel_Run_Defination,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: '',
        async: false,
        success: function (result) {
            debugger;
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.Status == "S") {
                    $('#popup').modal('hide');
                    $('#pupupHtml').empty();
                }
            }
        },
        error: function (result) { }
    });
}

function Cancel_Run_Defination() {
    if (!checkCurrentAction()) {
        return false
    }
    $('#txtStartPrimeTime').val("")
    $('#txtEndPrimeTime').val("")
    $('#txtStartNPrimeTime').val("")
    $('#txtEndNPrimeTime').val("")
    $('#hdnAction').val('')
    $.ajax({
        type: "POST",
        url: URL_Cancel_Run_Defination,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Title_dummycode: $('#hdn_Title_dummycode').val()
        }),
        async: false,
        success: function (result) {
            debugger;
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.Status == "S") {
                    ClosePopup();
                }
            }
        },
        error: function (result) { }
    });
}

//channel methods
function checkCurrentAction() {
    debugger;
    var action = $.trim($('#hdnAction').val());
    if (action == "ADD_RC") {
        showAlert("E", "Complete Add Operation First")
        return false;
    }
    else if (action == "EDIT_RC") {
        showAlert("E", "Complete Edit Operation First")
        return false;
    }
    else if (action == "DELETE_EDIT_CHN") {
        showAlert("E", "Complete Edit Operation First")
        return false;
    }
    return true;
}

function AddEditRunChannel(RunChannelDummyguid, commandName, ChannelDummyGuid) {
    debugger;
    if (commandName == "DELETE_EDIT_CHN" && $('.removeChannel').hasClass("disabled")) {
        return false;
    }
    if (commandName != "DELETE_EDIT_CHN") {
        if (!checkCurrentAction()) {
            return false
        }
    }
    if (commandName == "ADD_RC") {
        var isError = 'N';
        var date1 = "";
        var counter = 0;
        $('#Multiple_Title .SumoSelect option').each(function (i) {
            debugger;
            if ($(this)[0].selected == true) {
                if (counter == 0) {
                    date1 = $(this)[0].text.substr($(this)[0].text.length - 25);
                    counter += 1;
                }
                else {
                    if (date1 != $(this)[0].text.substr($(this)[0].text.length - 25)) {
                        isError = 'Y'
                        showAlert("E", "Rights Period for the selected Title is not matching.");
                    }
                }
            }
        });
        if (isError == "Y") {
            $('#hdn_min_maxstartdate').val("");
            return false;
        }
    }
    $.ajax({
        type: "POST",
        url: URL_AddEditRunChannel,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            RunChannelDummyguid: RunChannelDummyguid,
            commandName: commandName,
            ChannelDummyGuid: ChannelDummyGuid
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                debugger;
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    if (result.Status == "S") {
                        if (commandName == "ADD_RC") {
                            BindRunDef("", "ADD_RD")
                        }
                        else if (commandName == "EDIT_RC" || commandName == "DELETE_EDIT_CHN") { //|| commandName == "ADD_EDIT_CHN"
                            BindRunDef(RunChannelDummyguid, "EDIT_RD")
                        }
                        else {
                            BindRunDef("", "SHOW_ALL")
                        }
                    }
                    $('#hdnAction').val(commandName)
                }
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });

}

//added update delete channel;

function SaveUpdate_RUN_CHANNEL(dummy_GUID, key, counter, isClone) {
    debugger;
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    $('#div_Channel_Edit').removeClass('required');

    var formData = new FormData();
    if (key == "ADD") {
        if (!Validate_Save_RC()) {
            //mybutton_counter = 0;
            return false;
        }

        var Chk_Run_Type = $("#Chk_Run_Type").prop("checked");
        var ddlChannel = $.trim($('#ddlChannel').val());
        var Start_Date = $.trim($('#Start_Date_Add').val());
        var End_Date = $.trim($('#End_Date_Add').val());
        var run = $.trim($('#run').val());
        var ddlRightRule = $.trim($('#ddlRightRule').val());
        var txtSimulcast = $.trim($('#txtSimulcast').val());
        var Prime = $.trim($('#Prime').val());
        var Off_Prime = $.trim($('#Off_Prime').val());

        formData.append("Chk_Run_Type", Chk_Run_Type);
        formData.append("dummy_GUID", dummy_GUID);
        formData.append("ddlChannel", ddlChannel);
        formData.append("Start_Date", Start_Date);
        formData.append("End_Date", End_Date);
        formData.append("run", run);
        formData.append("ddlRightRule", ddlRightRule);
        formData.append("txtSimulcast", txtSimulcast);
        formData.append("Prime", Prime);
        formData.append("Off_Prime", Off_Prime);
    }
    else if (key == "UPDATE") {
        if (!Validate_Update_RC(counter, isClone)) {
            //mybutton_counter = 0;
            return false;
        }
        debugger;
        var cmd = "";
        var ddlChannel_chn = "", Start_Date_chn = "", End_Date_chn = "";
        if ($('#hdn_AddChn').val() == "NEW_CHN") {
            cmd = "NEW_CHN";
        }
        if (cmd == "NEW_CHN") {
            ddlChannel_chn = $.trim($('#ddlChannelAddEdit').val());
            Start_Date_chn = $.trim($('#Start_Date_Edit_chn').val());
            End_Date_chn = $.trim($('#End_Date_Edit_chn').val());
            formData.append("ddlChannel_chn", ddlChannel_chn);
            formData.append("Start_Date_chn", Start_Date_chn);
            formData.append("End_Date_chn", End_Date_chn);
        }

        var Start_Date_Hash = "", End_Date_Hash = "";
        for (var i = 0; i < counter; i++) {
            Start_Date_Hash += $.trim($('#Start_Date_Edit_' + i).val()) + ","
            End_Date_Hash += $.trim($('#End_Date_Edit_' + i).val()) + ","
        }
        var run_Edit = $.trim($('#run_Edit').val());
        var ddlRightRule_Edit = $.trim($('#ddlRightRule_Edit').val());
        var txtSimulcast_Edit = $.trim($('#txtSimulcast_Edit').val());
        var Prime_Edit = $.trim($('#Prime_Edit').val());
        var Off_Prime_Edit = $.trim($('#Off_Prime_Edit').val());
        var Chk_Run_Type_Edit = $("#Chk_Run_Type_Edit").prop("checked");
        if (isClone == "Y") {
            var ddlChannel_Edit = $('#ddlChannel_Edit').val();
            formData.append("ddlChannel_Edit", ddlChannel_Edit);
        }
        else {
            isClone = "N";
        }

        formData.append("Chk_Run_Type_Edit", Chk_Run_Type_Edit);
        formData.append("isClone", isClone);
        formData.append("dummy_GUID", dummy_GUID);
        formData.append("Start_Date_Edit", Start_Date_Hash);
        formData.append("End_Date_Edit", End_Date_Hash);
        formData.append("run_Edit", run_Edit);
        formData.append("ddlRightRule_Edit", ddlRightRule_Edit);
        formData.append("txtSimulcast_Edit", txtSimulcast_Edit);
        formData.append("Prime_Edit", Prime_Edit);
        formData.append("Off_Prime_Edit", Off_Prime_Edit);
        formData.append("counter", counter);
        formData.append("cmd", cmd);
    }

    showLoading();
    $.ajax({
        type: "POST",
        url: URL_SaveUpdate_RUN_CHANNEL,
        traditional: true,
        enctype: 'multipart/form-data',
        data: formData,
        dataType: 'json',
        contentType: false,
        processData: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.Status == "S") {
                    debugger;
                    $('#hdnAction').val("")     
                    BindRunDef()
                    hideLoading();
                }
                else {
                    showAlert("E", result.Message);
                    hideLoading();
                }
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}

function OnChangeBindTitle(callFrom) {
    debugger;
    var dealTypeVal = $('#ddlDealType').val();
    var ddlBU = $('#ddlBusinessUnit').val();
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
                $("#ddlTitle").empty();
                $(result).each(function (index, item) {
                    $("#ddlTitle").append($("<option>").val(this.Value).text(this.Text));
                });
                $("#ddlTitle").val('')[0].sumo.reload();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
    if (dealTypeVal == Deal_Type_Content || dealTypeVal == Deal_Type_Format_Program || dealTypeVal == Deal_Type_Event || dealTypeVal == Deal_Type_Documentary_Show || dealTypeVal == Deal_Type_Sports)
        $("#chkSubDeal").removeAttr("checked");
}

function Cancel_RUN_CHANNEL(guid) {
    debugger;
    $('#hdn_recentCloseOnFocus').val(guid)
    $('#hdnAction').val("")
    BindRunDef(guid, "SHOW_ALL");
}
//end popup methods

// Add_Edit_Pro_Deal
function OnFocusLostTerm() {
    debugger;
    var canAssign = true;
    var txtStartDate = $('#Start_Date');
    var txtEndDate = $('#End_Date');
    var txtTermYear = $('#Term_YY');
    var txtTermMonth = $('#Term_MM');

    if (txtTermYear.val() == '' || isNaN(txtTermYear.val()))
        txtTermYear.val('0');
    if (txtTermMonth.val() == '' || isNaN(txtTermMonth.val()))
        txtTermMonth.val('0');

    if (txtStartDate.val() != "") {
        var rightSD = new Date(MakeDateFormate(txtStartDate.val()));
        if (!isNaN(rightSD)) {

            var year = 0;
            var month = 0;

            if (txtTermYear.val() != '')
                year = parseInt(txtTermYear.val());
            if (txtTermMonth.val() != '')
                month = parseInt(txtTermMonth.val());

            if (year > 0 || month > 0) {
                var newDate = CalculateEndDate(rightSD, year, month, 0);
                if (canAssign) {
                    txtEndDate.val(newDate);
                }
                else {
                    txtEndDate.val('');
                }
            }
            else {
                txtEndDate.val('');
            }
        }
    }
    else if (txtEndDate.val() != "") {
        var rightED = new Date(MakeDateFormate(txtEndDate.val()));
        if (!isNaN(rightED)) {

            var year = 0;
            var month = 0;

            if (txtTermYear.val() != '')
                year = parseInt(txtTermYear.val());
            if (txtTermMonth.val() != '')
                month = parseInt(txtTermMonth.val());

            if (year > 0 || month > 0) {
                var newDate = CalculateStartDate(rightED, year, month);
                txtStartDate.val(newDate);
            }
            else {
                txtStartDate.val('');
            }
        }
    }
    else {
        txtTermYear.val('0');
        txtTermMonth.val('0');
    }
}
function AutoPopulateTerm() {
    var txtStartDate = $('#Start_Date');
    var txtEndDate = $('#End_Date');
    var rightSD = new Date(MakeDateFormate(txtStartDate.val()));
    var rightED = new Date(MakeDateFormate(txtEndDate.val()));

    if (!isNaN(rightSD) && !isNaN(rightED)) {
        rightED.setDate(rightED.getDate() + 1);
        var term = CalculateTerm(rightSD, rightED);
        var arr = term.split('.');
        $('#Term_YY').val(arr[0]);
        $('#Term_MM').val(arr[1]);
    }
}
function SetMaxDt() {
    setMinMaxDates('Start_Date', '', $('#End_Date').val());
}
function SetMinDt() {
    setMinMaxDates('End_Date', $('#Start_Date').val(), '');
}
function CalculateTerm(startDate, endDate) {
    var val = CalculateMonthBetweenTwoDate(startDate, endDate);
    var year = val / 12;
    var month = val % 12;
    var term = parseInt(year) + '.' + month;
    return term;
}
function MakeDateFormate(dateInString) {
    if (dateInString != null || dateInString != "") {
        var array = dateInString.split('/');
        var month = parseFloat(array[1]);
        switch (month) {
            case 1:
                array[1] = "Jan";
                //array[1] = "01";
                break;

            case 2:
                //array[1] = "Feb";
                array[1] = "02";
                break;

            case 3:
                //array[1] = "Mar";
                array[1] = "03";
                break;

            case 4:
                //array[1] = "Apr";
                array[1] = "04";
                break;

            case 5:
                //array[1] = "May";
                array[1] = "05";
                break;

            case 6:
                //array[1] = "Jun";
                array[1] = "06";
                break;

            case 7:
                //array[1] = "Jul";
                array[1] = "07";
                break;

            case 8:
                //array[1] = "Aug";
                array[1] = "08";
                break;

            case 9:
                //array[1] = "Sep";
                array[1] = "09";
                break;

            case 10:
                //array[1] = "Oct";
                array[1] = "10";
                break;

            case 11:
                //array[1] = "Nov";
                array[1] = "11";
                break;

            case 12:
                //array[1] = "Dec";
                array[1] = "12";
                break;
        }

        //if ($.browser.chrome) {

        //} else if ($.browser.mozilla) {
        //    alert(2);
        //} else if ($.browser.msie) {
        //    alert(3);
        //}
        var format = array[2] + "-" + array[1] + "-" + array[0];
        return format;
    }
    return "";
}
function CalculateMonthBetweenTwoDate(startDate, endDate) {
    var months = (endDate.getFullYear() - startDate.getFullYear()) * 12;
    months += endDate.getMonth() - startDate.getMonth();

    if (endDate.getDate() < startDate.getDate())
        months--;
    return months;
}
function CalculateEndDate(startDate, year, month, days) {
    var yearToMonth = 12 * year;
    month = month + yearToMonth;
    startDate.setMonth(startDate.getMonth() + month);
    startDate.setDate(startDate.getDate() + days);
    startDate.setDate(startDate.getDate() - 1);
    var newDateStr = ConvertDateToCurrentFormat(startDate);
    return newDateStr;
}
function CalculateStartDate(startDate, year, month) {
    debugger;
    var yearToMonth = 12 * year;
    month = month + yearToMonth;
    startDate.setMonth(startDate.getMonth() - month);
    startDate.setDate(startDate.getDate() + 1);
    var newDateStr = ConvertDateToCurrentFormat(startDate);
    return newDateStr;
}
function ConvertDateToCurrentFormat(objDate) {
    var dd = objDate.getDate();
    var mm = objDate.getMonth() + 1; //January is 0!
    var yyyy = objDate.getFullYear();

    if (dd < 10)
        dd = '0' + dd

    if (mm < 10)
        mm = '0' + mm

    var newDate = dd + '/' + mm + '/' + yyyy;
    return newDate;
}

function BindListTitle(row, action) {
    debugger;
    $.ajax({
        type: "POST",
        url: URL_BindTitleList,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            row: row,
            action: action
        }),
        success: function (result) {
            debugger;
            $("#tblDealFor").empty();
            $("#tblDealFor").html(result);
            if ($("#tblProTitle tr:not(:has(th))").length > 0) {
                $('input[name="Deal_Type_Code"]').attr('disabled', true);
            }
            initializeTooltip();
            BindRunDefTitle();
        },
        error: function (result) { }
    });
}
function BindRunDefTitle() {
    debugger;
    $.ajax({
        type: "POST",
        url: URL_BindRunDefTitle,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: '',
        async: false,
        success: function (result) {
            debugger;
            $("#ddlRunDefTitle").empty();
            $('#ddlRunDefTitle').SumoSelect();
            $(result.lst_ddlRunDefTitle).each(function (index, item) {
                $("#ddlRunDefTitle").append($("<option>").val(this.Value).text(this.Text));
            });
            $('#ddlRunDefTitle')[0].sumo.reload();
        },
        error: function (result) { }
    });
}


// List_Title
function tblTitle_CommonAction(guid, row, action) {
    if (action == "DELETE") {
        DeleteTitle(guid, row);
    } else {
        BindListTitle(row, action);
    }
}
function DeleteTitle(guid, row) {
    debugger;
    $("#hdn_Title_Codes").val("");
    $.ajax({
        type: "POST",
        url: URL_DeleteTitle,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            guid: guid
        }),
        success: function (result) {
            var dealTypeCode = $("input[name='Deal_Type_Code']:radio:checked").val();
            if (dealTypeCode == "1") {
                debugger;
                var searchString = $.trim($("#txtSearchTitle").val());
                $.ajax({
                    type: "POST",
                    url: URL_GetProDealTitleNotIn,
                    traditional: true,
                    enctype: 'multipart/form-data',
                    contentType: "application/json; charset=utf-8",
                    async: false,
                    data: JSON.stringify({
                        DealForCode: 1,
                        searchString: "",
                        removeTitleCode: "",
                        action: "D"
                    }),
                    success: function (result) {
                        debugger;
                        if (result == "true") {
                            redirectToLogin();
                        }
                        else {
                            $("#ddlTitle").html("");
                            $.each(result, function (i, Form_ID) {
                                $("#ddlTitle").append($('<option></option>').val(result[i].Title_Code).html(result[i].Title_Name));
                            });
                            $('#ddlTitle')[0].sumo.reload();
                            $("#txtSearchTitle").val("");
                        }
                    },
                    error: function (result) { }
                });
            }
            BindListTitle(0, "");
            if ($("#tblProTitle tr:not(:has(th))").length == 0) {
                $('input[name="Deal_Type_Code"]').attr('disabled', false);
            }
        },
        error: function (result) { }
    });
}
function addNumeric() {
    $("input.numeric").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        max: 9999,
        min: 1
    });
}
function OnEditSave_Title(guid, row) {
    debugger;
    var returnVal = true;

    var lblRight_End_Date = $.trim($("#lblRight_End_Date_" + row).val());
    var lblRight_Start_Date = $.trim($("#lblRight_Start_Date_" + row).val());
    var txtEpisode_From = $.trim($("#txtEpisode_From_" + row).val());
    var txtEpisode_To = $.trim($("#txtEpisode_To_" + row).val());
    var Term_YY = $.trim($("#Term_YY_" + row).val());
    var Term_MM = $.trim($("#Term_MM_" + row).val());

    if (txtEpisode_From == "" || txtEpisode_To == "") {
        txtEpisode_To = 1; txtEpisode_From = 1;
    }

    if (lblRight_End_Date == "") {
        $("#lblRight_End_Date_" + row).addClass("required");
        returnVal = false;
    }
    if (lblRight_Start_Date == "") {
        $("#lblRight_Start_Date_" + row).addClass("required");
        returnVal = false;
    }
    if (Term_YY == "") {
        $("#Term_YY_" + row).addClass("required");
        returnVal = false;
    }

    if (Term_MM == "") {
        $("#Term_MM_" + row).addClass("required");
        returnVal = false;
    }

    var dateFrom = $.trim($("#lblRight_Start_Date_" + row).val());
    var dateTo = $.trim($("#lblRight_End_Date_" + row).val());
    var dateCheck_startDate = $('#Start_Date').val()
    var dateCheck_endDate = $('#End_Date').val();

    var d1 = dateFrom.split("/");
    var d2 = dateTo.split("/");
    var c = dateCheck_startDate.split("/");
    var d = dateCheck_endDate.split("/");

    var from = new Date(d1[2], parseInt(d1[1]) - 1, d1[0]);  // -1 because months are from 0 to 11
    var to = new Date(d2[2], parseInt(d2[1]) - 1, d2[0]);
    var check_start = new Date(c[2], parseInt(c[1]) - 1, c[0]);
    var check_end = new Date(d[2], parseInt(d[1]) - 1, d[0]);

    if (from < check_start) {
        showAlert("E", "Start Date of Title should not be less than  Period's Start Date ");
        returnVal = false;
    } else if (from > check_end) {
        showAlert("E", "Start Date of Title should be between Period's Start Date & End's Date");
        returnVal = false;
    } else if (to > check_end) {
        showAlert("E", "End Date of Title should not be greater than between Period's End Date");
        returnVal = false;
    } else if (to < check_start) {
        showAlert("E", "End Date of Title  should be between Period's Start Date & End's Date");
        returnVal = false;
    }

    if (returnVal == false) {
        return returnVal;
    }

    $.ajax({
        type: "POST",
        url: URL_UpdateTitle,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            guid: guid,
            Start_Date: lblRight_Start_Date,
            End_Date: lblRight_End_Date,
            Episode_From: txtEpisode_From,
            Episode_To: txtEpisode_To,
            Term_YY: Term_YY,
            Term_MM: Term_MM
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            } else {
                if (result.Status == "E") {
                    showAlert('E', result.Error_Message);
                    returnVal = false;
                } else {
                    BindListTitle(0, "");
                }
            }
        },
        error: function (result) { }
    });
}


function Ask_Confirmation_Title_Del(confirmMsg, dummyGuid, rowIndex, commandName) {
    if (Command_Name == "") {
        Command_Name = null;
    }
    Dummy_Guid = dummyGuid;
    Row_Index = rowIndex;
    Command_Name = commandName;
    if (commandName == "DELETE") {
        showAlert("I", confirmMsg, "OKCANCEL");
    }
}
function handleOk() {
    debugger;
    if (Command_Name == "DELETE_PRO_DEAL") {
        DeleteProvisionalDeal(key_G, PDCode_G, Mode_G, true);
    }
    if (Command_Name == "DELETE") {
        tblTitle_CommonAction(Dummy_Guid, Row_Index, Command_Name);
    }
    if (Command_Name == "REDIRECT_PAGE") {
        window.location.href = Redirect_URL;
    }
    if (Command_Name == 'CANCEL_SAVE_DEAL') {
        location.href = URL_Cancel;
    }
  
    if (CommandName_G == "LIST_PAGE") {
        CommandName_G = "";
        BindPartialView("LIST", 0, 'B');
    }
}
function handleCancel() {
    debugger;
    CommandName_G = "";
    Command_Name = null;
    PDCode_G = "";
    key_G = "";
    Mode_G = "";
    BindListTitle(0, "");
}


//validation
function Validate_Save_RC() {
    var returnVal = true;
    var addition = true;
    var is_Blank = 'N';
    debugger;
    if ($('#txtSimulcast').val() == "00:00") {
        $('#txtSimulcast').val('')
    }

    if ($.trim($('#Start_Date_Add').val()) == "") {
        $('#Start_Date_Add').val('')
        $('#Start_Date_Add').attr('required', true)
        returnVal = false;
    }
    if ($.trim($('#End_Date_Add').val()) == "") {
        $('#End_Date_Add').val('')
        $('#End_Date_Add').attr('required', true)
        returnVal = false;
    }

    if (!$("#Chk_Run_Type").prop("checked")) {
        if ($.trim($('#run').val()) == "") {
            $('#run').val('')
            $('#run').attr('required', true)
            addition = false;
            returnVal = false;
        }
        if ($.trim($('#Prime').val()) == "") {
            $('#Prime').val('0')
        }
        if ($.trim($('#Off_Prime').val()) == "") {
            $('#Off_Prime').val('0')
        }
        if ($('#Prime').val() == "0" && $('#Off_Prime').val() == "0") {
            addition = false;
        }
    }
    else
        addition = false;
  
    var channelCodes = $('#ddlChannel').val();
    if (channelCodes == null) {
        $('#divChannel').addClass("required");
        returnVal = false;
    }


    if ($('#Start_Date_Add').val() != "" && $('#End_Date_Add').val() != "") {
        var dateFrom = $('#hdn_minDate').val();
        var dateTo = $('#hdn_maxDate').val();
        var dateCheck_startDate = $('#Start_Date_Add').val()
        var dateCheck_endDate = $('#End_Date_Add').val()

        var d1 = dateFrom.split("/");
        var d2 = dateTo.split("/");
        var c = dateCheck_startDate.split("/");
        var d = dateCheck_endDate.split("/");

        var from = new Date(d1[2], parseInt(d1[1]) - 1, d1[0]);  // -1 because months are from 0 to 11
        var to = new Date(d2[2], parseInt(d2[1]) - 1, d2[0]);
        var check_c = new Date(c[2], parseInt(c[1]) - 1, c[0]);
        var check_d = new Date(d[2], parseInt(d[1]) - 1, d[0]);

        if (check_c <= check_d) {
            if (check_c >= from && check_c <= to) {
                if (!(check_d >= from && check_d <= to)) {
                    showAlert("E", "End Date is not in between Title Startdate and Title end date")
                    returnVal = false;
                }
            }
            else {
                showAlert("E", "Start Date is not in between Title Startdate and Title end date")
                returnVal = false;
            }
        }
        else {
            showAlert("E", "Start Date should be less than End date")
            returnVal = false;
        }
    }

    //if (is_Blank == 'N') {
    if (addition) {
        var run = $.trim($('#run').val())
        var Prime = $.trim($('#Prime').val())
        var Off_Prime = $.trim($('#Off_Prime').val())
        var sum = parseInt(Prime) + parseInt(Off_Prime)
        if (sum != parseInt(run)) {
            showAlert("E", "The total of Prime And OffPrime should be equal to Runs")
            returnVal = false;
        }
    }
  
    return returnVal;
}
function Validate_Update_RC(counter, isClone) {
    var returnVal = true;
    var addition = true;
    if (isClone == "Y") {
        var ddlChannel_Edit = $('#ddlChannel_Edit').val();
        if (ddlChannel_Edit == null) {
            $('#div_Channel_Edit').addClass("required");
            returnVal = false;
        }
    }
    var is_Blank = 'N';
    debugger;
   
    var isError = "N";
    if ($('#txtSimulcast_Edit').val() == "00:00") {
        $('#txtSimulcast_Edit').val('')
    }

    if (counter > 0) {
        for (var i = 0; i < counter; i++) {
            if ($.trim($('#Start_Date_Edit_' + i).val()) == "") {
                $('#Start_Date_Edit_' + i).val('')
                $('#Start_Date_Edit_' + i).attr('required', true)
                isError = "Y";
                returnVal = false;
            }
            if ($.trim($('#End_Date_Edit_' + i).val()) == "") {
                $('#End_Date_Edit_' + i).val('')
                $('#End_Date_Edit_' + i).attr('required', true)
                isError = "Y";
                returnVal = false;
            }
        }
    }

    if (!$("#Chk_Run_Type_Edit").prop("checked")) {
        if ($.trim($('#run_Edit').val()) == "") {
            $('#run_Edit').val('')
            $('#run_Edit').attr('required', true)
            addition = false;
            returnVal = false;
        }
        if ($.trim($('#Prime_Edit').val()) == "") {
            $('#Prime_Edit').val('0')
        }
        if ($.trim($('#Off_Prime_Edit').val()) == "") {
            $('#Off_Prime_Edit').val('0')
        }
        if ($('#Prime_Edit').val() == "0" && $('#Off_Prime_Edit').val() == "0") {
            addition = false;
        }
    }
    else
        addition = false;

    var dateFrom = $('#hdn_minDate').val();
    var dateTo = $('#hdn_maxDate').val();
    var d1 = dateFrom.split("/");
    var d2 = dateTo.split("/");
    var from = new Date(d1[2], parseInt(d1[1]) - 1, d1[0]);  // -1 because months are from 0 to 11
    var to = new Date(d2[2], parseInt(d2[1]) - 1, d2[0]);

    if (isError != "Y") {
        if (counter > 0) {
            for (var i = 0; i < counter; i++) {

                var dateCheck_startDate = $('#Start_Date_Edit_' + i).val()
                var dateCheck_endDate = $('#End_Date_Edit_' + i).val()

                var c = dateCheck_startDate.split("/");
                var d = dateCheck_endDate.split("/");

                var check_c = new Date(c[2], parseInt(c[1]) - 1, c[0]);
                var check_d = new Date(d[2], parseInt(d[1]) - 1, d[0]);

                if (check_c <= check_d) {
                    if (check_c >= from && check_c <= to) {
                        if (!(check_d >= from && check_d <= to)) {
                            showAlert("E", "End Date is not in between Title Startdate and Title end date")
                            returnVal = false;
                        }
                    }
                    else {
                        showAlert("E", "Start Date is not in between Title Startdate and Title end date")
                        returnVal = false;
                    }
                }
                else {
                    showAlert("E", "Start Date should be less than End date")
                    returnVal = false;
                }
            }
        }
    }

    if ($('#Add_Chn').hasClass('clicked')) {

        var ChannelAddEdit = $('#ddlChannelAddEdit').val();
        if (ChannelAddEdit == null) {
            $('#div_ChannelAddEdit').addClass("required");
            returnVal = false;
        }
        debugger;
        var dateCheck_startDate = $('#Start_Date_Edit_chn').val()
        var dateCheck_endDate = $('#End_Date_Edit_chn').val()

        var c = dateCheck_startDate.split("/");
        var d = dateCheck_endDate.split("/");

        var check_c = new Date(c[2], parseInt(c[1]) - 1, c[0]);
        var check_d = new Date(d[2], parseInt(d[1]) - 1, d[0]);

        if (check_c <= check_d) {
            if (check_c >= from && check_c <= to) {
                if (!(check_d >= from && check_d <= to)) {
                    showAlert("E", "End Date of new channel is not in between Title Startdate and Title end date")
                    returnVal = false;
                }
            }
            else {
                showAlert("E", "Start Date of new channel is not in between Title Startdate and Title end date")
                returnVal = false;
            }
        }
        else {
            showAlert("E", "Start Date of new channel should be greater than End date")
            returnVal = false;
        }
    }

    //if (is_Blank == 'N') {
    if (addition) {
        var run = $.trim($('#run_Edit').val())
        var Prime = $.trim($('#Prime_Edit').val())
        var Off_Prime = $.trim($('#Off_Prime_Edit').val())
        var sum = parseInt(Prime) + parseInt(Off_Prime)
        if (sum != parseInt(run)) {
            showAlert("E", "The toltal of Prime And OffPrime should be equal to Runs")
            returnVal = false;
        }
    }
  
    return returnVal;
}
function Validate_Save_RD(callFrom) {
    var returnVal = true;

    if (callFrom != "EDIT_RD_MOVIE") {

        var RunDefTitleCodes = $('#ddlRunDefTitle').val()
        if (RunDefTitleCodes == null) {
            $('#divRunDefTitle').addClass("required");
            returnVal = false;
        }

        if ($.trim($('#txtStartPrimeTime').val()) != "" ||
            $.trim($('#txtEndPrimeTime').val()) != "" ||
            $.trim($('#txtStartNPrimeTime').val()) != "" ||
            $.trim($('#txtEndNPrimeTime').val()) != "") {

            if ($.trim($('#txtStartPrimeTime').val()) == "") {
                $('#txtStartPrimeTime').val('')
                $('#txtStartPrimeTime').attr('required', true)
                returnVal = false;
            }
            if ($.trim($('#txtEndPrimeTime').val()) == "") {
                $('#txtEndPrimeTime').val('')
                $('#txtEndPrimeTime').attr('required', true)
                returnVal = false;
            }
            if ($.trim($('#txtStartNPrimeTime').val()) == "") {
                $('#txtStartNPrimeTime').val('')
                $('#txtStartNPrimeTime').attr('required', true)
                returnVal = false;
            }
            if ($.trim($('#txtEndNPrimeTime').val()) == "") {
                $('#txtEndNPrimeTime').val('')
                $('#txtEndNPrimeTime').attr('required', true)
                returnVal = false;
            }
        }
    }
    else {
        if ($.trim($('#txtStartPrimeTime_Edit').val()) != "" ||
           $.trim($('#txtEndPrimeTime_Edit').val()) != "" ||
           $.trim($('#txtStartNPrimeTime_Edit').val()) != "" ||
           $.trim($('#txtEndNPrimeTime_Edit').val()) != "") {

            if ($.trim($('#txtStartPrimeTime_Edit').val()) == "") {
                $('#txtStartPrimeTime_Edit').val('')
                $('#txtStartPrimeTime_Edit').attr('required', true)
                returnVal = false;
            }
            if ($.trim($('#txtEndPrimeTime_Edit').val()) == "") {
                $('#txtEndPrimeTime_Edit').val('')
                $('#txtEndPrimeTime_Edit').attr('required', true)
                returnVal = false;
            }
            if ($.trim($('#txtStartNPrimeTime_Edit').val()) == "") {
                $('#txtStartNPrimeTime_Edit').val('')
                $('#txtStartNPrimeTime_Edit').attr('required', true)
                returnVal = false;
            }
            if ($.trim($('#txtEndNPrimeTime_Edit').val()) == "") {
                $('#txtEndNPrimeTime_Edit').val('')
                $('#txtEndNPrimeTime_Edit').attr('required', true)
                returnVal = false;
            }
        }
    }

    return returnVal;
}
function GetDealTypeCondition(selectedDealTypeCode) {
    debugger;
    if (selectedDealTypeCode == Deal_Type_Content || selectedDealTypeCode == Deal_Type_Sports || selectedDealTypeCode == Deal_Type_Format_Program
        || selectedDealTypeCode == Deal_Type_Event || selectedDealTypeCode == Deal_Type_Documentary_Show) {
        return Deal_Program;
    }
}
function ValidateEpisodeOverlapping() {
    debugger;
    var DealforCode = $("input[name=Deal_Type_Code]:checked").val();
    var tblProTitle = $("#tblProTitle tr:not(:has(th))");
    var dealTypeCondition = GetDealTypeCondition(DealforCode);
    var returnVal = true;
    var emptyCount = 0;
    var errorMessage = "";

    if (dealTypeCondition == Deal_Program) {
        tblProTitle.each(function (rowId_Outer) {
            if (returnVal == false)
                return false;

            var txtEpisodeFrom_Outer = $(this).find("input[id*='txtEpisode_From_'][type='text']");
            var txtEpisodeTo_Outer = $(this).find("input[id*='txtEpisode_To_'][type='text']");
            var titleCode_outer = parseInt($(this).find("input[id*='hdnTitleCode']").val());
            var episodeFrom_Outer = parseInt(txtEpisodeFrom_Outer.val());
            var episodeTo_Outer = parseInt(txtEpisodeTo_Outer.val());

            if (!isNaN(episodeFrom_Outer) && !isNaN(episodeTo_Outer)) {
                tblProTitle.each(function (rowId_Inner) {
                    debugger;
                    var txtEpisodeFrom_Inner = $(this).find("input[id*='txtEpisode_From_'][type='text']");
                    var txtEpisodeTo_Inner = $(this).find("input[id*='txtEpisode_To_'][type='text']");
                    var episodeFrom_Inner = parseInt(txtEpisodeFrom_Inner.val());
                    var episodeTo_Inner = parseInt(txtEpisodeTo_Inner.val());
                    var titleCode_inner = parseInt($(this).find("input[id*='hdnTitleCode']").val());

                    if (!isNaN(episodeFrom_Inner) && !isNaN(episodeTo_Inner)) {
                        var txtFrom = null, txtTo = null;
                        if (episodeFrom_Inner == 0 || episodeTo_Inner == 0) {
                            if (episodeFrom_Inner == 0)
                                txtFrom = txtEpisodeFrom_Inner[0];

                            if (episodeTo_Inner == 0)
                                txtTo = txtEpisodeTo_Inner[0];

                            errorMessage = "Episode No. must be greater than 0";


                            returnVal = false;
                        }
                        else if (episodeFrom_Inner > episodeTo_Inner) {
                            txtFrom = null;
                            txtTo = txtEpisodeTo_Inner[0];
                            errorMessage = "Episode From cannot be greater than Episode To"

                            returnVal = false;
                        }

                        var maxEpisode_From = parseInt($(this).find("input[id*='hdnMaximumEpisodeFrom'][type='hidden']").val());
                        var minEpisode_To = parseInt($(this).find("input[id*='hdnMininumEpisodeTo'][type='hidden']").val());

                        if (!isNaN(maxEpisode_From) && !isNaN(minEpisode_To) && returnVal) {
                            if (episodeFrom_Inner > maxEpisode_From && maxEpisode_From > 0) {
                                txtFrom = txtEpisodeFrom_Inner[0];
                                txtTo = null;
                                errorMessage = "Episode No. cannot be greater than " + maxEpisode_From;
                                returnVal = false;
                            }

                            if (episodeTo_Inner < minEpisode_To && minEpisode_To > 0 && returnVal) {

                                errorMessage = "Episode No. cannot be less than " + minEpisode_To;

                                txtFrom = null;
                                txtTo = txtEpisodeTo_Inner[0];
                                returnVal = false;
                            }

                            if (rowId_Outer != rowId_Inner && titleCode_inner == titleCode_outer && returnVal) {
                                txtFrom = null;
                                txtTo = null;

                                if (episodeFrom_Inner >= episodeFrom_Outer && episodeFrom_Inner <= episodeTo_Outer) {
                                    txtFrom = txtEpisodeFrom_Inner[0];
                                    returnVal = false;
                                }

                                if (episodeTo_Inner >= episodeFrom_Outer && episodeTo_Inner <= episodeTo_Outer && returnVal) {
                                    txtTo = txtEpisodeTo_Inner[0];
                                    returnVal = false;
                                }

                                if (episodeFrom_Outer >= episodeFrom_Inner && episodeFrom_Outer <= episodeTo_Inner && returnVal) {
                                    txtFrom = txtEpisodeFrom_Outer[0];
                                    returnVal = false;
                                }

                                if (episodeTo_Outer >= episodeFrom_Inner && episodeTo_Outer <= episodeTo_Inner && returnVal) {
                                    txtTo = txtEpisodeTo_Outer[0];
                                    returnVal = false;
                                }

                                if (!returnVal) {
                                    errorMessage = "Overlapping Episode No.";
                                }
                            }
                        }

                        if (!returnVal) {
                            emptyCount = 0;
                            $("[required='required']").removeAttr("required");
                            $('.required').removeClass('required');
                            if (txtFrom != null)
                                $('#' + txtFrom.id).addClass('required');

                            if (txtTo != null)
                                $('#' + txtTo.id).addClass('required');

                            showAlert("E", errorMessage);
                            return false;
                        }
                    }
                    else {
                        if (isNaN(episodeFrom_Inner))
                            $('#' + txtEpisodeFrom_Inner[0].id).attr('required', true)

                        if (isNaN(episodeTo_Inner))
                            $('#' + txtEpisodeTo_Inner[0].id).attr('required', true)
                        emptyCount++;
                    }
                });
            }
            else {
                if (isNaN(episodeFrom_Outer))
                    $('#' + txtEpisodeFrom_Outer[0].id).attr('required', true)

                if (isNaN(episodeTo_Outer))
                    $('#' + txtEpisodeTo_Outer[0].id).attr('required', true)
                emptyCount++;
            }
        });
        if (emptyCount > 0) {
            errorMessage = "Please enter Episode No.";
            showAlert("E", errorMessage);
            returnVal = false;
        }
        return returnVal;
    }

    return returnVal;

}
function ValidateSave(isSubmitted) {
    var returnVal = true;
    $("[required='required']").removeAttr("required");
    $('.required').removeClass('required');
    var agreementDate = $("#Agreement_Date").val();
    var dealDesc = $.trim($("#Deal_Desc").val());
    var businessUnitCode = $("#ddlBUUnit").val();
    var licenseeCode = $("#ddlLicensee").val();
    var licensorCode = $("#ddlLicensors").val();
    var StartDate = $("#Start_Date").val();
    var EndDate = $("#End_Date").val();
    var TermYY = $.trim($("#Term_YY").val());
    var TermMM = $.trim($("#Term_MM").val());
    var titleCount = $("#tblDealFor tr:not(:has(th))").length;

    if (agreementDate == "") {
        $('#Agreement_Date').addClass("required");
        returnVal = false;
    }
    if (dealDesc == "") {
        $("#Deal_Desc").addClass("required");
        returnVal = false;
    }
    if (businessUnitCode == "") {
        $("#ddlBUUnit").addClass("required");
        returnVal = false;
    }
    if (licenseeCode == 0) {
        $("#ddlLicensee").addClass("required");
        returnVal = false;
    }
    if (licensorCode == "" || licensorCode == null || licensorCode === undefined) {
        $(".sumo_Provisional_Deal_Licensor").addClass("required");
        returnVal = false;
    }
    if (StartDate == "") {
        // $("#Start_Date").attr("required", true);
        $("#Start_Date").addClass("required");
        returnVal = false;
    }
    if (EndDate == "") {
        //$("#End_Date").attr("required", true);
        $("#End_Date").addClass("required");
        returnVal = false;
    }
    if (TermYY == "") {
        //$("#Term_YY").attr("required", true);
        $("#Term_YY").addClass("required");
        returnVal = false;
    }
    if (TermMM == "") {
        //$("#Term_MM").attr("required", true);
        $("#Term_MM").addClass("required");
        returnVal = false;
    }

    if (titleCount == 0) {
        showAlert("E", "Please add atleast one title")
        returnVal = false;
    }
    if (returnVal == false) {
        return false;
    }

    if (!ValidateEpisodeOverlapping()) {
        return false;
    }

    if (returnVal) {
        $('#hdnIsSubmitted').val(isSubmitted);
        $("#hdnDeal_Type_Code").val($("input:radio[name=Deal_Type_Code]:checked").val());
        return true;
    }

    return returnVal;
}


function CheckRecordLock() {
    debugger;
    showLoading();
    var returnVal = false;
    $.ajax({
        type: "POST",
        url: URL_CheckRecordLock,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Pro_Deal_Code: ProDealCode_G
        }),
        async: true,
        success: function (result) {
            hideLoading();
            if (result == "true") {
                redirectToLogin();
            }
            else {
                debugger;
                if (result.Is_Locked == "Y") {
                    if (Command_Name_G == "E" || Command_Name_G == "A") {
                        BindPartialView('ADD_DEAL', ProDealCode_G, Command_Name_G, result.Record_Locking_Code);
                    }
                    else {
                        $('#hdnRecodLockingCode').val(result.Record_Locking_Code);
                        Call_RefreshRecordReleaseTime(result.Record_Locking_Code, URL_Refresh_Lock);
                    }
                    returnVal = true;
                }
                else {
                    showAlert("E", result.Message);
                    returnVal = false;
                }
            }
        },
        error: function (result) {
            alert('Error in CheckRecordLock(): ' + result.responseText);
            hideLoading();
            returnVal = false;
        }
    });
    return returnVal;
}
function Ask_Confirmation(commandName, proDealCode, Mode) {
    debugger;
    Command_Name_G = Mode;
    ProDealCode_G = proDealCode;
    if (Mode == "E" || Mode == "A") {
        CheckRecordLock();
    }
}