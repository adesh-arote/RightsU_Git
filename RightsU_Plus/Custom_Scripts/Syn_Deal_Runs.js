function showLimited2(obj2) {
    if (obj2.value == "C") {
        $('input[name=Is_Yearwise_Definition]').prop('disabled', '');
        document.getElementById("addLimited2").style.display = '';
        document.getElementById("lblAddLimited").style.display = '';
    }
    else if (obj2.value == "U") {
        $('#hdnIs_Yearwise_Definition').val('N');
        document.getElementById("addLimited2").style.display = 'none';
        document.getElementById("lblAddLimited").style.display = 'none';
        $('#addLimited2').val('');
        $('input[name=Is_Yearwise_Definition][value="N"]').prop('checked', true);
        $('#hdnIs_Yearwise_Definition').val('N');
        $('input[name=Is_Yearwise_Definition]').prop('disabled', 'disabled');
        document.getElementById("addrunsDef2").style.display = 'none';
        $('#addrunsDef2').html('');
        $("#addLimited2").removeAttr('required');
    }
}
$(document).ready(function () {
    showLoading();
    if (Record_Locking_Code_G > 0) {
        var fullUrl = URL_Refresh_Lock
        Call_RefreshRecordReleaseTime(Record_Locking_Code_G, fullUrl);
    }

    $('#ddlPTitle').change(function () {

        if ($("select#ddlPTitle").val() != null) {
            showLoading();
            if ($("select#ddlPPlatform").val() != null) {
                var channelCode = $("select#ddlPPlatform").val().join(",");
            }
            else {
                var channelCode = '';
            }

            $.ajax({
                type: "POST",
                url: URL_BindPlatform,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    titleCodes: $("select#ddlPTitle").val().join(","),
                    PlatformCodes: channelCode
                }),
                success: function (result) {
                    if (result == "true") {
                        redirectToLogin();
                    }
                    $('#ddlPPlatform').empty();
                    $("#ddlPPlatform")[0].sumo.reload();
                    $.each(result, function (i, room) {
                        $("#ddlPPlatform").append('<option value="' + room.Value + '">' +
                             room.Text + '</option>');
                        $("#ddlPPlatform")[0].sumo.reload();
                    });
                    hideLoading();
                },
                error: function (result) {
                    alert('Error: ' + result.responseText);
                    $('#ddlPPlatform').empty();
                    $("#ddlPPlatform")[0].sumo.reload();
                    hideLoading();
                }
            });
        }
        else {
            $('#ddlPPlatform').empty();
            $("#ddlPPlatform")[0].sumo.reload();
            hideLoading();
        }
    });

    $('#ddlPTitle + .btnSelectAll').click(function () {
        if ($("select#ddlPTitle").val() != null) {
            showLoading();
            if ($("select#ddlPPlatform").val() != null)
                var channelCode = $("select#ddlPPlatform").val().join(",");
            else
                var channelCode = '';
            $.ajax({
                type: "POST",
                url: URL_BindPlatform,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    titleCodes: $("select#ddlPTitle").val().join(","),
                    PlatformCodes: channelCode
                }),
                success: function (result) {
                    if (result == "true") {
                        redirectToLogin();
                    }
                    $('#ddlPPlatform').empty();
                    $("#ddlPPlatform")[0].sumo.reload();
                    $.each(result, function (i, room) {

                        $("#ddlPPlatform").append('<option value="' + room.Value + '">' +
                             room.Text + '</option>');
                        $("#ddlPPlatform")[0].sumo.reload();
                    });
                    hideLoading();
                },
                error: function (result) {
                    alert('Error: ' + result.responseText);
                    $('#ddlPPlatform').empty();
                    $("#ddlPPlatform")[0].sumo.reload();
                    hideLoading();
                }
            });
        }
        else {
            $('#ddlPPlatform').empty();
            $("#ddlPPlatform")[0].sumo.reload();
            hideLoading();
        }
    });

    if (Syn_Deal_Run_Code_G > 0) {
        var strTitleHiddenHtml = '';
        var titleIndex = 0;
        var runType = Run_Type_G;
        $('input[name=Run_Type][value=' + runType + ']').prop('checked', true);
        if (runType == "C") {
            $('input[name=Is_Yearwise_Definition]').prop('disabled', '');
            document.getElementById("addLimited2").style.display = '';
            document.getElementById("lblAddLimited").style.display = '';
        }
        else if (runType == "U") {
            document.getElementById("addLimited2").style.display = 'none';
            document.getElementById("lblAddLimited").style.display = 'none';
            $('input[name=Is_Yearwise_Definition][value="N"]').prop('checked', true);
            $('#hdnIs_Yearwise_Definition').val('N');
            $('input[name=Is_Yearwise_Definition]').prop('disabled', 'disabled');
            document.getElementById("addrunsDef2").style.display = 'none';
        }

        var isYearWise = Is_Yearwise_Definition_G
        $('input[name=Is_Yearwise_Definition][value=' + isYearWise + ']').prop('checked', true)

        if (isYearWise == "Y") {
            document.getElementById("addrunsDef2").style.display = '';
            $.ajax({
                type: "POST",
                url: URL_PartialYearWiseList,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({}),
                success: function (result) {
                    if (result == "true") {
                        redirectToLogin();
                    }
                    $('#addrunsDef2').html(result);
                    $('.numbertext').numeric({
                        allowMinus: false,
                        allowThouSep: false,
                        allowDecSep: false,
                        maxPreDecimalPlaces: 5,
                        maxDecimalPlaces: 0
                    });
                    hideLoading();
                },
                error: function (result) {
                    alert('Error: ' + result.responseText);
                    hideLoading();
                }
            });
        }
        else
            document.getElementById("addrunsDef2").style.display = 'none';

        var isRuleRight = Is_Rule_Right_G;

        $('input[name=Is_Rule_Right][value=' + isRuleRight + ']').prop('checked', true)
        var RulRightCode = Right_Rule_Code_G
        $("select#ddlRuleRight.form_input.chosen-select").val(RulRightCode).trigger("chosen:updated");

        if (isRuleRight == "Y") {
            var repeatWithinDaysHrs = Repeat_Within_Days_Hrs_G
            bindRuleRecord(document.getElementById('ddlRuleRight'));
            for (var i = 1; i < 8; i++) {
                document.getElementById("RuleEdit_" + i).style.display = '';
            }
            debugger;
            if (repeatWithinDaysHrs == 'D') {
                if (Syn_Deal_Run_Repeat_On_Day_Count_G != null && Syn_Deal_Run_Repeat_On_Day_Count_G != undefined) {
                    Set_Repeat_Day_Codes();
                    for (var i = 0; i < Syn_Deal_Run_Repeat_On_Day_Count_G; i++) {
                        var days = List_Repeat_On_Day_Code_G[i];
                        $('input[name=chkDays][value=' + days + ']').prop('checked', true)

                    }
                }
                document.getElementById("RuleEdit_7").style.display = '';
                $('#lblDaysHours')[0].innerHTML = ShowMessage.Days;
                $('#lblDaysHours')[0].innerText = ShowMessage.Days;
            }
            else {
                document.getElementById("RuleEdit_7").style.display = 'none';
                $('#lblDaysHours')[0].innerHTML = ShowMessage.Hrs;
                $('#lblDaysHours')[0].innerText = ShowMessage.Hrs;
            }
        }
    }
    else {
        $('input[name=Is_Yearwise_Definition][value="N"]').prop('checked', true);
        $('input[name=Is_Yearwise_Definition]').prop('disabled', 'disabled');
        $('#hdnIs_Yearwise_Definition').val('N');
        document.getElementById("addrunsDef2").style.display = 'none';

    }
    $('.numbertext').numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        maxPreDecimalPlaces: 5,
        maxDecimalPlaces: 0
    });
    setChosenWidth('#ddlRuleRight', '45%');
    hideLoading();
});


