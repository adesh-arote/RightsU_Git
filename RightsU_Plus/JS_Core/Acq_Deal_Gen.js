$(document).ready(function () {
    debugger;
    $('.modal').modal({
        backdrop: 'static',
        keyboard: false,
        show: false
    })

    showLoading();
    if (recordLockingCode > 0) {
        var fullUrl = URL_Refresh_Lock;
        Call_RefreshRecordReleaseTime(recordLockingCode, fullUrl);
    }
    $('.nav-tabs li.active input').attr('disabled', 'disabled');

    if (acqDealMovie_Count > 0) {
        Enable_DisableControl(true);
    }
    else if (isMasterDeal == 'Y') {
        $("select[ID='ddlMaster_Deal_List']").attr('disabled', true);
        $("select[ID='ddlOther']").attr('disabled', true);
        $('.chosen-select:not(#ddlLicensor)').trigger("chosen:updated");
    }

    if (parentCode > 0)
        $("input[name=Deal_Type_Code][value='" + parentCode + "']").prop("checked", "checked");

    $("#txtAgreement_Date").datepicker("option", "maxDate", new Date());

    ChangeLabelName();
    $("input[name=hdnPrimaryVendorCode]").val(vendorCode);

    if (generalPageNo > 0 && generalPageSize > 0) {
        $('#txtPageSize').val(generalPageSize)
        $('#hdnPageNo').val(generalPageNo)
    }
    else {
        $('#txtPageSize').val('10')
        $('#hdnPageNo').val('1')
    }

    var txtRemark = document.getElementById('txtRemark');
    countChar(txtRemark);
    hideLoading();
    BindAllPreReq_Async(); // Always call this function last


});

function GetDealTypeCondition(selectedDealTypeCode) {
    hideLoading();
    if (selectedDealTypeCode == Deal_Type_Content || selectedDealTypeCode == Deal_Type_Sports || selectedDealTypeCode == Deal_Type_Format_Program
        || selectedDealTypeCode == Deal_Type_Event || selectedDealTypeCode == Deal_Type_Documentary_Show || selectedDealTypeCode == Deal_Type_Webseries) {
        return Deal_Program;
    }
    else if (selectedDealTypeCode == Deal_Type_Music || selectedDealTypeCode == Deal_Type_ContentMusic)
        return Deal_Music;
    else if (selectedDealTypeCode == Deal_Type_Movie || selectedDealTypeCode == Deal_Type_ShortFilm || selectedDealTypeCode == Deal_Type_Featurette || selectedDealTypeCode == Deal_Type_Cineplay)
        return Deal_Movie;
    else
        return Sub_Deal_Talent;
}

function SetNull() {
    txtMovie_Closed_Date = txtClosing_Remarks = null;
    btnSave = btnCancel = btnDelete = btnCloseTitle = null;
    Acq_Deal_Movie_Code = Notes = Title_Type = Command_Name = Dummy_Guid = Row_Index = null;
    episode_From = episode_To = no_Of_Episodes = null;
}

