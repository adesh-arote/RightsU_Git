﻿var YearBased = "Y";
var Milestone = "M";
var Perpetuity = "U";
var MessageFrom = '';
var TabType = 'RR';
var Check = false;
var Promoter_Check = false;
$(document).ready(function () {
    showLoading();
    $('#lbTitles,#lbTerritory,#lbSub_Language,#lbDub_Language').SumoSelect({ selectAll: true, triggerChangeCombined: false });
    $(".isDatepicker").datepicker();
    setChosenWidth('#ROFR_Code', '40%');
    $("#lblCountry").text('Country');
    if (recordLockingCode_G > 0) {
        Call_RefreshRecordReleaseTime(recordLockingCode_G, URL_Global_Refresh_Lock);
    }
    // EDIT SECTION START

    if (mode_G == "E" || mode_G == "C") {
        SetRightPeriod(rightType_G)
        $('#hdnSub_License_Code').val(subLicenseCode_G);
        if (isTheatricalRight_G == "Y") {
            $('#lblTheatrical').show();
            $("#lblCountry").text('Circuit');
            $('#' + treeID_G).hide();
        }
        else
            BindPlatform();

        if (rightType_G == YearBased) {
            SetMinDt();
            SetMaxDt();
        }

        if (disableTentative_G == "Y") {
            $('#Is_Tentative').prop("disabled", true);
        }

        if (isTentative_G == "Y") {
            $('#End_Date').prop("disabled", true);
            $('#End_Date').val('');
        }

        if (disableThetrical_G == "Y") {
            $('#Is_Theatrical_Right').prop("disabled", true);
        }

        if (disableIsExclusive_G == "Y") {
            $('#Is_Exclusive').prop("disabled", true);
        }
        if (disableTitleRights_G == "Y") {
            $('#Is_Title_Language_Right').prop("disabled", true);
        }

        if (rightType_G == 'M') {
            if (isTentative_G == 'Y') {
                //$('#ROFR_DT').prop("disabled", true);
                //$('#ROFR_Days').prop("disabled", true);
                $('#ddlMilestone_Type_Code').prop("disabled", false);
                $('#txtMilestone_No_Of_Unit').prop("disabled", false);
                $('#ddlMilestone_Unit_Type').prop("disabled", false);
            }
            else {
                $('#Milestone_Start_Date').prop('disabled', true);
                $('#Milestone_End_Date').prop('disabled', true);
                $('#ddlMilestone_Type_Code').prop("disabled", true).trigger('chosen:updated');
                $('#txtMilestone_No_Of_Unit').prop("disabled", true);
                $('#ddlMilestone_Unit_Type').prop("disabled", true).trigger('chosen:updated');
                $('#ROFR_DT').prop("disabled", false);
                $('#ROFR_Days').prop("disabled", false);
            }

            if (rofrDate_G != '')
                $("#ROFR_DT").datepicker("setDate", rofrDate_G);

            if (rofrDays_G != '')
                $("#ROFR_Days").val(rofrDays_G);
        }
        if (disableRightType_G == "Y") {
            if (existingRightType_G == Milestone) {
                $('#tabValidity a[href="#tabCal"]').prop("disabled", true);
                $('#tabValidity a[href="#tabCal"]').prop("title", ShowMessage.MsgTabCal);//MsgTabCal = Can not select right type year based as rights already syndicated
                $('#tabValidity a[href="#tabPerp"]').prop("disabled", true);
                $('#tabValidity a[href="#tabPerp"]').prop("title", ShowMessage.MsgTabPerp);//MsgTabPerp = Can not select right type perpetuity as rights already syndicated

                if (isNullEmpty_milestoneStartDate_G == false) {
                    $('#ROFR_DT').prop("disabled", true);
                    $('#ROFR_Days').prop("disabled", true);
                }
            }
            else {
                $('#tabValidity a[href="#tabMile"]').prop("disabled", true);
                $('#tabValidity a[href="#tabMile"]').prop("title", ShowMessage.MsgTabMile);//MsgTabMile = Can not select right type milestone as rights already syndicated
            }
        }
        else if (disableRightType_G == "U") {
            // It means Syndication deal's right type is 'Perpetuity'
            $('#tabValidity a[href="#tabCal"]').prop("disabled", true);
            $('#tabValidity a[href="#tabCal"]').prop("title", ShowMessage.MsgTabCal);//MsgTabCal = Can not select right type year based as rights already syndicated

            $('#tabValidity a[href="#tabMile"]').prop("disabled", true);
            $('#tabValidity a[href="#tabMile"]').prop("title", ShowMessage.MsgTabCal);//MsgTabCal = Can not select right type year based as rights already syndicated
        }
        else if (disableRightType_G == "M") {
            $('#tabValidity a[href="#tabCal"]').prop("disabled", true);
            $('#tabValidity a[href="#tabCal"]').prop("title", ShowMessage.MsgTabCal);//MsgTabCal = Can not select right type year based as rights already syndicated
            $('#tabValidity a[href="#tabPerp"]').prop("disabled", true);
            $('#tabValidity a[href="#tabPerp"]').prop("title", ShowMessage.MsgRunDef);//MsgRundef = Can not select right type perpetuity as run definition already added
        }
        else if (disableRightType_G == "R") {
            $('#tabValidity a[href="#tabMile"]').prop("disabled", true);
            $('#tabValidity a[href="#tabMile"]').prop("title", ShowMessage.MsgMileRunDef);//MsgMileRunDef = Can not select right type Milestone based as run definition already added
            $('#tabValidity a[href="#tabPerp"]').prop("disabled", true);
            $('#tabValidity a[href="#tabPerp"]').prop("title", ShowMessage.MsgRunDef);//MsgRunDef = Can not select right type perpetuity as run definition already added
        }

        var txtRemark = document.getElementById('Restriction_Remarks');
        countChar(txtRemark);
    }

    if ($('#Milestone_Type_Code').val() == '')
        $('#Milestone_Type_Code').val(1);

    if ($('#Milestone_Unit_Type').val() == '')
        $('#Milestone_Unit_Type').val(1);

    $('#lbTitles').change(function () {
        SetTitleLanguage();
    });

    $('#ddlMilestone_Unit_Type').change(function () {
        $('#Milestone_Unit_Type').val($('#ddlMilestone_Unit_Type').val());
    });

    $('#ddlMilestone_Type_Code').change(function () {
        $('#Milestone_Type_Code').val($('#ddlMilestone_Type_Code').val());
    });

    $('#ddlSub_License_Code').change(function () {
        $('#hdnSub_License_Code').val($('#ddlSub_License_Code').val());
    });

    $('#Is_Theatrical_Right').change(function () {
        SetTheatrical('C');
    });

    $('#Is_Tentative').change(function () {
        OnClickTentative();
    });

    $('#ROFR_DT').change(function () {
        CalculateROFRDays();
    });

    $('#ROFR_Days').change(function () {
        CalculateROFRDate();
    });

    $('#Term_YY').change(function () {
        OnFocusLostTerm();
        Set_MinMax_ROFR();
    });

    $('#Term_MM').change(function () {
        OnFocusLostTerm();
        Set_MinMax_ROFR();
    });
    $('#Term_DD').change(function () {
        debugger;
        OnFocusLostTerm();
        Set_MinMax_ROFR();
    });

    $('#Start_Date').change(function () {
        SetMinDt();
        AutoPopulateTerm();
    });

    $('#End_Date').change(function () {
        SetMaxDt();
        AutoPopulateTerm();
    });

    $('#Milestone_Start_Date').change(function () {
        CalculateMilestoneEndDate();
    });

    $('#txtMilestone_No_Of_Unit').blur(function () {
        CalculateMilestoneEndDate();
    });

    $('#ddlMilestone_Unit_Type').change(function () {
        CalculateMilestoneEndDate();
    });

    $('#txtPerpetuity_Date').change(function () {
        CalculatePerpetuityEndDate();
    });

    $("#Term_YY").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        maxPreDecimalPlaces: 2,
        maxDecimalPlaces: 0
    });
    $("#Term_MM").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        maxPreDecimalPlaces: 2,
        maxDecimalPlaces: 0
    });
    $("#Term_DD").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        maxPreDecimalPlaces: 2,
        maxDecimalPlaces: 0
    });
    $("#ROFR_Days").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        maxPreDecimalPlaces: 3,
        maxDecimalPlaces: 0
    });
    $("#txtMilestone_No_Of_Unit").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        maxPreDecimalPlaces: 3,
        maxDecimalPlaces: 0
    });

    BindAllPreReq_Async();
});

function CalculateTerm(startDate, endDate) {
    debugger;
    var val = CalculateMonthBetweenTwoDate(startDate, endDate);
    var year = val / 12;
    var month = val % 12;

    var day = 0;
    var SDno = startDate.getDate();
    var EDno = endDate.getDate();

    if (EDno > SDno) {
        day = EDno - SDno
    }
    else if (startDate.getMonth() == endDate.getMonth() && startDate.getFullYear() == endDate.getFullYear()) {
        day = CalculateDaysBetweenTwoDates(startDate, endDate);
    }
    else if (SDno == EDno) {
        day = 0;
    }
    else {
        var m = endDate.getMonth(),
            y = endDate.getFullYear();
        var FirstDay = new Date(y, m, 1);
        day = CalculateDaysBetweenTwoDates(FirstDay, endDate);

        startDate.setMonth(startDate.getMonth() + month);
        startDate.setYear(startDate.getYear() + year);

        m = startDate.getMonth(),
            y = startDate.getFullYear();
        var LastDay = new Date(y, m + 1, 1);
        day = day + CalculateDaysBetweenTwoDates(startDate, LastDay);
    }
    var term = parseInt(year) + '.' + month + "." + day;
    return term;
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
        $('#Term_DD').val(arr[2]);
    }
}
function PromoterChange() {

    var Promoter = $('#Promoter_Flag').is(':checked');
    if (Promoter == true)
        $('#hdnPromoter').val('Y');
    else
        $('#hdnPromoter').val('N');

}

