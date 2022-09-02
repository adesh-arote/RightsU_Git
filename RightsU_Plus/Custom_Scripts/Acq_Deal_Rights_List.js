$(document).ready(function () {
    $('#txtPageSize').numeric({
        max: 100,
        min: 1

    });

    if (recordLockingCode_G > 0)
        Call_RefreshRecordReleaseTime(recordLockingCode_G, URL_Global_Refresh_Lock);

    var txtAcqRemarks = document.getElementById('txtAcqRemarks');
    if (txtAcqRemarks != null)
        countChar(txtAcqRemarks);

    //$("#btnShowAll").click(function () {
    //    if (ValidatePageSize()) {
    //        $("#ddlTitleCode").find("option").attr("selected", false);
    //        $("#ddlTitleCode")[0].sumo.reload();
    //        $("#ddlRegionn").find("option").attr("selected", false);
    //        $("#ddlRegionn")[0].sumo.reload();
    //        $('#lstReleaseUnit').val('B').trigger("chosen:updated");
    //        $('#hdnTVCode').val('')
    //        $("#G").prop("checked", true);
    //        ClearTitleValues();
    //        document.getElementById('TotalselectedPlatform').innerHTML = parseInt(0)
    //        $('.sumo_Region > .optWrapper.multiple > .options li ul li.opt').removeClass('selected')
    //        BindRegionList();
    //        BindGridNew($("#G")[0], 'N','Y');
    //    }
    //});

    $("#ddlTitleCode").change(function () {
        SelectedTitles = $(this).val();
    });

    BindGrid(null);
    initializeExpander();
});
function ValidatePageSize() {
    var recordPerPage = $('#txtPageSize').val();
    if ($.trim(recordPerPage) != '') {
        var pageSize = parseInt(recordPerPage);
        if (pageSize > 0)
            return true;
    }
    //$('#txtPageSize').addClass("required");
    return false;
}
function pageBinding() {
    BindGridNew($("#G")[0], 'Y');
}

