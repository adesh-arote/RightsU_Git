var IsHideLoading = true;
function OnTabChange(obj) {
    showLoading();
    if (obj == 'HB') {
        TabType = 'HB';
        Bind_Holdback();
        $('#btnAddSD').show();
    }
    else if (obj == "PR") {
        TabType = 'PR';
        $('#btnAddSD').show();
        Bind_Promoter();
    }
    else {
        if (obj == "BO") {
            TabType = 'BO';
            $('#btnAddSD').show();
        }
        else {
            TabType = 'RR';
            $('#btnAddSD').hide();
        }
        Bind_BlackOut();
    }
    hideLoading();
}
function CheckIfHoldbackExistAcq() {
    var j = $('#tabHoldback .grid_item').html();
    if (j != undefined) {
        $.ajax({
            type: 'POST',
            url: URL_CheckHBWithAcq,
            data: $('#frmRights').serialize(),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                return false;
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
                hideLoading();
                return false;
            }
        });
    }
}

function Bind_Holdback() {
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
            //  hideLoading();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}

function Bind_BlackOut() {
    //showLoading();
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
            //  hideLoading();
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
                $('#hdnpromoter').val('N');
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
function PromoterChange() {

    var Promoter = $('#Promoter_Flag').is(':checked');
    if (Promoter == true)
        $('#hdnPromoter').val('Y');
    else
        $('#hdnPromoter').val('N');

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
        showAlert('I', ShowMessage.PromoterGroupDetailsNotEntered, 'OKCANCEL');//MsgForPromoter = Promoter Group details is not entered. Do you wish to continue and Save the Rights ?
        return Check = false;
    }
    else {
        return Check = true;
    }
}

function Add_Holdback_Blackout(Call_FROM) {
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
                $(".lbTitles").attr('required', true);
                $(".lbTitles").addClass('required');
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
                $(".lbTerritory").attr('required', true);
                $(".lbTerritory").addClass('required');
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
                    ErrorMsg = ShowMessage.StartDateLessThanEndDate;
                }

                var txtYear = $('#Term_YY').val();
                var txtMonth = $('#Term_MM').val();
                if (isTentative == true && (txtYear == null || txtYear == '0' || txtYear == undefined || txtYear == '') && (txtMonth == null || txtMonth == '0' || txtMonth == undefined || txtMonth == '')) {
                    IsValidSave = false;
                    showAlert("E", ShowMessage.PleaseEnterValidTerm);
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
                $(".lbTerritory").addClass('required');
                if (ErrorMsg != '')
                    ErrorMsg = ErrorMsg + '</br>'

                ErrorMsg = ErrorMsg + ShowMessage.PleaseSelectOneLanguage;
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
                            var rightSD = new Date(MakeDateFormate(txtStartDate.val()));
                            var year = 0, month = 0;

                            if (txtTermYear.val() != '')
                                year = parseInt(txtTermYear.val());

                            if (txtTermMonth.val() != '')
                                month = parseInt(txtTermMonth.val());

                            var EndDate = CalculateEndDate(rightSD, year, month);

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
        showAlert('E', ShowMessage.PleaseCompleteAddEdit);
}

function BindDropdown(radioType, CallFrom) {
    debugger;
    //alert('Bind dropdown')
    var selectedTitles = '';
    if ($("#lbTitles").val() != null)
        selectedTitles = $("#lbTitles").val().join(',');
    var platformCodes = $('#hdnTVCodes').val();
    if (platformCodes == undefined)
        platformCodes = "";
    var region_type = $("#rdoCountryHB").prop('checked') ? 'I' : 'T';
    var SL_Type = $("#rdoSubL").prop('checked') ? 'SL' : 'SG';
    var DL_Type = $("#rdoDubbingL").prop('checked') ? 'DL' : 'DG';
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
    var selectedCodes = '';
    var selected_Territory = '';
    var selected_Sub_Lang = '';
    var selected_Dub_Lang = '';
    if (CallFrom == 'PF') {
        if (selectedCodes != "")
            selectedCodes = $('#' + selectedId).val();
    }

    $.ajax({
        type: "POST",
        url: URL_Bind_JSON_ListBox,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: true,
        data: JSON.stringify({
            str_Type: radioType,
            Is_Thetrical: Is_Thetrical,
            titleCodes: selectedTitles,
            platformCodes: platformCodes,
            Region_Type: region_type,
            rdbSubtitlingLanguage: SL_Type,
            rdbDubbingLanguage: DL_Type
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            if (result == 'Holdback is already added.') {
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
                if (radioType == 'A') {
                    var selected_Territory = $('#lbTerritory').val();
                    var selected_Sub_Lang = $('#lbSub_Language').val();
                    var selected_Dub_Lang = $('#lbDub_Language').val();
                    $("#lbTerritory,#lbSub_Language,#lbDub_Language").empty();
                }
                else {
                    $("#" + selectedId).empty();
                }
                $(result.USP_Result).each(function (index, item) {
                    if (this.Data_For == 'RGN')
                        $("#lbTerritory").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                    else if (this.Data_For == 'SL')
                        $("#lbSub_Language").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                    else if (this.Data_For == 'DL')
                        $("#lbDub_Language").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                });
                if (radioType == 'A') {
                    $("#lbTerritory").val(selected_Territory)[0].sumo.reload();
                    $("#lbSub_Language").val(selected_Sub_Lang)[0].sumo.reload();
                    $("#lbDub_Language").val(selected_Dub_Lang)[0].sumo.reload();
                }
                else
                    $("#" + selectedId).val(selectedCodes)[0].sumo.reload();
                if (selectedId == 'lbTerritory')
                    fillTotal();

                else if (selectedId == 'lbSub_Language')
                    fillTotal('LS');

                else if (selectedId == 'lbDub_Language')
                    fillTotal('LD');
            }
        }
        , error: function (result) {
            showAlert('E', 'Error: ' + result.responseText);
        }
    });
}

function BindListandDdl() {

    debugger;
    //alert('BindListandDdl');
    $.ajax({
        type: "POST",
        url: URL_Bind_JSON_ListBox,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: true,
        data: JSON.stringify({
            str_Type: "DR",//Here DR Call From Document.ready
            Is_Thetrical: $('#Is_Theatrical_Right').prop('checked'),
            titleCodes: '',
            platformCodes: '',
            Region_Type: '',
            rdbSubtitlingLanguage: '',
            rdbDubbingLanguage: ''
        }),
        success: function (result) {
            //hideLoading();
            if (result == "true") {
                redirectToLogin();
            }
            else {
                $(result.USP_Result).each(function (index, item) {
                    if (this.Data_For == null || this.Data_For == undefined || this.Data_For == '') {
                    }
                    else {
                        debugger;
                        if (this.Data_For == 'ROR')
                            $("#ROFR_Code").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                        if (this.Data_For == 'SBL') {
                            $("#Sub_License_Code").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                        }
                        if (this.Data_For == 'TIT')
                            $("#lbTitles").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                        if (this.Data_For == 'RGN')
                            $("#lbTerritory").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                        if (this.Data_For == 'SL')
                            $("#lbSub_Language").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                        if (this.Data_For == 'DL')
                            $("#lbDub_Language").append($("<option>").val(this.Display_Value).text(this.Display_Text));
                    }
                });
                debugger;
                $("#ROFR_Code").val(result.Selected_ROR).attr("selected", "true").trigger("chosen:updated");
                $("#Sub_License_Code").val(result.Selected_SBL).attr("selected", "true").trigger("chosen:updated");
                $("#lbTitles").val(result.Selected_Tit_Code.split(',')).attr("selected", "true")[0].sumo.reload();
                $("#lbTerritory").val(result.Selected_R_Code.split(',')).attr("selected", "true")[0].sumo.reload();


                $("#lbSub_Language").val(result.Selected_SL_Code.split(',')).attr("selected", "true")[0].sumo.reload();
                $("#lbDub_Language").val(result.Selected_DL_Code.split(',')).attr("selected", "true")[0].sumo.reload();

                if (Is_Theatrical_Right_G != 'Y')
                    BindPlatform();
                initializeTooltip();
                SetTitleLanguage();
                fillTotal();
                fillTotal('LS');
                fillTotal('LD');
            }
        }
    });
    //SBL	= SubLicencing					
    //SL  = SubTitle Lang.
    //SG  = SubTitle Lang. Group.
    //DL  = Dubbing Lang.				  
    //DG  = Dubbing Group.
    //T   = Territory
    //C   = Couuntry
    //THT = Theatrical Territory
    //THC = Theatrical Country             
    //var arr_ddlId = ['ROFR_Code', 'Sub_License_Code', 'lbTitles', 'lbTerritory', 'lbSub_Language', 'lbDub_Language'];

}

$(document).ready(function () {
    setChosenWidth('#ROFR_Code', '40%');
    debugger;
    var Exclusive = $("input[type='radio'][name='hdnExclusive']:checked").val();
    if (Exclusive != "C") {
        $('#trCoExRemarks').hide();
    }

    $("#lblCountry").text(ShowMessage.Country);
    if (Record_Locking_Code_G > 0) {
        var fullUrl = URL_Refresh_Lock;
        Call_RefreshRecordReleaseTime(Record_Locking_Code_G, fullUrl);
    }
    // EDIT SECTION START            
    if (MODE_G == "E" || MODE_G == "C") {
        SetRightPeriod(Right_Type_G)
        if (Is_Theatrical_Right_G == "Y") {
            $('#lblTheatrical').show();
            $("#lblCountry").text(ShowMessage.Circuit);
            $('#' + TreeId_G).hide();
        }
        //else
        //    BindPlatform();

        if (Right_Type_G == YearBased) {
            SetMinDt();
            SetMaxDt();
        }

        if (Disable_SubLicensing_G == "Y") {
            $('#Sub_License_Code').prop("disabled", true);
        }

        if (Disable_Tentative_G == "Y") {
            $('#Is_Tentative').prop("disabled", true);
        }

        if (Is_Tentative_G == "Y") {
            $('#End_Date').prop("disabled", true);
            $('#End_Date').val('');
        }

        if (Disable_Thetrical_G == "Y") {
            $('#Is_Theatrical_Right').prop("disabled", true);
        }

        if (Disable_IsExclusive_G == "Y") {
            $('#Is_Exclusive').prop("disabled", true);
        }
        if (Disable_TitleRights_G == "Y") {
            $('#Is_Title_Language_Right').prop("disabled", true);
        }

        if (Disable_RightType_G == "Y") {
            if (Existing_RightType_G == YearBased) {

                $('#tabValidity a[href="#tabPerp"]').prop("disabled", true);

                $('#tabValidity a[href="#tabPerp"]').prop("title", ShowMessage.Cannotselectrighttypeperpetuityasrightsalreadysyndicated);
            }
            else {
                $('#tabValidity a[href="#tabCal"]').prop("disabled", true);
                $('#tabValidity a[href="#tabCal"]').prop("title", ShowMessage.Cannotselectrighttypeyearbasedasrightsalreadysyndicated);
            }
        }
        else
            if (Disable_RightType_G == "M") {
                //DISABLE PERP
                $('#tabValidity a[href="#tabCal"]').prop("disabled", true);
                //DISABLE YEARBASE
                $('#tabValidity a[href="#tabPerp"]').prop("disabled", true);

            }
            else
                if (Disable_RightType_G == "R") {
                    //DISABLE PERP
                    //DISABLE YEARBASE
                    $('#tabValidity a[href="#tabPerp"]').prop("disabled", true);
                    $('#tabValidity a[href="#tabPerp"]').prop("title", ShowMessage.Cannotselectrighttypeperpetuityasrundefinitionalreadyadded);
                }

        var txtRemark = document.getElementById('Restriction_Remarks');
        countChar(txtRemark);
    }
    //else
    //    BindPlatform();
    //END    
    $('#lbTitles').change(function () {
        debugger;
        showLoading();

        var newPerLogic = $('#hdnAllow_Perpetual_Date_Logic').val();
        if (newPerLogic == "Y") {
            var Titles = $('#lbTitles').val() == null ? 0 : $('#lbTitles').val().length;
            if (Titles == 1) {
                $('#li_Perpetuity').show();
                CalculatePerpetuityEndDate()
            }
            else {
                $('#li_Perpetuity').hide();
            }
        }

        SetTitleLanguage();
        var Rmode = $('#hdn_RMODE').val();

        if (Rmode != undefined && Rmode == 'C') {
            $.ajax({
                type: "POST",
                url: URL_DeleteExistingPromoter,
                traditional: true,
                async: false,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                data: '',
                success: function (result) {
                    if (result == "true")
                        redirectToLogin();
                    else {
                        Bind_Promoter();
                        $('#spnPromotercount').text('0');
                    }
                },
                error: function (x, e) {
                    alert(x.responseText);
                    hideLoading();
                }
            });
        }

        if ($('#Is_Theatrical_Right').prop('checked') == true) {
            var SelectedCode = '';
            if ($("#lbTitles").val() != null)
                SelectedCode = $("#lbTitles").val().join(',');
            $.ajax({
                type: "POST",
                url: URL_CheckTheatrical,
                traditional: true,
                async: false,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    titleCodes: SelectedCode
                }),
                success: function (result) {
                    if (result == "true")
                        redirectToLogin();
                    $('#lblTheatrical').hide();
                    $('#hdnTVCodes').val('');
                    if (result == Theatrical_Platform_Code_G) {
                        $("#lblCountry").text('Circuit');
                        $('#lblTheatrical').show();
                        $('#' + TreeId_G).hide();
                        $('#hdnTVCodes').val(Theatrical_Platform_Code_G);
                        Is_Theatrical = 'Y';
                        $("#tree").removeClass('required');
                    }
                    TreeViewSelectedChange($('#Is_Theatrical_Right'));
                },
                error: function (x, e) {
                    alert(x.responseText);
                    hideLoading();
                }
            });
        }
        else {

            BindPlatform();
            TreeViewSelectedChange(document.getElementById('Rights_Platform'));
        }
        hideLoading();
    });

    $('#lbTitles').click(function () {
        debugger;
        SetTitleLanguage();
        if ($('#Is_Theatrical_Right').prop('checked') == true) {
            var SelectedCode = '';
            if ($("#lbTitles").val() != null)
                SelectedCode = $("#lbTitles").val().join(',');
            $.ajax({
                type: "POST",
                url: URL_CheckTheatrical,
                traditional: true,
                async: false,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    titleCodes: SelectedCode
                }),
                success: function (result) {
                    if (result == "true")
                        redirectToLogin();
                    $('#lblTheatrical').hide();
                    $('#hdnTVCodes').val('');
                    if (result == Theatrical_Platform_Code_G) {
                        $("#lblCountry").text('Circuit');
                        $('#lblTheatrical').show();
                        $('#' + TreeId_G).hide();
                        $('#hdnTVCodes').val(Theatrical_Platform_Code_G);
                        Is_Theatrical = 'Y';
                        $("#tree").removeClass('required');
                    }
                    TreeViewSelectedChange($('#Is_Theatrical_Right'));
                },
                error: function (x, e) {
                    alert(x.responseText);
                }
            });
        }
        else {

            BindPlatform();
            TreeViewSelectedChange(document.getElementById('Rights_Platform'));
        }
    });

    $('#Is_Theatrical_Right').change(function () {
        showLoading();
        SetTheatrical('C');
        hideLoading();
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
    // hideLoading();
    BindListandDdl();
    //initializeTooltip();
    //Bind_Holdback();
    //Bind_BlackOut();

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

        //startDate.setMonth(startDate.getMonth() + month);
        //startDate.setYear(startDate.getYear() + year);

        m = startDate.getMonth(),
            y = startDate.getFullYear();
        var LastDay = new Date(y, m + 1, 0);
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
function CalculateDaysBetweenTwoDates(startDate, endDate) {
    var oneDay = 24 * 60 * 60 * 1000; // hours*minutes*seconds*milliseconds
    var diffDays = Math.round(Math.abs((startDate.getTime() - endDate.getTime()) / (oneDay)))
    return diffDays;
}
function CalculatePerpetuityEndDate(ValidateSave = "") {
    debugger;
    var newPerLogic = $('#hdnAllow_Perpetual_Date_Logic').val();
    if (newPerLogic === "N") {
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
    else {
        var Titles = $('#lbTitles').val() == null ? 0 : $('#lbTitles').val().length;
        var perpetuityDate = $('#txtPerpetuity_Date').val();
        if (ValidateSave == "Y") {
            Titles = 1;
        }
        if (Titles == 1) {

            $.ajax({
                type: "POST",
                url: URL_GetPerpetuity_Logic_Date,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    perpetuityDate: perpetuityDate,
                    titleCodes: $('#lbTitles').val(),
                    callFromValidate: ValidateSave
                }),
                success: function (result) {
                    if (result == "true") {
                        redirectToLogin();
                    }
                    if (ValidateSave == "Y") {

                        if (result != "") {
                            showAlert("E", result + " does not have Release Date.")
                        }
                    }
                    else {
                        $('#txtPer_Date_Logic_EndDate').val(result);
                    }

                },
                error: function (x, e) {
                }
            });
        }
    }
}

var MessageFrom = '';
function handleOk() {
    debugger
    if (MessageFrom == "DOMESTIC_CHECK_UNCHECK") {
        MessageFrom = '';
        ReSetTheatrical();
    }

    if (MessageFrom == 'SV') {
        if ($('#hdnTabName').val() == '')
            BindPartialTabs(pageRights_List);
        else {
            var tabName = $('#hdnTabName').val()
            BindPartialTabs(tabName);
        }
    }
    if ($('#hdnCommandName').val() != undefined && $('#hdnCommandName').val() != '' && $('#hdnCommandName').val() == "CANCEL") {
        BindPartialTabs(pageRights_List);
    }

    //event.preventDefault();
    if (CommandName == "COPY_HB") {
        var j = HB_Code;
        //alert(j.toString());
        $.ajax({
            type: "POST",
            url: URL_CopyHoldbackFromAcq,
            data: { HoldbackCode: j.toString() },
            success: function (result) {
                //debugger;
                CommandName = "";
                if (result == "true") {
                    redirectToLogin();
                }
                $('#tabRights li[href="#tabHoldback"]').trigger('click');
                $('#hdnHB_Code').val(j.toString());

                BindPlatform();
            },
            error: function (result) { }
        });
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
                showAlert('S', ShowMessage.Holdbackdeletedsuccessfully);
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

                Bind_BlackOut();
                var count = parseInt($('#spnBlackOutCount').text());
                count -= 1;
                $('#spnBlackOutCount').text(count);

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

function CheckHBRegionWithRightsRegion() {
    $("#lbTerritory option:selected").prop('disabled', false);
    $("#lbTerritory option").removeAttr('disabled')

    //  $('#lbTerritory')[0].sumo.enable();
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
    //$("#lbSub_Language option:selected").prop('disabled', false);
    //$("#lbSub_Language option").removeAttr('disabled');

    $('#lbSub_Language')[0].sumo.enable();
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
    //$("#lbDub_Language option:selected").prop('disabled', false);
    //$("#lbDub_Language option").removeAttr('disabled');

    $('#lbDub_Language')[0].sumo.enable();
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
        if (EndDate != undefined && EndDate != '' && $('#Start_Date').val() != '' && (year > 0 || month > 0 || day > 0))
            setMinMaxDates('ROFR_DT', $('#Start_Date').val(), EndDate);
    }
}
function showHoldbackValidationPopup(title_Code) {
    debugger
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
            debugger
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
            //   alert(x.responseText);
        }
    });
    $('#popupValidationError').modal();
    initializeChosen();
    setChosenWidth('#lbSearchTitles', '500px');
    initializeExpander();
}