function OnTabChange(obj) {
    if (obj == 'HB') {
        TabType = 'HB';
        $('#btnAddSD').show();
        Bind_Holdback();
    }
    else {
        if (obj == "BO") {
            TabType = 'BO';
            $('#btnAddSD').show();
            Bind_BlackOut();
        }
        else if (obj == "PR") {
            TabType = 'PR';
            $('#btnAddSD').show();
            Bind_Promoter();
        }
        else {
            TabType = 'RR';
            $('#btnAddSD').hide();
        }
    }
}
function Bind_Holdback() {
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_BindHoldback,
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

    $("#hdnEditRecord").val('');
    $.ajax({
        type: "POST",
        url: URL_BindBlackOut,
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
            initializeTooltip();
            hideLoading();
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
            //  if ($('#trAddEditPR') != null && $('#trAddEditPR') != undefined)
            //    $('#trAddEditPR').hide();
            debugger;
            if ($('#spnPromotercount').text() == '0') {
                if ($('#hdnPromoter').val() == 'Y') {
                    $('#Promoter_Flag').prop('checked', true);
                }
                else {
                    $('#Promoter_Flag').prop('checked', false);
                }
                $('#Promoter_Flag').prop('disabled', false);
            }
            else {
                $('#Promoter_Flag').prop('checked', false);
                $('#Promoter_Flag').prop('disabled', true);
                $('#hdnPromoter').val('N');
            }
            initializeTooltip();
            hideLoading();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}
function Add_Holdback_Blackout(Call_FROM) {
    debugger
    var Is_Exclusive = $('input[name=hdnExclusive]:checked').val();

    if ($('#hdnEditRecord').val() == '') {
        var IsValidSave = true;
        if (TabType != 'PR') {
            $('.required').removeClass('required');
            $("[required='required']").removeAttr("required");

            var hdnTitle_Code = $("#hdnTitle_Code");
            var hdnRegion_Code = $("#hdnRegion_Code");
            var hdnDub_Code = $("#hdnDub_Code");
            var hdnSub_Code = $("#hdnSub_Code");

            hdnTitle_Code.val('');
            hdnRegion_Code.val('');
            hdnDub_Code.val('');
            hdnSub_Code.val('');

            //------------------ TITLE

            var selectedTitles = '';
            if ($("#lbTitles").val() != null)
                selectedTitles = $("#lbTitles").val().join(',');

            hdnTitle_Code.val(selectedTitles);

            var IsValidSave = true;

            if (selectedTitles == '') {
                IsValidSave = false;
                $("#lbTitles").attr('required', true);
                //alert('Please select title');
                //return false;
            }

            //------------------ END

            //------------------ PLATFORM

            if ($("#hdnTVCodes").val() == '') {
                IsValidSave = false;
                $("#tree").attr('required', true);
                $("#tree").addClass('required');
            }

            //------------------ END

            //------------------ COUNTRY

            var selectedRegion = '';
            var regionType = $("#rdoCountryHB").prop('checked') ? $("#rdoCountryHB").val() : $("#rdoTerritoryHB").val();
            $("#hdnRegion_Type").val(regionType);

            if ($("#lbTerritory option:selected").length > 0) {
                $("#lbTerritory option:selected").each(function () {
                    if (selectedRegion == '')
                        selectedRegion = $(this).val();
                    else
                        selectedRegion = selectedRegion + ',' + $(this).val();
                });
            }

            hdnRegion_Code.val(selectedRegion);

            if (selectedRegion == '') {
                IsValidSave = false;
                $("#lbTerritory").attr('required', true);
                //alert('Please select region');
                //return false;
            }

            //------------------ END

            var ErrorMsg = '';

            //------------------ PERIOD

            var Term = $('#Right_Type').val();

            if (Term == YearBased) {
                var txtStartDate = $('#Start_Date');
                var txtEndDate = $('#End_Date');
                var isTentative = false;
                if ($('#Is_Tentative').prop('checked'))
                    isTentative = true;

                if (txtStartDate.val() == "") {
                    IsValidSave = false;
                    $("#Start_Date").attr('required', true);
                    //alert('Please select start date.')
                    //return false;
                }

                if (txtEndDate.val() == "" && isTentative == false) {
                    IsValidSave = false;
                    $("#End_Date").attr('required', true);
                    //alert('Please select end date.')
                    //return false;
                }

                if (txtStartDate.val() != "" && txtEndDate.val() != "" && compareDates_DMY(txtStartDate.val(), txtEndDate.val()) < 0) {
                    IsValidSave = false;
                    $("#Start_Date").attr('required', true);
                    $("#End_Date").attr('required', true);
                    txtROFRDays.val('');
                    ErrorMsg = ShowMessage.MsgForDate;//MsgForDate = Start Date should be less than end date.
                    //alert('Start Date should be less than end date.');
                    //return false;
                }

                var txtYear = $('#Term_YY').val();
                var txtMonth = $('#Term_MM').val();
                var txtDay = $('#Term_DD').val();
                if (isTentative == true && (txtYear == null || txtYear == '0' || txtYear == undefined || txtYear == '') && (txtMonth == null || txtMonth == '0' || txtMonth == undefined || txtMonth == '') && (txtDay == null || txtDay == '0' || txtDay == undefined || txtDay == '')) {
                    IsValidSave = false;
                    //$('#Term_YY').attr('required', true);
                    // $('#Term_MM').attr('required', true);
                    showAlert("E", ShowMessage.MsgValidTerm);//MsgValidTerm = Please enter valid Term
                }
            }
            else if (Term == Milestone) {
                if ($("#txtMilestone_No_Of_Unit").val() == "") {
                    IsValidSave = false;
                    $("#txtMilestone_No_Of_Unit").attr('required', true);
                }
            }
            else if (Term == Perpetuity) {
                if ($('#txtPerpetuity_Date').val() == "" || $('#txtPerpetuity_Date').val() == "DD/MM/YYYY") {
                    IsValidSave = false;
                    $("#txtPerpetuity_Date").attr('required', true);
                }

                if ($('#txtPerpetuity_EndDate').val() == "" || $('#txtPerpetuity_EndDate').val() == "DD/MM/YYYY") {
                    IsValidSave = false;
                    $("#txtPerpetuity_EndDate").attr('required', true);
                }
            }

            //------------------ END

            //------------------ DUBBING

            var dubbingType = $("#rdoDubbingL").prop('checked') ? $("#rdoDubbingL").val() : $("#rdoDubbingLG").val();
            $("#hdnDub_Type").val(dubbingType);

            var selectedDub = '';

            if ($("#lbDub_Language option:selected").length > 0) {
                $("#lbDub_Language option:selected").each(function () {
                    if (selectedDub == '')
                        selectedDub = $(this).val();
                    else
                        selectedDub = selectedDub + ',' + $(this).val();
                });
            }

            hdnDub_Code.val(selectedDub);

            //------------------ END

            //------------------ SUBTITLING

            var subType = $("#rdoSubL").prop('checked') ? $("#rdoSubL").val() : $("#rdoSubLG").val();
            $("#hdnSub_Type").val(subType);

            var selectedSub = '';

            if ($("#lbSub_Language option:selected").length > 0) {
                $("#lbSub_Language option:selected").each(function () {
                    if (selectedSub == '')
                        selectedSub = $(this).val();
                    else
                        selectedSub = selectedSub + ',' + $(this).val();
                });
            }

            hdnSub_Code.val(selectedSub);

            //------------------ END

            if ($("#Is_Title_Language_Right").prop('checked') == false && selectedSub == '' && selectedDub == '') {
                IsValidSave = false;
                $("#lbTerritory").attr('required', true);
                if (ErrorMsg != '')
                    ErrorMsg = ErrorMsg + '</br>'

                ErrorMsg = ErrorMsg + ShowMessage.MsgForLang;//MsgForLang = Please select atleast one Language
            }

            if (!IsValidSave && $.trim(ErrorMsg) != '') {
                showAlert('E', ErrorMsg);
            }
        }
        if (IsValidSave) {
            var Term = $('#Right_Type').val();
            var Period = '';
            var isTentative = 'No';
            var PeriodTerm = '';
            if (Term == YearBased) {

                var txtStartDate = $('#Start_Date');
                var txtEndDate = $('#End_Date');

                if ($('#Is_Tentative').prop('checked')) {
                    isTentative = 'Yes';
                    Period = MakeDateFormate(txtStartDate.val());
                }
                else
                    Period = MakeDateFormate(txtStartDate.val()) + ' To ' + MakeDateFormate(txtEndDate.val());
                PeriodTerm = $('#Term_YY').val() + ' Year'
                if ($('#Term_MM').val() != 0)
                    PeriodTerm = PeriodTerm + $('#Term_MM').val() + ' Month';
                if ($('#Term_DD').val() != 0)
                    PeriodTerm = PeriodTerm + $('#Term_DD').val() + ' Day';
            }
            else if (Term == Milestone) {
                if ($("#txtMilestone_No_Of_Unit").val() != "") {
                    PeriodTerm = $('#ddlMilestone_Type_Code option:selected').text() + ' Valid For ' + $("#txtMilestone_No_Of_Unit").val() + ' ' + $('#ddlMilestone_Unit_Type option:selected').text();
                }
                if ($('#Milestone_SD').text() != '' && $('#Milestone_ED').text() != '')
                    Period = MakeDateFormate($('#Milestone_SD').text()) + ' To ' + MakeDateFormate($('#Milestone_ED').text());
            }
            else if (Term == Perpetuity) {
                if ($('#txtPerpetuity_Date').val() != "" && $('#txtPerpetuity_EndDate').val() != "") {
                    Period = MakeDateFormate($('#txtPerpetuity_Date').val());
                    PeriodTerm = 'Perpetuity';
                }
            }
            if (TabType == 'HB') {
                var region_type = $("#rdoCountryHB").prop('checked') ? $("#rdoCountryHB").val() : $("#rdoTerritoryHB").val();
                region_type = region_type == "G" ? "T" : region_type;

                var region_Code = '';
                if ($("#lbTerritory option:selected").length > 0) {
                    $("#lbTerritory option:selected").each(function () {
                        if (region_Code == '')
                            region_Code = $(this).val();
                        else
                            region_Code = region_Code + ',' + $(this).val();
                    });
                }

                var SL_Type = $("#rdoSubL").prop('checked') ? $("#rdoSubL").val() : $("#rdoSubLG").val();
                var SL_Code = '';
                if ($("#lbSub_Language option:selected").length > 0) {
                    $("#lbSub_Language option:selected").each(function () {
                        if (SL_Code == '')
                            SL_Code = $(this).val();
                        else
                            SL_Code = SL_Code + ',' + $(this).val();
                    });
                }

                var DL_Type = $("#rdoDubbingL").prop('checked') ? $("#rdoDubbingL").val() : $("#rdoDubbingLG").val();
                var DL_Code = '';

                if ($("#lbDub_Language option:selected").length > 0) {
                    $("#lbDub_Language option:selected").each(function () {
                        if (DL_Code == '')
                            DL_Code = $(this).val();
                        else
                            DL_Code = DL_Code + ',' + $(this).val();
                    });
                }

                var titles = $("#lbTitles option:selected").map(function () {
                    return $(this).text();
                }).get().join();

                var title_Code = $('#lbTitles').val().join(',');
                showLoading();
                $.ajax({
                    type: "POST",
                    url: URL_Add_Holdback,
                    traditional: true,
                    enctype: 'multipart/form-data',
                    contentType: "application/json; charset=utf-8",
                    dataType: "html",
                    data: JSON.stringify({
                        R_Type: region_type,
                        SL_Type: SL_Type,
                        DL_Type: DL_Type,
                        R_Code: region_Code,
                        SL_Code: SL_Code,
                        DL_Code: DL_Code,
                        Titles: titles,
                        Period: Period,
                        IsTentative: isTentative,
                        PeriodTerm: PeriodTerm,
                        strPlatform: $("#hdnTVCodes").val(),
                        title_Code: title_Code,
                        Is_Exclusive: Is_Exclusive
                    }),
                    success: function (result) {
                        if (result == "true") {
                            redirectToLogin();
                        }
                        $('#popEditHB').html(result);
                        initializeChosen();
                        initializeDatepicker();

                        if (Term == YearBased) {
                            var txtTermYear = $('#Term_YY');
                            var txtTermMonth = $('#Term_MM');
                            var txtTermDay = $('#Term_DD');
                            var rightSD = new Date(MakeDateFormate(txtStartDate.val()));
                            var year = 0, month = 0, day = 0;

                            if (txtTermYear.val() != '')
                                year = parseInt(txtTermYear.val());

                            if (txtTermMonth.val() != '')
                                month = parseInt(txtTermMonth.val());

                            if (txtTermDay.val() != '')
                                day = parseInt(txtTermDay.val());

                            var EndDate = CalculateEndDate(rightSD, year, month, day);

                            if ($('#Is_Tentative').prop('checked'))
                                setMinMaxDates('Holdback_Release_Date', $('#Start_Date').val(), EndDate);
                            else
                                setMinMaxDates('Holdback_Release_Date', $('#Start_Date').val(), $('#End_Date').val());
                        }
                        else
                            if (Term == Perpetuity) {
                                if ($('#txtPerpetuity_EndDate').val() == undefined)
                                    setMinMaxDates('Holdback_Release_Date', $('#txtPerpetuity_Date').val(), '');
                                else
                                    setMinMaxDates('Holdback_Release_Date', $('#txtPerpetuity_Date').val(), $('#txtPerpetuity_EndDate').val());
                            }
                        hideLoading();
                        $('#popEditHB').modal();
                    },
                    error: function (result) {
                        alert('Error: ' + result.responseText);
                    }
                });
            }
            else
                if (TabType == "BO") {
                    $('#hdnEditRecord').val('Add');
                    $.ajax({
                        type: "POST",
                        url: URL_Add_Blackout,
                        traditional: true,
                        enctype: 'multipart/form-data',
                        contentType: "application/json; charset=utf-8",
                        dataType: "html",
                        data: JSON.stringify({}),
                        success: function (result) {
                            if (result == "true")
                                redirectToLogin();

                            $('a[href="#tabHoldback"]').prop("disabled", true);
                            $('a[href="#tabRestriction"]').prop("disabled", true);

                            $('#tabBlackout').html(result);
                            $('#trAddEditBO').show();
                            initializeChosen();
                            initializeDatepicker();
                            hideLoading();
                        },
                        error: function (result) {
                            alert('Error: ' + result.responseText);
                        }
                    });
                }
                else if (TabType == "PR") {
                    $('#hdnEditRecord').val('Add');
                    $.ajax({
                        type: "POST",
                        url: URL_Add_Promoter,
                        traditional: true,
                        enctype: 'multipart/form-data',
                        contentType: "application/json; charset=utf-8",
                        dataType: "html",
                        data: JSON.stringify({}),
                        success: function (result) {
                            if (result == "true")
                                redirectToLogin();

                            $('a[href="#tabHoldback"]').prop("disabled", true);
                            $('a[href="#tabRestriction"]').prop("disabled", true);
                            $('a[href="#tabBlackout"]').prop("disabled", true);
                            debugger;
                            $('#tabPromoter').html(result);

                            if ($('#spnPromotercount').text() == '0') {
                                if ($('#hdnPromoter').val() == 'Y') {
                                    $('#Promoter_Flag').prop('checked', true);
                                }
                                else {
                                    $('#Promoter_Flag').prop('checked', false);
                                }
                                $('#Promoter_Flag').prop('disabled', false);
                            }
                            else {
                                $('#Promoter_Flag').prop('checked', false);
                                $('#Promoter_Flag').prop('disabled', true);

                            }
                            $('#ddlRemarks_0').SumoSelect();
                            $('#ddlRemarks_0')[0].sumo.reload();
                            $('#trAddEditBO').show();
                            initializeChosen();
                            initializeDatepicker();
                            hideLoading();
                        },
                        error: function (result) {
                            alert('Error: ' + result.responseText);
                        }
                    });
                }
            return true;
        }
        else
            return false;
    }
    else
        showAlert('E', ShowMessage.MsgForAddEdit);//MsgForAddEdit = Please complete Add/Edit operation first
}
function BindDropdown(radioType, callFrom) {
    var selectedId = '';
    var Is_Thetrical = $('#Is_Theatrical_Right').prop('checked');

    if (Is_Thetrical)
        Is_Thetrical = 'Y'
    else
        Is_Thetrical = 'N'

    if (radioType == "I" || radioType == "T") {
        selectedId = 'lbTerritory';
    }
    else if (radioType == "DL" || radioType == "DG") {
        selectedId = 'lbDub_Language';
    }
    else if (radioType == "SL" || radioType == "SG") {
        selectedId = 'lbSub_Language';
    }

    $.ajax({
        type: "POST",
        url: URL_Bind_JSON_ListBox,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            str_Type: radioType,
            Is_Thetrical: Is_Thetrical
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            if (result == ShowMessage.MsgForHBAdd) {//MsgForHBAdd = Holdback is already added

                if (radioType == "I") {
                    $("#rdoTerritoryHB").prop('checked', true);
                }
                else if (radioType == "T") {
                    $("#rdoCountryHB").prop('checked', true);
                }
                else if (radioType == "DL") {
                    $("#rdoDubbingLG").prop('checked', true);
                }
                else if (radioType == "DG") {
                    $("#rdoDubbingL").prop('checked', true);
                }
                else if (radioType == "SL") {
                    $("#rdoSubLG").prop('checked', true);
                }
                else if (radioType == "SG") {
                    $("#rdoSubL").prop('checked', true);
                }
                showAlert('E', result);
            }
            else {
                debugger;
                $("#" + selectedId).empty();
                $("#" + selectedId).trigger("chosen:updated");
                $.each(result, function () {
                    $("#" + selectedId).append($("<option />").val(this.Value).text(this.Text));
                });
                if (callFrom == undefined) {

                    $("#" + selectedId)[0].sumo.reload();
                }
                //if (selectedId == 'lbTerritory')
                //    fillTotal();

                //else if (selectedId == 'lbSub_Language')
                //    fillTotal('LS');

                //else if (selectedId == 'lbDub_Language')
                //    fillTotal('LD');

            }
        },
        error: function (result) {
            showAlert('E', 'Error: ' + result.responseText);
        }
    });
}

function CheckHBRegionWithRightsRegion() {
    $("#lbTerritory option:selected").prop('disabled', false);
    $("#lbTerritory option").removeAttr('disabled')
    var region_type = $("#rdoCountryHB").prop('checked') ? $("#rdoCountryHB").val() : $("#rdoTerritoryHB").val();
    var region_Code = '';
    if ($("#lbTerritory option:selected").length > 0) {
        $("#lbTerritory option:selected").each(function () {
            if (region_Code == '')
                region_Code = $(this).val();
            else
                region_Code = region_Code + ',' + $(this).val();
        });
    }
    var IsValid = "Valid";

    $.ajax({
        type: "POST",
        url: URL_CheckHBRegionWithRightsRegion,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            region_type: region_type,
            region_Code: region_Code
        }),
        async: false,
        success: function (result) {
            if (result == "true")
                redirectToLogin();

            IsValid = result;
        },
        error: function (result) {
            hideLoading();
            alert('Error Validate_Save_Holdback: ' + result.responseText);
        }
    });

    return IsValid;
}
function CheckHBSubtitleRegionWithRightsSubtitle() {
    $("#lbSub_Language option:selected").prop('disabled', false);
    $("#lbSub_Language option").removeAttr('disabled');
    var SL_Type = $("#rdoSubL").prop('checked') ? $("#rdoSubL").val() : $("#rdoSubLG").val();
    var SL_Code = '';
    var IsValid = "Valid";

    if ($("#lbSub_Language option:selected").length > 0) {
        $("#lbSub_Language option:selected").each(function () {
            if (SL_Code == '')
                SL_Code = $(this).val();
            else
                SL_Code = SL_Code + ',' + $(this).val();
        });
    }

    $.ajax({
        type: "POST",
        url: URL_CheckHBSubtitleWithRightsSubtitle,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Subtitle_type: SL_Type,
            Subtitle_Code: SL_Code
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            IsValid = result;
        },
        error: function (result) {
            hideLoading();
            alert('Error Validate_Save_Holdback: ' + result.responseText);
        }
    });
    return IsValid;
}