function showrunsDefinition2(runsdefobj2) {
    $('#hdnIs_Yearwise_Definition').val(runsdefobj2.value);
    if (runsdefobj2.value == "Y") {
        showLoading();
        var titleCodes = '';
        if ($("select#ddlPTitle").val() != null) {
            if ($('#addLimited2').val() != "") {

                titleCodes = $("select#ddlPTitle").val().join(",");
                $.ajax({
                    type: "POST",
                    url: URL_GetYearWiseRun,
                    traditional: true,
                    enctype: 'multipart/form-data',
                    contentType: "application/json; charset=utf-8",
                    //async: false,
                    data: JSON.stringify({
                        TitleCodes: titleCodes, txtNoOfRun: $('#addLimited2').val()
                    }),
                    success: function (result) {
                        ;
                        if (result == "true") {
                            redirectToLogin();
                        }

                        if ($.trim(result) == 'Invalid' || $.trim(result) == '') {
                            showAlert("E", "Selected titles are invalid for yearwise run definition ");
                            $('input[name=Is_Yearwise_Definition][value="N"]').prop('checked', true);
                            $('#hdnIs_Yearwise_Definition').val('N');
                        }
                        else {
                            $('#addrunsDef2').html(result);
                            $('.numbertext').numeric({
                                allowMinus: false,
                                allowThouSep: false,
                                allowDecSep: false,
                                maxPreDecimalPlaces: 5,
                                maxDecimalPlaces: 0
                            });
                            document.getElementById("addrunsDef2").style.display = '';
                        }
                        hideLoading();
                    },
                    error: function (result) { }
                });
            }
            else {
                showAlert("E", ShowMessage.PleaseenternoofRuns)
                $('input[name=Is_Yearwise_Definition][value="N"]').prop('checked', true);
                $('#hdnIs_Yearwise_Definition').val('N');
                hideLoading();
            }
        }
        else {
            showAlert("E", ShowMessage.PleaseselectTitle);
            $('input[name=Is_Yearwise_Definition][value="N"]').prop('checked', true);
            $('#hdnIs_Yearwise_Definition').val('N');
            hideLoading();
        }
    }
    else if (runsdefobj2.value == "N") {
        $('#addrunsDef2').html('');
        document.getElementById("addrunsDef2").style.display = 'none';
    }
}