function ClearTitleValues() {
    $("#ddlTitleCode").find("option").attr("selected", false);
    $("#ddlTitleCode")[0].sumo.reload();
}
function BindGrid(obj) {
    debugger;
    showLoading();
    var ViewType = "";
    var regionCode = "";
    var exclusiveRights = "";
    if ($('#ddlRegionn').val() == null)
        regionCode = "";
    else
        regionCode = $('#ddlRegionn').val();

    exclusiveRights = $('#lstReleaseUnit').val();
    var platformcode = $('#hdnTVCode').val();
    var Rights_PageNo = 0;
    var TitleCode = '';
    var page_index = 0;
    if (obj == null) {
        ViewType = "G";
        if (rightsView_G != null) {
            $('#' + rightsView_G)[0].checked = true;
            ViewType = rightsView_G;
        }
        if (rightsTitles_G != null && rightsTitles_G != '')
            TitleCode = rightsTitles_G;
        if (rightsExclusive_G != null && rightsExclusive_G != '')
            exclusiveRights = rightsExclusive_G;
        if (rightsPageSize_G != null && rightsPageSize_G != '0')
            $('#txtPageSize').val(rightsPageSize_G);
        if (rightsPageNo_G != null && rightsPageNo_G != '0')
            page_index = parseInt(rightsPageNo_G) - 1;
    }
    else
        ViewType = $('input[name=optViewType]:checked').val();


    if ($("#ddlTitleCode").val() != null)
        TitleCode = $("#ddlTitleCode").val().join(',');
    if ($("#ddlRegionn").val() != null)
        regionCode = $("#ddlRegionn").val().join(',');

    if ($('#hdnCurrentPageNo').val() != undefined && $('#hdnCurrentPageNo').val() != '')
        Rights_PageNo = $('#hdnCurrentPageNo').val();

    var page_Index = parseInt(Rights_PageNo) - 1;

    if (obj == null) {
        var txtpageSize = $("#txtPageSize").val();
        $.ajax({
            type: "POST",
            url: URL_BindGrid,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            async: true,
            data: JSON.stringify({
                Selected_Title_Code: TitleCode,
                view_Type: ViewType,
                txtpageSize: txtpageSize,
                page_index: page_index,
                IsCallFromPaging: 'N',
                RegionCode: regionCode,
                PlatformCode: platformcode,
                ExclusiveRight: exclusiveRights,

            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                $('.div_BindGrid').html(result);
                SetPaging($('#txtPageSize').val());
                setNumericForPagingSize();
                initializeExpander();
                CheckRightStatus();
                hideLoading();
            },
            error: function (result) {
            }
        });
    }
}
function BindGridNew(obj, IsCallFromPaging, ShowAll) {
    debugger;
    showLoading();
    var regionCode = "";
    var exclusiveRights = "";
    var ViewType = "";
    var TitleCode = "";
    var isValid = true;
    if ($('#ddlRegionn').val() == null)
        regionCode = "";
    else
        regionCode = $('#ddlRegionn').val().join(',');

    exclusiveRights = $('#lstReleaseUnit').val();
    var platformcode = $('#hdnTVCode').val();
    if (ShowAll == "N") {
        if ($("#ddlTitleCode").val() == null && $('#ddlRegionn').val() == null && $('#hdnTVCode').val() == "" && $('#lstReleaseUnit').val() == "B") {
            //MsgForSearch = Please select at least one criteria to view.
            showAlert('E', ShowMessage.MsgForSearch, "ddlTitleCode");
            hideLoading();
            isValid = false;
        }
    }
    $('#divddlTitleCode').removeClass("required");
    if (isValid) {
        if (ValidatePageSize()) {
            if ($("#ddlTitleCode").val() != undefined && $("#ddlTitleCode").val() != null)
                TitleCode = $("#ddlTitleCode").val().join(',');
            else
                TitleCode = "";
            if (obj == null)
                ViewType = "G";
            else
                ViewType = $('input[name=optViewType]:checked').val();
            //if (ViewType != "G") {
            //    if (TitleCode != '')
            //        TitleCode = $("#ddlTitleCode").val().join(',');
            //    else {
            //        debugger;
            //        showAlert('info', 'Please select atleast one title to view', "ddlTitleCode");
            //        $('#divddlTitleCode').addClass("required");
            //        hideLoading();
            //        $("#G").prop("checked", true);
            //        return;
            //    }
            //}

            //if (ViewType == 'G') {
            //    ClearTitleValues();
            //    TitleCode = '';
            //}
            var Rights_PageNo = 1;
            var page_Index = 0;
            //if ($("#ddlTitleCode").val() != null && ViewType != 'G')
            //    TitleCode = $("#ddlTitleCode").val().join(',');
            if ($('#hdnCurrentPageNo').val() != undefined && $('#hdnCurrentPageNo').val() != '')
                Rights_PageNo = $('#hdnCurrentPageNo').val();
            page_Index = parseInt(Rights_PageNo) - 1;
            var txtpageSize = $("#txtPageSize").val();
            $.ajax({
                type: "POST",
                url: URL_BindGrid,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    Selected_Title_Code: TitleCode,
                    view_Type: ViewType,
                    txtpageSize: txtpageSize,
                    page_index: page_Index,
                    IsCallFromPaging: IsCallFromPaging,
                    RegionCode: regionCode,
                    PlatformCode: platformcode,
                    ExclusiveRight: exclusiveRights
                }),
                success: function (result) {
                    if (result == "true") {
                        redirectToLogin();
                    }
                    $('.div_BindGrid').html(result);
                    SetPaging($('#txtPageSize').val());
                    initializeExpander();
                    CheckRightStatus();
                    hideLoading();
                },
                error: function (result) {
                    hideLoading();
                }
            });
        }
    }
    else {
        if (rightsView_G != null)
            $('#' + rightsView_G)[0].checked = true;
    }
}
function ClearHidden() {
    if (!clickedOnTab) {
        $("#hdnTabName").val('');
    }
}
function DeleteRight(obj) {
    showLoading();
    var TitleCode = $("#" + obj + "_hdnTitleCode").val();
    var PlatformCode = $("#" + obj + "_hdnPlatformCode").val();
    var EpisodeFrom = $("#" + obj + "_hdnEpisodeFrom").val();
    var EpisodeTo = $("#" + obj + "_hdnEpisodeTo").val();
    var RightCode = $("#" + obj + "_hdnRightCode").val();
    var DealCode = $("#" + obj + "_hdnDealCode").val();
    var ViewType = $('input[name=optViewType]:checked').val();
    var hdnIsDelete = $("#" + obj + "_hdnIsDelete").val();
    var hdnIs_Syn_Acq_Mapp = $("#" + obj + "_hdnIs_Syn_Acq_Mapp").val();
    if (hdnIs_Syn_Acq_Mapp == "Y") {
        //MsgForDeleteSyndRcd = Cannot delete right as it is already syndicated.
        showAlert('error', ShowMessage.MsgForDeleteSyndRcd);
        hideLoading();
    }
    else {
        $.ajax({
            type: "POST",
            url: URL_DeleteRight,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                RightCode: RightCode,
                DealCode: DealCode,
                TitleCode: TitleCode,
                PlatformCode: PlatformCode,
                EpisodeFrom: EpisodeFrom,
                EpisodeTo: EpisodeTo,
                ViewType: ViewType
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                showAlert('info', result);
                BindGridNew($("#G")[0], 'N', 'Y');
                BindRightsFilterData();
                hideLoading();
            },
            error: function (result) {
                alert('Error occured while calling DeleteRight');
                hideLoading();
            }
        });
    }
}
function ValidateDelete(obj) {
    if (ValidatePageSize()) {
        $('#hdnCurrentID').val(obj);
        $('#hdn_Command_Name').val('DELETE');
        //MsgForDeleteRgt = Are you sure you want to delete this right
        showAlert('I', ShowMessage.MsgForDeleteRgt, 'OKCANCEL');
    }
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
function CancelSaveDeal() {
    $('#hdn_Command_Name').val('CANCEL_SAVE_DEAL');
    //MsgForunsavedData = All unsaved data will be lost, still want to go ahead
    showAlert("I", ShowMessage.MsgForunsavedData, "OKCANCEL");
}
function handleCancel() {

}
function handleOk() {
    if (MessageFrom == 'SV') {
        if ($('#hdnTabName').val() == '') {
            $('#hdn_Command_Name').val('');
            window.location.href = URL_Acq_List_Index;
        }
    }
    if ($('#hdn_Command_Name').val() != undefined && $('#hdn_Command_Name').val() != '' && $('#hdn_Command_Name').val() == "CANCEL_SAVE_DEAL") {
        location.href = URL_Cancel;
    }
    else if ($('#hdn_Command_Name').val() != undefined && $('#hdn_Command_Name').val() != '' && $('#hdn_Command_Name').val() == "DELETE") {
        var obj = $('#hdnCurrentID').val();
        DeleteRight(obj);
    }
}
function ValidateSave() {
    showLoading();
    var Isvalid = true;
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
    if (ValidatePageSize()) {
        // Code for Maintaining approval remarks in session
        if (SaveApprovalRemarks())
            Isvalid = true
        else
            Isvalid = false;
    }

    if (Isvalid) {
        if (dealMode_G == dealMode_View || dealMode_G == dealMode_Approve || dealMode_G == dealMode_EditWOA) {
            hideLoading();
            var tabName = $('#hdnTabName').val();
            BindPartialTabs(tabName);
        }
    }
    //Code end for approval
    return Isvalid;
}
function Save_Success(message) {
    hideLoading();
    if (message == "true") {
        redirectToLogin();
    }
    else {
        if (message.Success_Message != "") {
            MessageFrom = "SV"
            showAlert('S', message.Success_Message, 'OK');
        }
        else {
            $('#hdn_Command_Name').val('');
            var tabName = $('#hdnTabName').val();
            BindPartialTabs(tabName);
        }
    }

    if (message.Status == "SA") {
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
}
function ButtonEvents(mode, rCode, tCode, episodeFrom, episodeTo, pCode, isHB, isSynAcqMapp) {
    debugger;
    $.ajax({
        //    $('#lbTerritory,#lbSub_Language,#lbDub_Language').SumoSelect({ selectAll: true, triggerChangeCombined: false });
        //$('#lbTerritory,#lbSub_Language,#lbDub_Language')[0].sumo.reload();
        type: "POST",
        url: URL_ButtonEvents,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            MODE: mode,
            RCode: rCode,
            TCode: tCode,
            Episode_From: episodeFrom,
            Episode_To: episodeTo,
            PCode: pCode,
            IsHB: isHB,
            Is_Syn_Acq_Mapp: isSynAcqMapp
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                BindPartialTabs(result.TabName);

            }
        },
        error: function (result) {
            alert('Error_ADESH: ' + result.responseText);
        }
    });
}