function CheckHBDubbingWithRightsDubbing() {
    $("#lbDub_Language option:selected").prop('disabled', false);
    $("#lbDub_Language option").removeAttr('disabled');
    var DL_Type = $("#rdoDubbingL").prop('checked') ? $("#rdoDubbingL").val() : $("#rdoDubbingLG").val();
    var DL_Code = '';

    if ($("#lbDub_Language option:selected").length > 0) {
        $("#lbDub_Language option:selected").each(function () {
            if (DL_Code == '')
                DL_Code = $(this).val();
            else
                DL_Code = DL_Code + ',' + $(this).val();
        });
    }
    var IsValid = "Valid";
    $.ajax({
        type: "POST",
        url: URL_CheckHBDubbingWithRightsDubbing,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Dubbing_type: DL_Type,
            Dubbing_Code: DL_Code
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            IsValid = result;
        },
        error: function (result) {
            hideLoading();
            alert('Error Validate_Save_Holdback: ' + result.responseText);
        }
    });
    return IsValid;
}
function SetMaxDt() {
    setMinMaxDates('Start_Date', '', $('#End_Date').val());
    Set_MinMax_ROFR();
}
function SetMinDt() {
    setMinMaxDates('End_Date', $('#Start_Date').val(), '');
    Set_MinMax_ROFR();
}
function Set_MinMax_ROFR() {
    if ($('#End_Date').val() != '') {
        setMinMaxDates('ROFR_DT', $('#Start_Date').val(), $('#End_Date').val());
    }
    else {
        var txtTermYear = $('#Term_YY');
        var txtTermMonth = $('#Term_MM');
        var txtTermDay = $('#Term_DD');
        var txtROFRDate = $('#ROFR_DT');
        var txtStartDate = $('#Start_Date');
        var rightSD = new Date(MakeDateFormate(txtStartDate.val()));
        var year = 0;
        var month = 0;
        var day = 0;

        if (txtTermYear.val() != '')
            year = parseInt(txtTermYear.val());
        if (txtTermMonth.val() != '')
            month = parseInt(txtTermMonth.val());
        if (txtTermDay.val() != '')
            day = parseInt(txtTermDay.val());

        var EndDate = CalculateEndDate(rightSD, year, month, day);
        if (EndDate != undefined && EndDate != '' && $('#Start_Date').val() != '' && (year > 0 || month > 0))
            setMinMaxDates('ROFR_DT', $('#Start_Date').val(), EndDate);
    }
}
function showHoldbackValidationPopup(title_Code) {
    var isValid;
    $.ajax({
        type: "POST",
        url: URL_showHoldbackValidationPopup,
        traditional: true,
        async: false,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            acqdealMovieCode: title_Code
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            if (result.trim() != '') {
                $("#BindHoldbackValidationPopup").html(result);
                isValid = true;
            }
            else
                isValid = false;
            initializeExpander();
        },
        error: function (x, e) {
        }
    });
    if (isValid) {

        $('#popupHoldbackValidationError').modal();
        initializeChosen();
        setChosenWidth('#lbSearchTitles', '500px');
        initializeExpander();
    }
    return isValid;
}
function Show_Validation_Popup(search_Titles, Page_Size, Page_No) {
    $.ajax({
        type: "POST",
        url: URL_Show_Validation_Popup,
        traditional: true,
        async: false,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            searchForTitles: search_Titles,
            PageSize: Page_Size,
            PageNo: Page_No
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            $("#BindValidationPopup").html(result);
        },
        error: function (x, e) {
        }
    });
    $('#popupValidationError').modal();
    initializeChosen();
    setChosenWidth('#lbSearchTitles', '500px');
    initializeExpander();
}