function SetTheatrical(CallFrom) {
    debugger
    //HERE  CallFROM  C- Means Change Event    

    var ShowMsg = false;
    var isCheck = false;
    var tvCodes = $('#hdnTVCodes').val();
    var regionCodes = $('#lbTerritory').val();
    var confirmMsg = "";
    var selection = "uncheck";

    if (tvCodes != "") {
        ShowMsg = true;
        confirmMsg = ShowMessage.Platform;
    }

    if (regionCodes != "" && regionCodes != null) {
        ShowMsg = true;

        if (confirmMsg != '')
            confirmMsg += ", ";

        confirmMsg += ShowMessage.Region;
    }

    if ($('#Is_Theatrical_Right').prop('checked') == true) {
        var selection = "check";
        isCheck = true;
    }

    if (ShowMsg && CallFrom == 'C') {
        confirmMsg = ShowMessage.Areyousureyouwantto + selection + ShowMessage.Allselected + confirmMsg + ShowMessage.willgetcleareddoyoustillwanttocontinue;
        MessageFrom = "DOMESTIC_CHECK_UNCHECK";
        showAlert("I", confirmMsg, "OKCANCEL");

        //if (!confirm(confirmMsg)) {
        //    $('#Is_Theatrical_Right').prop('checked', !isCheck);
        //    showAlert("I", confirmMsg);
        //    return false;
        //}

    }
    else {
        ReSetTheatrical();
    }

    //if (isCheck) {
    //    var SelectedCode = '';
    //    if ($("#lbTitles").val() != null)
    //        SelectedCode = $("#lbTitles").val().join(',');
    //    $.ajax({
    //        type: "POST",
    //        url: URL_CheckTheatrical,
    //        traditional: true,
    //        async: false,
    //        enctype: 'multipart/form-data',
    //        contentType: "application/json; charset=utf-8",
    //        data: JSON.stringify({
    //            titleCodes: SelectedCode
    //        }),
    //        success: function (result) {
    //            if (result == "true")
    //                redirectToLogin();
    //            $('#lblTheatrical').hide();
    //            $('#' + TreeId_G).hide();
    //            $('#hdnTVCodes').val('');
    //            if (result == Theatrical_Platform_Code_G) {
    //                $("#lblCountry").text('Circuit');
    //                $('#lblTheatrical').show();
    //                $('#hdnTVCodes').val(Theatrical_Platform_Code_G);
    //                Is_Theatrical = 'Y';
    //                $("#tree").removeClass('required');
    //            }
    //            TreeViewSelectedChange($('#Is_Theatrical_Right'));
    //        },
    //        error: function (x, e) {
    //            alert(x.responseText);
    //        }
    //    });
    //}
    //else {
    //    $('#lblTheatrical').hide();
    //    $("#lblCountry").text('Country');
    //    $('#hdnTVCodes').val('');
    //    BindPlatform();
    //    $('#' + TreeId_G).show();
    //    Is_Theatrical = 'N';
    //}
    //var regionType = $("#rdoCountryHB").prop('checked') ? $("#rdoCountryHB").val() : $("#rdoTerritoryHB").val();
    //regionType = regionType == "G" ? "T" : regionType;
    //ClearHoldbackGrid(Is_Theatrical);
    //BindDropdown(regionType, '');
    //Bind_Holdback();
}
function ReSetTheatrical() {
    debugger
    var Is_Theatrical = 'N';
    var isCheck = false;
    if ($('#Is_Theatrical_Right').prop('checked') == true) {
        var selection = "check";
        isCheck = true;
    }
    if (isCheck) {
        var SelectedCode = '';
        if ($("#lbTitles").val() != null)
            SelectedCode = $("#lbTitles").val().join(',');
        $.ajax({
            type: "POST",
            url: URL_CheckTheatrical,
            traditional: true,
            async: false,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                titleCodes: SelectedCode
            }),
            success: function (result) {
                if (result == "true")
                    redirectToLogin();
                $('#lblTheatrical').hide();
                $('#' + TreeId_G).hide();
                $('#hdnTVCodes').val('');
                if ($('#Is_Theatrical_Right').prop('checked') == true) {
                    $('#Tree_Filter_Rights_Platform').css("display", "none");
                }
                else {
                    $('#Tree_Filter_Rights_Platform').css("display", "block");
                    $('#tdExclusiveRight').css("width", "100px");
                    $('#tdExclusiveRight').css("padding", "0px");
                    $('#tdExclusiveDiv').css("padding-left", "0px");
                    $('#tdExclusiveDiv').css("padding-top", "0px");
                    $('#tdExclusiveDiv').css("padding-bottom", "0px");
                }
                if (result == Theatrical_Platform_Code_G) {
                    $("#lblCountry").text('Circuit');
                    $('#lblTheatrical').show();
                    $('#hdnTVCodes').val(Theatrical_Platform_Code_G);
                    Is_Theatrical = 'Y';
                    $("#tree").removeClass('required');
                }
                TreeViewSelectedChange($('#Is_Theatrical_Right'));
            },
            error: function (x, e) {
                alert(x.responseText);
            }
        });
    }
    else {
        $('#lblTheatrical').hide();
        $("#lblCountry").text('Country');
        $('#hdnTVCodes').val('');

        BindPlatform();
        $('#' + TreeId_G).show();
        $('#tdExclusiveRight').css("width", "100px");
        $('#tdExclusiveRight').css("padding", "0px");
        $('#tdExclusiveDiv').css("padding-left", "0px");
        $('#tdExclusiveDiv').css("padding-top", "0px");
        $('#tdExclusiveDiv').css("padding-bottom", "0px");
        Is_Theatrical = 'N';
    }
    var regionType = $("#rdoCountryHB").prop('checked') ? $("#rdoCountryHB").val() : $("#rdoTerritoryHB").val();
    regionType = regionType == "G" ? "T" : regionType;
    ClearHoldbackGrid(Is_Theatrical);
    BindDropdown(regionType, '');
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

    $('#Right_Type').val(rightType)
    $('#Original_Right_Type').val(rightType)

    if (rightType != YearBased) {
        $('#ROFR_DT').prop("disabled", true);
        $('#ROFR_Days').prop("disabled", true);
        $('#ROFR_DT').val('');
        $('#ROFR_Days').val('');
        if (rightType == Perpetuity)
            $('#ROFR_Code').prop("disabled", true);
        else
            $('#ROFR_Code').prop("disabled", false);
        CalculatePerpetuityEndDate();
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
                    showAlert('E', ShowMessage.Startdateisnotinproperformat);
                    return false;
                }
            }
            else {
                showAlert('E', ShowMessage.Pleaseselectstartdate);
                return false;
            }
        }
        else {
            if (txtEndDate.val() == "") {
                txtROFRDays.val('');
                showAlert('E', ShowMessage.Pleaseselectenddate);
                return false;
            }
            rightRD = new Date(MakeDateFormate(txtEndDate.val()));
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
                showAlert('E', ShowMessage.PleaseentervalidRefusalDays, 'ROFR_Days');
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
            showAlert('E', ShowMessage.ROFRdateisnotinproperformat, 'ROFR_DT');
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
                    showAlert('E', ShowMessage.Startdateisnotinproperformat);
                    return false;
                }
            }
            else {
                showAlert('E', ShowMessage.Pleaseselectstartdate);
                return false;
            }
        }
        else {
            if (txtEndDate.val() == "") {
                txtROFRDays.val('');
                showAlert('E', ShowMessage.Pleaseselectenddate);
                return false;
            }
            rightED = new Date(MakeDateFormate(txtEndDate.val()));
        }
    }
    var diff = new Date(rightED - ROFTDT);
    var days = diff / 1000 / 60 / 60 / 24;
    txtROFRDays.val(days);
    if (Term == YearBased) {
        if (txtStartDate.val() != "" && txtROFRDate.val() != "" && compareDates_DMY(txtStartDate.val(), txtROFRDate.val()) < 0) {
            showAlert('E', ShowMessage.PleaseentervalidRefusalDays, 'ROFR_DT');
            txtROFRDays.val('0');
            txtROFRDate.val('');
            return false;
        }
    }
}