function CheckRightStatus() {
    var pendingRecord = 0;
    $(".clsTdAction").each(function () {
        var refCloseTitle = $(this).find("input[id*='hdnRefCloseTitle']").val();
        if (refCloseTitle != 'Y') {
            var rightStatus = $(this).find("input[id*='hdnRightStatus']").val();
            if (rightStatus == "P" || rightStatus == 'E') {
                var rightCode = $(this).find("input[id*='hdnRightCode']").val();
                if (isNaN(rightCode))
                    rightCode = 0;

                if (rightCode > 0) {

                    var btnEdit = $(this).find("a[id*='btnEdit']");
                    var btnDelete = $(this).find("a[id*='btnDelete']");
                    var btnClone = $(this).find("a[id*='btnClone']");
                    var btnShowError = $(this).find("a[id*='btnShowError']");
                    var btnReprocess = $(this).find("a[id*='btnReprocess']");
                    var imgLoading = $(this).find("img[id*='imgLoading']");

                    $.ajax({
                        type: "POST",
                        url: URL_GetSynRightStatus,
                        traditional: true,
                        enctype: 'multipart/form-data',
                        contentType: "application/json; charset=utf-8",
                        async: false,
                        data: JSON.stringify({
                            rightCode: rightCode
                        }),
                        success: function (result) {
                            debugger;
                            if (result == "true") {
                                redirectToLogin();
                            }
                            if (result.RecordStatus == "E") {
                                // Error
                                btnEdit[0].style.display = '';
                                btnDelete[0].style.display = '';
                                btnClone[0].style.display = 'none';
                                btnShowError[0].style.display = '';
                                btnReprocess[0].style.display = '';
                                imgLoading[0].style.display = "none";
                                $(this).find("input[id*='hdnRightStatus']").val("E");

                            }
                            else if (result.RecordStatus == "D") {
                                // Completed
                                btnEdit[0].style.display = '';
                                btnDelete[0].style.display = '';
                                btnClone[0].style.display = '';
                                btnShowError[0].style.display = 'none';
                                btnReprocess[0].style.display = 'none';
                                imgLoading[0].style.display = "none";
                                $(this).find("input[id*='hdnRightStatus']").val("C");
                            }
                            else if (result.RecordStatus == "P" || result.RecordStatus == "W") {
                                // Processing
                                btnEdit[0].style.display = 'none';
                                btnDelete[0].style.display = 'none';
                                btnClone[0].style.display = 'none';
                                btnShowError[0].style.display = 'none';
                                btnReprocess[0].style.display = 'none';
                                imgLoading[0].style.display = '';
                                $(this).find("input[id*='hdnRightStatus']").val("P");
                                pendingRecord++;
                            }
                        },
                        error: function (result) {
                        }
                    });
                }
            }
        }
    });
    //if (pendingRecord > 0) {
    setTimeout(CheckRightStatus, 5000);
    //}

}