function SetTheatrical(CallFrom) {
    //HERE  CallFROM  C- Means Change Event    
    var ShowMsg = false;
    var isCheck = false;
    var tvCodes = $('#hdnTVCodes').val();
    var regionCodes = $('#lbTerritory').val();
    var confirmMsg = "";
    var selection = "uncheck";

    if (tvCodes != "") {
        ShowMsg = true;
        confirmMsg = "Platform";
    }

    if (regionCodes != "" && regionCodes != null) {
        ShowMsg = true;

        if (confirmMsg != '')
            confirmMsg += ", ";

        confirmMsg += "Region";
    }

    if ($('#Is_Theatrical_Right').prop('checked') == true) {
        var selection = "check";
        isCheck = true;
    }
    $('#hdnIs_Theatrical_Right').val(isCheck);
    if (ShowMsg && CallFrom == 'C') {
        confirmMsg = 'Are you sure you want to ' + selection + '? All selected ' + confirmMsg + ' will get cleared, do you still want to continue?';
        // Show Syntem Popup
        MessageFrom = "DOMESTIC_CHECK_UNCHECK";
        showAlert("I", confirmMsg, "OKCANCEL");
    }
    else {
        ReSetTheatrical();
    }
}
function ReSetTheatrical() {
    var isCheck = false;
    if ($('#Is_Theatrical_Right').prop('checked') == true) {
        var selection = "check";
        isCheck = true;
    }
    if (isCheck) {
        $("#lblCountry").text('Circuit');
        $('#lblTheatrical').show();
        $('#' + treeID_G).hide();
        $('#hdnTVCodes').val(theatricalPlatformCode_G);
        Is_Theatrical = 'Y';
        $("#tree").removeClass('required');
    }
    else {
        $('#lblTheatrical').hide();
        $("#lblCountry").text('Country');
        $('#hdnTVCodes').val('');
        BindPlatform();
        $('#' + treeID_G).show();
        Is_Theatrical = 'N';
    }
    var regionType = $("#rdoCountryHB").prop('checked') ? $("#rdoCountryHB").val() : $("#rdoTerritoryHB").val();
    regionType = regionType == "G" ? "T" : regionType;
    ClearHoldbackGrid(Is_Theatrical);
    BindDropdown(regionType);
    Bind_Holdback();
}
function ClearHoldbackGrid(Is_Theatrical) {
    $.ajax({
        type: "POST",
        url: URL_ClearHoldbackGrid,
        traditional: true,
        async: false,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Is_Theatrical: Is_Theatrical
        }),
        success: function (result) {
            if (result == "true")
                redirectToLogin();
        },
        error: function (x, e) {
            alert(x.responseText);
        }
    });
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
    $('#Right_Type').val(rightType);
    $('#Original_Right_Type').val(rightType);
    if (rightType != YearBased) {

        if (rightType == Perpetuity) {
            $('#ROFR_DT').prop("disabled", true);
            $('#ROFR_Days').prop("disabled", true);
            $('#ROFR_DT').val('');
            $('#ROFR_Days').val('');
            $('#ROFR_Code').prop("disabled", true);
            CalculatePerpetuityEndDate();
        }
        else
            $('#ROFR_Code').prop("disabled", false);

        if ($('#Milestone_Type_Code').val() == '')
            $('#Milestone_Type_Code').val(1);

        if ($('#Milestone_Unit_Type').val() == '')
            $('#Milestone_Unit_Type').val(1);
    }
    else {
        $('#ROFR_DT').prop("disabled", false);
        $('#ROFR_Days').prop("disabled", false);
        $('#ROFR_Code').prop("disabled", false);
    }
    $('#ROFR_Code').trigger('chosen:updated');
}


