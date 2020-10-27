$(document).ready(function () {
    $('.modal').modal({
        backdrop: 'static',
        keyboard: false,
        show: false
    });
    debugger;
    $('#ddlTitle').SumoSelect();
    $('#ddlTitle_Search_List').SumoSelect();
    $('.modal-open').removeClass('modal-open');
    //  $("#ancFileName").attr('href', 'Help/index.html?IntCode=@Session["FileName"]');
    showLoading();
    if (recordLockingCode > 0) {
        var fullUrl = URL_Refresh_Lock;
        Call_RefreshRecordReleaseTime(recordLockingCode, fullUrl);
    }
    $('.nav-tabs li.active input').attr('disabled', 'disabled');
    setChosenWidth('#ddlOther', '140px');
    if (synDealMovie_Count > 0)
        Enable_DisableControl(true);
    if (parentCode > 0)
        $("input[name=Deal_Type_Code][value='" + parentCode + "']").prop("checked", "checked");
    $("#txtAgreement_Date").datepicker("option", "maxDate", new Date());
    if (generalPageNo > 0 && generalPageSize > 0) {
        $('#txtPageSize').val(generalPageSize)
        $('#hdnPageNo').val(generalPageNo)
    }
    else {
        $('#txtPageSize').val('10')
        $('#hdnPageNo').val('1')
    }
    BindTitleLabel(true);
    debugger;
    $("select#ddlTitle_Search_List").val(generalSearchTitleCodes.split(','))[0].sumo.reload();
    addNumeric();
    var txtRemark = document.getElementById('txtRemark');
    countChar(txtRemark);
    BindAllPreReq_Async();
});
//$(window).load(function () {
//    BindAllPreReq_Async();
//});
function ddlTitle_Search_List_OnChange() {
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    var arrSelectedTitles = $("#ddlTitle_Search_List").val();
    if (arrSelectedTitles == null) {
        if (!ValidatePageSize())
            return false;
        SearchTitle('');
    }
}
function SearchTitle(titleCode) {
    if (!SaveTitleListData(false))
        return false;
    $.ajax({
        type: "POST",
        url: URL_SearchTitle,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            selectedTitleCodes: titleCode
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.Status == "S") {
                    $('#lblTitleSearchCount').text(result.Record_Count);
                    $('#hdnPageNo').val(1);
                    BindTitleGridview();
                    addNumeric();
                    BindTitleLabel(false);
                }
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}
function btnSearchTitle_Click() {
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    if (Command_Name != null) {
        showAlert("E", ShowMessage.PleaseCompleteAddEdit);
        return false;
    }
    if (!ValidatePageSize())
        return false;
    var arrSelectedTitles = $("#ddlTitle_Search_List").val();
    titleCodes = arrSelectedTitles.join(',');
    if (arrSelectedTitles != null)
        SearchTitle(titleCodes);
    else
        showAlert("E", ShowMessage.Pleaseselectatleastonetitle, 'ddlTitle_Search_List')
}
function tblMovie_RowCommand(dummyGuid, rowIndex, commandName) {
    debugger;

    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    if (!ValidatePageSize())
        return false;
    Dummy_Guid = dummyGuid;
    Row_Index = rowIndex;
    Command_Name = commandName;

    var ddlTitle = $('#ddlTitle_' + rowIndex);
    var divTitle = $('#divTitle_' + rowIndex);
    var lblTitleName = $('#lblTitleName_' + rowIndex);
    var hdnTitleCode = $('#hdnTitleCode_' + rowIndex);
    var lblStarCast = $('#lblStarCast_' + rowIndex);
    var lblDuration = $('#lblDuration_' + rowIndex);
    var lblTitleLangName = $('#lblTitleLangName_' + rowIndex);


    var btnSave = $('#btnSave_' + rowIndex);
    var btnCancel = $('#btnCancel_' + rowIndex);
    var btnDelete = $('#btnDelete_' + rowIndex);
    var btnCloseTitle = $('#btnCloseTitle_' + rowIndex);
    var btnReplace = $('#btnReplace_' + rowIndex);


    //Movie_Closed_Date = (txtMovie_Closed_Date != null && txtMovie_Closed_Date != 'undefined') ? txtMovie_Closed_Date.val() : '';
    //Closing_Remarks = (txtClosing_Remarks != null && txtClosing_Remarks != 'undefined') ? txtClosing_Remarks.val() : '';

    //var OldClosedDate = $.trim($("#" + rowIndex + "_hdnTitleClosedDate").val());

    Syn_Deal_Movie_Code = $('#hdnSyn_Deal_Movie_Code_' + rowIndex).val();
    Title_Type = $("input[name='Syn_Deal_Movie[" + rowIndex + "].Syn_Title_Type']:radio:checked").val();


    var dealTypeCode = GetDealTypeCode();
    var dealCondition = GetDealTypeCondition(dealTypeCode);
    episode_From = 1, episode_To = 1, no_Of_Episodes = 1;
    if (dealCondition == "Deal_Music")
        episode_To = episode_From = parseInt($('#txtEpisode_End_To_' + rowIndex).val());
    else if (dealCondition == "Deal_Program") {
        episode_From = parseInt($('#txtEpisode_From_' + rowIndex).val());
        episode_To = parseInt($('#txtEpisode_End_To_' + rowIndex).val());
        if (dealTypeCode == "Deal_Type_Sports")
            episode_From = 1;
    }
    else if (dealCondition == "Sub_Deal_Talent") {
        txtNo_Of_Episodes = $('#txtNo_Of_Episode_' + rowIndex);
        if (txtNo_Of_Episodes.length == 0)
            no_Of_Episodes = 1;
        else
            no_Of_Episodes = parseInt(txtNo_Of_Episodes.val());
    }


    if (commandName == "DELETE") {
        var bindSearch = false;
        var status = "S";
        var searchSelectedCodes = $('#ddlTitle_Search_List').val();
        $.ajax({
            type: "POST",
            url: URL_DeleteTitle,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                Dummy_Guid: dummyGuid,
                synDealMovieCode: Syn_Deal_Movie_Code
            }),
            async: false,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    if (result.Status == "S") {
                        $('#imgTitleIcon').prop("src", result.Title_Icon_Path);
                        $('#divTitleIcon').attr("title", result.Title_Icon_Tooltip);
                        $('#tblMovie_tr_' + rowIndex).addClass("deleted");
                        bindSearch = result.Bind_Search;
                    }
                    else {
                        status = "E";
                        showAlert('E', result.Error_Message);
                    }
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });

        SetNull();
        if (status == "S") {
            SaveTitleListData(false);
            BindTitleGridview();
            addNumeric();
            BindTitleLabel(bindSearch);
            if (searchSelectedCodes != null && bindSearch) {
                $("select#ddlTitle_Search_List").val(searchSelectedCodes)[0].sumo.reload();
            }
        }
    }
    else if (commandName == 'REPLACE_TITLE') {
        divTitle.show();
        lblTitleName.hide();
        btnReplace.hide();
        btnDelete.hide();
        btnSave.show();
        btnCancel.show();

        var masterDealMovieCode = $("select[ID='ddlMaster_Deal_List'] option:selected").val();
        var dealTypeCode = GetDealTypeCode();
        var tc = parseInt(hdnTitleCode.val());
        //BindTitlePopup(masterDealMovieCode, dealTypeCode, tc, ddlTitle[0].id)
        BindTitlePopup(dealTypeCode, ddlTitle[0].id, tc);
        initializeChosen();
        ddlTitle.val(hdnTitleCode.val());
        ddlTitle.trigger("chosen:updated");

    }
    else if (commandName == 'CANCEL_REPLACE_TITLE') {

        divTitle.hide();

        lblTitleName.show();

        btnDelete.show();
        btnReplace.show();
        btnSave.hide();
        btnCancel.hide();

        SetNull();
    }
    else if (commandName == 'SAVE_REPLACE_TITLE') {
        debugger;
        var titleCode = ddlTitle.val();
        var oldTitleCode = hdnTitleCode.val();
        hdnTitleCode.val(titleCode);
        var returnVal = ValidateEpisodeOverlapping();
        if (!returnVal) {
            hdnTitleCode.val(oldTitleCode);
            return false;
        }

        $.ajax({
            type: "POST",
            url: URL_Replace_Title,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                dummyGuid: dummyGuid,
                titleCode: titleCode,
                titleType: Title_Type,
                episodeFrom: episode_From,
                episodeTo: episode_To,
                noOfEpisodes: no_Of_Episodes
            }),
            async: false,
            success: function (result) {

                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    if (result.Status == "S") {
                        debugger;
                        divTitle.hide();
                        lblTitleName.show();

                        lblTitleName.text(result.Title_Name);
                        lblTitleLangName.text(result.Title_Language_Name);
                        lblStarCast.text(result.Star_Cast);
                        lblDuration.text(result.Duration_In_Min);

                        btnDelete.show();
                        btnReplace.show();
                        btnSave.hide();
                        btnCancel.hide();
                        SetNull();
                    }
                    else if (result.Status == "E") {
                        hdnTitleCode.val(oldTitleCode);
                        showAlert("E", result.Error_Message);
                    }
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
}
function Ask_Confirmation(confirmMsg, dummyGuid, rowIndex, commandName) {
    debugger;
    if (!ValidatePageSize())
        return false;
    if (Command_Name != null) {
        showAlert("E", ShowMessage.PleaseCompleteAddEdit);
        return false;
    }
    Dummy_Guid = dummyGuid;
    Row_Index = rowIndex;
    Command_Name = commandName;
    //if (commandName == "DELETE") {
    //    showAlert("I", confirmMsg, "OKCANCEL");
    //}
    if (commandName == "DELETE" || commandName == 'REPLACE_TITLE') {
        showAlert("I", confirmMsg, "OKCANCEL");
    }
}
function handleOk() {
    debugger
    if (Command_Name == "DELETE" || Command_Name == "REPLACE_TITLE") {
        showLoading();
        tblMovie_RowCommand(Dummy_Guid, Row_Index, Command_Name);
        hideLoading();
    }
    else if (Command_Name == "REDIRECT_PAGE") {
        window.location.href = Redirect_URL;
    }
    else if (Command_Name == 'CANCEL_SAVE_DEAL') {
        location.href = URL_Cancel;
    }
}

function handleCancel() {
    SetNull();
}
function RequiredFieldValidation() {
    debugger;
    var returnVal = true;
    var agreementDate = $("#txtAgreement_Date").val();
    var dealDesc = $("#txtDeal_Desc").val();
    var dealTagCode = $("select[ID='ddlDeal_Tag'] option:selected").val();
    var currencyCode = $("select[ID='ddlCurrency'] option:selected").val();
    var licenseeCode = $("select[ID='ddlLicensee'] option:selected").val();
    var businessUnitCode = $("select[ID='ddlBusinessUnit'] option:selected").val();
    var categoryCode = $("select[ID='ddlCategory'] option:selected").val();
    var titleCount = $("#tblMovie tr:not(:has(th))").length
    var DealSegmentCode = $("select[ID='ddlDealSegment'] option:selected").val();
    if ($.trim(agreementDate) == "") {
        $('#txtAgreement_Date').attr('required', true)
        returnVal = false;
    }

    if ($.trim(dealDesc) == "") {
        $('#txtDeal_Desc').attr('required', true)
        returnVal = false;
    }

    if (dealTagCode == 0) {
        $('#ddlDeal_Tag').addClass("required");
        returnVal = false;
    }

    if (currencyCode == 0) {
        $('#ddlCurrency').addClass("required");
        returnVal = false;
    }

    if (licenseeCode == 0 || licenseeCode == undefined) {
        $('#ddlLicensee').addClass("required");
        returnVal = false;
    }

    if (businessUnitCode == 0) {
        $('#ddlBusinessUnit').addClass("required");
        returnVal = false;
    }

    if (categoryCode == 0) {
        $('#ddlCategory').addClass("required");
        returnVal = false;
    }

    if (titleCount == 0 && returnVal) {
        showAlert("E", ShowMessage.Pleaseaddatleastonetitle)
        returnVal = false;
    }

    if (DealSegmentCode == 0 || DealSegmentCode == "") {
        //$('#ddlBusinessUnit').attr('required', true)
        $('#ddlDealSegment').addClass("required");
        returnVal = false;
    }

    if (!returnVal)
        $('#hdnTabName').val("");

    return returnVal;
}
function ValidateSave() {
    if (!clickedOnTab) {
        if ($(event.target).val().toUpperCase() == "SAVE & APPROVE") {
            $('input[name=hdnReopenMode]').val('RO');
        }
        else {
            $('input[name=hdnReopenMode]').val('E');
        }
    }
    else {
        $('input[name=hdnReopenMode]').val('E');
    }

    if (!ValidatePageSize())
        return false;
    if (Command_Name != null) {
        showAlert("E", ShowMessage.PleaseCompleteAddEdit);
        return false;
    }
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");

    if (!RequiredFieldValidation())
        return false;
    if (!ValidateEpisodeOverlapping())
        return false;
    showLoading();
    $('input[name=hdnDeal_Type_Code]').val(GetDealTypeCode());
    $('input[name=hdnAgreementDate]').val($("input[ID='txtAgreement_Date']").val());
    $('input[name=hdnDealDesc]').val($("input[ID='txtDeal_Desc']").val());
    $('input[name=hdnDealTagStatusCode]').val($("select[ID='ddlDeal_Tag'] option:selected").val());
    return true;
}

function SetNull() {
    btnSave = btnCancel = btnDelete = btnCloseTitle = null;
    Syn_Deal_Movie_Code = Syn_Title_Type = Command_Name = Dummy_Guid = Row_Index = null;
    episode_From = episode_To = No_Of_Episode = null;
}
function rblDeal_For_OnChange() {
    debugger;
    var selectedValue = $("input[name='Deal_Type_Code']:radio:checked").val();
    if (selectedValue == Deal_Type_Other) {
        $("input[name=Deal_Type_Code][value='N']").prop("checked", "checked");
        $("#ddlOther").attr("disabled", false);
        $("#hdnDeal_Type_Code").val(0);
    }
    else {
        $("#ddlOther").val("0");
        $("#ddlOther").attr("disabled", true);
        $("#hdnDeal_Type_Code").val(selectedValue);
    }
    BindTitleLabel(true);
    $('.chosen-select:not(#ddlLicensor)').trigger("chosen:updated");
    BindTitleGridview();
}
function rbCustomer_Type_OnChange() {
    debugger;
    var selectedValue = $("input[name='Customer_Type']:radio:checked").val();
    var selectedValueForDDL = $("#ddlCustomerTypeOther").val();
    if (selectedValueForDDL > 0)
        selectedValue = selectedValueForDDL

    if (selectedValue == 0) {
        $("#ddlCustomerTypeOther").attr("disabled", false);
        $("#hdnCustomerTypeCode").val(0);
    }
    else {
        $.ajax({
            type: "POST",
            url: URL_CustomerType_Change,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                Selected_Role_Code: selectedValue
            }),
            async: true,
            success: function (result) {
                $("#ddlLicensee").empty();
                $.each(result, function () {
                    $("#ddlLicensee").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlLicensee").val('').trigger("chosen:updated");
                $("#ddlVContact").empty();
                $("#ddlVContact").trigger("chosen:updated");
                $("#lblVPhone").text('');
                $("#lblVEmail").text('');
            },
            error: function (result) {
                alert('E' + result.responseText);
            }
        });
    }


}
function ddlLicensee_Change() {
    var Selected_Licensee = $('#ddlLicensee').val();
    if (Selected_Licensee == null)
        Selected_Licensee = 0;
    $.ajax({
        type: "POST",
        url: URL_Licensee_Change,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Selected_Licensee_Code: Selected_Licensee
        }),
        async: true,
        success: function (result) {
            $("#ddlVContact").empty();
            $.each(result, function () {
                $("#ddlVContact").append($("<option />").val(this.Value).text(this.Text));
            });
            $("#ddlVContact").trigger("chosen:updated");
            $("#lblVPhone").text('');
            $("#lblVEmail").text('');
        },
        error: function (result) {
            alert('E' + result.responseText);
        }
    });
}
function ddlSaleAgent_Change() {
    var Selected_Sale_Agent = $('#ddlSale_Agent').val();
    if (Selected_Sale_Agent == null)
        Selected_Sale_Agent = 0;
    $.ajax({
        type: "POST",
        url: URL_SaleAgent_Change,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Selected_SaleAgent_Code: Selected_Sale_Agent
        }),
        async: true,
        success: function (result) {
            $("#ddlSAContact").empty();
            $.each(result, function () {
                $("#ddlSAContact").append($("<option />").val(this.Value).text(this.Text));
            });
            $("#ddlSAContact").trigger("chosen:updated");
            $("#lblSAPhone").text('');
            $("#lblSAEmail").text('');
        },
        error: function (result) {
            alert('E' + result.responseText);
        }
    });
}
function ddlVContact_OnChange() {
    var Selected_VContact = $('#ddlVContact').val();
    if (Selected_VContact == null)
        Selected_VContact = 0;
    $.ajax({
        type: "POST",
        url: URL_Licensee_Contact_Change,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Selected_Contact_Code: Selected_VContact
        }),
        async: true,
        success: function (result) {
            $("#lblVPhone").text(result.Vendor_Phone);
            $("#lblVEmail").text(result.Vendor_Email);
        },
        error: function (result) {
            alert('E' + result.responseText);
        }
    });
}
function ddlSAContact_OnChange() {
    var Selected_VContact = $('#ddlSAContact').val();
    if (Selected_VContact == null)
        Selected_VContact = 0;
    $.ajax({
        type: "POST",
        url: URL_SaleAgent_Contact_Change,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Selected_Contact_Code: Selected_VContact
        }),
        async: true,
        success: function (result) {
            $("#lblSAPhone").text(result.SA_Phone);
            $("#lblSAEmail").text(result.SA_Email);
        },
        error: function (result) {
            alert('E' + result.responseText);
        }
    });
}
function GetDealTypeCode() {
    debugger;
    var dealTypeCode = $("input[name='Deal_Type_Code']:radio:checked").val();
    if (dealTypeCode == Deal_Type_Other)
        dealTypeCode = $("select[ID='ddlOther'] option:selected").val();

    if (dealTypeCode == undefined)
        dealTypeCode = 0;
    return dealTypeCode;
}
function Enable_DisableControl(isDisable) {
    debugger;
    $("input[name='Deal_Type_Code'][type=radio]").attr('disabled', isDisable);
    var dealTypeCode = $("input[name='Deal_Type_Code']:radio:checked").val();
    if (dealTypeCode == Deal_Type_Other) {
        var otherCode = $('#ddlOther').val();
        if (otherCode > 0)
            $("select[ID='ddlOther']").attr('disabled', isDisable);
    }
    else
        $("select[ID='ddlOther']").attr('disabled', true);
    $('.chosen-select:not(#ddlLicensor)').trigger("chosen:updated");
}
function BindTitleLabel(bindSearch) {
    var dealTypeCode = GetDealTypeCode();
    if (dealTypeCode > 0) {
        $.ajax({
            type: "POST",
            url: URL_BindTitleLabel,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                dealTypeCode: dealTypeCode
            }),
            async: false,
            success: function (result) {

                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    $('#lblTitleLabel').text(result.Title_Label)
                    if (result.Title_Label != "")
                        $('#lblTitleCount').text(" ( " + result.Title_Count + " )");
                    else
                        $('#lblTitleCount').text("");

                    if (result.Title_Count == 0)
                        Enable_DisableControl(false);

                    $('#lblTitleSearchCount').text(result.Record_Count);
                    $("input[name=hdnRecordCount]").val(result.Record_Count);
                    if (bindSearch) {
                        debugger;
                        $("#ddlTitle_Search_List").empty();
                        $.each(result.Title_Search_List, function () {
                            $("#ddlTitle_Search_List").append($("<option />").val(this.Value).text(this.Text));
                        });
                        $("#ddlTitle_Search_List")[0].sumo.reload();
                    }
                    SetPaging();
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
    else {
        $('#lblTitleLabel').text("");
        $('#lblTitleCount').text("");
        $('#lblTitleSearchCount').text(0);
        $("input[name=hdnRecordCount]").val(0);
    }
}

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

    $('#hdnPageNo').val(pageNo);
    var index = pageNo - 1;
    var opt = { callback: pageselectCallback };
    opt["items_per_page"] = recordPerPage;
    opt["num_display_entries"] = pagePerBatch;
    opt["num"] = 10;
    opt["prev_text"] = "<<";
    opt["next_text"] = ">>";
    opt["current_page"] = index;
    $("#Pagination").pagination(recordCount, opt);
}

function pageselectCallback(page_index, jq) {

    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");

    if (Command_Name != null) {
        showAlert("E", ShowMessage.PleaseCompleteAddEdit);
        return false;
    }

    if (!ValidatePageSize())
        return false;

    var pageNo = page_index + 1
    $('#hdnPageNo').val(pageNo);
    if (IsCall == 'Y') {
        var returnVal = SaveTitleListData(true);
        if (returnVal)
            BindTitleGridview();
    }
    else
        IsCall = 'Y';
}

function ValidatePageSize() {
    var recordPerPage = $('#txtPageSize').val()
    if ($.trim(recordPerPage) != '') {
        var pageSize = parseInt(recordPerPage);
        if (pageSize > 0)
            return true;
    }
    $('#txtPageSize').addClass("required");

    return false;
}
function pageBinding() {
    BindTitleGridview();
}
function ValidateEpisodeOverlapping() {
    var returnVal = true;
    var dealTypeCode = GetDealTypeCode();
    var dealTypeCondition = GetDealTypeCondition(dealTypeCode);
    var tblMovie = $("#tblMovie tr:not(:has(th),.deleted)");
    var Count = tblMovie.length;
    if (dealTypeCondition == Deal_Program) {
        tblMovie.each(function (rowId_outer) {
            var az = rowId_outer;
            if (returnVal == false)
                return false;
            var txtEpisode_From_outer = $(this).find("input[id*='txtEpisode_From'][type='text']");
            var txtEpisode_End_To_outer = $(this).find("input[id*='txtEpisode_End_To'][type='text']");
            var titleCode_outer = parseInt($(this).find("input[id*='hdnTitleCode']").val());
            var startEpisodeNo_outer = parseInt(txtEpisode_From_outer.val());
            var endEpisodeNo_outer = parseInt(txtEpisode_End_To_outer.val());
            var hdn_Min_Episode_Avail_From = $('#hdn_Min_Episode_Avail_From_' + rowId_outer).val();
            var hdn_Max_Episode_Avail_To = $('#hdn_Max_Episode_Avail_To_' + rowId_outer).val();
            if (!isNaN(startEpisodeNo_outer) && !isNaN(endEpisodeNo_outer)) {
                var message = "";
                if (startEpisodeNo_outer == 0 || endEpisodeNo_outer == 0) {
                    var txt = txtEpisode_End_To_outer[0];

                    if (startEpisodeNo_outer == 0)
                        txt = txtEpisode_From_outer[0];

                    message = ShowMessage.Episodenomustbegreaterthanzero;
                    if (dealTypeCode == Deal_Type_Sports)
                        message = ShowMessage.NoofMatchesmustbegreaterthanzero;

                    showAlert("E", message, txt.id);

                    returnVal = false;
                    return false;
                }
                else if (startEpisodeNo_outer > endEpisodeNo_outer) {
                    var txt = txtEpisode_From_outer[0];

                    if (dealTypeCode == Deal_Type_Sports)
                        message = ShowMessage.MatchesFromcannotbegreaterthanNoofMatches
                    else
                        message = ShowMessage.EpisodeFromcannotbegreaterthanEpisodeTo

                    showAlert("E", message, txt.id);
                    returnVal = false;
                    return false;
                }

                var txtMaximumEpisode_From = $(this).find("input[id*='txtMaximumEpisode_From'][type='text']");
                var txtMininumEpisode_To = $(this).find("input[id*='txtMininumEpisode_To'][type='text']");

                var maxEpisode_From = parseInt(txtMaximumEpisode_From.val());
                var minEpisode_To = parseInt(txtMininumEpisode_To.val());

                if (!isNaN(maxEpisode_From) && !isNaN(minEpisode_To)) {
                    if (startEpisodeNo_outer > maxEpisode_From && maxEpisode_From > 0) {
                        var txt = txtEpisode_From_outer[0];
                        message = "Episode no. cannot be greater than " + maxEpisode_From;

                        showAlert("E", message, txt.id);
                        returnVal = false;
                        return;
                    }

                    if (endEpisodeNo_outer < minEpisode_To && minEpisode_To > 0) {
                        var txt = txtEpisode_End_To_outer[0];
                        if (dealTypeCode == Deal_Type_Sports)
                            message = ShowMessage.NoofMatchescannotbelessthan + minEpisode_To;
                        else
                            message = ShowMessage.Episodenocannotbelessthan + minEpisode_To;

                        showAlert("E", message, txt.id);
                        returnVal = false;
                        return;
                    }
                    if (returnVal && hdn_Min_Episode_Avail_From > 0 && startEpisodeNo_outer != "") {
                        if (parseInt(startEpisodeNo_outer) < parseInt(hdn_Min_Episode_Avail_From)) {
                            var txt = txtEpisode_From_outer[0];
                            message = ShowMessage.Episodenocannotbelessthan + hdn_Min_Episode_Avail_From;
                            showAlert("E", message, txt.id);
                            returnVal = false;
                            return;
                        }
                    }

                    if (hdn_Max_Episode_Avail_To > 0 && endEpisodeNo_outer != "") {
                        if (parseInt(endEpisodeNo_outer) > parseInt(hdn_Max_Episode_Avail_To)) {
                            var txt = txtEpisode_End_To_outer[0];
                            message = ShowMessage.Episodenocannotbegreaterthan + hdn_Max_Episode_Avail_To;
                            showAlert("E", message, txt.id);
                            returnVal = false;
                            return;
                        }
                    }

                }

                tblMovie.each(function (rowId_inner) {
                    if (rowId_outer != rowId_inner) {
                        var txtEpisode_From_inner = $(this).find("input[id*='txtEpisode_From'][type='text']");
                        var txtEpisode_End_To_inner = $(this).find("input[id*='txtEpisode_End_To'][type='text']");

                        var startEpisodeNo_inner = parseInt(txtEpisode_From_inner.val());
                        var endEpisodeNo_inner = parseInt(txtEpisode_End_To_inner.val());
                        var titleCode_inner = parseInt($(this).find("input[id*='hdnTitleCode']").val());

                        if (!isNaN(startEpisodeNo_inner) && !isNaN(endEpisodeNo_inner) && titleCode_inner == titleCode_outer) {

                            var txt = null;
                            if (startEpisodeNo_inner > endEpisodeNo_inner) {
                                txt = txtEpisode_From_inner[0];
                                showAlert("E", ShowMessage.EpisodeFromcannotbegreaterthanEpisodeTo, txt.id)
                                returnVal = false;
                                return false;
                            }

                            if (startEpisodeNo_inner >= startEpisodeNo_outer && startEpisodeNo_inner <= endEpisodeNo_outer) {
                                txt = txtEpisode_From_inner[0];
                                returnVal = false;
                            }

                            if (endEpisodeNo_inner >= startEpisodeNo_outer && endEpisodeNo_inner <= endEpisodeNo_outer && returnVal) {
                                txt = txtEpisode_End_To_inner[0];
                                returnVal = false;
                            }

                            if (startEpisodeNo_outer >= startEpisodeNo_inner && startEpisodeNo_outer <= endEpisodeNo_inner && returnVal) {
                                txt = txtEpisode_From_outer[0];
                                returnVal = false;
                            }

                            if (endEpisodeNo_outer >= startEpisodeNo_inner && endEpisodeNo_outer <= endEpisodeNo_inner && returnVal) {
                                txt = txtEpisode_End_To_outer[0];
                                returnVal = false;
                            }
                            if (!returnVal) {
                                var message = ShowMessage.OverlappingEpisodeNo;
                                if (dealTypeCode == Deal_Type_Sports)
                                    message = ShowMessage.OverlappingNoofMatches;

                                showAlert("E", message, txt.id)
                                return false;
                            }
                        }
                    }
                });
            }
            else {
                var txt = txtEpisode_End_To_outer[0];

                if (isNaN(startEpisodeNo_outer))
                    txt = txtEpisode_From_outer[0];

                var message = ShowMessage.PleaseEnterEpisodeno
                if (dealTypeCode == Deal_Type_Sports)
                    message = ShowMessage.PleaseEnternoofmatches
                $('#' + txt.id).attr('required', true)
                showAlert("E", message)
                returnVal = false;
                return false;
            }
        });
        return returnVal;
    }
    else
        return true;
}
function Validate_Episode(id, obj, CallFrom) {
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    var selectedDealType = $("input[name='Deal_Type_Code']:radio:checked").val();
    if (selectedDealType == Deal_Type_Other)
        selectedDealType = $("select[ID='ddlOther'] option:selected").val();
    var hdn_Min_Episode_Avail_From = $('#hdn_Min_Episode_Avail_From_' + id).val();
    var hdn_Max_Episode_Avail_To = $('#hdn_Max_Episode_Avail_To_' + id).val();
    var Episode_End_To = $('#txtEpisode_End_To_' + id).val();
    var Episode_From = $('#txtEpisode_From_' + id).val();
    var Error_msg = "";
    if (obj != null && $.trim($(obj).val()) == "") {
        if (selectedDealType == Deal_Type_Sports)
            Error_msg = ShowMessage.PleaseEnternoofmatches;
        else
            Error_msg = ShowMessage.PleaseEnterEpisodeno;
    }
    if (obj != null && parseInt($.trim($(obj).val())) <= 0) {
        if (selectedDealType == Deal_Type_Sports)
            Error_msg = ShowMessage.NoofMatchesmustbegreaterthanzero;
        else
            Error_msg = ShowMessage.Episodenomustbegreaterthanzero;
    }
    var startEpisodeNo = 0;
    var endEpisodeNo = 0;
    var minEpisode_From = 0;
    var maxEpisode_To = 0;
    startEpisodeNo = Episode_From;
    minEpisode_From = hdn_Min_Episode_Avail_From;
    endEpisodeNo = Episode_End_To;
    maxEpisode_To = hdn_Max_Episode_Avail_To;
    if (minEpisode_From > 0 && startEpisodeNo != "") {
        if (parseInt(startEpisodeNo) < parseInt(minEpisode_From)) {
            Error_msg = ShowMessage.Episodenomustbegreaterthanzero + hdn_Min_Episode_Avail_From;
        }
    }

    if (maxEpisode_To > 0 && endEpisodeNo != "") {
        if (parseInt(endEpisodeNo) > parseInt(maxEpisode_To)) {
            if (selectedDealType == Deal_Type_Sports)
                Error_msg = ShowMessage.NoofMatchescannotbegreaterthan + maxEpisode_To;
            else
                Error_msg = ShowMessage.Episodenocannotbegreaterthan + maxEpisode_To;
        }
    }
    if (Error_msg != "" && startEpisodeNo != "" && endEpisodeNo != "") {
        if (parseInt(endEpisodeNo) < parseInt(startEpisodeNo)) {
            if (CallFrom == "EP_FROM") {
                if (selectedDealType != Deal_Type_Sports)
                    Error_msg = ShowMessage.EpisodeFromcannotbegreaterthanEpisodeTo
                else
                    Error_msg = ShowMessage.MatchesFromcannotbegreaterthanNoofMatches
            }
            if ((CallFrom == "EP_TO") && (Error_msg != "")) {
                if (selectedDealType != Deal_Type_Sports)
                    Error_msg = ShowMessage.EpisodeTocannotbelessthanEpisodeFrom
                else
                    Error_msg = ShowMessage.NoofMatchescannotbelessthanMatchesFrom
            }
        }
    }
    if (Error_msg == "" && startEpisodeNo != "" && endEpisodeNo == "") {
        if (parseInt(startEpisodeNo) > parseInt(maxEpisode_To)) {
            if (CallFrom == "EP_FROM") {
                if (selectedDealType != Deal_Type_Sports)
                    Error_msg = ShowMessage.Episodenocannotbegreaterthan + maxEpisode_To;
            }
        }
    }
    if (Error_msg != "") {
        if (CallFrom == "EP_FROM")
            showAlert("E", Error_msg, $('#txtEpisode_From_' + id)[0].id);
        else
            showAlert("E", Error_msg, $('#txtEpisode_End_To_' + id)[0].id);
        return false;
    }
}
function txtPageSize_OnChange() {
    debugger;
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");

    if (Command_Name != null) {
        showAlert("E", ShowMessage.PleaseCompleteAddEdit);
        return false;
    }

    if (!ValidatePageSize())
        return false;

    var returnVal = SaveTitleListData(true);
    if (returnVal) {
        BindTitleGridview();
        SetPaging();
    }
}
function BindTitleGridview() {
    var pageNo = $('#hdnPageNo').val();
    var dealTypeCode = GetDealTypeCode();
    var recordPerPage = $('#txtPageSize').val();
    $.ajax({
        type: "POST",
        url: URL_BindTitleGridview,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            dealTypeCode: dealTypeCode,
            pageNo: pageNo,
            recordPerPage: recordPerPage
        }),
        async: false,
        success: function (result) {
            hideLoading();
            if (result == "true") {
                redirectToLogin();
            }
            else {
                $('#subDealMovie').empty();
                $('#subDealMovie').html(result);
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
    initializeTooltip();
    initializeDatepicker();
    initializeExpander();
}
function ddlOther_OnChange() {
    var dealTypeCode = $("select[ID='ddlOther'] option:selected").val();
    $("#hdnDeal_Type_Code").val(dealTypeCode);
    BindTitleLabel(true);
    BindTitleGridview();
}
function btnAddTitle_OnClick() {
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    if (Command_Name != null) {
        showAlert("E", ShowMessage.PleaseCompleteAddEdit);
        return false;
    }
    var valid = ValidatePageSize();
    if (!valid)
        return false;

    var dealTypeCode = GetDealTypeCode();
    BindTitlePopup(dealTypeCode, 'ddlTitle')
    $('#popAddDealMovie').modal();
}
function BindTitlePopup(dealTypeCode, ddl_ID, replacingTitleCode) {
    debugger;
    $.ajax({
        type: "POST",
        url: URL_BindTitlePopup,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            dealTypeCode: dealTypeCode,
            replacingTitleCode: replacingTitleCode
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                $("#" + ddl_ID).empty();
                $.each(result, function () {
                    $("#" + ddl_ID).append($("<option />").val(this.Value).text(this.Text));
                });
                if (replacingTitleCode != undefined)
                    $("#" + ddl_ID).trigger("chosen:updated");
                else
                    $("#" + ddl_ID)[0].sumo.reload();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}
function GetDealTypeCondition(selectedDealTypeCode) {
    if (selectedDealTypeCode == Deal_Type_Content || selectedDealTypeCode == Deal_Type_Sports || selectedDealTypeCode == Deal_Type_Format_Program
        || selectedDealTypeCode == Deal_Type_Event || selectedDealTypeCode == Deal_Type_Documentary_Show || selectedDealTypeCode == Deal_Type_Webseries) {
        return Deal_Program;
    }
    else if (selectedDealTypeCode == Deal_Type_Movie || selectedDealTypeCode == Deal_Type_ShortFilm || selectedDealTypeCode == Deal_Type_Featurette || selectedDealTypeCode == Deal_Type_Cineplay)
        return Deal_Movie;
}
function addNumeric() {
    $("input.numeric").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        max: 9999,
        min: 1
    });

    $("input.numeric_music").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        max: 9999,
        min: 0
    });

    $("input.pagingSize").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        max: 100,
        min: 1
    });
}
function SaveTitleListData(validateOverlapping) {
    var titleList = new Array();
    var tblMovie = $("#tblMovie tr:not(:has(th))");
    var returnVal = true;
    if (validateOverlapping)
        returnVal = ValidateEpisodeOverlapping();
    if (returnVal) {
        var dealTypeCode = GetDealTypeCode();
        var dealCondition = GetDealTypeCondition(dealTypeCode);
        var i = 0;

        tblMovie.each(function () {
            debugger;
            if ($(this).attr('class') != 'deleted') {
                var _titleCode = 0, _dummyGuid = "", _notes = "", _episode_from = 1, _episode_to = 1, _no_of_episode = 1, _Syn_Title_Type = "";

                _titleCode = parseInt($("#hdnTitleCode_" + i).val());
                _dummyGuid = $("#hdnDummyGuid_" + i).val();
                _Syn_Title_Type = $("input[name='Syn_Deal_Movie[" + i + "].Syn_Title_Type']:radio:checked").val();
                _notes = $('#txtNotes_' + i).val();

                if (dealCondition == Deal_Program) {
                    _episode_from = parseInt($('#txtEpisode_From_' + i).val());
                    _episode_to = parseInt($('#txtEpisode_End_To_' + i).val());
                    if (dealTypeCode == Deal_Type_Sports)
                        _episode_from = 1;
                }

                titleList.push({
                    Title_Code: _titleCode, _Dummy_Guid: _dummyGuid, Notes: _notes, Episode_From: _episode_from,
                    Episode_End_To: _episode_to, No_Of_Episode: _no_of_episode, Syn_Title_Type: _Syn_Title_Type
                });

            }

            i = i + 1;
        });
        $.ajax({
            type: "POST",
            url: URL_SaveTitleListData,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                titleList: titleList
            }),
            async: false,
            success: function (result) {

                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    if (result.Status == "E") {
                        showAlert('E', result.Error_Message);
                        returnVal = false;
                    }
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }

    return returnVal;
}
function btnSaveTitle_OnClick() {
    var arrTitleCodes = $("#ddlTitle").val();
    $('.ddlTitle').removeClass("required");
    if (arrTitleCodes != null) {
        Enable_DisableControl(true);
        titleCodes = arrTitleCodes.join(',');
        $('#popAddDealMovie').modal('hide')
        valid = SaveTitleListData(false);
        if (!valid)
            return false;
        var dealTypeCode = GetDealTypeCode();
        $.ajax({
            type: "POST",
            url: URL_SaveTitle,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                titleCodes: titleCodes,
                dealTypeCode: dealTypeCode
            }),
            async: false,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    if (result.Status == "S") {
                        $('#imgTitleIcon').prop("src", result.Title_Icon_Path);
                        $('#divTitleIcon').attr("title", result.Title_Icon_Tooltip);
                        BindTitleGridview();
                        addNumeric();
                        BindTitleLabel(true);
                    }
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
    else {
        $('.ddlTitle').addClass("required");
        showAlert("E", ShowMessage.Pleaseselectatleastonetitle, 'ddlTitle')
    }
}
function Save_Success(result) {
    hideLoading();
    if (result == "true") {
        redirectToLogin();
    }
    else {
        status = result.Status;
        var Validation_Result = result.Validation_Result;
        if (Validation_Result != null && Validation_Result.length != '0') {
            var tbl_html = "<table class='table table-bordered table-hover'><tr><th>Title Name</th><th>Episode No.</th></tr>";
            for (var f = 0; f < Validation_Result.length; f++) {
                tbl_html = tbl_html + "<tr><td>" + Validation_Result[f].Title_Name + "</td><td>" + Validation_Result[f].Episode_No + "</td></tr>";
            }
            tbl_html = tbl_html + "</table>";
            $('#dv_Validate_Episodes').html(tbl_html);
            $('#popValidate_Episode').modal();
        }
        else if (result.Status == "S" || result.Status == "SA") {
            if (result.Status == "SA") {
                $.ajax({
                    type: "POST",
                    url: URL_Syn_Approve_Reject,
                    traditional: true,
                    enctype: 'multipart/form-data',
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({
                        user_Action: 'A',
                        approvalremarks: ''
                    }),
                    async: false,
                    success: function (data) { }
                });
            }
            if (result.Success_Message != "") {
                // When we clicked on Save, now move to deal list page 
                Command_Name = "REDIRECT_PAGE"
                Redirect_URL = result.Redirect_URL;
                showAlert("S", result.Success_Message, "OK");
            }
            else {
                // When we clicked on Tab, now move to another tab
                BindPartialTabs(result.TabName);
                BindTopSynDetails();
            }
        }
        else if (result.Status == undefined) {
            Command_Name = null;
            Redirect_URL = null;
            window.location.href = URL_Login_Index;
        } else if (result.Status == "E") {
            Command_Name = null;
            Redirect_URL = null;
            if (result.Error_Message != "")
                showAlert("E", result.Error_Message);

            if (result.Error_Page_Index > 0) {
                $('#hdnPageNo').val(result.Error_Page_Index);
                $('#hdnRecordCount').val(result.Total_Record_Count);
                $("#ddlTitle_Search_List").val('')[0].sumo.reload();
                BindTitleGridview();
                SetPaging()
                ValidateEpisodeOverlapping()
            }
        }
    }

    return false;
}

function CancelSaveDeal() {
    Command_Name = "CANCEL_SAVE_DEAL";
    showAlert("I", ShowMessage.Allunsavedata, "OKCANCEL");
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
            // hideLoading();
            if (result == "true") {
                redirectToLogin();
            }
            else {
                debugger
                $.each(result.Currency_List, function () {
                    $("#ddlCurrency").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlCurrency").val(result.Currency_Code);

                $.each(result.Business_Unit_List, function () {
                    $("#ddlBusinessUnit").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlBusinessUnit").val(result.Business_Unit_Code);

                $.each(result.Category_List, function () {
                    $("#ddlCategory").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlCategory").val(result.Category_Code);

                $.each(result.Licensee_List, function () {
                    $("#ddlLicensee").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlLicensee").val(result.Vendor_Code);

                $.each(result.Licensee_Contact_List, function () {
                    $("#ddlVContact").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlVContact").val(result.Licensee_Contact_Code);

                $.each(result.Sales_Agent_List, function () {
                    $("#ddlSale_Agent").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlSale_Agent").val(result.Sales_Agent_Code);

                $.each(result.Sales_Agent_Contact_List, function () {
                    $("#ddlSAContact").append($("<option />").val(this.Value).text(this.Text));
                });

                $("#ddlSAContact").val(result.Sales_Agent_Contact_Code);
                $("#ddlCurrency,#ddlBusinessUnit,#ddlCategory,#ddlSale_Agent,#ddlLicensee,#ddlVContact,#ddlSAContact").trigger("chosen:updated");
                ddlVContact_OnChange()
                ddlSAContact_OnChange()
                BindTitleGridview();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}

function ddlTitle_Change(e, rowIndex) {
    debugger;
    var dealTypeCode = GetDealTypeCode();
    if (dealTypeCode == 11) {
        var replacingTitleCode = $('#' + e.id).val();
        $.ajax({
            type: "POST",
            url: URL_ProgramTitleChange,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                replacingTitleCode: replacingTitleCode
            }),
            async: false,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    $('#hdn_Min_Episode_Avail_From_' + rowIndex).val(result.Min_Episode_Avail_From);
                    $('#hdn_Max_Episode_Avail_To_' + rowIndex).val(result.Max_Episode_Avail_To);
                }
            }
        });
    }
}