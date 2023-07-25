$(document).ready(function () {
    debugger
    showLoading();
    
    $('#ddlPTitle,#lbChannel').SumoSelect();
    if (recordLockingCode_G > 0)
        Call_RefreshRecordReleaseTime(recordLockingCode_G, URL_Global_Refresh_Lock);
    debugger;
    if (acqDealRunCode_G > 0) {
        $('#tdTitleCodes').append(strTitleHiddenHtml_G);

        $('input[name=Run_Type][value=' + runType_G + ']').prop('checked', true);
        if (runType_G == "C") {
            //document.getElementById("tblLimited").style.display = '';
            $('input[name=Is_Yearwise_Definition]').prop('disabled', '');
            $('input[name=Is_Prime_OffPrime_Defn]').prop('disabled', '');
            document.getElementById("addLimited2").style.display = '';
            document.getElementById("lblAddLimited").style.display = '';
            document.getElementById("addSynRun").style.display = '';
            document.getElementById("lbladdNoRun").style.display = '';
            document.getElementById("addNoRun").style.display = '';
            document.getElementById("lbladdSynRun").style.display = '';

        }
        else if (runType_G == "U") {
            document.getElementById("addSynRun").style.display = 'none';
            document.getElementById("addSynRun").value = '0';
            document.getElementById("lbladdNoRun").style.display = 'none';
            document.getElementById("addNoRun").style.display = 'none';
            document.getElementById("lbladdSynRun").style.display = 'none';
            document.getElementById("addLimited2").style.display = 'none';
            document.getElementById("lblAddLimited").style.display = 'none';
            $('input[name=Is_Yearwise_Definition][value="N"]').prop('checked', true);
            $('input[name=Is_Yearwise_Definition]').prop('disabled', 'disabled');
            document.getElementById("addrunsDef2").style.display = 'none';

            $('input[name=Is_Prime_OffPrime_Defn][value="N"]').prop('checked', true);
            $('input[name=Is_Prime_OffPrime_Defn]').prop('disabled', 'disabled');
            document.getElementById("rowPrime1").style.display = 'none';
            document.getElementById("rowPrime2").style.display = 'none';
        }

        $('input[name=Is_Yearwise_Definition][value=' + isYearWise_G + ']').prop('checked', true)

        if (yearWiseScheduleRunCount_G > 0 && isYearWise_G == 'Y')
            $('input[name=Is_Yearwise_Definition]').prop('disabled', 'disabled');

        if (isYearWise_G == "Y") {
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

        $('input[name=Is_Rule_Right][value=' + isRuleRight_G + ']').prop('checked', true)
        $("select#ddlRuleRight.form_input.chosen-select").val(rightRuleCode_G).trigger("chosen:updated");

        if (isRuleRight_G == "Y") {
            bindRuleRecord(document.getElementById('ddlRuleRight'));

            for (var i = 1; i < 8; i++) {
                document.getElementById("RuleEdit_" + i).style.display = '';
            }
            if (repeatWithinDaysHrs_G == 'D') {
                SelectDaysCheckbox();
                document.getElementById("RuleEdit_7").style.display = '';
                $('#lblDaysHours')[0].innerHTML = "Days";
                $('#lblDaysHours')[0].innerText = "Days";
            }
            else {
                document.getElementById("RuleEdit_7").style.display = 'none';
                $('#lblDaysHours')[0].innerHTML = "Hrs";
                $('#lblDaysHours')[0].innerText = "Hrs";
            }
        }

        $('input[name=Is_Channel_Definition_Rights][value=' + isChannelDefinitionRights_G + ']').prop('checked', true)

        if (isChannelDefinitionRights_G == 'Y') {
            debugger
            $('input[name=Run_Definition_Type][value=' + runDefinitionType_G + ']').prop('checked', true)
            document.getElementById("addChannel_edit").style.display = '';
            document.getElementById("addChannel2_edit").style.display = '';

            if (runDefinitionType_G == "C") {
                document.getElementById("showRundefinition2_1").style.display = '';
                document.getElementById("showRundefinition2_2").style.display = 'none';
                document.getElementById("showRundefinition2_3").style.display = 'none';
                document.getElementById("showRundefinition2_4").style.display = 'none';
                document.getElementById("showRundefinition2_5").style.display = 'none';
            }
            else if (runDefinitionType_G == "CS") {
                document.getElementById("showRundefinition2_1").style.display = 'none';
                document.getElementById("showRundefinition2_2").style.display = '';
                document.getElementById("showRundefinition2_3").style.display = 'none';
                document.getElementById("showRundefinition2_4").style.display = 'none';
                document.getElementById("showRundefinition2_5").style.display = 'none';
            }
            else if (runDefinitionType_G == "A") {
                document.getElementById("showRundefinition2_1").style.display = 'none';
                document.getElementById("showRundefinition2_2").style.display = 'none';
                document.getElementById("showRundefinition2_3").style.display = '';
                document.getElementById("showRundefinition2_4").style.display = 'none';
                document.getElementById("showRundefinition2_5").style.display = 'none';
            }
            else if (runDefinitionType_G == "S") {
                document.getElementById("showRundefinition2_1").style.display = 'none';
                document.getElementById("showRundefinition2_2").style.display = 'none';
                document.getElementById("showRundefinition2_3").style.display = 'none';
                document.getElementById("showRundefinition2_4").style.display = '';
                document.getElementById("showRundefinition2_5").style.display = 'none';
            }
            else if (runDefinitionType_G == "N") {
                document.getElementById("showRundefinition2_1").style.display = 'none';
                document.getElementById("showRundefinition2_2").style.display = 'none';
                document.getElementById("showRundefinition2_3").style.display = 'none';
                document.getElementById("showRundefinition2_4").style.display = 'none';
                document.getElementById("showRundefinition2_5").style.display = 'none';
            }

            $.ajax({
                type: "POST",
                url: URL_PartialChannelList1,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    Acq_Deal_Run_Code: acqDealRunCode_G
                }),
                success: function (result) {
                    if (result == "true") {
                        redirectToLogin();
                    }
                    if (runDefinitionType_G == "C")
                        $('#showRundefinition2_1').html(result);
                    else if (runDefinitionType_G == "CS")
                        $('#showRundefinition2_2').html(result);
                    else if (runDefinitionType_G == "A")
                        $('#showRundefinition2_3').html(result);
                    else if (runDefinitionType_G == "S")
                        $('#showRundefinition2_4').html(result);

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
                }
            });
        }
        else {
            document.getElementById("addChannel_edit").style.display = 'none';
            document.getElementById("addChannel2_edit").style.display = 'none';
        }

        if ((primeRun_G + offPrimeRun_G) > 0) {
            $('input[name=Is_Prime_OffPrime_Defn][value="Y"]').prop('checked', true);
            showPrime(document.getElementById('Is_Prime_OffPrime_Defn'));
        }
        else
            $('input[name=Is_Prime_OffPrime_Defn][value="N"]').prop('checked', true);

    }
    else {
        $('input[name=Is_Yearwise_Definition][value="N"]').prop('checked', true);
        $('input[name=Is_Yearwise_Definition]').prop('disabled', 'disabled');
        $('#hdnIs_Yearwise_Definition').val('N');
        document.getElementById("addrunsDef2").style.display = 'none';

        $('input[name=Is_Prime_OffPrime_Defn][value="N"]').prop('checked', true);
        $('input[name=Is_Prime_OffPrime_Defn]').prop('disabled', 'disabled');
        document.getElementById("rowPrime1").style.display = 'none';
        document.getElementById("rowPrime2").style.display = 'none';
        $('input[name=Run_Definition_Type][value=N]').prop('checked', true)
    }


    if (runDisableChannelwise_G == 'Y') {
        $('input[name=Is_Channel_Definition_Rights][value="Y"]').prop('checked', true);
        $('input[name=Is_Channel_Definition_Rights]').prop('disabled', 'disabled');
        $('#hdnIs_Channel_Definition_Rights').val('Y');
        document.getElementById("addChannel_edit").style.display = '';
        document.getElementById("addChannel2_edit").style.display = '';
    }

    $('.numbertext').numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        maxPreDecimalPlaces: 5,
        maxDecimalPlaces: 0
    });
    var returnCount = true;

    $('#lbChannel').on('change', function (evt, params) {
        debugger;
        if (params != undefined) {
            if (params.deselected != undefined) {
                $.ajax({
                    type: "POST",
                    url: URL_CheckIfShowLinked,
                    traditional: true,
                    async: false,
                    enctype: 'multipart/form-data',
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({
                        Acq_Deal_Run_Code: $('#Acq_Deal_Run_Code').val(),
                        selectedChannel: params.deselected
                    }),
                    success: function (result) {
                        if (result > 0) {
                            showAlert('E', ShowMessage.MsgForLinked);//MsgForLinked  = Can not remove channel. It has shows that are already linked
                            $('#lbChannel').find('option[value=' + params.deselected + ']').attr('selected', true);
                            $('#lbChannel')[0].sumo.reload();
                        }
                    },
                    error: function (result) {
                        alert('Error: ' + result.responseText);
                    }
                });
            }
        }
        var strHTML = '<option value="0">Please Select</option>';
        $('#lbChannel option:selected').each(function () {
            debugger
            var s = $(this);
            strHTML = strHTML + s[0].outerHTML;
        });
       
        //$('#lbChannelCluster').on('change', function (evt, params) {
        //    debugger;
        //    if (params != undefined) {
        //        if (params.deselected != undefined) {
        //            $.ajax({
        //                type: "POST",
        //                url: URL_CheckIfShowLinked,
        //                traditional: true,
        //                async: false,
        //                enctype: 'multipart/form-data',
        //                contentType: "application/json; charset=utf-8",
        //                data: JSON.stringify({
        //                    Acq_Deal_Run_Code: $('#Acq_Deal_Run_Code').val(),
        //                    selectedChannel: params.deselected
        //                }),
        //                success: function (result) {
        //                    if (result > 0) {
        //                        showAlert('E', 'Can not remove channel. It has shows that are already linked');
        //                        $('#lbChannel').find('option[value=' + params.deselected + ']').attr('selected', true);
        //                        $('#lbChannel')[0].sumo.reload();
        //                    }
        //                },
        //                error: function (result) {
        //                    alert('Error: ' + result.responseText);
        //                }
        //            });
        //        }
        //    }
        //    var strHTML = '<option value="0">Please Select</option>';
        //    $('#lbChannel option:selected').each(function () {
        //        debugger
        //        var s = $(this);
        //        strHTML = strHTML + s[0].outerHTML;
        //    });
        $('#ddlPrimaryChannel').html(strHTML);
        $('#ddlPrimaryChannel option[value= 0]').attr("selected", "selected");
        $('#showRundefinition2_1').empty();
        $('#showRundefinition2_2').empty();
        $('#showRundefinition2_3').empty();
        $('#showRundefinition2_4').empty();

        document.getElementById("showRundefinition2_1").style.display = 'none';
        document.getElementById("showRundefinition2_2").style.display = 'none';
        document.getElementById("showRundefinition2_3").style.display = 'none';
        document.getElementById("showRundefinition2_4").style.display = 'none';
        document.getElementById("showRundefinition2_5").style.display = 'none';
        $('input[name=Run_Definition_Type][value=N]').prop('checked', true)
        //$('input[name=Run_Definition_Type][value=N]').prop('checked', true)
        $('#ddlPrimaryChannel').trigger('chosen:updated');
    });
   
    hideLoading();
    AssignTimeJquery();
    PrimeRunKeyUp();
    debugger;
    BindAllPreReq_Async();
    if (channelType == "G") {
        $('#divChannelCategory').show();
        $('#addChannel_edit').hide();
    }
    else {
        $('#addChannel_edit').show();
        $('#divChannelCategory').hide();
    }
    
});
function DealType(obj2) {
    if (obj2.value == "1") {
        document.getElementById("subDealMovie").style.display = '';
        document.getElementById("movieSearchBand").style.display = '';
        document.getElementById("optDealFor").style.display = '';
        document.getElementById("optDealFor2").style.display = 'none';
    }
    if (obj2.value == "2") {
        document.getElementById("subDealMovie").style.display = 'none';
        document.getElementById("movieSearchBand").style.display = 'none';
        document.getElementById("optDealFor").style.display = 'none';
        document.getElementById("optDealFor2").style.display = '';
    }
}
function ModeAcquisition(obj) {
    if (obj.value == "1") {
        document.getElementById("showAcquisition").innerHTML = ShowMessage.lblForAssignor;//lblForAssignor = Assignor
    }
    if (obj.value == "2") {
        document.getElementById("showAcquisition").innerHTML = ShowMessage.lblForLicensor;//lblForLicensor = Licensor
    }
    if (obj.value == "3") {
        document.getElementById("showAcquisition").innerHTML = ShowMessage.lblForProducerLineProducer;//lblForProducerLineProducer = Producer/ Line Producer
    }
}
function DealFor(obj3) {
    if (obj3.value == "1") {
        document.getElementById("subDealMovie").style.display = '';
        document.getElementById("movieSearchBand").style.display = '';
        document.getElementById("subDealProgram").style.display = 'none';
        document.getElementById("ProgramSearchBand").style.display = 'none';
        document.getElementById("ddlOtherFor").disabled = false;
    }
    if (obj3.value == "2") {
        document.getElementById("subDealMovie").style.display = 'none';
        document.getElementById("movieSearchBand").style.display = 'none';
        document.getElementById("subDealProgram").style.display = '';
        document.getElementById("ProgramSearchBand").style.display = '';
        document.getElementById("ddlOtherFor").disabled = false;
    }
    if (obj3.value == "3") {
        document.getElementById("subDealMovie").style.display = 'none';
        document.getElementById("movieSearchBand").style.display = 'none';
        document.getElementById("subDealProgram").style.display = 'none';
        document.getElementById("ProgramSearchBand").style.display = 'none';
        document.getElementById("ddlOtherFor").disabled = true;
    }
}
function showOverflow(obj2) {
    if (obj2.value == "1" || obj2.value == "3") {
        document.getElementById("RevenueSharing").style.display = 'none';
    }
    if (obj2.value == "2") {
        document.getElementById("RevenueSharing").style.display = '';
    }
}
/*Run Defination */
function showLimited2(obj2) {
    debugger;
    if (obj2.value == "C") {
        //document.getElementById("tblLimited").style.display = '';
        $('input[name=Is_Yearwise_Definition]').prop('disabled', '');
        $('input[name=Is_Prime_OffPrime_Defn]').prop('disabled', '');
        document.getElementById("addLimited2").style.display = '';
        document.getElementById("lblAddLimited").style.display = '';
        document.getElementById("addSynRun").style.display = '';
        document.getElementById("lbladdNoRun").style.display = '';
        document.getElementById("addNoRun").style.display = '';
        document.getElementById("lbladdSynRun").style.display = '';
        document.getElementById("addLimited2").readOnly = true;
        CheckSubLicen();
        CalculateActualRun();
    }
    else if (obj2.value == "U") {
        document.getElementById("addSynRun").value = '0';
        document.getElementById("addLimited2").style.display = 'none';
        document.getElementById("lblAddLimited").style.display = 'none';
        document.getElementById("addSynRun").style.display = 'none';
        document.getElementById("lbladdNoRun").style.display = 'none';
        document.getElementById("addNoRun").style.display = 'none';
        document.getElementById("lbladdSynRun").style.display = 'none';

        $('#addLimited2').val('');
        $('input[name=Is_Yearwise_Definition][value="N"]').prop('checked', true);
        $('input[name=Is_Yearwise_Definition]').prop('disabled', 'disabled');
        document.getElementById("addrunsDef2").style.display = 'none';

        $('input[name=Is_Prime_OffPrime_Defn][value="N"]').prop('checked', true);
        $('input[name=Is_Prime_OffPrime_Defn]').prop('disabled', 'disabled');
        document.getElementById("rowPrime1").style.display = 'none';
        document.getElementById("rowPrime2").style.display = 'none';
        $('#addrunsDef2').html('');
        $("#addLimited2").removeAttr('required');
        $("#hdnIs_Yearwise_Definition").val('N');
    }
}
function CheckSubLicen() {
    debugger;
    if ($('input[name=Run_Type]:checked').val() == 'C') {
        var titleCodes = '';
        if ($("#ddlPTitle").val() != null)
            titleCodes = $("#ddlPTitle").val().join(",");
                         
        if (titleCodes != '')
            $.ajax({
                type: "POST",
                url: URL_CheckSubLicen,
                traditional: true,
                async: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    TitleCodes: titleCodes
                }),
                success: function (result) {
                    debugger;
                    if (result == 'False') {
                        //document.getElementById("tblLimited").style.display = 'none';
                        document.getElementById("addSynRun").value = '0';
                        document.getElementById("addSynRun").style.display = 'none';
                        document.getElementById("lbladdNoRun").style.display = 'none';
                        document.getElementById("addNoRun").style.display = 'none';
                        document.getElementById("lbladdSynRun").style.display = 'none';
                        document.getElementById("addLimited2").readOnly = false;
                    }
                    else {
                        //document.getElementById("tblLimited").style.display = '';
                        document.getElementById("addSynRun").style.display = '';
                        document.getElementById("lbladdNoRun").style.display = '';
                        document.getElementById("addNoRun").style.display = '';
                        document.getElementById("lbladdSynRun").style.display = '';
                        document.getElementById("addLimited2").readOnly = true;
                    }
                },
                error: function (result) {
                    alert('Error: ' + result.responseText);
                }
            });
    }
}
function CalculateActualRun() {
    debugger;
    var addNoRun = 0;
    var addSynRun = 0;
    if ($('#addNoRun').val() != '')
        addNoRun = parseInt($('#addNoRun').val());
    if ($('#addSynRun').val() != '')
        addSynRun = parseInt($('#addSynRun').val());
    var lblAddLimited = 0;

    if (addNoRun > addSynRun) {
        lblAddLimited = addNoRun - addSynRun;
        $('#addLimited2').val(lblAddLimited);
    }
    else {
        //showAlert("E", "Syndication Run should be less then No. of Runs")
        $('#addLimited2').val('0');
    }
}
function showrunsDefinition2(runsdefobj2) {
    $('#hdnIs_Yearwise_Definition').val(runsdefobj2.value);
    if (runsdefobj2.value == "Y") {
        showLoading();
        var titleCodes = '';
        if ($("#ddlPTitle").val() != null) {
            if ($('#addLimited2').val() != "") {

                titleCodes = $("#ddlPTitle").val().join(",");
                $.ajax({
                    type: "POST",
                    url: URL_GetYearWiseRun,
                    traditional: true,
                    enctype: 'multipart/form-data',
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({
                        TitleCodes: titleCodes, txtNoOfRun: $('#addLimited2').val()
                    }),
                    success: function (result) {
                        debugger;
                        if (result == "true") {
                            redirectToLogin();
                        }

                        if ($.trim(result) == 'Invalid' || $.trim(result) == '') {
                            showAlert("E", ShowMessage.invalidTitleRun);//invalidTitleRun = Selected titles are invalid for yearwise run definition
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
                showAlert("E", ShowMessage.lblForNoOfExhibition)//lblForNoOfExhibition = Please enter no. of exhibition
                $('input[name=Is_Yearwise_Definition][value="N"]').prop('checked', true);
                hideLoading();
            }
        }
        else {
            showAlert("E", ShowMessage.lblForSelectTitle);//lblForSelectTitle = Please Select Title
            $('input[name=Is_Yearwise_Definition][value="N"]').prop('checked', true);
            hideLoading();
        }
    }
    else if (runsdefobj2.value == "N") {
        $('#addrunsDef2').html('');
        document.getElementById("addrunsDef2").style.display = 'none';
    }
}
function getFormattedDate(input) {
    var pattern = /(.*?)\/(.*?)\/(.*?)$/;
    var result = input.replace(pattern, function (match, p1, p2, p3) {
        var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return (p2 < 10 ? "0" + p2 : p2) + " " + months[(p1 - 1)] + " " + p3;
    });

    return result;
}
function bindRuleRecord(ddlRule) {
    //var txtDayStartTime = $('#txtDayStartTime');

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
        $("#txtDayStartTime").value = $("#txtPlaysperday").value = $("#txtDurationofDay").value = $("#txtNoofRepeat").value = '';
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
function showdays2(daysobj2) {
    showLoading();
    if (daysobj2.value == "D") {
        document.getElementById("RuleEdit_7").style.display = '';
        $('#lblDaysHours')[0].innerHTML = "Days";
        $('#lblDaysHours')[0].innerText = "Days";
    }
    else if (daysobj2.value == "H") {
        document.getElementById("RuleEdit_7").style.display = 'none';
        $('#lblDaysHours')[0].innerHTML = "Hrs";
        $('#lblDaysHours')[0].innerText = "Hrs";
        $('input[name=chkDays]').prop('checked', false);
    }
    hideLoading();
}
function showChannel2(obj2) {
    $('#hdnIs_Channel_Definition_Rights').val(obj2.value);
    showLoading();
    if (obj2.value == "Y") {
        document.getElementById("addChannel_edit").style.display = '';
        document.getElementById("addChannel2_edit").style.display = '';
    }
    else if (obj2.value == "N") {
        document.getElementById("addChannel_edit").style.display = 'none';
        document.getElementById("addChannel2_edit").style.display = 'none';
        $('input[name=Run_Definition_Type][value=N]').prop('checked', true);
        $('#ddlPrimaryChannel option[value= 0]').attr("selected", "selected");
        $('#ddlPrimaryChannel').trigger('chosen:updated');
        $('select#lbChannel.form_input.chosen-select').val('').trigger('chosen:updated');
        $('#showRundefinition2_1').html('');
        $('#showRundefinition2_2').html('');
        $('#showRundefinition2_3').html('');
        $('#showRundefinition2_4').html('');
        $('#showRundefinition2_5').html('');
        $("#lbChannel").removeAttr('required');
    }
    hideLoading();
}
function showRunDifination2(daysobj2) {
    debugger
    if (daysobj2.value == "C") {
        document.getElementById("showRundefinition2_1").style.display = '';
        document.getElementById("showRundefinition2_2").style.display = 'none';
        document.getElementById("showRundefinition2_3").style.display = 'none';
        document.getElementById("showRundefinition2_4").style.display = 'none';
        document.getElementById("showRundefinition2_5").style.display = 'none';
    }
    else if (daysobj2.value == "CS") {
        document.getElementById("showRundefinition2_1").style.display = 'none';
        document.getElementById("showRundefinition2_2").style.display = '';
        document.getElementById("showRundefinition2_3").style.display = 'none';
        document.getElementById("showRundefinition2_4").style.display = 'none';
        document.getElementById("showRundefinition2_5").style.display = 'none';
    }
    else if (daysobj2.value == "A") {
        document.getElementById("showRundefinition2_1").style.display = 'none';
        document.getElementById("showRundefinition2_2").style.display = 'none';
        document.getElementById("showRundefinition2_3").style.display = '';
        document.getElementById("showRundefinition2_4").style.display = 'none';
        document.getElementById("showRundefinition2_5").style.display = 'none';

    }
    else if (daysobj2.value == "S") {
        document.getElementById("showRundefinition2_1").style.display = 'none';
        document.getElementById("showRundefinition2_2").style.display = 'none';
        document.getElementById("showRundefinition2_3").style.display = 'none';
        document.getElementById("showRundefinition2_4").style.display = '';
        document.getElementById("showRundefinition2_5").style.display = 'none';
    }
    else if (daysobj2.value == "N") {
        document.getElementById("showRundefinition2_1").style.display = 'none';
        document.getElementById("showRundefinition2_2").style.display = 'none';
        document.getElementById("showRundefinition2_3").style.display = 'none';
        document.getElementById("showRundefinition2_4").style.display = 'none';
        document.getElementById("showRundefinition2_5").style.display = 'none';
    }

    if (daysobj2.value != "N") {
        debugger
        var channelchecked = "";
        if (document.getElementById('rbChannel').checked) {
            channelchecked = document.getElementById('rbChannel').value;
        }
        else if (document.getElementById('rbChannelCategory').checked) {
            channelchecked = document.getElementById('rbChannelCategory').value;
        }
        if (channelchecked == "C") {
            if ($('#lbChannel').val() != null) {
                showLoading();
                $.ajax({
                    type: "POST",
                    url: URL_PartialChannelList,
                    traditional: true,
                    enctype: 'multipart/form-data',
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({
                        channelCodes: $('#lbChannel').val().join(","),
                        channelDefinitionType: daysobj2.value,
                        txtNoOfRun: $('#addLimited2').val(),
                        ChannelCategoryChecked: channelchecked
                    }),
                    success: function (result) {
                        debugger;
                        if (result == "true") {
                            redirectToLogin();
                        }
                        if (daysobj2.value == "C") {
                            $('#showRundefinition2_1').html(result);
                            $('#showRundefinition2_2').html('');
                            $('#showRundefinition2_3').html('');
                            $('#showRundefinition2_4').html('');
                        }
                        else if (daysobj2.value == "CS") {
                            $('#showRundefinition2_1').html('');
                            $('#showRundefinition2_2').html(result);
                            $('#showRundefinition2_3').html('');
                            $('#showRundefinition2_4').html('');

                        }
                        else if (daysobj2.value == "A") {
                            $('#showRundefinition2_1').html('');
                            $('#showRundefinition2_2').html('');
                            $('#showRundefinition2_3').html(result);
                            $('#showRundefinition2_4').html('');
                        }
                        else if (daysobj2.value == "S") {
                            $('#showRundefinition2_1').html('');
                            $('#showRundefinition2_2').html('');
                            $('#showRundefinition2_3').html('');
                            $('#showRundefinition2_4').html(result);
                        }
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
                    }
                });
            }
            else {
                $('input[name=Run_Definition_Type][value=N]').prop('checked', true);
                showAlert('E', ShowMessage.lblForSelectChannel);//lblForSelectChannel = Please select channel
                hideLoading();
            }
        }
        else if (channelchecked == "G") {
            if ($('#lbChannelCluster').val() != 0) {
                showLoading();
                $.ajax({
                    type: "POST",
                    url: URL_PartialChannelList,
                    traditional: true,
                    enctype: 'multipart/form-data',
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({
                        channelCodes: $('#lbChannelCluster').val(),
                        channelDefinitionType: daysobj2.value,
                        txtNoOfRun: $('#addLimited2').val(),
                        ChannelCategoryChecked : channelchecked
                    }),
                    success: function (result) {
                        if (result == "true") {
                            redirectToLogin();
                        }
                        if (daysobj2.value == "C") {
                            $('#showRundefinition2_1').html(result);
                            $('#showRundefinition2_2').html('');
                            $('#showRundefinition2_3').html('');
                            $('#showRundefinition2_4').html('');
                        }
                        else if (daysobj2.value == "CS") {
                            $('#showRundefinition2_1').html('');
                            $('#showRundefinition2_2').html(result);
                            $('#showRundefinition2_3').html('');
                            $('#showRundefinition2_4').html('');

                        }
                        else if (daysobj2.value == "A") {
                            $('#showRundefinition2_1').html('');
                            $('#showRundefinition2_2').html('');
                            $('#showRundefinition2_3').html(result);
                            $('#showRundefinition2_4').html('');
                        }
                        else if (daysobj2.value == "S") {
                            $('#showRundefinition2_1').html('');
                            $('#showRundefinition2_2').html('');
                            $('#showRundefinition2_3').html('');
                            $('#showRundefinition2_4').html(result);
                        }
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
                    }
                });
            }
            else {
                $('input[name=Run_Definition_Type][value=N]').prop('checked', true);
                showAlert('E', ShowMessage.lblForSelectChannel);//lblForSelectChannel = Please select channel
                hideLoading();
            }
        }
    }
}
function showPrime(Primeobj) {
    showLoading();
    if (Primeobj.value == "Y") {
        document.getElementById("rowPrime1").style.display = '';
        document.getElementById("rowPrime2").style.display = '';
    }
    else if (Primeobj.value == "N") {
        document.getElementById("rowPrime1").style.display = 'none';
        document.getElementById("rowPrime2").style.display = 'none';
        $('#txtStartPrimeTime').val('')
        $('#txtEndPrimeTime').val('')
        $('#txtPrimeRun').val('')
        $('#txtStartNPrimeTime').val('')
        $('#txtEndNPrimeTime').val('')
        $('#txtNPrimeRun').val('')
    }
    hideLoading();
}
function checkvalue(obj, id) {
    debugger;
    if (obj.checked) {
        $("#Acq_Deal_Run_Channel_" + id + "__Do_Not_Consume_Rights").val('Y');
        $("#Acq_Deal_Run_Channel_" + id + "__Min_Runs").val("");
        $("#Acq_Deal_Run_Channel_" + id + "__Min_Runs").val("0");
    }
    else {
        $("#Acq_Deal_Run_Channel_" + id + "__Do_Not_Consume_Rights").val('N');
    }      
}
function ValidateSave() {
    debugger;
    $("[required='required']").removeAttr("required");
    $('.required').removeClass('required');
    var IsValid = true;
    var channelchecked = "";
    if (document.getElementById('rbChannel').checked) {
        channelchecked = document.getElementById('rbChannel').value;
    }
    else if (document.getElementById('rbChannelCategory').checked) {
        channelchecked = document.getElementById('rbChannelCategory').value;
    }
    var yearWiseRunSum = 0;
    $('#tblYearWiseRun tr input[type=text]').each(function () {
        yearWiseRunSum = yearWiseRunSum + parseInt($(this).val());
    })
    var isYearWise = $('input[name=Is_Yearwise_Definition]:checked').val();
    var RunDefType = $('input[name=Run_Definition_Type]:checked').val();
    if (RunDefType == undefined)
    {
        showAlert("E", ShowMessage.lblForSelectRunDef);//lblForSelectRunDef = Please select run definition
        $('#divRunChannelDef').addClass("required");
        IsValid = false;
    }
    if ($("#ddlPTitle").val() == '' || $("#ddlPTitle").val() == null) {
        $("#divddlPTitle").addClass("required");
        IsValid = false;
    }

    if ($('input[name=Run_Type]:checked').val() == 'C' && $('#addLimited2').val() == '') {
        $("#addLimited2").attr('required', true);
        IsValid = false;
    }

    if ($('input[name=Run_Type]:checked').val() == 'C' && isYearWise == 'Y' && parseInt($('#addLimited2').val()) != parseInt(yearWiseRunSum)) {
        showAlert("E", ShowMessage.lblForSumOfYearwise);//lblForSumOfYearwise = Sum of yearwise run should be equal to number of exhibition
        IsValid = false;
    }
    if (document.getElementById("addSynRun").style.display != 'none' && document.getElementById("addNoRun").style.display != 'none') {
        var addNoRun1 = 0;
        var addSynRun1 = 0;
        if ($('#addNoRun').val() != '')
            addNoRun1 = parseInt($('#addNoRun').val());
        if ($('#addSynRun').val() != '')
            addSynRun1 = parseInt($('#addSynRun').val());
        var lblAddLimited = 0;

        if (addNoRun1 < addSynRun1) {
            showAlert("E", ShowMessage.lblForSynRun);//lblForSynRun = Syndication Run should be less then Total Number Of Run
            IsValid = false;
        }
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
    if (channelchecked == "C") {
        if ($('input[name=Is_Channel_Definition_Rights]:checked').val() == 'Y' && $("#lbChannel").val() == null) {
            $('#divlbChannel').addClass('required');
            IsValid = false;
        }
    }
    if (channelchecked == "G") {
        if ($('input[name=Channel_Type]:checked').val() == 'G' && $("#lbChannelCluster").val() == "0") {
            $('#lbChannelCluster').addClass('required');
            IsValid = false;
        }
    }
    //if ($('input[name=Channel_Type]:checked').val() == 'G' && $("#lbChannelCluster").val() != "0" && $("#lbChannel").val() == null) {
    //    $('#divlbChannel').addClass('required');
    //    IsValid = false;
    //}
    debugger;
    if (IsValid) {
        if (!checkChannelMinimum()) {
            IsValid = false;
        }
        else if (!validateTitle()) {
            IsValid = false;
        }
        else if (!ValidateTime()) {
            IsValid = false;
        }
        else if (!validateDuplication()) {
            IsValid = false;
        }
        else {
            $('#hdnTitleList').val($("#ddlPTitle").val().join(","));
            var days = '';

            $('input[name=chkDays]:checked').each(function () {
                if (days === '')
                    days = days + $(this).val();
                else
                    days = days + ',' + $(this).val();
            });

            $('#hdnDays').val(days);
            showLoading();
            IsValid = true;
        }
    }

    return IsValid;
}
function ClearHidden() {
    if (!clickedOnTab) {
        $('#hdnTabName').val('');
    }
}
function validateTitle() {
    debugger
    if ($('input[name=Is_Yearwise_Definition]:checked').val() == 'Y') {
        var isValid = true;
        $.ajax({
            type: "POST",
            url: URL_ValidateTitleOnSave,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            async: false,
            data: JSON.stringify({
                Acq_Deal_Run_Code: acqDealRunCode_G,
                titleCodes : $("#ddlPTitle").val().join(",")
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                if (result == "Valid") {
                    isValid = true;
                } else
                    if (result == ShowMessage.lblForInvalidYearwiseRun) {//lblForInvalidYearwiseRun = Invalid available period for yearwise run
                        showAlert("E", result);
                        isValid = false;
                    }
                    else
                        if (result.length > 0) {
                            var HTML = "<table class='table table-bordered table-hover'><thead><tr>";
                            HTML = HTML + "<th>" + ShowMessage.lblForTitle + "</th>";//lblForTitle = Title
                            HTML = HTML + "<th>" + ShowMessage.lblForRightStartDate + "</th>";//lblForRightStartDate = Right Start Date
                            HTML = HTML + "<th>" + ShowMessage.lblForRightEndDate + "</th>";//lblForRightEndDate = Right End Date
                            HTML = HTML + "<th>" + ShowMessage.lblForChannel + "</th></tr></thead><tbody>";//lblForChannel = Channel
                            for (var i = 0 ; i < result.length ; i++) {

                                var startDate = new Date(parseInt(result[i].Rights_Start_Date.substr(6)));
                                var endDate = new Date(parseInt(result[i].Rights_End_Date.substr(6)));
                                var actualStart = getFormattedDate((startDate.getMonth() + 1) + '/' + startDate.getDate() + '/' + startDate.getFullYear());
                                var actualEnd = getFormattedDate((endDate.getMonth() + 1) + '/' + endDate.getDate() + '/' + endDate.getFullYear());
                                HTML = HTML + "<tr>";
                                HTML = HTML + "<td>" + result[i].Title_Name + "</td>";
                                HTML = HTML + "<td>" + actualStart.toLocaleString("ar-AE") + "</td>";
                                HTML = HTML + "<td>" + actualEnd + "</td>";
                                HTML = HTML + "<td>" + result[i].CHANNEL_NAME + "</td></tr>";
                            }
                            HTML = HTML + "<tbody></table>"
                            document.getElementById("lblConflictHeading").innerHTML = ShowMessage.lblForConflictCombination;//lblForConflictCombination = Combination conflicts with other run definition
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
    }
    else
        isValid = true;

    return isValid;
}
function validateDuplication() {
    debugger
    var channelchecked = "";
    if (document.getElementById('rbChannel').checked) {
        channelchecked = document.getElementById('rbChannel').value;
    }
    else if (document.getElementById('rbChannelCategory').checked) {
        channelchecked = document.getElementById('rbChannelCategory').value;
    }
    showLoading();
    var channelCode = '';
    if (channelchecked == "C") {
        if ($('#lbChannel').val() != null)
            channelCode = $('#lbChannel').val().join(",");
    }
    else {
        if ($('#lbChannelCluster').val() != null)
            channelCode = $('#lbChannelCluster').val();
    }
    var isValid = true;
    $.ajax({
        type: "POST",
        url: URL_ValidateDuplication,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            Acq_Deal_Run_Code: acqDealRunCode_G,
            titleCodes: $("#ddlPTitle").val().join(","),
            IsYearWiseRunDefn: $('#hdnIs_Yearwise_Definition').val(),
            IsRuleRight: $('input[name=Is_Rule_Right]:checked').val(),
            IsChannelDefnRight: $('input[name=Is_Channel_Definition_Rights]:checked').val(),
            channelCodes: channelCode,
            channelchecked: channelchecked
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
                    HTML = HTML + "<th>" + ShowMessage.lblForTitle + "</th>";//lblForTitle = Title
                    HTML = HTML + "<th>" + ShowMessage.lblForRightStartDate + "</th>";//lblForRightStartDate = Right Start Date
                    HTML = HTML + "<th>" + ShowMessage.lblForRightEndDate + "</th>";//lblForRightEndDate = Right End Date
                    HTML = HTML + "<th>" + ShowMessage.lblForChannel + "</th></tr></thead><tbody>";//lblForChannel = Channel
                    for (var i = 0 ; i < result.length ; i++) {
                        var actualStart = ''
                        var actualEnd = ''
                        var startDate = result[i].RIGHTS_START_DATE;
                        var endDate = result[i].RIGHTS_END_DATE;
                        if (startDate != null)
                            startDate = new Date(parseInt(startDate.substr(6)));
                        if (endDate != null)
                            endDate = new Date(parseInt(endDate.substr(6)));

                        if (startDate != null && endDate != null) {
                            actualStart = getFormattedDate((startDate.getMonth() + 1) + '/' + startDate.getDate() + '/' + startDate.getFullYear());
                            actualEnd = getFormattedDate((endDate.getMonth() + 1) + '/' + endDate.getDate() + '/' + endDate.getFullYear());
                        }
                        if (LayoutDirection_G == "RTL") {
                            HTML = HTML + "<tr>";
                            HTML = HTML + "<td>" + result[i].TITLE_NAME + "</td>";
                            HTML = HTML + "<td>" + startDate.toLocaleString("ar-AE") + "</td>";
                            HTML = HTML + "<td>" + endDate.toLocaleString("ar-AE") + "</td>";
                            HTML = HTML + "<td>" + result[i].CHANNEL_NAME + "</td></tr>";
                        }
                        else {
                            HTML = HTML + "<tr>";
                            HTML = HTML + "<td>" + result[i].TITLE_NAME + "</td>";
                            HTML = HTML + "<td>" + actualStart + "</td>";
                            HTML = HTML + "<td>" + actualEnd + "</td>";
                            HTML = HTML + "<td>" + result[i].CHANNEL_NAME + "</td></tr>";
                        }
                    }
                    HTML = HTML + "<tbody></table>";
                    document.getElementById("lblConflictHeading").innerHTML = ShowMessage.lblForConflictCombination;//lblForConflictCombination = Combination conflicts with other run definition
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
function ValidateTime() {
    showLoading();
    var channelCode = '';
    if ($('#lbChannel').val() != null)
        channelCode = $('#lbChannel').val().join(",");

    var isValid = true;
    $.ajax({
        type: "POST",
        url: URL_ValidateTime,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            No_Of_Runs: $('#addLimited2').val(),
            Run_Type: $('input[name=Run_Type]:checked').val(),
            Is_Prime_OffPrime_Defn: $('input[name=Is_Prime_OffPrime_Defn]:checked').val(),
            Prime_Start_Time: $('input[name=Prime_Start_Time]').val(),
            Prime_End_Time: $('input[name=Prime_End_Time]').val(),
            Prime_Run: $('input[name=Prime_Run]').val(),
            Off_Prime_Start_Time: $('input[name=Off_Prime_Start_Time]').val(),
            Off_Prime_End_Time: $('input[name=Off_Prime_End_Time]').val(),
            Off_Prime_Run: $('input[name=Off_Prime_Run]').val()
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            if (result == "Success") {
                isValid = true;
            }
            else {
                showAlert('E', result);
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
function checkChannelMinimum() {
    var CHANNEL_WISE = "C";
    var CHANNEL_WISE_SHARED = "CS";
    var CHANNEL_WISE_ALL = "A";
    var CHANNEL_SHARED = "S";
    var isChannelDefnRights = $('input[name=Is_Channel_Definition_Rights]:checked').val();
    var checkedRunDefination = $('input[name=Run_Definition_Type]:checked').val();
    var txtNoOfRun = $('#addLimited2').val();
    if (isChannelDefnRights != 'N') {
        if ((checkedRunDefination != "NOTCHECKED") && $('input[name=Run_Type]:checked').val() == 'C') {
            if ((CHANNEL_WISE == checkedRunDefination) || (CHANNEL_WISE_SHARED == checkedRunDefination) || (CHANNEL_WISE_ALL == checkedRunDefination)) {
                if ((CHANNEL_WISE == checkedRunDefination) || (CHANNEL_WISE_SHARED == checkedRunDefination)) {

                    var totalNoOfRuns = 0;
                    var totalNoOfRuns = 0;
                    var totalNoOfRuns_MAX = 0;

                    $('#tblChannelWise tr input[name*="Min_Runs"]').each(function () {
                        totalNoOfRuns = totalNoOfRuns + parseInt($(this).val());
                    })

                    $('#tblChannelWise tr input[name*="Max_Runs"]').each(function () {
                        totalNoOfRuns_MAX = totalNoOfRuns_MAX + parseInt($(this).val());
                    })

                    if (totalNoOfRuns != Number(txtNoOfRun) && (CHANNEL_WISE == checkedRunDefination)) {
                        showAlert("E", 'Please enter sum of channel wise No.of Runs equal to [' + txtNoOfRun + ']');
                        return false;
                    }
                    else if ((CHANNEL_WISE_SHARED == checkedRunDefination)) {
                        if ((totalNoOfRuns != Number(txtNoOfRun))) {
                            showAlert("E", 'Please enter sum of minimum channel wise no of Runs equal to [' + txtNoOfRun + ']');
                            return false;
                        }
                        if ((totalNoOfRuns_MAX != Number(txtNoOfRun))) {
                            showAlert("E", 'Please enter sum of maximum channel wise no of Runs equal to [' + txtNoOfRun + ']');
                            return false;
                        }
                        return true;
                    }
                    else {
                        return true;
                    }
                }
                else if ((CHANNEL_WISE_ALL == checkedRunDefination)) {
                    if ($('#tblChannelWise tr input[name*="ChannelNames"]').length != txtNoOfRun) {
                        showAlert("E", ShowMessage.lblForEqualChannel);//lblForEqualChannel = Please enter no of runs equal to no of channel
                        return false;
                    }
                    return true;
                }
            }
            else {
                return true;
            }
        }
        else
            return true;
    }
    else
        return true;
}
function AssignTimeJquery() {

    $('#txtStartNPrimeTime').timeEntry();
    $('#txtEndNPrimeTime').timeEntry();
    $('#txtTimeLag').timeEntry({ show24Hours: true, showSeconds: true });


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
function checkPrimeTime() {
    if ($('#txtStartPrimeTime').val() != '' && $('#txtEndPrimeTime') != '') {
        if ($('#txtStartPrimeTime').timeEntry('getTime') > $('#txtEndPrimeTime').timeEntry('getTime')) {
            AlertModalPopup($('#txtStartPrimeTime'), "End time is greater than start time");
        }
    }
}
function PrimecustomRange(input) {
    return {
        minTime: (input.id === 'txtEndPrimeTime' ?
            $('#txtStartPrimeTime').timeEntry('getTime') : null),
        maxTime: (input.id === 'txtStartPrimeTime' ?
        $('#txtEndPrimeTime').timeEntry('getTime') : null)
    };
}
function NonPrimecustomRange(input) {
    return {
        minTime: (input.id === 'txtEndNPrimeTime' ?
            $('#txtStartNPrimeTime').timeEntry('getTime') : null),
        maxTime: (input.id === 'txtStartNPrimeTime' ?
        $('#txtEndNPrimeTime').timeEntry('getTime') : null)
    };
}
function PrimeRunKeyUp() {
    $("#txtPrimeRun").keyup(function (e) {
        if ($("#addLimited2").val() === $("#txtPrimeRun").val()) {
            $("#txtNPrimeRun").val('');
            $('#txtStartNPrimeTime').val('');
            $('#txtEndNPrimeTime').val('');
        }
        else {
            if ($("#txtPrimeRun").val() === '' && $('#txtStartNPrimeTime').val() === '' && $('#txtEndNPrimeTime').val() === '' && $('#txtStartPrimeTime').val() === '' && $('#txtEndPrimeTime').val() === '') {
                $("#txtNPrimeRun").val('');
                $("#txtPrimeRun").val('');
            }
            else
                if ($("#txtPrimeRun").val() === '' && $('#txtStartNPrimeTime').val() === '' && $('#txtEndNPrimeTime').val() === '') {
                    $("#txtNPrimeRun").val('');
                }
                else if ($("#txtPrimeRun").val() != '' && $("#addLimited2").val() != '') {
                    var sub = parseInt($("#addLimited2").val()) - parseInt($("#txtPrimeRun").val());
                    $("#txtNPrimeRun").val(sub);
                }
        }
        //}
    });

    $("#txtNPrimeRun").keyup(function (e) {
        if ($("#addLimited2").val() === $("#txtNPrimeRun").val()) {
            $("#txtPrimeRun").val('');
            $('#txtStartPrimeTime').val('');
            $('#txtEndPrimeTime').val('');
        }
        else {
            if ($("#txtNPrimeRun").val() === '' && $('#txtStartNPrimeTime').val() === '' && $('#txtEndNPrimeTime').val() === '' && $('#txtStartPrimeTime').val() === '' && $('#txtEndPrimeTime').val() === '') {
                $("#txtNPrimeRun").val('');
                $("#txtPrimeRun").val('');
            }
            else
                if ($("#txtNPrimeRun").val() === '' && $('#txtStartPrimeTime').val() === '' && $('#txtEndPrimeTime').val() === '') {
                    $("#txtPrimeRun").val('');
                }
                else if ($("#txtNPrimeRun").val() != '' && $("#addLimited2").val() != '') {
                    var nsub = parseInt($("#addLimited2").val()) - parseInt($("#txtNPrimeRun").val());
                    $("#txtPrimeRun").val(nsub);
                }
        }
        //}
    });
}
function validateOnCancel() {
    $('#hdnTabName').val('');
    showAlert('I', ShowMessage.lblForUnsavedData, 'OKCANCEL');//lblForUnsavedData = All unsaved data will be lost, still want to go ahead?
}
function handleOk() {
    if ($('#hdnTabName').val() == '')
        BindPartialTabs(pageRun);
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
        //        debugger;
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
        var tabName = $('#hdnTabName').val();
        BindPartialTabs(tabName);
    }
}
function OnSuccess(Message) {
    hideLoading();
    if (Message == ShowMessage.lblForRunUpdate || Message == ShowMessage.lblForRunAdded) {
        //lblForRunUpdate = Run Definition Updated Successfully || lblForRunAdded = Run Definition Added Successfully
        showAlert('S', Message, 'OK');
    }
    else if (Message.length > 0) {
        var HTML = "<table class='table table-bordered table-hover'><thead><tr>";
        HTML = HTML + "<th>Title</th>";
        HTML = HTML + "<th>Episode</th>";
        HTML = HTML + "<th>Start Date</th>";
        HTML = HTML + "<th>End Date</th>";
        HTML = HTML + "<th>Channel</th>";
        HTML = HTML + "<th>User Allocated Runs</th>";
        HTML = HTML + "<th>Scheduled Runs</th>";
        HTML = HTML + "</tr></thead><tbody>";
        for (var i = 0 ; i < Message.length ; i++) {
            HTML = HTML + "<tr>";
            HTML = HTML + "<td>" + Message[i].Title_Name + "</td>";
            HTML = HTML + "<td>" + Message[i].Episode_No + "</td>";
            HTML = HTML + "<td>" + Message[i].StartDate + "</td>";
            HTML = HTML + "<td>" + Message[i].EndDate + "</td>";
            HTML = HTML + "<td>" + Message[i].Channel_Name + "</td>";
            HTML = HTML + "<td>" + Message[i].No_Of_Runs + "</td>";
            HTML = HTML + "<td>" + Message[i].No_Of_Schd_Run + "</td>";
            HTML = HTML + "</tr>"
        }
        HTML = HTML + "<tbody></table>";
        HTML = HTML + "<br /><b>Note</b>: User Allocated Runs should be greater than or equal to Scheduled Runs";
        document.getElementById("lblConflictHeading").innerHTML = ShowMessage.lblForInvalidRun;//lblForInvalidRun = Invalid Run Combination for Scheduled Run
        $('#conflictRun').html(HTML);
        $('#popRunDefn').modal();
        isValid = false;
    }
}

function BindAllPreReq_Async() {
    debugger;
    showLoading();
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
                    $("#ddlPTitle").append($("<option />").val(this.Value).text(this.Text));
                });
                if (result.Selected_Title_Codes != '')
                    $("#ddlPTitle").val(result.Selected_Title_Codes.split(','))
                if (runType_G == "C") {
                    if (result.Is_SubLic != null)
                        if (result.Is_SubLic == false) {
                            debugger;
                            document.getElementById("addSynRun").style.display = 'none';
                            document.getElementById("lbladdNoRun").style.display = 'none';
                            document.getElementById("addNoRun").style.display = 'none';
                            document.getElementById("lbladdSynRun").style.display = 'none';
                            document.getElementById("addLimited2").readOnly = false;
                        }
                        else {

                            document.getElementById("addSynRun").style.display = '';
                            document.getElementById("lbladdNoRun").style.display = '';
                            document.getElementById("addNoRun").style.display = '';
                            document.getElementById("lbladdSynRun").style.display = '';
                            document.getElementById("addLimited2").readOnly = true;
                        }
                }
                $.each(result.Channel_List, function () {
                    $("#lbChannel").append($("<option />").val(this.Value).text(this.Text));
                });
                if (result.Selected_Channel_Codes != '')
                    $("#lbChannel").val(result.Selected_Channel_Codes.split(','))

                if (result.Selected_Channel_Cluster_Codes != null) {
                    $.each(result.Channel_Cluster_List, function () {
                        $("#lbChannelCluster").append($("<option />").val(this.Value).text(this.Text));
                    });

                    if (result.Selected_Channel_Cluster_Codes != '')
                        $("#lbChannelCluster").val(result.Selected_Channel_Cluster_Codes);
                }
                $.each(result.RightRule_List, function () {
                    $("#ddlRuleRight").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlRuleRight").val(result.Right_Rule_Code)

                $("#lbChannel,#ddlRuleRight").trigger("chosen:updated");
                $("#lbChannelCluster").trigger("chosen:updated");
                
                $('#ddlPTitle,#lbChannel').each(function () {
                    $(this)[0].sumo.reload();
                });

                if (acqDealRunCode_G > 0) {
                    if (isRuleRight_G == "Y") {
                        bindRuleRecord(document.getElementById('ddlRuleRight'));
                        setChosenWidth('#ddlRuleRight', '45%');
                    }
                }
                
                if (isChannelDefinitionRights_G == 'Y') {
                    var strHTML = '<option value="0">Please Select</option>';
                    $('#lbChannel option:selected').each(function () {
                        var s = $(this);
                        strHTML = strHTML + s[0].outerHTML;
                    });
                    $('#ddlPrimaryChannel').html(strHTML);
                   
                    if (primaryChannelCode_G != '')
                        $('#ddlPrimaryChannel option[value="' + primaryChannelCode_G + '"]').attr("selected", "selected");
                    else
                        $('#ddlPrimaryChannel option[value= 0]').attr("selected", "selected");

                    $('#ddlPrimaryChannel').trigger('chosen:updated');
                    var strHTML = '<option value="0">Please Select</option>';
                    $('#ddlPrimaryChannelCluster').html(strHTML);
                    $.each(result.PrimarychannelList, function () {
                        $("#ddlPrimaryChannelCluster").append($("<option />").val(this.Value).text(this.Text));
                    });

                    if (primaryChannelClusterCode_G != '')
                        $('#ddlPrimaryChannelCluster option[value="' + primaryChannelClusterCode_G + '"]').attr("selected", "selected");
                    else
                        $('#ddlPrimaryChannelCluster option[value= 0]').attr("selected", "selected");

                    $('#ddlPrimaryChannelCluster').trigger('chosen:updated');
                }
            }
            hideLoading();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}