function OnClickTentative(control) {
    var IsTentative = false;
    if ($('#Is_Tentative').prop('checked'))
        IsTentative = true
    if (IsTentative) {
        $('#End_Date').prop("disabled", true);
        $('#End_Date').val('');
    }
    else {
        $('#End_Date').prop("disabled", false);
        OnFocusLostTerm();
    }
}
function CalculateROFRDate() {
    var txtStartDate = $('#Start_Date');
    var txtEndDate = $('#End_Date');
    var txtTermYear = $('#Term_YY');
    var txtTermMonth = $('#Term_MM');
    var txtTermDay = $('#Term_DD');
    var txtROFRDate = $('#ROFR_DT');
    var txtROFRDays = $('#ROFR_Days');
    var Milestone_SD = '';
    var Milestone_ED = '';
    var rightRD;
    var isTentative = false;

    if (txtROFRDays.val() == '' || txtROFRDays.val() == '0') {
        txtROFRDays.val('0');
        txtROFRDate.val('');
        return false;
    }

    if ($('#Is_Tentative').prop('checked'))
        isTentative = true;

    var Term = $('#Right_Type').val();

    if (Term == YearBased) {
        if (isTentative) {
            if (txtStartDate.val() != "") {
                var rightSD = new Date(MakeDateFormate(txtStartDate.val()));
                if (!isNaN(rightSD)) {
                    var year = 0, month = 0, day = 0;

                    if (txtTermYear.val() != '')
                        year = parseInt(txtTermYear.val());

                    if (txtTermMonth.val() != '')
                        month = parseInt(txtTermMonth.val());

                    if (txtTermDay.val() != '')
                        day = parseInt(txtTermDay.val());

                    if (year > 0 || month > 0 || day > 0) {
                        var newDate = CalculateEndDate(rightSD, year, month, day);
                        rightRD = new Date(MakeDateFormate(newDate));
                    }
                }
                else {
                    showAlert('E', 'Start date is not in proper format.');
                    return false;
                }
            }
            else {
                showAlert('E', 'Please select start date.');
                return false;
            }
        }
        else {
            if (txtEndDate.val() == "") {
                txtROFRDays.val('');
                showAlert('E', 'Please select end date.');
                return false;
            }
            rightRD = new Date(MakeDateFormate(txtEndDate.val()));
        }
    }
    else if (Term == Milestone) {
        Milestone_SD = $('#Milestone_Start_Date').val();
        Milestone_ED = $('#Milestone_End_Date').val();
        if (Milestone_ED != '') {
            rightRD = new Date(MakeDateFormate(Milestone_ED));
        }
    }

    if (isNaN(txtROFRDays.val()) || txtROFRDays.val() == '')
        txtROFRDays.val() = "0";
    if (txtROFRDays.val() != '') {
        var noOfPreviousDays = parseInt(txtROFRDays.val());

        rightRD.setDate(rightRD.getDate() - noOfPreviousDays);
        var newDateStr = ConvertDateToCurrentFormat(rightRD);

        txtROFRDate.val(newDateStr);
        if (Term == YearBased) {
            if (txtStartDate.val() != "" && txtROFRDate.val() != "" && compareDates_DMY(txtStartDate.val(), txtROFRDate.val()) < 0) {
                showAlert('E', ShowMessage.MsgForROFR, 'ROFR_Days');//MsgForROFR = Please enter valid Refusal Days so that Refusal Date greater than or equal to Start Date
                txtROFRDays.val('0');
                txtROFRDate.val('');
                return false;
            }
        }
        else if (Term == Milestone) {
            if (Milestone_SD != "" && Milestone_ED != "" && txtROFRDate.val() != "" && compareDates_DMY(Milestone_SD, txtROFRDate.val()) < 0) {
                showAlert('E', ShowMessage.MsgForROFRMile, 'ROFR_Days');// MsgForROFRMile = Please enter valid Refusal Days so that Refusal Date greater than or equal to milestone Start Date
                txtROFRDays.val('0');
                txtROFRDate.val('');
                return false;
            }
        }
    }
}
function CalculateROFRDays() {
    var txtStartDate = $('#Start_Date');
    var txtEndDate = $('#End_Date');
    var txtTermYear = $('#Term_YY');
    var txtTermMonth = $('#Term_MM');
    var txtTermDay = $('#Term_DD');
    var txtROFRDate = $('#ROFR_DT');
    var txtROFRDays = $('#ROFR_Days');
    var Term = $('#Right_Type').val();
    var rightRD;
    var rightED = '';
    var ROFTDT = '';

    if (txtROFRDate.val() == '') {
        txtROFRDays.val('0');
        return false;
    }

    if (txtROFRDate.val() != '') {
        var ROFTDT = new Date(MakeDateFormate(txtROFRDate.val()));
        if (isNaN(ROFTDT)) {
            showAlert('E', ShowMessage.MsgForROFRFormat, 'ROFR_DT');//MsgForROFRFormat = ROFR date is not in proper format
            return false;
        }
    }

    var isTentative = false;
    if ($('#Is_Tentative').prop('checked'))
        isTentative = true;

    if (Term == YearBased) {
        if (isTentative) {
            if (txtStartDate.val() != "") {
                var rightSD = new Date(MakeDateFormate(txtStartDate.val()));
                if (!isNaN(rightSD)) {
                    var year = 0;
                    var month = 0;
                    var day = 0;

                    if (txtTermYear.val() != '')
                        year = parseInt(txtTermYear.val());

                    if (txtTermMonth.val() != '')
                        month = parseInt(txtTermMonth.val());

                    if (txtTermDay.val() != '')
                        day = parseInt(txtTermDay.val());

                    if (year > 0 || month > 0 || day > 0) {
                        var newDate = CalculateEndDate(rightSD, year, month, day);
                        rightED = new Date(MakeDateFormate(newDate));
                    }
                }
                else {
                    showAlert('E', ShowMessage.MsgForStartDateFmt);//MsgForStartDate = Start Date is not in proper format
                    return false;
                }
            }
            else {
                showAlert('E', ShowMessage.MsgForStartDate);//MsgForStartDate = Please select start date
                return false;
            }
        }
        else {
            if (txtEndDate.val() == "") {
                txtROFRDays.val('');
                showAlert('E', ShowMessage.MsgForEndDate);//MsgForEndDate = Please select end date
                return false;
            }
            rightED = new Date(MakeDateFormate(txtEndDate.val()));
        }
    }
    else if (Term == Milestone) {
        Milestone_SD = $('#Milestone_Start_Date').val();
        Milestone_ED = $('#Milestone_End_Date').val();
        if (Milestone_ED != '') {
            rightED = new Date(MakeDateFormate(Milestone_ED));
        }
    }

    var days = CalculateDaysBetweenTwoDates(ROFTDT, rightED)
    //var diff = new Date(rightED - ROFTDT);
    //var days = diff / 1000 / 60 / 60 / 24;
    txtROFRDays.val(days);

    if (Term == YearBased) {
        if (txtStartDate.val() != "" && txtROFRDate.val() != "" && compareDates_DMY(txtStartDate.val(), txtROFRDate.val()) < 0) {
            showAlert('E', ShowMessage.MsgForROFR, 'ROFR_DT');//MsgForROFR = Please enter valid Refusal Days so that Refusal Date greater than or equal to Start Date
            txtROFRDays.val('0');
            txtROFRDate.val('');
            return false;
        }
    }
    else if (Term == Milestone) {
        if (Milestone_SD != "" && Milestone_ED != "" && txtROFRDate.val() != "" && compareDates_DMY(Milestone_SD, txtROFRDate.val()) < 0) {
            showAlert('E', ShowMessage.MsgForROFRMile, 'ROFR_DT');// MsgForROFRMile = Please enter valid Refusal Days so that Refusal Date greater than or equal to milestone Start Date
            txtROFRDays.val('0');
            txtROFRDate.val('');
            return false;
        }
    }
}
function OnFocusLostTerm() {
    debugger;
    var canAssign = true;
    if ($('#Is_Tentative').prop('checked'))
        canAssign = false

    var txtStartDate = $('#Start_Date');
    var txtEndDate = $('#End_Date');
    var txtTermYear = $('#Term_YY');
    var txtTermMonth = $('#Term_MM');
    var txtTermDay = $('#Term_DD');

    if (txtTermYear.val() == '' || isNaN(txtTermYear.val()))
        txtTermYear.val('0');
    if (txtTermMonth.val() == '' || isNaN(txtTermMonth.val()))
        txtTermMonth.val('0');

    if (txtTermDay.val() == '' || isNaN(txtTermDay.val()))
        txtTermDay.val('0');

    if (txtStartDate.val() != "") {
        var rightSD = new Date(MakeDateFormate(txtStartDate.val()));
        if (!isNaN(rightSD)) {

            var year = 0;
            var month = 0;
            var day = 0;

            if (txtTermYear.val() != '')
                year = parseInt(txtTermYear.val());
            if (txtTermMonth.val() != '')
                month = parseInt(txtTermMonth.val());

            if (txtTermDay.val() != '')
                day = parseInt(txtTermDay.val());

            if (year > 0 || month > 0 || day > 0) {
                var newDate = CalculateEndDate(rightSD, year, month, day);
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
            var day = 0;

            if (txtTermYear.val() != '')
                year = parseInt(txtTermYear.val());
            if (txtTermMonth.val() != '')
                month = parseInt(txtTermMonth.val());

            if (txtTermDay.val() != '')
                day = parseInt(txtTermDay.val());

            if (year > 0 || month > 0 || day > 0) {
                var newDate = CalculateStartDate(rightED, year, month, day);
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
        txtTermDay.val('0');
    }
    CalculateROFRDate();
}
function OnFocusLostDate() {
    debugger
    var isRet = false;
    var canAssign = true;
    var txtRightStartDate = $('#Start_Date');
    var txtRightEndDate = $('#End_Date');
    var txtTermYear = $('#Term_YY');
    var txtTermMonth = $('#Term_MM');
    var txtTermDay = $('#Term_DD');

    if ($('#Is_Tentative').prop('checked'))
        canAssign = false

    if (txtRightStartDate.val() == "" && txtTermYear.val() == "0" && txtTermMonth.val() == "0" && txtTermDay.val() == "0")
        isRet = true;

    if (txtRightEndDate.val() == "" && txtTermYear.val() == "0" && txtTermMonth.val() == "0" && txtTermDay.val() == "0")
        isRet = true;

    if (!isRet) {
        if (txtRightStartDate.val() != '' && txtRightEndDate.val() != '') {
            var rightSD = new Date(MakeDateFormate(txtRightStartDate.val()));
            var rightED = new Date(MakeDateFormate(txtRightEndDate.val()));

            if (!isNaN(rightSD) && !isNaN(rightED)) {
                rightED.setDate(rightED.getDate() + 1);
                var term = CalculateTerm(rightSD, rightED);
                var arr = term.split('.');
                txtTermYear.val(arr[0]);
                txtTermMonth.val(arr[1]);
                txtTermDay.val(arr[2]);
            }
            else {
                if (isNaN(rightSD)) {
                    showAlert('E', ShowMessage.VDMsgForStartDate, "Start_Date");//VDMsgForStartDate = Start Date is not valid
                    txtRightStartDate.val('');
                }
                if (isNaN(rightED)) {
                    showAlert('E', ShowMessage.VDMsgForEndDate, "End_Date");//VDMsgForEndDate = End Date is not valid
                    txtRightEndDate.val('');
                }
                return false;
            }
        }
        else {
            if (txtRightStartDate.val() != '') {
                var rightSD = new Date(MakeDateFormate(txtRightStartDate.val()));
                if (!isNaN(rightSD)) {
                    OnFocusLostTerm();
                }
                else {
                    showAlert('E', ShowMessage.VDMsgForStartDate, "Start_Date");//VDMsgForStartDate = Start Date is not valid
                    txtRightStartDate.val('');
                }
            }
            else if (txtRightEndDate.val() != '') {
                var rightED = new Date(MakeDateFormate(txtRightEndDate.val()));
                if (isNaN(rightED)) {
                    showAlert('E', ShowMessage.VDMsgForEndDate, "End_Date");//VDMsgForEndDate = End Date is not valid
                    txtRightEndDate.val('');
                }
                else {
                    OnFocusLostTerm();
                }
            }
        }
    }
}
function CalculateEndDate(startDate, year, month, days) {
    debugger;
    var yearToMonth = 12 * year;
    month = month + yearToMonth;
    startDate.setMonth(startDate.getMonth() + month);
    startDate.setDate(startDate.getDate() + days);
    startDate.setDate(startDate.getDate() - 1);
    var newDateStr = ConvertDateToCurrentFormat(startDate);
    return newDateStr;
}
function CalculateStartDate(startDate, year, month, days) {
    debugger;
    var yearToMonth = 12 * year;
    month = month + yearToMonth;
    startDate.setMonth(startDate.getMonth() - month);
    startDate.setDate(startDate.getDate() - days);
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
function CalculateMonthBetweenTwoDate(startDate, endDate) {
    var months = (endDate.getFullYear() - startDate.getFullYear()) * 12;
    months += endDate.getMonth() - startDate.getMonth();

    // Subtract one month if b's date is less that a's.
    if (endDate.getDate() < startDate.getDate())
        months--;
    return months;
}

function CalculateDaysBetweenTwoDates(startDate, endDate) {
    var oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
    var diffDays = Math.round(Math.abs((startDate.getTime() - endDate.getTime()) / (oneDay)))
    return diffDays;
}
function SetTitleLanguage() {
    if ($("#lbTitles").val() != null) {
        var selectedTitles = $("#lbTitles").val().join(',');
        $.ajax({
            type: "POST",
            url: URL_GetTitleLanguageName,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                selectedTitles: selectedTitles
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                $("#Title_Language")[0].innerHTML = '(' + result + ')';
            },
            error: function (x, e) {
            }
        });
    }
    else
        $("#Title_Language")[0].innerHTML = '(-)';
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
function checkTitleForPt() {
    $("#hdnTitle_Code").val('');

    var selectedTitles = '';
    if ($("#lbTitles").val() != null)
        selectedTitles = $("#lbTitles").val().join(',');

    $("#hdnTitle_Code").val(selectedTitles);
    if (selectedTitles == '') {
        showAlert('E', 'Please select title', 'lbTitles');
        return false;
    }

    if ($("#hdnTVCodes").val() == '') {
        showAlert('E', 'Please select Platform');
        return false;
    }

    return true;
}

function ClearHidden() {
    if (!clickedOnTab) {
        $("#hdnTabName").val('');
    }
}
function CheckPromoter() {
    var count = 0;
    var PromoterCheck = $('#hdnPromoter').val();
    PromoterCheck = PromoterCheck.trim();
    if (PromoterCheck == "" || PromoterCheck == null) {
        $('#hdnPromoter').val('N');
        PromoterCheck = 'N';
    }

    count = $('#spnPromotercount').text();
    if (count == 0 && PromoterCheck == 'N') {
        hideLoading();
        MessageFrom = "PR";
        showAlert('I', ShowMessage.MsgForPromoter, 'OKCANCEL');//MsgForPromoter = Promoter Group details is not entered. Do you wish to continue and Save the Rights ?
        return Check = false;
    }
    else {
        return Check = true;
    }
}
function ValidateSave() {
    debugger;
    var IsValidSave = true;
    if ($('#hdnEditRecord').val() != '') {
        IsValidSave = false;
        showAlert('E', ShowMessage.MsgForAddEdit);//MsgForAddEdit = Please complete Add/Edit operation first
    }
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");

    var hdnTitle_Code = $("#hdnTitle_Code");
    var hdnRegion_Code = $("#hdnRegion_Code");
    var hdnDub_Code = $("#hdnDub_Code");
    var hdnSub_Code = $("#hdnSub_Code");

    hdnTitle_Code.val('');
    hdnRegion_Code.val('');
    hdnDub_Code.val('');
    hdnSub_Code.val('');

    var Excl = $('.exc:checked').val();
    // var temp = $('#hdnIs_Exclusive').val(Excl);
    $('#hdnIs_Exclusive').empty().val(Excl);
    //if (Excl == "Y") {
    //    $('#hdnIs_Exclusive').empty().val(true);
    //}
    //else {
    //    $('#hdnIs_Exclusive').empty().val(false);
    //}
    var selectedTitles = '';
    if ($("#lbTitles").val() != null)
        selectedTitles = $("#lbTitles").val().join(',');
    hdnTitle_Code.val(selectedTitles);
    if (selectedTitles == '') {
        IsValidSave = false;
        $("#divlbTitles").addClass("required");
    }

    if ($('input[type=radio][name=hdnExclusive]:checked').val() == undefined) {
        IsValidSave = false;
        $('#divExclusiveRights').addClass('required');
    }

    if ($('input[type=radio][name=rdoSublicensing]:checked').val() == undefined) {
        IsValidSave = false;
        $('#divSublicensingOptions').addClass('required');
    }
    else if ($('input[type=radio][name=rdoSublicensing]:checked').val() == "Y") {
        if ($('#ddlSub_License_Code').val() == null) {
            IsValidSave = false;
            $('#ddlSub_License_Code').attr('required', true);
        }
    }

    if ($("#hdnTVCodes").val() == '') {
        IsValidSave = false;
        $("#tree").attr('required', true);
        $("#tree").addClass('required');
    }

    var regionType = $("#rdoCountryHB").prop('checked') ? $("#rdoCountryHB").val() : $("#rdoTerritoryHB").val();
    $("#hdnRegion_Type").val(regionType);
    var selectedRegion = '';
    if ($("#lbTerritory option:selected").length > 0) {
        $("#lbTerritory option:selected").each(function () {
            if (selectedRegion == '')
                selectedRegion = $(this).val();
            else
                selectedRegion = selectedRegion + ',' + $(this).val();
        });
    }
    hdnRegion_Code.val(selectedRegion);
    if (selectedRegion == '') {
        IsValidSave = false;
        $("#divCountry").addClass("required");
    }

    var ErrorMsg = '';
    var Term = $('#Right_Type').val();
    if (Term == YearBased) {
        var txtStartDate = $('#Start_Date');
        var txtEndDate = $('#End_Date');
        var isTentative = false;
        if ($('#Is_Tentative').prop('checked'))
            isTentative = true;

        if (txtStartDate.val() == "") {
            IsValidSave = false;
            $("#Start_Date").attr('required', true);
        }

        if (txtEndDate.val() == "" && isTentative == false) {
            IsValidSave = false;
            $("#End_Date").attr('required', true);
        }

        if (txtStartDate.val() != "" && txtEndDate.val() != "" && compareDates_DMY(txtStartDate.val(), txtEndDate.val()) < 0) {
            IsValidSave = false;
            $("#Start_Date").attr('required', true);
            $("#End_Date").attr('required', true);
            txtROFRDays.val('');
            ErrorMsg = ShowMessage.MsgForDate;//MsgForDate = Start Date should be less than end date.
        }

        var txtYear = $('#Term_YY').val();
        var txtMonth = $('#Term_MM').val();
        var txtDay = $('#Term_DD').val();
        var rightED = "";
        if (isTentative == true && (txtYear == null || txtYear == '0' || txtYear == undefined || txtYear == '') && (txtMonth == null || txtMonth == '0' || txtMonth == undefined || txtMonth == '') && (txtDay == null || txtDay == '0' || txtDay == undefined || txtDay == '')) {
            IsValidSave = false;
            showAlert("E", ShowMessage.MsgValidTerm);//MsgValidTerm = Please enter valid Term
        }
        else {
            debugger;
            var rightSD = new Date(MakeDateFormate(txtStartDate.val()));
            var newDate = CalculateEndDate(rightSD, parseInt(txtYear), parseInt(txtMonth), parseInt(txtDay));
            rightED = new Date(MakeDateFormate(newDate));
        }

        if (IsValidSave) {
            var rightSD = new Date(MakeDateFormate(txtStartDate.val()));
            if (!isTentative)
                rightED = new Date(MakeDateFormate(txtEndDate.val()));

            rightED.setDate(rightED.getDate() + 1)

            var term = CalculateTerm(rightSD, rightED);
            var arr = term.split('.');
            $('#Term_YY').val(arr[0]);
            $('#Term_MM').val(arr[1]);
            $('#Term_DD').val(arr[2]);
        }
    }
    else if (Term == Milestone) {
        if ($("#Milestone_Start_Date").val() == "") {
            IsValidSave = false;
            $("#Milestone_Start_Date").attr('required', true);
        }

        if ($("#ddlMilestone_Type_Code").val() == null) {
            IsValidSave = false;
            $("#ddlMilestone_Type_Code").attr('required', true);
        }

        if ($("#txtMilestone_No_Of_Unit").val() == "") {
            IsValidSave = false;
            $("#txtMilestone_No_Of_Unit").attr('required', true);
        }

        if ($("#ddlMilestone_Unit_Type").val() == null) {
            IsValidSave = false;
            $("#ddlMilestone_Unit_Type").attr('required', true);
        }

    }
    else if (Term == Perpetuity) {
        if ($('#txtPerpetuity_Date').val() == "" || $('#txtPerpetuity_Date').val() == "DD/MM/YYYY") {
            IsValidSave = false;
            $("#txtPerpetuity_Date").attr('required', true);
        }
        if ($('#txtPerpetuity_EndDate').val() == "" || $('#txtPerpetuity_EndDate').val() == "DD/MM/YYYY") {
            IsValidSave = false;
            $("#txtPerpetuity_EndDate").attr('required', true);
        }
    }

    var dubbingType = $("#rdoDubbingL").prop('checked') ? $("#rdoDubbingL").val() : $("#rdoDubbingLG").val();
    $("#hdnDub_Type").val(dubbingType);
    var selectedDub = '';
    if ($("#lbDub_Language option:selected").length > 0) {
        $("#lbDub_Language option:selected").each(function () {
            if (selectedDub == '')
                selectedDub = $(this).val();
            else
                selectedDub = selectedDub + ',' + $(this).val();
        });
    }
    hdnDub_Code.val(selectedDub);

    var subType = $("#rdoSubL").prop('checked') ? $("#rdoSubL").val() : $("#rdoSubLG").val();
    $("#hdnSub_Type").val(subType);
    var selectedSub = '';
    if ($("#lbSub_Language option:selected").length > 0) {
        $("#lbSub_Language option:selected").each(function () {
            if (selectedSub == '')
                selectedSub = $(this).val();
            else
                selectedSub = selectedSub + ',' + $(this).val();
        });
    }
    hdnSub_Code.val(selectedSub);

    if ($("#Is_Title_Language_Right").prop('checked') == false && selectedSub == '' && selectedDub == '') {
        IsValidSave = false;
        $("#lbTerritory").attr('required', true);
        if (ErrorMsg != '')
            ErrorMsg = ErrorMsg + '</br>'

        ErrorMsg = ErrorMsg + ShowMessage.MsgForLang;//MsgForLang = Please select atleast one Language
    }

    if (!IsValidSave && $.trim(ErrorMsg) != '') {
        showAlert('E', ErrorMsg);
    }

    if (IsValidSave) {
        var ValidationMessage = '';
        ValidationMessage = CheckHBRegionWithRightsRegion();
        if (ValidationMessage != "Valid") {
            ValidationMessage = ShowMessage.MsgForRegion + ValidationMessage + ShowMessage.MsgForHB;
            //MsgForRegion = Please select Region
            //MsgForHB = as it is already selected in Holdback
            showAlert('E', ValidationMessage);
            return false;
        }
        ValidationMessage = CheckHBSubtitleRegionWithRightsSubtitle();
        if (ValidationMessage != "Valid") {
            ValidationMessage = ShowMessage.MsgForSubTitle + ValidationMessage + ShowMessage.MsgForHB;
            //MsgForSubTitle = Please select Subtitling language
            showAlert('E', ValidationMessage);
            return false;
        }
        ValidationMessage = CheckHBDubbingWithRightsDubbing();
        if (ValidationMessage != "Valid") {
            ValidationMessage = ShowMessage.MsgForDubb + ValidationMessage + ShowMessage.MsgForHB;
            //MsgForDubb = Please select Dubbing language
            showAlert('E', ValidationMessage);
            return false;
        }

        if (regionType == "G" || dubbingType == "G" || subType == "G") {
            var groupOfRegions = selectedRegion;
            if (regionType != "G")
                groupOfRegions = "";

            var groupOfDubs = selectedDub;
            if (dubbingType != "G")
                groupOfDubs = "";

            var groupOfSubs = selectedSub;
            if (subType != "G")
                groupOfSubs = "";

            var msg = ValidateGroups(groupOfRegions, groupOfDubs, groupOfSubs)
            if (msg != '') {
                showAlert('E', msg);
                return false;
            }
        }

        var msgSyn = "";
        if (Term == Perpetuity) {
            msgSyn = Validate_After_Syndication(selectedTitles, regionType, selectedRegion, subType, selectedSub, dubbingType, selectedDub,
                $('#txtPerpetuity_Date').val(), $('#txtPerpetuity_EndDate').val())
        }
        else {
            msgSyn = Validate_After_Syndication(selectedTitles, regionType, selectedRegion, subType, selectedSub, dubbingType, selectedDub,
                $('#Start_Date').val(), $('#End_Date').val())
        }
        if (msgSyn != '') {
            showAlert('E', msgSyn);
            return false;
        }
    }

    if (Term == YearBased) {
        msgSyn = Validate_Acq_Right_Title_Platform($("#hdnTVCodes").val(), selectedTitles, Term, isTentative,
            $('#Start_Date').val(), $('#End_Date').val(), '', '')
    }
    else if (Term == Milestone) {
        msgSyn = Validate_Acq_Right_Title_Platform($("#hdnTVCodes").val(), selectedTitles, Term, isTentative,
            $('#Milestone_Start_Date').val(), $('#Milestone_End_Date').val(), $('#txtMilestone_No_Of_Unit').val(), $('#ddlMilestone_Unit_Type').val())
    }
    else if (Term == Perpetuity) {
        msgSyn = Validate_Acq_Right_Title_Platform($("#hdnTVCodes").val(), selectedTitles, Term, isTentative,
            $('#txtPerpetuity_Date').val(), $('#txtPerpetuity_EndDate').val(), '', '')
    }

    if (msgSyn != '') {
        showAlert('E', msgSyn);
        return false;
    }

    $('#Milestone_No_Of_Unit').val($('#txtMilestone_No_Of_Unit').val());
    var title_Code = $('#hdnTitle_Code').val();
    if (IsValidSave) {
        var duplicate = showHoldbackValidationPopup(title_Code);
        if (duplicate == false)
            IsValidSave = true;
        else
            IsValidSave = false;
    }
    if (IsValidSave == true) {
        if ($('#IsPromoter').val() == 'Y') {
            var CheckPromoters = CheckPromoter();
            if (CheckPromoters) {
                IsValidSave = true;
            }
            else {
                IsValidSave = false;
            }
        }
    }
    if (IsValidSave)
        showLoading();

    return IsValidSave;
}
function ValidateGroups(RegionCodes, DubbingCodes, SubtitlingCodes) {
    var msg = '';
    $.ajax({
        type: "POST",
        url: URL_Validate_Groups,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            Region_Codes: RegionCodes,
            Dubbing_Codes: DubbingCodes,
            Subtitling_Codes: SubtitlingCodes
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            msg = result;
        },
        error: function (result) {
        }
    });
    return msg;
}
function Validate_After_Syndication(TitCodes, RegType, RegCodes, SubType, SubCodes, DubType, DubCodes, RightStartDate, RightEndDate) {
    var msg = '';
    $.ajax({
        type: "POST",
        url: URL_Validate_Acq_Rights_After_Syndication,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            Tit_Codes: TitCodes,
            Reg_Type: RegType,
            Reg_Codes: RegCodes,
            Sub_Type: SubType,
            Sub_Codes: SubCodes,
            Dub_Type: DubType,
            Dub_Codes: DubCodes,
            Right_Start_Date: RightStartDate,
            Right_End_Date: RightEndDate,
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            msg = result;
        },
        error: function (result) {
        }
    });
    return msg;
}
function Validate_Acq_Right_Title_Platform(hdnPlatform, hdnMMovies, Right_Type, Is_Tentative, Start_Date, End_Date, milestoneNoOfUnit, milestoneUnitType) {
    var msg = '';
    $.ajax({
        type: "POST",
        url: URL_Validate_Acq_Right_Title_Platform,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            hdnPlatform: hdnPlatform,
            hdnMMovies: hdnMMovies,
            Right_Type: Right_Type,
            Is_Tentative: Is_Tentative,
            Start_Date: Start_Date,
            End_Date: End_Date,
            milestoneNoOfUnit: milestoneNoOfUnit,
            milestoneUnitType: milestoneUnitType
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            msg = result;
        },
        error: function (result) {
        }
    });
    return msg;
}
function Cancel_Rights() {
    $('#hdnCommandName').val('CANCEL');
    showAlert('I', ShowMessage.MsgForunsavedData, 'OKCANCEL');
    //MsgForunsavedData = All unsaved data will be lost, still want to go ahead
}
function handleCancel() {
    if (MessageFrom == "DOMESTIC_CHECK_UNCHECK") {
        var isCheck = false;
        if ($('#Is_Theatrical_Right').prop('checked') == true) {
            var selection = "check";
            isCheck = true;
        }
        MessageFrom = '';
        $('#Is_Theatrical_Right').prop('checked', !isCheck);
        $('#hdnIs_Theatrical_Right').val(!isCheck);
    }
    if (MessageFrom == "PR")
        Check = false;
}
function chkHoldback_TitleLanguage(chk) {

    var isFound = "NO";
    if (!chk.checked) {
        if ($('#Title_Language_Added_For_Holdback').val() == 'Y')
            isFound = "YES";
    }
    if (isFound == "YES") {
        showAlert('E', ShowMessage.VDMsgForHB);//VDMsgForHB = Holdback already added for Title Language
        $('#hdnIs_Title_Language_Right').val(!chk.checked);
        return false;
    }
    $('#hdnIs_Title_Language_Right').val(chk.checked);
}
function chkIsExclusive(chk) {
    $('#hdnIs_Exclusive').val(chk.checked);
}
function BindPlatform() {
    $.ajax({
        type: "POST",
        url: URL_BindPlatformTreeView,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            strPlatform: $("#hdnTVCodes").val()
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            $('#tree').html(result);
        },
        error: function (result) { }
    });
}
function handleOk() {
    if (MessageFrom == "DOMESTIC_CHECK_UNCHECK") {
        MessageFrom = '';
        ReSetTheatrical();
    }

    if (MessageFrom == 'SV') {
        if ($('#hdnTabName').val() == '') {
            //window.location.href = URL_Acq_Rights_List_Index;
            BindPartialTabs(pageRights_List);
        }
        else {
            //$.ajax({
            //    type: "POST",
            //    url: URL_Global_ChangeTab,
            //    traditional: true,
            //    enctype: 'multipart/form-data',
            //    contentType: "application/json; charset=utf-8",
            //    async: false,
            //    data: JSON.stringify({
            //        tabName: $('#hdnTabName').val()
            //    }),
            //    success: function (result) {
            //        if (result == "true") {
            //            redirectToLogin();
            //        }
            //        else {
            //            window.location.href = result.Redirect_URL;
            //        }
            //    },
            //    error: function (result) {
            //        alert('Error: ' + result.responseText);
            //    }
            //});
            var tabName = $('#hdnTabName').val()
            BindPartialTabs(tabName);
        }
    }
    if ($('#hdnCommandName').val() != undefined && $('#hdnCommandName').val() != '' && $('#hdnCommandName').val() == "CANCEL") {
        showLoading();
        //$.ajax({
        //    type: "POST",
        //    url: URL_Cancel_Rights,
        //    traditional: true,
        //    enctype: 'multipart/form-data',
        //    contentType: "application/json; charset=utf-8",
        //    success: function (result) {
        //        if (result == "true")
        //            redirectToLogin();

        //        hideLoading();
        //        window.location.href = URL_Global_RedirectToControl.replace("PageNo", result);
        //    },
        //    error: function (result) {
        //        alert('Error');
        //    }
        //});
        BindPartialTabs(pageRights_List);
    }

    if ($('#dummyProperty') != null && $('#dummyProperty').val() != undefined && $('#dummyProperty').val() != '') {
        showLoading();
        var dummyProperty = $('#dummyProperty').val();
        $.ajax({
            type: "POST",
            url: URL_Delete_Holdback,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({
                DummyProperty: dummyProperty
            }),
            success: function (result) {
                if (result == "true")
                    redirectToLogin();

                $('#dummyProperty').val('');
                Bind_Holdback();
                var count = parseInt($('#spnHoldBackCount').text());
                count -= 1;
                $('#spnHoldBackCount').text(count);
                if ($('#Is_Theatrical_Right').prop('checked') == false) {
                    BindPlatform();
                }
                hideLoading();
                $('#spnHoldBackCount').text(count);
                showAlert('S', ShowMessage.MsgForHBDelete);//MsgForHBDelete = Holdback deleted successfully
            },
            error: function (result) {
                hideLoading();
                alert('Error: ' + result.responseText);
            }
        });
    }
    if ($('#hdnDummyProp') != null && $('#hdnDummyProp').val() != undefined && $('#hdnDummyProp').val() != '') {
        $.ajax({
            type: "POST",
            url: URL_Delete_Blackout,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            data: JSON.stringify({
                DummyProperty: $('#hdnDummyProp').val()
            }),
            success: function (result) {
                if (result == "true")
                    redirectToLogin();

                //$('#tabBlackout').html(result);
                var count = parseInt($('#spnBlackOutCount').text());
                count -= 1;
                $('#spnBlackOutCount').text(count);
                Bind_BlackOut();

                initializeDatepicker();
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }

    if ($('#hdnDummyPropPro') != null && $('#hdnDummyPropPro').val() != undefined && $('#hdnDummyPropPro').val() != '') {
        $.ajax({
            type: "POST",
            url: URL_Delete_Promoter,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                DummyProperty: $('#hdnDummyPropPro').val()
            }),
            async: false,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                var count = parseInt($('#spnPromotercount').text());
                count -= 1;
                $('#spnPromotercount').text(count);
                $('a[href="#tabHoldback"]').prop("disabled", false);
                $('a[href="#tabRestriction"]').prop("disabled", false);
                $('a[href="#tabBlackout"]').prop("disabled", false);
                Bind_Promoter();

                hideLoading();

            },
            error: function (result) {
                hideLoading();
                alert('Error Validate_Save_Rights: ' + result.responseText);
            }
        });
    }
    if (MessageFrom == 'PR') {
        showLoading();
        Check = true;
        MessageFrom = '';
        $('#frmRights').submit();
    }
}
function OnSuccess(message) {
    hideLoading();
    if (message == "ERROR") {
        Show_Validation_Popup("", 5, 0);
    }
    else if (message != "") {
        MessageFrom = "SV"
        showAlert('S', message, 'OK');
    }
}

