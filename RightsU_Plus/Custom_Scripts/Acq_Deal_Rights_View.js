var TabType = 'RR'
var YearBased = "Y";
var Milestone = "M";
var Perpetuity = "U";

$(document).ready(function () {
    setChosenWidth('#ROFR_Code', '40%');
    $("#lblCountry").text('Country');
    if (recordLockingCode_G > 0) {
        Call_RefreshRecordReleaseTime(recordLockingCode_G, URL_Global_Refresh_Lock);
    }
    //});
    // EDIT SECTION START

    if (mode_G == "V") {
        SetRightPeriod(rightType_G)
        if (isTheatricalRight_G == "Y") {
            $('#lblTheatrical').show();
            $("#lblCountry").text('Circuit');
            $('#' + treeID_G).hide();
        }

        if (disableRightType_G == "Y") {
            if (existingRightType_G == Milestone) {
                //DISABLE PERP
                $('#tabValidity a[href="#tabCal"]').prop("disabled", true);

                //DISABLE YEARBASE
                $('#tabValidity a[href="#tabPerp"]').prop("disabled", true);

                $('#tabValidity a[href="#tabCal"]').prop("title", ShowMessage.MsgTabCal);//MsgTabCal = Can not select right type year based as rights already syndicated
                $('#tabValidity a[href="#tabPerp"]').prop("title", ShowMessage.MsgTabPerp);//MsgTabPerp = Can not select right type perpetuity as rights already syndicated

            }
            else {
                //$('#someTab').tab('show')
                $('#tabValidity a[href="#tabMile"]').prop("disabled", true);
                //DISABLE MILESTONE
                $('#tabValidity a[href="#tabPerp"]').prop("title", ShowMessage.MsgTabMile);//MsgTabMile = Can not select right type milestone as rights already syndicated

            }
        }

    }
    //END

    if (showPopup_G == "ERROR") {
        Show_Validation_Popup("", 5, 0);
    }
    else if (message_G != "") {
        showAlert('S', message_G, 'OK');
    }

    function CalculateTerm(startDate, endDate) {
        var val = CalculateMonthBetweenTwoDate(startDate, endDate);
        var year = val / 12;
        var month = val % 12;
        var term = parseInt(year) + '.' + month;
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
        }
    }

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
    $("#ROFR_Days").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        maxPreDecimalPlaces: 3,
        maxDecimalPlaces: 0
    });
    $("#Milestone_No_Of_Unit").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        maxPreDecimalPlaces: 2,
        maxDecimalPlaces: 0
    });
    initializeTooltip();
    Bind_Holdback();
    Bind_BlackOut();
    if (isTheatricalRight_G == "N")
        BindPlatform();

    if (dealMode_G == 'APRV') {
        if (recordLockingCode_G > 0)
            Call_RefreshRecordReleaseTime(recordLockingCode_G, URL_Global_Refresh_Lock);
    }
});
function OnTabChange(obj) {
    debugger;
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
function Add_Holdback_Blackout(Call_FROM) {
    var Term = $('#Right_Type').val();
    var Period = '';
    var isTentative = 'False';
    var PeriodTerm = '';

    if (Term == YearBased) {
        var txtStartDate = $('#Start_Date');
        var txtEndDate = $('#End_Date');
        Period = txtStartDate.val() + ' To ' + txtEndDate.val();
        if ($('#Is_Tentative').prop('checked'))
            isTentative = 'True';
        PeriodTerm = $('#Term_YY').val() + ' Year' + $('#Term_MM').val() + ' Month';
    }
    else if (Term == Milestone) {
        if ($("#Milestone_No_Of_Unit").val() == "") {
            PeriodTerm = $('#ddlMilestone_Type_Code').text() + ' Valid For ' + $("#Milestone_No_Of_Unit").val() + ' ' + $('#ddlMilestone_Unit_Type').text();
        }
        if ($('#Milestone_SD').text() != '' && $('#Milestone_ED').text() != '')
            Period = $('#Milestone_SD').text() + ' To ' + $('#Milestone_ED').text();
    }
    else if (Term == Perpetuity) {
        if ($('#txtPerpetuity_Date').val() == "" || $('#txtPerpetuity_Date').val() == "DD/MM/YYYY") {
            Period = $('#txtPerpetuity_Date').val() + ' To Perpetuity';
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
                strPlatform: $("#hdnTVCodes").val()
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                $('#popEditHB').html(result);
                initializeChosen();
                initializeDatepicker();
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
            $.ajax({
                type: "POST",
                url: URL_Add_Blackout,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                dataType: "html",
                data: JSON.stringify({}),
                success: function (result) {
                    if (result == "true") {
                        redirectToLogin();
                    }
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
}
function BindDropdown(radioType) {
    var Is_Thetrical = $('#Is_Theatrical_Right').prop('checked');
    var selectedId = '';

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
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            $("#" + selectedId).empty();
            $("#" + selectedId).trigger("chosen:updated");
            $.each(result, function () {
                $("#" + selectedId).append($("<option />").val(this.Value).text(this.Text));
            });
            $("#" + selectedId).trigger("chosen:updated");
        },
        error: function (result) {
            showAlert('E', 'Error: ' + result.responseText);
        }
    });
}
function handleOk() {
    if (messageFrom_G == 'SV') {
        //window.location.href = URL_Index;
        BindPartialTabs(pageRights_List);
    }
    if ($('#hdnCommandName').val() != undefined && $('#hdnCommandName').val() != '' && $('#hdnCommandName').val() == "CANCEL") {
        showLoading();
        BindPartialTabs(pageRights_List);
    }
}
function SetTheatrical(CallFrom) {
    //HERE  CallFROM  C- Means Change Event
    var ShowMsg = false;
    var tvCodes = $('#hdnTVCodes').val();
    var regionCodes = $('#lbTerritory').val();
    var confirmMsg = "";

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

    var selection = "uncheck";
    var isCheck = false;
    if ($('#Is_Theatrical_Right').prop('checked') == true) {
        var selection = "check";
        isCheck = true;
    }

    if (ShowMsg && CallFrom == 'C') {
        confirmMsg = 'Are you sure you want to ' + selection + '? All selected ' + confirmMsg + ' will get cleared, do you still want to continue?';
        if (!confirm(confirmMsg)) {
            $('#Is_Theatrical_Right').prop('checked', !isCheck);
            return false;
        }
    }

    if (isCheck) {
        $("#lblCountry").text('Circuit');
        $('#lblTheatrical').show();
        $('#' + treeID_G).hide();
        $('#hdnTVCodes').val(theatricalPlatformCode_G);
    }
    else {
        $('#lblTheatrical').hide();
        $("#lblCountry").text('Country');
        $('#hdnTVCodes').val('');
        $('#' + treeID_G).show();
    }
    var regionType = $("#rdoCountryHB").prop('checked') ? $("#rdoCountryHB").val() : $("#rdoTerritoryHB").val();
    regionType = regionType == "G" ? "T" : regionType;
    BindDropdown(regionType);
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
function MakeDateFormate(dateInString) {
    if (dateInString != null || dateInString != "") {
        var array = dateInString.split('/');
        var month = parseFloat(array[1]);
        switch (month) {
            case 1:
                array[1] = "Jan";
                break;

            case 2:
                array[1] = "Feb";
                break;

            case 3:
                array[1] = "Mar";
                break;

            case 4:
                array[1] = "Apr";
                break;

            case 5:
                array[1] = "May";
                break;

            case 6:
                array[1] = "Jun";
                break;

            case 7:
                array[1] = "Jul";
                break;

            case 8:
                array[1] = "Aug";
                break;

            case 9:
                array[1] = "Sep";
                break;

            case 10:
                array[1] = "Oct";
                break;

            case 11:
                array[1] = "Nov";
                break;

            case 12:
                array[1] = "Dec";
                break;
        }
        var format = array[0] + " " + array[1] + " " + array[2];
        return format;
    }
    return "";
}
function ClearHidden() {
    $("#hdnTabName").val('');
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
        error: function (result) {
        }
    });
}
function ValidateSave() {
    showLoading();
    var Isvalid = true;

    // Code for Maintaining approval remarks in session
    if (SaveApprovalRemarks())
        Isvalid = true;
    else
        Isvalid = false;

    if (Isvalid) {
        hideLoading();
        var tabName = $('#hdnTabName').val();
        BindPartialTabs(tabName);
    }
    else
        hideLoading();

    //Code end for approval
    return Isvalid;
}
function SaveApprovalRemarks() {
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