function Show_Validation_Popup(search_Titles, Page_Size, Page_No, IsFirst, RightCode) {
    debugger;
    var selectedErrorType = '';
    if (IsFirst != true)
        selectedErrorType = $("#ddlErrorType").val();
    //$("#hdnSynDealCode").val(Syn_Deal_Code);
    $.ajax({
        type: "POST",
        url: '@Url.Action("BulkSaveError", "Acq_Rights_List")',
        traditional: true,
        async: false,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            searchForTitles: search_Titles,
            PageSize: Page_Size,
            PageNo: Page_No,
            ErrorMsg: selectedErrorType,
            RightCode: RightCode
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
    setChosenWidth('#lbTitle_ErrorPopup', '500px');
    //initializeExpander();
}

function RightReprocess(RightCode) {
    debugger;
    $.ajax({
        type: "POST",
        url: URL_RightReprocess,//'@Url.Action("RightReprocess", "Acq_Rights_List")',
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            rightCode: RightCode
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            showAlert('S', result.message);
        },
        error: function (x, e) {
        }
    });
}

function ValidateRightsTitleWithAcq(RCode, TCode, Episode_From, Episode_To, PCode, IsHB, Is_Syn_Acq_Mapp, Mode) {
    //  showLoading();
    debugger;
    var Isvalid = true;
    $.ajax({
        type: "POST",
        url: URL_ValidateRightsTitleWithAcq,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            RCode: RCode,
            TCode: TCode,
            Episode_From: Episode_From,
            Episode_To: Episode_To
        }),
        success: function (result) {
            debugger;
            if (result == "true") {
                redirectToLogin();
            }

            if (result == "VALID") {
                Isvalid = true;
                ButtonEvents(Mode, RCode, TCode, Episode_From, Episode_To, PCode, IsHB, Is_Syn_Acq_Mapp)
            }
            else {
                hideLoading();
                showAlert('E', 'Cannot edit Rights as corresponding Syndication Deal is in Amendment state.');
                Isvalid = false;
            }
            //hideLoading();
        },
        error: function (result) {
            Isvalid = false;
        }
    });

    return Isvalid;
}