function bindRuleRecord(ddlRule) {
    if (Number(ddlRule.value) > 0) {
        showLoading();
        $.ajax({
            type: "POST",
            url: URL_GetRightRule,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            async: true,
            data: JSON.stringify({
                RightRuleCode: ddlRule.value
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                if (result.length > 0) {
                    $('#txtDayStartTime').val(result[0].Start_Time);
                    $('#txtPlaysperday').val(result[0].Play_Per_Day);
                    $('#txtDurationofDay').val(result[0].Duration_Of_Day);
                    $('#txtNoofRepeat').val(result[0].No_Of_Repeat);
                    hideLoading();
                }
            },
            error: function (result) { }
        });
        $('#Right_Rule_Code').val(ddlRule.value);
    } else {
        txtDayStartTime.value = txtPlaysperday.value = txtDurationofDay.value = txtNoofRepeat.value = '';
    }
}

function showRules2(rulesobj2) {
    showLoading();
    for (var i = 1; i < 8; i++) {
        if (rulesobj2.value == "Y") {
            document.getElementById("RuleEdit_" + i).style.display = '';
            $("select#ddlRuleRight.form_input.chosen-select").val('0').trigger("chosen:updated");
        }
        else if (rulesobj2.value == "N") {
            document.getElementById("RuleEdit_" + i).style.display = 'none';
            $('#txtHrs2').val('');
            $('#Right_Rule_Code').val('');
            $('#txtDayStartTime').val('');
            $('#txtPlaysperday').val('');
            $('#txtDurationofDay').val('');
            $('#txtNoofRepeat').val('');
            $('input[name=chkDays]').prop('checked', false);
            $('input[name=Repeat_Within_Days_Hrs][value=D]').prop('checked', true)
            $("#ddlRuleRight").removeClass('required');
            $("#txtHrs2").removeAttr('required');
        }
    }
    hideLoading();
}

function ClearHidden() {
    $('#hdnTabName').val('');
}

function validateTitle() {
    if ($('input[name=Is_Yearwise_Definition]:checked').val() == 'Y') {
        var synDealRunCode = Syn_Deal_Run_Code_G;
        var isValid = true;
        $.ajax({
            type: "POST",
            url: URL_ValidateTitleOnSave,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            async: false,
            data: JSON.stringify({
                Syn_Deal_Run_Code: synDealRunCode,
                titleCodes: $("select#ddlPTitle").val().join(",")
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                if (result == "Valid") {
                    isValid = true;
                } else {
                    showAlert("E", result);
                    isValid = false;
                }
                hideLoading();
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
    else
        isValid = true;

    return isValid;
}

function validateDuplication() {
    showLoading();
    var synDealRunCode = Syn_Deal_Run_Code_G;
    var channelCode = $("select#ddlPPlatform").val().join(",");
    var isValid = true;
    $.ajax({
        type: "POST",
        url: URL_ValidateDuplication,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            Syn_Deal_Run_Code: synDealRunCode,
            titleCodes: $("select#ddlPTitle").val().join(","),
            PlatformCodes: channelCode
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            if (result == "Valid") {
                isValid = true;
            }
            else
                if (result.length > 0) {
                    var HTML = "<table class='table table-bordered table-hover'><thead><tr>";
                    HTML = HTML + "<th>Title</th>";
                    HTML = HTML + "<th>Platform</th></tr></thead><tbody>";
                    for (var i = 0 ; i < result.length ; i++) {
                        HTML = HTML + "<tr>";
                        HTML = HTML + "<td>" + result[i].Title_Name + "</td>";
                        HTML = HTML + "<td>" + result[i].PLATFORM_NAME + "</td></tr>";
                    }
                    HTML = HTML + "<tbody></table>";
                    document.getElementById("lblConflictHeading").innerHTML = ShowMessage.Combinationconflictswithotherrundefinition;
                    $('#conflictRun').html(HTML);
                    $('#popRunDefn').modal();
                    isValid = false;
                }
            hideLoading();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });

    return isValid;
}


function ValidatePlatform() {
    showLoading();
    var synDealRunCode = Syn_Deal_Run_Code_G;
    var channelCode = $("select#ddlPPlatform").val().join(",");

    var isValid = true;
    $.ajax({
        type: "POST",
        url: URL_ValidatePlatform,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            Syn_Deal_Run_Code: synDealRunCode,
            titleCodes: $("select#ddlPTitle").val().join(","),
            PlatformCodes: channelCode
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            if (result == "Valid") {
                isValid = true;
            }
            else {
                showAlert("E", result);
                isValid = false;
            }
            hideLoading();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });

    return isValid;
}


function getFormattedDate(input) {
    var pattern = /(.*?)\/(.*?)\/(.*?)$/;
    var result = input.replace(pattern, function (match, p1, p2, p3) {
        var months = [ShowMessage.Jan, ShowMessage.Feb, ShowMessage.Mar, ShowMessage.Apr, ShowMessage.May, ShowMessage.Jun, ShowMessage.Jul, ShowMessage.Aug, ShowMessage.Sep, ShowMessae.Oct, ShowMessage.Nov, ShowMessage.Dec];
        return (p2 < 10 ? "0" + p2 : p2) + " " + months[(p1 - 1)] + " " + p3;
    });

    return result;
}

function showdays2(daysobj2) {
    showLoading();
    if (daysobj2.value == "D") {
        document.getElementById("RuleEdit_7").style.display = '';
        $('#lblDaysHours')[0].innerHTML = ShowMessage.Days;
        $('#lblDaysHours')[0].innerText = ShowMessage.Days;
    }
    else if (daysobj2.value == "H") {
        document.getElementById("RuleEdit_7").style.display = 'none';
        $('#lblDaysHours')[0].innerHTML = ShowMessage.Hrs;
        $('#lblDaysHours')[0].innerText = ShowMessage.Hrs;
        $('input[name=chkDays]').prop('checked', false);
    }
    hideLoading();
}

function validateOnCancel() {
    $('#hdnTabName').val('');
    showAlert('I', ShowMessage.MSGAllUnsaved, 'OKCANCEL');
}

function handleOk() {
    if ($('#hdnTabName').val() == '')
        BindPartialTabs(pageRun);
    else {
        var tabName = $('#hdnTabName').val();
        BindPartialTabs(tabName);
    }
}

function ValidateSave() {

    var IsValid = true;
    var yearWiseRunSum = 0;
    $('#tblYearWiseRun tr input[type=text]').each(function () {
        yearWiseRunSum = yearWiseRunSum + parseInt($(this).val());
    })
    var isYearWise = $('input[name=Is_Yearwise_Definition]:checked').val();

    if ($("select#ddlPTitle").val() == '' || $("select#ddlPTitle").val() == null) {
        $(".ddlPTitle").attr('required', true);
        $(".ddlPTitle").addClass('required');
        IsValid = false;
    }
    if ($("select#ddlPPlatform").val() == '' || $("select#ddlPPlatform").val() == null) {
        $(".ddlPPlatform").attr('required', true);
        $(".ddlPPlatform").addClass('required');
        IsValid = false;
    }


    if ($('input[name=Run_Type]:checked').val() == 'C' && $('#addLimited2').val() == '') {
        $("#addLimited2").attr('required', true);
        IsValid = false;
    }

    if ($('input[name=Run_Type]:checked').val() == 'C' && isYearWise == 'Y' && parseInt($('#addLimited2').val()) != parseInt(yearWiseRunSum)) {
        showAlert("E", ShowMessage.Sumofyearwiserunshouldbeequaltonumberofexhibition);
        IsValid = false;
    }

    if ($('input[name=Is_Rule_Right]:checked').val() == 'Y' && $("select#ddlRuleRight.form_input.chosen-select").val() == '0') {
        $("#ddlRuleRight").addClass('required');
        IsValid = false;
    }
    else
        $("#ddlRuleRight").removeClass('required');

    if ($('input[name=Is_Rule_Right]:checked').val() == 'Y' && $("#txtHrs2").val() == '') {
        $("#txtHrs2").attr('required', true);
        IsValid = false;
    }

    if (IsValid) {
        if (!validateTitle()) {
            return false;
        }
        else if (!ValidatePlatform()) {
            return false;
        }
        else if (!validateDuplication()) {
            return false;
        }
        else {
            $('#hdnTitleList').val($("select#ddlPTitle").val().join(","));
            $('#hdnPlatformList').val($("select#ddlPPlatform").val().join(","));
            var days = '';
            $('input[name=chkDays]:checked').each(function () {
                if (days === '')
                    days = days + $(this).val();
                else
                    days = days + ',' + $(this).val();
            });

            $('#hdnDays').val(days);
            showLoading();
            return true;
        }
    }
    else
        return IsValid;
}

function OnSuccess(Message) {
    hideLoading();
    if (Message == ShowMessage.MSGRunDefUpdate || Message == ShowMessage.MSGRunDefAdd) {
        showAlert('S', Message, 'OK');
    }
}