function Enable_DisableControl(isDisable) {
    debugger
    $("input[name='Deal_Type_Code'][type=radio]").attr('disabled', isDisable);
    $("input[name='Is_Master_Deal'][type=radio]").attr('disabled', isDisable);

    if (isDisable) {
        $("select[ID='ddlMaster_Deal_List']").attr('disabled', isDisable);
        $("select[ID='ddlOther']").attr('disabled', isDisable);
    }
    else {
        var masterDealCode = $('#ddlMaster_Deal_List').val();
        if (masterDealCode > 0)
            $("select[ID='ddlMaster_Deal_List']").attr('disabled', isDisable);

        var otherCode = $('#ddlOther').val();
        if (otherCode > 0)
            $("select[ID='ddlOther']").attr('disabled', isDisable);
    }

    $('.chosen-select:not(#ddlLicensor)').trigger("chosen:updated");
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

function setPrimaryLicensor(value) {
    var index = $('#ddlLicensor [value=' + value + ']').index();
    $('#ddlLicensor_chosen a').filter('[data-option-array-index="' + index + '"]').closest('li').addClass('primary');
}

function getPrimaryLicensor() {
    var index = $('#ddlLicensor_chosen li.search-choice.primary a').data("option-array-index");
    if (isNaN(index))
        return 0;

    index = parseInt(index) + 1;
    return $('#ddlLicensor option:nth-child(' + index + ')').val();
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
    if (Command_Name == "") {
        Command_Name = null;
    }
    if (Command_Name != null) {
        showAlert("E", ShowMessage.MsgForAddEdit);//MsgForAddEdit = Please complete add/edit operation.
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
    debugger
    var recordPerPage = $('#txtPageSize').val()
    if ($.trim(recordPerPage) != '') {
        var pageSize = parseInt(recordPerPage);
        if (pageSize > 0)
            return true;
    }
    $('#txtPageSize').addClass("required");

    return false
}
function pageBinding() {
    debugger
    BindTitleGridview();
    SetPaging();
}
function txtPageSize_OnChange() {
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    if (Command_Name == "") {
        Command_Name = null;
    }
    if (Command_Name != null) {
        showAlert("E", ShowMessage.MsgForAddEdit);//MsgForAddEdit = Please complete add/edit operation.
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

function GetDealTypeCode() {
    debugger;
    var dealTypeCode = $("input[name='Deal_Type_Code']:radio:checked").val();
    if (dealTypeCode == Deal_Type_Other)
        dealTypeCode = $("select[ID='ddlOther'] option:selected").val();

    if (dealTypeCode == undefined)
        dealTypeCode = 0;
    return dealTypeCode;
}

function BasicValidationForAddTitle() {
    var returnVal = true;
    var rblIsMasterDeal = $("input[name='Is_Master_Deal']:radio:checked").val();
    var masterDealMovieCode = $("select[ID='ddlMaster_Deal_List'] option:selected").val();
    var dealTypeCode = GetDealTypeCode();

    if (rblIsMasterDeal == "N" && masterDealMovieCode == 0 && dealTypeCode != Deal_Type_Music) {
        //$('#ddlMaster_Deal_List').attr('required', true)
        $('#ddlMaster_Deal_List').addClass("required");
        returnVal = false;
    }

    if (dealTypeCode == 0) {
        //$('#ddlOther').attr('required', true)
        $('#ddlOther').addClass("required");
        returnVal = false;
    }

    return returnVal;
}

function RequiredFieldValidation() {
    var returnVal = true;
    returnVal = BasicValidationForAddTitle();
    var agreementDate = $("#txtAgreement_Date").val();
    var dealDesc = $("#txtDeal_Desc").val();
    var dealTagCode = $("select[ID='ddlDeal_Tag'] option:selected").val();
    var currencyCode = $("select[ID='ddlCurrency'] option:selected").val();
    var licenseeCode = $("select[ID='ddlLicensee'] option:selected").val();
    var businessUnitCode = $("select[ID='ddlBusinessUnit'] option:selected").val();
    var licensorCode = $("#ddlLicensor").val();
    var categoryCode = $("select[ID='ddlCategory'] option:selected").val();
    var titleCount = $("#tblMovie tr:not(:has(th))").length

    if ($.trim(agreementDate) == "") {
        $('#txtAgreement_Date').attr('required', true)
        returnVal = false;
    }

    if ($.trim(dealDesc) == "") {
        $('#txtDeal_Desc').attr('required', true)
        returnVal = false;
    }

    if (dealTagCode == 0) {
        //$('#ddlDeal_Tag').attr('required', true)
        $('#ddlDeal_Tag').addClass("required");
        returnVal = false;
    }

    if (currencyCode == 0) {
        //$('#ddlCurrency').attr('required', true)
        $('#ddlCurrency').addClass("required");
        returnVal = false;
    }

    if (licenseeCode == 0 || licenseeCode == undefined) {
        //$('#ddlLicensee').attr('required', true)
        $('#ddlLicensee').addClass("required");
        returnVal = false;
    }

    if (businessUnitCode == 0) {
        //$('#ddlBusinessUnit').attr('required', true)
        $('#ddlBusinessUnit').addClass("required");
        returnVal = false;
    }

    if (licensorCode == null) {
        $('#ddlLicensor').attr('required', true)
        returnVal = false;
    }
    else {
        var plc = getPrimaryLicensor();

        if (plc == 0) {
            showAlert("E", ShowMessage.MsgForPrimLsr, 'ddlLicensor')//MsgForPrimLsr = Please select primary licensor
            returnVal = false;
        }
    }

    if (categoryCode == 0) {
        //$('#ddlCategory').attr('required', true)
        $('#ddlCategory').addClass("required");
        returnVal = false;
    }

    if (titleCount == 0 && returnVal) {
        showAlert("E", ShowMessage.MsgForAddTitle)//MsgForAddTitle = Please add atleast one title
        returnVal = false;
    }

    if (!returnVal)
        $('#hdnTabName').val("");

    return returnVal;
}

function rblIsMasterDeal_OnChange() {
    BindTopBand();
    var isMasterDeal = $("input[name='Is_Master_Deal']:radio:checked").val();

    if (isMasterDeal == "N") {
        $("input[name=Deal_Type_Code][value='" + Deal_Type_Other + "']").prop("checked", "checked");
        $("#ddlMaster_Deal_List").attr("disabled", false);
        $("#ddlOther").attr("disabled", false);
        $("#hdnDeal_Type_Code").val(0);
    }
    else {
        $("input[name=Deal_Type_Code][value='" + Deal_Type_Movie + "']").prop("checked", "checked");
        $("#ddlMaster_Deal_List").val("0");
        $("#ddlOther").val("0");
        $("#ddlMaster_Deal_List").attr("disabled", true);
        $("#ddlOther").attr("disabled", true);
        PopulateMasterDealData();
        $("#hdnDeal_Type_Code").val(Deal_Type_Movie);
    }

    BindTitleLabel(true);
    $('.chosen-select:not(#ddlLicensor)').trigger("chosen:updated");
    BindTitleGridview();
}

function rblDeal_For_OnChange() {
    BindTopBand();
    var selectedValue = $("input[name='Deal_Type_Code']:radio:checked").val();

    if (selectedValue == Deal_Type_Other) {
        $("input[name=Is_Master_Deal][value='N']").prop("checked", "checked");
        $("#ddlOther").attr("disabled", false);
        $("#ddlMaster_Deal_List").attr("disabled", false);
        $("#hdnDeal_Type_Code").val(0);
    }
    else {
        $("input[name=Is_Master_Deal][value='Y']").prop("checked", "checked");
        $("#ddlMaster_Deal_List").val("0");
        $("#ddlOther").val("0");
        $("#ddlMaster_Deal_List").attr("disabled", true);
        $("#ddlOther").attr("disabled", true);
        PopulateMasterDealData();
        $("#hdnDeal_Type_Code").val(selectedValue)
    }
    BindTitleLabel(true);
    $('.chosen-select:not(#ddlLicensor)').trigger("chosen:updated");

    BindTitleGridview();
}

function ddlOther_OnChange() {
    debugger;
    BindTopBand();
    var dealTypeCode = $("select[ID='ddlOther'] option:selected").val();
    $("#hdnDeal_Type_Code").val(dealTypeCode);
    if (dealTypeCode == Deal_Type_Music) {
        $("#ddlMaster_Deal_List").val("0");
        $("#ddlMaster_Deal_List").attr("disabled", true);
        PopulateMasterDealData();
    }
    else if (dealTypeCode == Deal_Type_Sports || dealTypeCode == Deal_Type_Format_Program || dealTypeCode == Deal_Type_Event
        || dealTypeCode == Deal_Type_Documentary_Show || dealTypeCode == Deal_Type_Documentary_Film ||
        dealTypeCode == Deal_Type_ContentMusic || dealTypeCode == Deal_Type_ShortFilm || dealTypeCode == Deal_Type_Webseries
        || dealTypeCode == Deal_Type_Featurette || dealTypeCode == Deal_Type_Cineplay || dealTypeCode == Deal_Type_Drama_Play || dealTypeCode == Deal_Type_Tele_Film) {
        $("#ddlMaster_Deal_List").val("0");
        $("#ddlMaster_Deal_List").attr("disabled", true);
        $("input[name=Is_Master_Deal][value='Y']").prop("checked", "checked");
        PopulateMasterDealData();
    }
    else {
        $("input[name=Is_Master_Deal][value='N']").prop("checked", "checked");
        $("#ddlMaster_Deal_List").attr("disabled", false);
    }
    BindTitleLabel(true);

    $('.chosen-select:not(#ddlLicensor)').trigger("chosen:updated");
    BindTitleGridview();
}

function AllowChosenRightClick() {
    $('#ddlLicensor_chosen li.search-choice').bind("contextmenu", function (e) {
        e.preventDefault();
        $('#ddlLicensor_chosen li.search-choice.primary').removeClass('primary');
        $(this).addClass('primary');

        BindContactDropDown();
    });
}

function btnAddTitle_OnClick() {
    $('#ddlTitle').SumoSelect();
    //  $('#ddlTitle').each(function () {

    //// });
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    if (Command_Name == "") {
        Command_Name = null;
    }
    if (Command_Name != null) {
        showAlert("E", ShowMessage.MsgForAddEdit);//MsgForAddEdit = Please complete add/edit operation.
        return false;
    }

    var rblIsMasterDeal = $("input[name='Is_Master_Deal']:radio:checked").val();
    var masterDealMovieCode = $("select[ID='ddlMaster_Deal_List'] option:selected").val();
    var dealTypeCode = GetDealTypeCode();

    var valid = BasicValidationForAddTitle()
    if (!valid)
        return false;

    valid = ValidatePageSize();
    if (!valid)
        return false;

    if (rblIsMasterDeal == "N" && dealTypeCode != Deal_Type_Music) {
        var masterDealText = $("select[ID='ddlMaster_Deal_List'] option:selected").text();
        var strNote = "( Rights will be copied from deal - {MASTER_DEAL_TEXT} )";
        strNote = strNote.replace("{MASTER_DEAL_TEXT}", masterDealText);
        $('#subDealNote').text(strNote)
    }
    else
        $('#subDealNote').text("");

    BindTitlePopup(masterDealMovieCode, dealTypeCode, 0, 'ddlTitle')

    $('#popAddDealMovie').modal();
    $('#ddlTitle')[0].sumo.reload();
}

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

function btnSearchTitle_Click() {
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    if (Command_Name == "") {
        Command_Name = null;
    }
    if (Command_Name != null) {
        showAlert("E", ShowMessage.MsgForAddEdit);//MsgForAddEdit = Please complete add/edit operation.
        return false;
    }

    if (!ValidatePageSize())
        return false;

    var arrSelectedTitles = $("#ddlTitle_Search_List").val();
    titleCodes = arrSelectedTitles.join(',');
    if (arrSelectedTitles != null)
        SearchTitle(titleCodes);
    else
        showAlert("E", ShowMessage.MsgForSelectTitle, 'ddlTitle_Search_List')//MsgForSelectTitle = Please select atleast one title
}

function chkUnlimited_OnClick(chk, txtID) {
    var txt = $('#' + txtID);
    if (chk.checked) {
        txt.attr('readonly', true).removeAttr("required").val("0").addClass("unlimitedMusic");
    }
    else {
        txt.attr({
            readonly: false,
            required: "required"
        }).val("").removeClass("unlimitedMusic");
    }
}

function Ask_Confirmation(confirmMsg, dummyGuid, rowIndex, commandName) {
    debugger
    if (!ValidatePageSize())
        return false;
    if (Command_Name == "") {
        Command_Name = null;
    }
    if (Command_Name != null) {
        showAlert("E", ShowMessage.MsgForAddEdit);//MsgForAddEdit = Please complete add/edit operation.
        return false;
    }

    Dummy_Guid = dummyGuid;
    Row_Index = rowIndex;
    Command_Name = commandName;
    if (commandName == "DELETE" || commandName == 'CLOSE_TITLE' || commandName == 'REPLACE_TITLE') {
        showAlert("I", confirmMsg, "OKCANCEL");
    }
}

function ChangeLabelName() {
    debugger;
    var lblLicensor = document.getElementById('lblLicensor');
    var roleCode = parseInt($("input[name='Role_Code']:radio:checked").val());

    if (roleCode == Role_Assignment)
        lblLicensor.innerHTML = ShowMessage.lblForAssignor;//lblForAssignor = Assignor

    else if (roleCode == Role_License)
        lblLicensor.innerHTML = ShowMessage.lblForLicensor;//lblForLicensor = Licensor

    else if (roleCode == Role_Own_Production)
        lblLicensor.innerHTML = ShowMessage.lblForProducerLineProducer;//lblForProducerLineProducer = Producer/ Line Producer

}

function ValidateEpisodeOverlapping() {
    debugger;
    if ($('#isAutoPush').val() == "N") {
        var returnVal = true;
        var emptyCount = 0;
        var errorMessage = "";
        var dealTypeCode = GetDealTypeCode();
        var dealTypeCondition = GetDealTypeCondition(dealTypeCode);

        var tblMovie = $("#tblMovie tr:not(:has(th),.deleted)");

        if (dealTypeCondition == Deal_Music) {
            tblMovie.each(function (rowId_Outer) {
                debugger;
                if (returnVal == false)
                    return false;

                var titleCode_outer = parseInt($(this).find("input[id*='hdnTitleCode']").val());
                var txtEpisodeTo = $(this).find("input[id*='txtEpisode_End_To'][type='text']");
                var episodeTo_Outer = parseInt(txtEpisodeTo.val());
                var txt = txtEpisodeTo[0];

                if (!isNaN(episodeTo_Outer)) {
                    tblMovie.each(function (rowId_Inner) {
                        var titleCode_inner = parseInt($(this).find("input[id*='hdnTitleCode']").val());
                        var chkUnlimited_inner = ($(this).find("input[id*='chkUnlimited_']"))[0].checked;
                        txtEpisodeTo = $(this).find("input[id*='txtEpisode_End_To'][type='text']");
                        var episodeTo_Inner = parseInt(txtEpisodeTo.val());
                        txt = txtEpisodeTo[0];

                        if (!isNaN(episodeTo_Inner)) {
                            var minEpisode_To = parseInt($(this).find("input[id*='hdnMininumEpisodeTo'][type='hidden']").val());

                            if (episodeTo_Inner == 0 && !chkUnlimited_inner) {
                                errorMessage = ShowMessage.NoofSongsGreaterZero//NoofSongsGreaterZero = No. of Songs must be greater than 0
                                returnVal = false;
                            }
                            else if (episodeTo_Inner < minEpisode_To && !chkUnlimited_inner) {
                                errorMessage = ShowMessage.NoofSongEqual + minEpisode_To;//NoofSongEqual = No. of Songs must be greater than equal to  
                                returnVal = false;
                            }
                            else if (episodeTo_Outer == episodeTo_Inner && titleCode_inner == titleCode_outer && rowId_Outer != rowId_Inner) {
                                errorMessage = Showmessage.MsgForDuplicate//MsgForDuplicate = No. of songs cannot be duplicate
                                returnVal = false;
                            }

                            if (!returnVal) {
                                emptyCount = 0;
                                $("[required='required']").removeAttr("required");
                                $('.required').removeClass('required');
                                showAlert("E", errorMessage, txt.id);
                                return false;
                            }
                        }
                        else {
                            $('#' + txt.id).attr('required', true)
                            emptyCount++;
                        }
                    });
                }
                else {
                    $('#' + txt.id).attr('required', true)
                    emptyCount++
                }
            });

            if (emptyCount > 0) {
                showAlert("E", ShowMessage.NoOfSongs);//NoOfSongs = Please enter No. of Songs
                returnVal = false;
            }

            return returnVal;
        }
        else if (dealTypeCondition == Deal_Program) {
            tblMovie.each(function (rowId_Outer) {

                if (returnVal == false)
                    return false;

                var txtEpisodeFrom_Outer = $(this).find("input[id*='txtEpisode_Starts_From'][type='text']");
                var txtEpisodeTo_Outer = $(this).find("input[id*='txtEpisode_End_To'][type='text']");
                var titleCode_outer = parseInt($(this).find("input[id*='hdnTitleCode']").val());
                var episodeFrom_Outer = parseInt(txtEpisodeFrom_Outer.val());
                var episodeTo_Outer = parseInt(txtEpisodeTo_Outer.val());

                if (!isNaN(episodeFrom_Outer) && !isNaN(episodeTo_Outer)) {

                    tblMovie.each(function (rowId_Inner) {
                        var txtEpisodeFrom_Inner = $(this).find("input[id*='txtEpisode_Starts_From'][type='text']");
                        var txtEpisodeTo_Inner = $(this).find("input[id*='txtEpisode_End_To'][type='text']");
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

                                errorMessage = ShowMessage.EpisodeNoComp;//EpisodeNoComp = Episode No. must be greater than 0
                                if (dealTypeCode == Deal_Type_Sports)
                                    errorMessage = ShowMessage.NoofMatchesgreater0;//NoofMatchesgreater0 = no. of Matches must be greater than 0

                                returnVal = false;
                            }
                            else if (episodeFrom_Inner > episodeTo_Inner) {
                                txtFrom = null;
                                txtTo = txtEpisodeTo_Inner[0];
                                if (dealTypeCode == Deal_Type_Sports)
                                    errorMessage = ShowMessage.MatchesFromTo//MatchesFromTo = Matches From cannot be greater than No. of Matches
                                else
                                    errorMessage = ShowMessage.EpisodeFromTo//EpisodeFromTo = Episode From cannot be greater than Episode To

                                returnVal = false;
                            }

                            var maxEpisode_From = parseInt($(this).find("input[id*='hdnMaximumEpisodeFrom'][type='hidden']").val());
                            var minEpisode_To = parseInt($(this).find("input[id*='hdnMininumEpisodeTo'][type='hidden']").val());

                            if (!isNaN(maxEpisode_From) && !isNaN(minEpisode_To) && returnVal) {
                                if (episodeFrom_Inner > maxEpisode_From && maxEpisode_From > 0) {
                                    txtFrom = txtEpisodeFrom_Inner[0];
                                    txtTo = null;
                                    errorMessage = ShowMessage.MsgForEpisodeNo + maxEpisode_From;//MsgForEpisodeNo = Episode No. cannot be greater than
                                    returnVal = false;
                                }

                                if (episodeTo_Inner < minEpisode_To && minEpisode_To > 0 && returnVal) {
                                    if (dealTypeCode == Deal_Type_Sports)
                                        errorMessage = ShowMessage.NoofMatchesComp + minEpisode_To;//NoofMatchesComp = No. of Matches cannot be less than
                                    else
                                        errorMessage = ShowMessage.NoOfEpisodeComp + minEpisode_To;//NoOfEpisodeComp = Episode No. cannot be less than

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
                                        errorMessage = ShowMessage.MsgoverlappEpisode;//MsgoverlappEpisode = Overlapping Episode No.
                                        if (dealTypeCode == Deal_Type_Sports)
                                            errorMessage = ShowMessage.MsgoverlappMatches;//MsgoverlappMatches = Overlapping No. of Matches
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
                errorMessage = ShowMessage.NoOfEpisode//NoOfEpisode = Please enter Episode no.
                if (dealTypeCode == Deal_Type_Sports)
                    errorMessage = ShowMessage.NoOfMatches//NoOfMatches = Please enter No. of Matches
                else if (dealTypeCode == Deal_Type_Music || dealTypeCode == Deal_Type_ContentMusic)
                    errorMessage = ShowMessage.NoOfSongs//NoOfSongs = Please enter No. of Songs

                showAlert("E", errorMessage);
                returnVal = false;
            }

            return returnVal;
        }
        else if (dealTypeCondition == Sub_Deal_Talent) {
            var length = $(this).find("input[id*='txtNo_Of_Episodes'][type='text']").length;
            // Note : Here i m checking length because, if our master deal's 'Deal For' is Movie so we dont show 'No of Appearances' column
            if (length > 0) {
                tblMovie.each(function (rowId_Inner) {

                    if (returnVal == false)
                        return false;

                    var txtNo_Of_Episodes = $(this).find("input[id*='txtNo_Of_Episodes'][type='text']");
                    var txt = txtNo_Of_Episodes[0];
                    var no_Of_Episodes = parseInt(txtNo_Of_Episodes.val());

                    if (!isNaN(no_Of_Episodes)) {
                        if (no_Of_Episodes == 0) {
                            showAlert("E", ShowMessage.MsgAppearanceComp, txt.id);//MsgAppearanceComp = No. of Appearances must be greater than 0
                            returnVal = false;
                            return false;
                        }
                    }
                    else {
                        $('#' + txt.id).attr('required', true)
                        emptyCount++
                    }
                });
                if (emptyCount > 0) {
                    showAlert("E", ShowMessage.NoOfAppearance);//NoOfAppearance = Please enter No. of Appearances
                    returnVal = false;
                }
            }
            return returnVal;
        }
        else
            return true;
    }
    else
        return true;
}

function CancelSaveDeal() {
    Command_Name = "CANCEL_SAVE_DEAL";
    showAlert("I", ShowMessage.MsgForunsavedData, "OKCANCEL");//MsgForunsavedData = All unsaved data will be lost, still want to go ahead?
}

function BindTitleGridview() {
    var pageNo = $('#hdnPageNo').val();
    var dealTypeCode = GetDealTypeCode();
    var masterDealMovieCode = $("select[ID='ddlMaster_Deal_List'] option:selected").val();
    if (masterDealMovieCode == undefined)
        masterDealMovieCode = 0;
    var recordPerPage = $('#txtPageSize').val();
    $.ajax({
        type: "POST",
        url: URL_BindTitleGridview,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            dealTypeCode: dealTypeCode,
            masterDealMovieCode: masterDealMovieCode,
            pageNo: pageNo,
            recordPerPage: recordPerPage
        }),
        async: false,
        success: function (result) {

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

function BindTopBand() {
    var dealTypeCode = GetDealTypeCode();
    var dealDesc = $('#txtDeal_Desc').val();
    var agreementDate = $('#txtAgreement_Date').val();
    var dealTagCode = $('#ddlDeal_Tag').val();
    var prevTitleCode = $("#hdnDeal_Type_Code").val()
    if (dealTypeCode == Deal_Type_Sports || prevTitleCode == Deal_Type_Sports) {
        $.ajax({
            type: "POST",
            url: URL_BindTopBand,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                dealTypeCode: dealTypeCode,
                dealDesc: dealDesc,
                agreementDate: agreementDate,
                dealTagCode: dealTagCode,
                IsAmort: isAmort
            }),
            async: false,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    $('#divTopBand').empty();
                    $('#divTopBand').html(result);
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
}

function PopulateMasterDealData() {
    var currentADMCode = $("select[ID='ddlMaster_Deal_List'] option:selected").val();
    var previousADMCode = $('#hdnPreviousADMCode').val();

    if (previousADMCode > 0 || currentADMCode > 0) {
        $.ajax({
            type: "POST",
            url: URL_PopulateMasterDealData,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                currentADMCode: currentADMCode,
                priviousADMCode: previousADMCode
            }),
            async: false,
            success: function (result) {

                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    // Please do not change order
                    $("#ddlCurrency").val(result.Currency_Code);
                    $("#ddlLicensee").val(result.Entity_Code);
                    $("#ddlBusinessUnit").val(result.Business_Unit_Code);
                    $("#ddlCategory").val(result.Category_Code);
                    $("#ddlLicensor").val(result.Vendor_Code);
                    $('#hdnVendorCodes').val(result.Selected_Vendor_Codes);

                    var vendorCodes = result.Selected_Vendor_Codes
                    $("select#ddlLicensor.form_input.chosen-select").val(vendorCodes.split(',')).trigger("chosen:updated");
                    setPrimaryLicensor(result.Vendor_Code);
                    AllowChosenRightClick();
                    BindContactDropDown();
                    $("#ddlContact").val(result.Vendor_Contact_Code);
                    $('.chosen-select:not(#ddlLicensor)').trigger("chosen:updated");
                    ddlContact_OnChange();
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }

    $('#hdnPreviousADMCode').val(currentADMCode);
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

function BindContactDropDown() {
    var cpvc = getPrimaryLicensor();
    var ppvc = $('#hdnPrimaryVendorCode').val();
    if (cpvc != ppvc) {
        $('#hdnPrimaryVendorCode').val(cpvc);
        $.ajax({
            type: "POST",
            url: URL_BindContactDropDown,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                vendorCode: cpvc
            }),
            async: false,
            success: function (result) {

                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    $("#lblPhone").text('');
                    $("#lblEmail").text('');
                    $("#ddlContact").empty();
                    $.each(result, function () {
                        $("#ddlContact").append($("<option />").val(this.Value).text(this.Text));
                    });
                    $("#ddlContact").trigger("chosen:updated");
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
}

function ddlContact_OnChange() {
    var vendorContactCode = $("select[ID='ddlContact'] option:selected").val();
    $.ajax({
        type: "POST",
        url: URL_BindPrimaryContactDetail,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            vendorContactCode: vendorContactCode
        }),
        async: false,
        success: function (result) {
            $("#lblPhone").text(result.Vendor_Phone);
            $("#lblEmail").text(result.Vendor_Email);
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}

function BindTitlePopup(masterDealMovieCode, dealTypeCode, replacingTitleCode, ddl_ID) {
    $.ajax({
        type: "POST",
        url: URL_BindTitlePopup,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            MasterDealMovieCode: masterDealMovieCode,
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
                $("#" + ddl_ID).trigger("chosen:updated");
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
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

function btnSaveTitle_OnClick() {
    debugger;
    var arrTitleCodes = $("#ddlTitle").val();
    $("#divTitle").removeClass("required");
    if (arrTitleCodes != null) {
        showLoading();
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
                        hideLoading();
                    }
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
    else {
        $("#divTitle").addClass("required");
        showAlert("E", ShowMessage.MsgForSelectTitle, 'ddlTitle')//MsgForSelectTitle = Please select atleast one title
    }
}

function Close_Title(confirmationDone) {

    if (!ValidatePageSize())
        return false;

    var status = "E"
    $.ajax({
        type: "POST",
        url: URL_Close_Title,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            acqDealMovieCode: Acq_Deal_Movie_Code,
            notes: Notes,
            titleType: Title_Type,
            closingDate: $.trim(Movie_Closed_Date),//$.trim(txtMovie_Closed_Date.val()),
            closingRemark: $.trim(Closing_Remarks),//$.trim(txtClosing_Remarks.val()),
            episodeFrom: episode_From,
            episodeTo: episode_To,
            noOfEpisodes: no_Of_Episodes,
            confirmationDone: confirmationDone
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.Status == "S") {
                    status = "S";
                    SetNull();
                }
                else if (result.Status == "E") {
                    if (result.Show_Confirmation == "Y")
                        showAlert("I", result.Error_Message, "OKCANCEL");
                    else {
                        showAlert("E", result.Error_Message);
                        status = "E";
                    }
                }
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });

    if (status == "S") {
        if (!SaveTitleListData(false))
            return false;

        BindTitleGridview();
    }
    if (status == "E")
        return false;
}

function SaveTitleListData(validateOverlapping) {
    debugger;
    var titleList = new Array();
    var tblMovie = $("#tblMovie tr:not(:has(th))");

    var returnVal = true;

    if (validateOverlapping) { returnVal = ValidateEpisodeOverlapping(); }   

    if (returnVal) {
        var dealTypeCode = GetDealTypeCode();
        var dealCondition = GetDealTypeCondition(dealTypeCode);
        var i = 0;

        tblMovie.each(function () {
            if ($(this).attr('class') != 'deleted') {
                var _titleCode = 0, _dummyGuid = "", _notes = "", _episode_from = 1, _episode_to = 1, _no_of_episode = 1, _title_type = "", _due_diligence = "";

                _titleCode = parseInt($("#hdnTitleCode_" + i).val());
                _dummyGuid = $("#hdnDummyGuid_" + i).val();
                _title_type = $("input[name='Acq_Deal_Movie[" + i + "].Title_Type']:radio:checked").val();
                _notes = $('#txtNotes_' + i).val();
                _due_diligence = $("input[name='Acq_Deal_Movie[" + i + "].Due_Diligence']:radio:checked").val();

                if (dealCondition == Deal_Music)
                    _episode_to = _episode_from = parseInt($('#txtEpisode_End_To_' + i).val());
                else if (dealCondition == Deal_Program) {
                    _episode_from = parseInt($('#txtEpisode_Starts_From_' + i).val());
                    _episode_to = parseInt($('#txtEpisode_End_To_' + i).val());
                    if (dealTypeCode == Deal_Type_Sports)
                        _episode_from = 1;
                }
                else if (dealCondition == Sub_Deal_Talent)
                    _no_of_episode = parseInt($('#txtNo_Of_Episodes_' + i).val());

                titleList.push({
                    Title_Code: _titleCode, _Dummy_Guid: _dummyGuid, Notes: _notes, Episode_Starts_From: _episode_from,
                    Episode_End_To: _episode_to, No_Of_Episodes: _no_of_episode, Title_Type: _title_type, Due_Diligence: _due_diligence
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

function tblMovie_RowCommand(dummyGuid, rowIndex, commandName) {   
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");

    if (!ValidatePageSize())
        return false;

    Dummy_Guid = dummyGuid;
    Row_Index = rowIndex;
    Command_Name = commandName;
    txtMovie_Closed_Date = $('#txtMovie_Closed_Date_' + rowIndex);
    txtClosing_Remarks = $('#txtClosing_Remarks_' + rowIndex);
    var lblMovie_Closed_Date = $('#lblMovie_Closed_Date_' + rowIndex);
    var lblClosing_Remarks = $('#lblClosing_Remarks_' + rowIndex);
    var divClosing_Remarks = $('#divClosing_Remarks_' + rowIndex);

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


    Movie_Closed_Date = (txtMovie_Closed_Date != null && txtMovie_Closed_Date != 'undefined') ? txtMovie_Closed_Date.val() : '';
    Closing_Remarks = (txtClosing_Remarks != null && txtClosing_Remarks != 'undefined') ? txtClosing_Remarks.val() : '';

    var OldClosedDate = $.trim($("#" + rowIndex + "_hdnTitleClosedDate").val());

    Acq_Deal_Movie_Code = $('#hdnAcq_Deal_Movie_Code_' + rowIndex).val();
    Title_Type = $("input[name='Acq_Deal_Movie[" + rowIndex + "].Title_Type']:radio:checked").val();
    Notes = $('#txtNotes_' + rowIndex).val();

    var dealTypeCode = GetDealTypeCode();
    var dealCondition = GetDealTypeCondition(dealTypeCode);
    episode_From = 1, episode_To = 1, no_Of_Episodes = 1;
    if (dealCondition == Deal_Music)
        episode_To = episode_From = parseInt($('#txtEpisode_End_To_' + rowIndex).val());
    else if (dealCondition == Deal_Program) {
        episode_From = parseInt($('#txtEpisode_Starts_From_' + rowIndex).val());
        episode_To = parseInt($('#txtEpisode_End_To_' + rowIndex).val());
        if (dealTypeCode == Deal_Type_Sports)
            episode_From = 1;
    }
    else if (dealCondition == Sub_Deal_Talent) {
        txtNo_Of_Episodes = $('#txtNo_Of_Episodes_' + rowIndex);
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
                acqDealMovieCode: Acq_Deal_Movie_Code,
                searchCodes: ''
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
                $("select#ddlTitle_Search_List.form_input.chosen-select").val(searchSelectedCodes).trigger("chosen:updated");
            }
        }
    }
    else if (commandName == 'CLOSE_TITLE') {
        lblMovie_Closed_Date.hide();
        divClosing_Remarks.hide();
        txtMovie_Closed_Date.show();
        txtClosing_Remarks.show();

        btnDelete.hide();
        btnCloseTitle.hide();
        btnSave.show();
        btnCancel.show();
    }
    else if (commandName == 'SAVE_CLOSED_TITLE') {
        var returnVal = ValidateEpisodeOverlapping();
        if (!returnVal)
            return false;

        if (txtMovie_Closed_Date.val() == "") {
            txtMovie_Closed_Date.attr('required', true)
            return false;
        }
        else {
            Command_Name = 'SAVE_CLOSED_TITLE';
            if (!Close_Title("N"))
                txtMovie_Closed_Date.val(OldClosedDate);
        }
    }
    else if (commandName == 'CANCEL_CLOSE_TITLE') {
        lblMovie_Closed_Date.show();
        divClosing_Remarks.show();
        txtMovie_Closed_Date.hide();
        txtClosing_Remarks.hide();

        btnDelete.show();
        btnCloseTitle.show();
        btnSave.hide();
        btnCancel.hide();

        SetNull();
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
        BindTitlePopup(masterDealMovieCode, dealTypeCode, tc, ddlTitle[0].id)
      
        initializeChosen();
        ddlTitle.val(hdnTitleCode.val());
        ddlTitle.trigger("chosen:updated");        

    }
    else if (commandName == 'SAVE_REPLACE_TITLE') {
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
                notes: Notes,
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
                      
                        divTitle.hide();
                      lblTitleName.show();

                        lblTitleName.text(result.Title_Name)
                        lblTitleLangName.text(result.Title_Language_Name)
                        lblStarCast.text(result.Star_Cast)
                        lblDuration.text(result.Duration_In_Min)

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
    else if (commandName == 'CANCEL_REPLACE_TITLE') {
      
        divTitle.hide();
        
        lblTitleName.show();

        btnDelete.show();
        btnReplace.show();
        btnSave.hide();
        btnCancel.hide();

        SetNull();
    }
}

function handleOk() {
    if (Command_Name == "SAVE_CLOSED_TITLE")
        Close_Title("Y");
    else if (Command_Name == "DELETE" || Command_Name == "CLOSE_TITLE" || Command_Name == "REPLACE_TITLE")
        tblMovie_RowCommand(Dummy_Guid, Row_Index, Command_Name);
    else if (Command_Name == "REDIRECT_PAGE") {
        debugger
        window.location.href = Redirect_URL;
    }
    else if (Command_Name == 'CANCEL_SAVE_DEAL') {
        location.href = URL_Cancel;
    }
}
function handleCancel() {
    SetNull();
}
function ValidateSave() {
    if (!ValidatePageSize())
        return false;

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
    if (Command_Name == "") {
        Command_Name = null;
    }
    if (Command_Name != null) {
        showAlert("E", ShowMessage.MsgForAddEdit);//MsgForAddEdit = Please complete add/edit operation.
        return false;
    }

    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");

    if (!RequiredFieldValidation())
        return false;

    if (!ValidateEpisodeOverlapping())
        return false;
    
    $('input[name=hdnIs_Master_Deal]').val($("input[name='Is_Master_Deal']:radio:checked").val());
    $('input[name=hdnMaster_Deal_Movie_Code]').val($("select[ID='ddlMaster_Deal_List'] option:selected").val());
    $('input[name=hdnDeal_Type_Code]').val(GetDealTypeCode());
    var vendorCodes = $("#ddlLicensor").val();
    $('input[name=hdnVendorCodes]').val(vendorCodes.join(','));
    $('input[name=hdnAgreementDate]').val($("input[ID='txtAgreement_Date']").val());
    $('input[name=hdnDealDesc]').val($("input[ID='txtDeal_Desc']").val());
    $('input[name=hdnDealTagStatusCode]').val($("select[ID='ddlDeal_Tag'] option:selected").val());

    showLoading();
    return true;
}
function Save_Success(result) {
    if (result == "true") {
        redirectToLogin();
    }
    else {
        status = result.Status;
        if (result.Status == "S" || result.Status == "SA") {
            if (result.Status == "SA") {
                $.ajax({
                    type: "POST",
                    url: URL_Approve_Reject_Reopen,
                    traditional: true,
                    enctype: 'multipart/form-data',
                    contentType: "application/json; charset=utf-8",
                    data: JSON.stringify({
                        user_Action: 'A',
                        approvalremarks: ''//$('#txtRemark').val()
                    }),
                    async: false,
                    success: function (data) { }
                });
            }

            if (result.Success_Message != "") {
                // When we clicked on Save, now move to deal list page 
                Command_Name = "REDIRECT_PAGE"
                Redirect_URL = result.Redirect_URL;
                RedirectTab = result.TabName;
                showAlert("S", result.Success_Message, "OK");
            }
            else {
                // When we clicked on Tab, now move to another tab
                BindPartialTabs(result.TabName);
                BindTopAcqDetails();
                //window.location.href = result.Redirect_URL;
            }
        }
        else if (result.Status == undefined) {
            Command_Name = null;
            Redirect_URL = null;
            RedirectTab = null;
            window.location.href = URL_Login_Index;
        } else if (result.Status == "E") {
            Command_Name = null;
            Redirect_URL = null;
            RedirectTab = null;
            $('#hdnTabName').val("");

            if (result.Error_Message != "")
                showAlert("E", result.Error_Message);

            if (result.Error_Page_Index > 0) {
                $('#hdnPageNo').val(result.Error_Page_Index);
                $('#hdnRecordCount').val(result.Total_Record_Count);
                $("#ddlTitle_Search_List").val('').trigger("chosen:updated");
                BindTitleGridview();
                SetPaging()
                ValidateEpisodeOverlapping()
            }
        }
    }
    hideLoading();
    return false;
}
function BindAllPreReq_Async() {
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
                $.each(result.Category_List, function () {
                    $("#ddlCategory").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlCategory").val(result.Category_Code);

                $.each(result.Licensee_List, function () {
                    $("#ddlLicensee").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlLicensee").val(result.Entity_Code);

                $.each(result.Business_Unit_List, function () {
                    $("#ddlBusinessUnit").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlBusinessUnit").val(result.Business_Unit_Code);

                $.each(result.Currency_List, function () {
                    $("#ddlCurrency").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlCurrency").val(result.Currency_Code);

                $.each(result.Licensor_List, function () {
                    $("#ddlLicensor").append($("<option />").val(this.Value).text(this.Text));
                });

                if (vendorCode > 0)
                    $("input[name=hdnPrimaryVendorCode]").val(vendorCode);

                if (vendorCodes != '')
                    $("select#ddlLicensor.form_input.chosen-select").val(vendorCodes.split(','))

                $.each(result.Master_Deal_List, function () {
                    $("#ddlMaster_Deal_List").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlMaster_Deal_List").val(result.Master_Deal_Movie_Code);

                $.each(result.Vendor_Contact_List, function () {
                    $("#ddlContact").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#ddlContact").val(result.Vendor_Contact_Code);

                $("#ddlCategory,#ddlLicensee,#ddlBusinessUnit,#ddlCurrency,#ddlContact").trigger("chosen:updated");
                $('#ddlLicensor').chosen().trigger("chosen:updated");
                $('#ddlLicensor').on('change', function (evt, params) {
                    AllowChosenRightClick();
                });
                AllowChosenRightClick();
                setPrimaryLicensor(vendorCode);
                $("#ddlMaster_Deal_List").trigger("chosen:updated");

                $('#btnAddTitle').removeAttr("disabled");
                BindTitleGridview();

                BindTitleLabel(true);
                $("select#ddlTitle_Search_List.form_input.chosen-select").val(generalSearchTitleCodes.split(',')).trigger("chosen:updated");
                addNumeric();

                hideLoading();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}