function OnFocusLostTerm() {


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
                    showAlert('E', ShowMessage.StartDateisnotvalid, "Start_Date");
                    txtRightStartDate.val('');
                }
                if (isNaN(rightED)) {
                    showAlert('E', ShowMessage.EndDateisnotValid, "End_Date");
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
                    showAlert('E', ShowMessage.StartDateisnotvalid, "Start_Date");
                    txtRightStartDate.val('');
                }
            }
            else if (txtRightEndDate.val() != '') {
                var rightED = new Date(MakeDateFormate(txtRightEndDate.val()));
                if (isNaN(rightED)) {
                    showAlert('E', ShowMessage.EndDateisnotValid, "End_Date");
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

function SetTitleLanguage() {
    if ($("#lbTitles").val() != null) {
        var selectedTitles = $("#lbTitles").val().join(',');
        $.ajax({
            type: "POST",
            url: URL_GetTitleLanguageName,
            traditional: true,
            async: true,
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
                array[1] = ShowMessage.Jan;
                break;

            case 2:
                array[1] = ShowMessage.Feb;
                break;

            case 3:
                array[1] = ShowMessage.Mar;
                break;

            case 4:
                array[1] = ShowMessage.Apr;
                break;

            case 5:
                array[1] = ShowMessage.May;
                break;

            case 6:
                array[1] = ShowMessage.Jun;
                break;

            case 7:
                array[1] = ShowMessage.Jul;
                break;

            case 8:
                array[1] = ShowMessage.Aug;
                break;

            case 9:
                array[1] = ShowMessage.Sep;
                break;

            case 10:
                array[1] = ShowMessage.Oct;
                break;

            case 11:
                array[1] = ShowMessage.Nov;
                break;

            case 12:
                array[1] = ShowMessage.Dec;
                break;
        }
        var format = array[0] + "-" + array[1] + "-" + array[2];
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
        showAlert('E', ShowMessage.Pleaseselecttitle, 'lbTitles');
        return false;
    }

    if ($("#hdnTVCodes").val() == '') {
        showAlert('E', ShowMessage.PleaseselectPlatform);
        return false;
    }
    return true;
}

function ClearHidden() {
    $("#hdnTabName").val('');
}

function ValidateSave() {
    debugger;
    var IsValidSave = true;
    if ($('#hdnEditRecord').val() != '') {
        IsValidSave = false;
        showAlert('E', ShowMessage.PleaseCompleteAddEdit);
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

    //------------------ TITLE
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
        $(".lbTitles").attr('required', true);
        $(".lbTitles").addClass('required');
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

    if ($('input[type=radio][name=hdnExclusive]:checked').val() == undefined) {
        IsValidSave = false;
        $('#divExclusiveRights').addClass('required');
    }

    if ($('input[type=radio][name=rdoSublicensing]:checked').val() == undefined) {
        IsValidSave = false;
        $('#divSublicensingOptions').addClass('required');
    }
    else if ($('input[type=radio][name=rdoSublicensing]:checked').val() == "Y") {
        if ($('#Sub_License_Code').val() == null) {
            IsValidSave = false;
            $('#Sub_License_Code').attr('required', true);
        }
    }

    if (selectedRegion == '') {
        IsValidSave = false;
        $(".lbTerritory").attr('required', true);
        $(".lbTerritory").addClass('required');
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
            ErrorMsg = ShowMessage.StartDateLessThanEndDate;
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
    else if (Term == Perpetuity) {
        if ($('#txtPerpetuity_Date').val() == "" || $('#txtPerpetuity_Date').val() == "DD/MM/YYYY") {
            IsValidSave = false;
            $("#txtPerpetuity_Date").attr('required', true);
        }

        if ($('#txtPerpetuity_EndDate').val() == "" || $('#txtPerpetuity_EndDate').val() == "DD/MM/YYYY") {
            IsValidSave = false;
            $("#txtPerpetuity_EndDate").attr('required', true);
        }

        var newPerLogic = $('#hdnAllow_Perpetual_Date_Logic').val();
        if (newPerLogic = "Y") {
            CalculatePerpetuityEndDate("Y");

            var Titles = $('#lbTitles').val() == null ? 0 : $('#lbTitles').val().length;
            if (Titles == 1) {
                if ($('#txtPer_Date_Logic_EndDate').val() == "" || $('#txtPer_Date_Logic_EndDate').val() == "DD/MM/YYYY") {
                    IsValidSave = false;
                    $("#txtPer_Date_Logic_EndDate").attr('required', true);
                }
            }
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
        $(".lbTerritory").attr('required', true);
        $(".lbTerritory").addClass('required');
        if (ErrorMsg != '')
            ErrorMsg = ErrorMsg + '</br>'

        ErrorMsg = ErrorMsg + ShowMessage.PleaseSelectOneLanguage;
    }

    if (!IsValidSave && $.trim(ErrorMsg) != '') {
        showAlert('E', ErrorMsg);
    }
    if (IsValidSave) {
        var ValidationMessage = '';
        ValidationMessage = CheckHBRegionWithRightsRegion();
        if (ValidationMessage != "Valid") {
            ValidationMessage = ShowMessage.PleaseselectRegion + ValidationMessage + ShowMessage.asitisalreadyselectedinHoldback;
            showAlert('E', ValidationMessage);
            return false;
        }
        ValidationMessage = CheckHBSubtitleRegionWithRightsSubtitle();
        if (ValidationMessage != "Valid") {
            ValidationMessage = ShowMessage.PleaseselectSubtitlinglanguage + ValidationMessage + ShowMessage.asitisalreadyselectedinHoldback;
            showAlert('E', ValidationMessage);
            return false;
        }
        ValidationMessage = CheckHBDubbingWithRightsDubbing();
        if (ValidationMessage != "Valid") {
            ValidationMessage = ShowMessage.PleaseselectDubbinglanguage + ValidationMessage + ShowMessage.asitisalreadyselectedinHoldback;
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

        /**Code added for buyback**/
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

    msgSyn = Validate_Acq_Right_Title_Platform($("#hdnTVCodes").val(), selectedTitles, Term, isTentative,
        $('#Start_Date').val(), $('#End_Date').val())
    if (msgSyn != '') {
        showAlert('E', msgSyn);
        return false;
    }
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

    if (IsValidSave && (Dealmode_G == dealMode_View || Dealmode_G == 'APRV')) {
        var tabName = $('#hdnTabName').val();
        BindPartialTabs(tabName);
    }
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
    debugger;
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
            Right_End_Date: RightEndDate
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

function Validate_Acq_Right_Title_Platform(hdnPlatform, hdnMMovies, Right_Type, Is_Tentative, Start_Date, End_Date) {
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
            End_Date: End_Date
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
    showAlert('I', ShowMessage.Allunsavewillgone, 'OKCANCEL');
}

function handleCancel() {
    debugger
    if (MessageFrom == "DOMESTIC_CHECK_UNCHECK") {
        var isCheck = false;
        if ($('#Is_Theatrical_Right').prop('checked') == true) {
            var selection = "check";
            isCheck = true;
        }
        MessageFrom = '';
        $('#Is_Theatrical_Right').prop('checked', !isCheck);
        // $('#hdnIs_Theatrical_Right').val(!isCheck);
    }
    if (CommandName == "COPY_HB") {
        $.ajax({
            type: "POST",
            url: URL_CancelHoldbackCopy,
            async: false,
            success: function (result) {
                //debugger;
                CommandName = "";
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    $('#btnSaveDeal').click();
                }
            },
            error: function (result) { }
        });
    }
}

function chkHoldback_TitleLanguage(chk) {
    //debugger;
    var isFound = "NO";
    if (!chk.checked) {
        if ($('#Title_Language_Added_For_Holdback').val() == 'Y')
            isFound = "YES";
    }
    if (isFound == "YES") {
        showAlert('E', ShowMessage.HoldbackalreadyaddedforTitleLanguage);
        $('#hdnIs_Title_Language_Right').val(!chk.checked);
        return false;
    }
    $('#hdnIs_Title_Language_Right').val(chk.checked);
}

function chkIsExclusive(chk) {
    debugger;
    $('#hdnIs_Exclusive').val(chk.checked);
}

function BindPlatform() {
    var selectedTitles = '';
    if ($("#lbTitles").val() != null)
        selectedTitles = $("#lbTitles").val().join(',');
    $.ajax({
        type: "POST",
        url: URL_BindPlatformTreeView,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            strPlatform: $("#hdnTVCodes").val(),
            strTitles: selectedTitles
        }),
        async: true,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            $('#tree').html(result);
            if (IsHideLoading) //true - if this function call from document.ready
            {
                hideLoading();
                IsHideLoading = false;
            }
        },
        error: function (result) { }
    });
}

var CommandName = "";
var HB_Code = [];
function OnSuccess(message) {
    //debugger;
    hideLoading();
    if ($.type(message) == "array") {
        CommandName = "COPY_HB";
        HB_Code = message;
        showAlert('E', ShowMessage.DoyouwanttocopyholdbackfromAcquisition, 'YN');
        return false;
    }

    if (message == "ERROR") {
        Show_Validation_Popup("", 5, 0);
    }
    else if (message != "") {
        $.ajax({
            type: "POST",
            url: URL_ShowRestriction_Remarks_Popup,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            async: true,
            success: function (result) {
                //debugger;
                if (result == "true") {
                    redirectToLogin();
                }
                $('#BindRestRemarksPopup').html(result);
                $('#popupRestRemarks').modal();
                initializeExpander();
            },
            error: function (result) { }
        });
    }
}

function CloseRestRemarks() {
    //debugger;
    showLoading();
    $('#popupRestRemarks').modal('hide');
    $('.modal-backdrop').hide();
    if ($('#hdnTabName').val() == '')
        BindPartialTabs(pageRights_List);
    else {
        var tabName = $('#hdnTabName').val();
        if (tabName == 'GNR') {
            $(".modal-open").css('overflow', 'auto');
        }
        BindPartialTabs(tabName);
    }
    hideLoading();
}

function TreeViewSelectedChange(obj) {
    if (obj.id != 'Rights_HB_Platform') {
        BindDropdown('A', 'PF');
    }
}

function fillTotal(check) {
    debugger;
    var selectedCount = 0, selectedRegion = '';
    if (check == "LS") {
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

    else if (check == "LD") {
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
    }
    else {
        $('#divSublicensingList').hide();
    }
}

function ShowHideCoExRemarks(radio) {
    debugger;
    if (radio == 'C') {
        $('#trCoExRemarks').show()
        //$('#trCoExRemarks').css("display", "block");
    }
    else {
        $('#trCoExRemarks').hide()
        //$('#trCoExRemarks').css("display", "none");
    }
}