function BindAllPreReq_Async() {

    $.ajax({
        type: "POST",
        url: URL_BindAllPreReq_Async,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: true,
        success: function (result) {

            if (result == "true") {
                redirectToLogin();
            }
            else {
                $.each(result.Title_List, function () {
                    $("#lbTitles").append($("<option />").val(this.Value).text(this.Text));
                });

                if (result.Selected_Title_Code != '')
                    $("#lbTitles").val(result.Selected_Title_Code.split(','))

                $.each(result.Region_List, function () {
                    $("#lbTerritory").append($("<option />").val(this.Value).text(this.Text));

                });
                if (result.Selected_Region_Code != '')
                    $("#lbTerritory").val(result.Selected_Region_Code.split(','))

                $.each(result.Sub_License_List, function () {
                    $("#ddlSub_License_Code").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlSub_License_Code").val(result.Sub_License_Code)

                $.each(result.Milestone_Type_List, function () {
                    $("#ddlMilestone_Type_Code").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlMilestone_Type_Code").val(result.Milestone_Type_Code)

                $.each(result.Milestone_Unit_Type_List, function () {
                    $("#ddlMilestone_Unit_Type").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlMilestone_Unit_Type").val(result.Milestone_Unit_Type)

                $.each(result.ROFR_List, function () {
                    $("#ROFR_Code").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ROFR_Code").val(result.ROFR_Code)

                $.each(result.Subtitle_List, function () {
                    $("#lbSub_Language").append($("<option />").val(this.Value).text(this.Text));
                });
                if (result.Selected_Subtitling_Code != '') {
                    $("#lbSub_Language").val(result.Selected_Subtitling_Code.split(','))

                }

                $.each(result.Dubbing_List, function () {
                    $("#lbDub_Language").append($("<option />").val(this.Value).text(this.Text));
                });
                if (result.Selected_Dubbing_Code != '') {
                    $("#lbDub_Language").val(result.Selected_Dubbing_Code.split(','))

                }


                $("#ddlSub_License_Code,#ddlMilestone_Type_Code,#ddlMilestone_Unit_Type,#ROFR_Code").trigger("chosen:updated");

                for (var i = 0; i <= 3; i++) {
                    $('#lbTitles,#lbTerritory,#lbSub_Language,#lbDub_Language')[i].sumo.reload();
                }
                //$('#lbTitles,#lbTerritory,#lbSub_Language,#lbDub_Language').each(function () {
                //    $()
                //});
                SetTitleLanguage();
                if (mode_G == "E" || mode_G == "C") {
                    if (isTheatricalRight_G != "Y")
                        BindPlatform()
                }
                else
                    BindPlatform();
                fillTotal();
                fillTotal('LS');
                fillTotal('LD');
                hideLoading();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}

function CalculateMilestoneEndDate() {
    var strSD = $('#Milestone_Start_Date').val();
    var strNo = $('#txtMilestone_No_Of_Unit').val();

    if (strSD != '' && strNo != '') {
        var startDate = new Date(MakeDateFormate(strSD));
        if (!isNaN(startDate)) {
            var unit = $('#ddlMilestone_Unit_Type').val();
            if (unit != null) {
                var day = 0, month = 0, year = 0;
                switch (unit) {
                    case "1":
                        day = parseInt(strNo);
                        break;

                    case "2":
                        day = parseInt(strNo) * 7;
                        break;
                    case "3":
                        month = parseInt(strNo);
                        break;

                    case "4":
                        year = parseInt(strNo);
                        break;
                }
                var endDate = CalculateEndDate(startDate, year, month, day);
                $('#Milestone_End_Date').val(endDate);
                if ($('#ROFR_Days').val() != "")
                    CalculateROFRDate();
            }
        }
    }
}

function CalculatePerpetuityEndDate() {
    var strSD = $('#txtPerpetuity_Date').val();
    if (strSD != '' && $('#hdnTerm_Perputity').val() != undefined && $('#hdnTerm_Perputity').val() != '' && $('#txtPerpetuity_EndDate').val() != undefined) {
        var startDate = new Date(MakeDateFormate(strSD));
        if (!isNaN(startDate)) {
            var year = $('#hdnTerm_Perputity').val();
            var endDate = CalculateEndDate(startDate, year, 0, 0);
            $('#txtPerpetuity_EndDate').val(endDate);
        }
    }
}

function fillTotal(check) {
    var selectedCount = 0, selectedRegion = '';

    if (check == 'LS') {
        if ($("#lbSub_Language option:selected").length > 0) {
            $("#lbSub_Language option:selected").each(function () {
                if (selectedRegion == '') {
                    selectedRegion = $(this).val();
                }
                else {
                    selectedRegion = selectedRegion + ',' + $(this).val();
                }
                selectedCount++
            });
        }
        $('#lblLanguageCount').html(selectedCount);
    }

    if (check == 'LD') {
        if ($("#lbDub_Language option:selected").length > 0) {
            $("#lbDub_Language option:selected").each(function () {
                if (selectedRegion == '') {
                    selectedRegion = $(this).val();
                }
                else {
                    selectedRegion = selectedRegion + ',' + $(this).val();
                }
                selectedCount++
            });
        }
        $('#lblDubbingCount').html(selectedCount);
    }

    else if (check == 'HLS') {
        if ($("#lbDub_Language option:selected").length > 0) {
            $("#lbDub_Language option:selected").each(function () {
                if (selectedRegion == '') {
                    selectedRegion = $(this).val();
                }
                else {
                    selectedRegion = selectedRegion + ',' + $(this).val();
                }
                selectedCount++
            });
        }
        $('#lblDubbingCount').html(selectedCount);
    }

    else {
        if ($("#lbTerritory option:selected").length > 0) {
            $("#lbTerritory option:selected").each(function () {
                if (selectedRegion == '') {
                    selectedRegion = $(this).val();
                }
                else {
                    selectedRegion = selectedRegion + ',' + $(this).val();
                }
                selectedCount++
            });
        }
        $('#lblTerritoryCount').html(selectedCount);
    }

}

function ShowHideSublicensingList(show) {
    if (show) {
        $('#divSublicensingList').show();
        $('#hdnSub_License_Code').val($('#ddlSub_License_Code').val());
    }
    else {
        $('#divSublicensingList').hide();
        $('#hdnSub_License_Code').val(0);
    }
}
function ApplyTemplate() {
    debugger;
    showLoading();
    var Code = $("#ddlTemplate_List").val();
    if (Code != "") {
        $.ajax({
            type: "POST",
            url: URL_ApplyTemplate,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                ARTCode: Code
            }),
            async: true,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    debugger;
                    $("#hdnTVCodes").val(result.objAcq_Rights_Template.Platform_Codes);
                    BindPlatform();

                    if (result.objAcq_Rights_Template.Is_Exclusive == "Y")
                        $("#rdoIsExclusiveY3").prop('checked', true);
                    else
                        $("#rdoIsExclusiveN3").prop('checked', true);

                    if (result.objAcq_Rights_Template.Is_Title_Language == "Y")
                        $("#Is_Title_Language_Right").prop('checked', true);
                    else
                        $("#Is_Title_Language_Right").prop('checked', false);

                    chkHoldback_TitleLanguage($("#Is_Title_Language_Right")[0]);

                    if (result.objAcq_Rights_Template.Region_Type == "I") {
                        $("#rdoCountryHB").prop('checked', true);
                        BindDropdown('I', true);
                    }
                    else if (result.objAcq_Rights_Template.Region_Type == "G") {
                        $("#rdoTerritoryHB").prop('checked', true);
                        BindDropdown('T', true);
                    }

                    if (result.objAcq_Rights_Template.Is_Sublicense == "Y") {
                        $("#rdoSublicensingY").prop('checked', true);
                        ShowHideSublicensingList(true)
                        $("#ddlSub_License_Code,#hdnSub_License_Code").val(result.objAcq_Rights_Template.SubLicense_Code);
                    }
                    else {
                        $("#rdoSublicensingN").prop('checked', true);
                        ShowHideSublicensingList(false)
                    }

                    if (result.objAcq_Rights_Template.Subtitling_Type == "G") {
                        $("#rdoSubLG").prop('checked', true);
                        BindDropdown('SG', true);
                    }
                    else if (result.objAcq_Rights_Template.Subtitling_Type == "L") {
                        $("#rdoSubL").prop('checked', true);
                        BindDropdown('SL', true);
                    }

                    if (result.objAcq_Rights_Template.Dubbing_Type == "G") {
                        $("#rdoDubbingLG").prop('checked', true);
                        BindDropdown('DG', true);
                    }
                    else if (result.objAcq_Rights_Template.Dubbing_Type == "L") {
                        $("#rdoDubbingL").prop('checked', true);
                        BindDropdown('DL', true);
                    }

                    if (result.objAcq_Rights_Template.Region_Codes != '')
                        $("#lbTerritory").val(result.objAcq_Rights_Template.Region_Codes.split(','))

                    if (result.objAcq_Rights_Template.Dubbing_Codes != '')
                        $("#lbDub_Language").val(result.objAcq_Rights_Template.Dubbing_Codes.split(','))

                    if (result.objAcq_Rights_Template.Subtitling_Codes != '')
                        $("#lbSub_Language").val(result.objAcq_Rights_Template.Subtitling_Codes.split(','))

                    $("#ddlSub_License_Code").trigger("chosen:updated");

                    $('#lbTerritory')[0].sumo.reload();
                    $('#lbSub_Language')[0].sumo.reload();
                    $('#lbDub_Language')[0].sumo.reload();

                    hideLoading();
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
    hideLoading();
}
