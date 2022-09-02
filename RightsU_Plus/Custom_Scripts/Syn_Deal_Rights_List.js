var Command_Name;
var MessageFrom = '';
var SelectedTitles = "";
var ViewType = "";

$(document).ready(function () {
    showLoading();
    var txtAcqRemarks = document.getElementById('txtAcqRemarks');
    var dealmode = Dealmode_G;

    $('#txtPageSize').numeric({
        max: 100,
        min: 1
    });

    if (parseInt(Record_Locking_Code_G) > 0) {
        var fullUrl = URL_Refresh_Lock;
        Call_RefreshRecordReleaseTime(Record_Locking_Code_G, fullUrl);
    }

    if (txtAcqRemarks != null)
        countChar(txtAcqRemarks);

    BindGrid(null);
    hideLoading();
    //$("#btnShowAll").click(function () {
    //    debugger
    //    if (ValidatePageSize()) {
    //        $("#ddlTitleCode").find("option").attr("selected", false);
    //        $("#ddlTitleCode")[0].sumo.reload();
    //        $("#ddlRegionn").find("option").attr("selected", false);
    //        $("#ddlRegionn")[0].sumo.reload();
    //        $('#lstReleaseUnit').val('B').trigger("chosen:updated");
    //        $('#hdnTVCode').val('');
    //        showLoading();
    //        $("#G").prop("checked", true);
    //        $('.sumo_Region > .optWrapper.multiple > .options li ul li.opt').removeClass('selected')
    //        document.getElementById('TotalselectedPlatform').innerHTML = parseInt(0)
    //        BindRegionList();
    //        ClearTitleValues();
    //        BindGridNew($("#G")[0], 'N', 'Y');
    //        //hideLoading();
    //    }
    //});


    $("#ddlTitleCode").change(function () {
        SelectedTitles = $(this).val();
    });
    //hideLoading();
})
//$(window).load(function () {
//    BindGrid(null);
//});
function ValidatePageSize() {
    var recordPerPage = $('#txtPageSize').val();

    if ($.trim(recordPerPage) != '') {
        var pageSize = parseInt(recordPerPage);

        if (pageSize > 0)
            return true;
    }

    $('#txtPageSize').addClass("required");
    return false;
}
function pageBinding() {
    BindGridNew($("#G")[0], 'Y');
}
function ClearTitleValues() {
    $("#ddlTitleCode").find("option").attr("selected", false);
    $("#ddlTitleCode").val('')[0].sumo.reload();
}

function BindGrid(obj) {
    // showLoading();
    var ViewType = "";
    var regionCode = "";
    var exclusiveRights = "";
    if ($('#ddlRegionn').val() == null)
        regionCode = "";
    else
        regionCode = $('#ddlRegionn').val().join(',');

    exclusiveRights = $('#lstReleaseUnit').val();
    var platformcode = $('#hdnTVCode').val();
    var Rights_PageNo = 0;
    var TitleCode = '';
    var page_index = 0;

    if (obj == null) {
        ViewType = "G";

        if (Rights_View_G != null) {
            $('#' + Rights_View_G)[0].checked = true;
            ViewType = Rights_View_G;
        }

        if (Rights_Titles_G != null && Rights_Titles_G != '')
            TitleCode = Rights_Titles_G;

        if (rightsExclusive_G != null && rightsExclusive_G != '')
            exclusiveRights = rightsExclusive_G;

        if (Rights_PageSize_G != null && Rights_PageSize_G != '0')
            $('#txtPageSize').val(Rights_PageSize_G);

        if (Rights_PageNo_G != null && Rights_PageNo_G != '0')
            page_index = parseInt(Rights_PageNo_G) - 1;
    }
    else
        ViewType = $('input[name=optViewType]:checked').val();

    if ($("#ddlTitleCode").val() != null)
        TitleCode = $("#ddlTitleCode").val().join(',');

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
            asyn: false,
            data: JSON.stringify({
                Selected_Title_Code: TitleCode,
                view_Type: ViewType,
                txtpageSize: txtpageSize,
                page_index: page_index,
                IsCallFromPaging: 'N',
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
                setNumericForPagingSize();
                initializeExpander();
                CheckRightStatus();
                //  hideLoading();
            },
            error: function (result) {
            }
        });
    }
}

//function CheckRightStatus() {
//    $("div.grid_item").each(function () {
//        var innerDivElement = $(this);
//        var rightStatus = $(this).find("input[id*='hdnRightStatus']").val();

//        if (rightStatus == "P") {
//            var rightCode = parseInt($(this).find("input[id*='hdnRightCode']").val());

//            if (isNaN(rightCode))
//                rightCode = 0;

//            if (rightCode > 0) {
//                $.ajax({
//                    type: "POST",
//                    url: URL_GetSynRightsStatus,
//                    traditional: true,
//                    enctype: 'multipart/form-data',
//                    contentType: "application/json; charset=utf-8",
//                    async: true,
//                    data: JSON.stringify({
//                        RightsCode: rightCode
//                    }),
//                    success: function (result) {
//                        if (result == "true") {
//                            redirectToLogin();
//                        }

//                        innerDivElement.find("input[id*='hdnRightStatus']").val(result);
//                        var btnEdit = innerDivElement.find(".glyphicon-pencil");
//                        var btnClone = innerDivElement.find(".glyphicon-duplicate");
//                        var btnDelete = innerDivElement.find(".glyphicon-trash");
//                        var btnShowError = innerDivElement.find(".glyphicon-exclamation-sign");
//                        var imgLoading = innerDivElement.find("img[id*='imgLoading']");

//                        if (result == "E") {
//                            //Error
//                            btnShowError[0].style.display = '';
//                            btnEdit[0].style.display = '';
//                            btnClone[0].style.display = '';
//                            btnDelete[0].style.display = '';
//                            imgLoading[0].style.display = "none";
//                        }
//                        else if (result == "C") {
//                            // Completed
//                            btnEdit[0].style.display = '';
//                            btnClone[0].style.display = '';
//                            btnDelete[0].style.display = '';
//                            btnShowError[0].style.display = 'none';
//                            imgLoading[0].style.display = "none";
//                        }
//                        else if (result == "P") {
//                            // Processing
//                            btnShowError[0].style.display = 'none';
//                            btnEdit[0].style.display = 'none';
//                            btnClone[0].style.display = 'none';
//                            btnDelete[0].style.display = 'none';
//                            imgLoading[0].style.display = '';
//                        }
//                    },
//                    error: function (result) {
//                        hideLoading();
//                        //alert('Error: '+ result.responseText);
//                    }
//                })
//            }
//        }
//    });

//    setTimeout(CheckRightStatus, 5000);
//}

function BindGridNew(obj, IsCallFromPaging, ShowAll) {
    showLoading();
    var regionCode = "";
    var exclusiveRights = "";
    var isValid = true;
    if ($('#ddlRegionn').val() == null)
        regionCode = "";
    else
        regionCode = $('#ddlRegionn').val().join(',');

    exclusiveRights = $('#lstReleaseUnit').val();
    var platformcode = $('#hdnTVCode').val();
    if (ShowAll == "N") {
        if ($("#ddlTitleCode").val() == null && $('#ddlRegionn').val() == null && $('#hdnTVCode').val() == "" && $('#lstReleaseUnit').val() == "B") {
            showAlert('E', ShowMessage.Pleaseselectatleastonecriteriatoview, "ddlTitleCode");
            hideLoading();
            isValid = false;
        }
    }
    if (isValid) {
        if (ValidatePageSize()) {
            var ViewType = "";
            var TitleCode = "";

            if ($("#ddlTitleCode").val() != undefined && $("#ddlTitleCode").val() != null)
                TitleCode = $("#ddlTitleCode").val().join(',');
            else
                TitleCode = "";
            if (obj == null)
                ViewType = "G";
            else
                ViewType = $('input[name=optViewType]:checked').val();

            var Rights_PageNo = 1;
            var page_Index = 0;
            var txtpageSize = $("#txtPageSize").val();

            if ($('#hdnCurrentPageNo').val() != undefined && $('#hdnCurrentPageNo').val() != '')
                Rights_PageNo = $('#hdnCurrentPageNo').val();

            page_Index = parseInt(Rights_PageNo) - 1;

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
                    hideLoading();
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
        if (Rights_View_G != null)
            $('#' + Rights_View_G)[0].checked = true;
    }
}

function DeleteRight(obj) {
    debugger;
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
        showAlert('error', ShowMessage.Cannotdeleterightasitisalreadysyndicated);
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
                hideLoading();
                showAlert(result.ShowError, result.RightMsg);
                BindGridNew($("#G")[0], 'Y');
                BindRightsFilterData();

            },
            error: function (result) {
                alert('Error');
                hideLoading();
            }
        });
    }
}

function ValidateDelete(obj) {
    if (ValidatePageSize()) {
        $('#hdnCurrentID').val(obj);
        $('#hdn_Command_Name').val('DELETE');
        showAlert('I', ShowMessage.Areyousureyouwanttodeletethisright, 'OKCANCEL');
    }
}

function handleCancel() { }

function handleOk() {
    if (MessageFrom == 'SV') {
        if ($('#hdnTabName').val() == '') {
            $('#hdn_Command_Name').val('');
            window.location.href = URL_Index;
        }
    }

    if ($('#hdn_Command_Name').val() != undefined && $('#hdn_Command_Name').val() != '' && $('#hdn_Command_Name').val() == "CANCEL_SAVE_DEAL") {
        location.href = URL_Cancel;
    }
    else if ($('#hdn_Command_Name').val() != undefined && $('#hdn_Command_Name').val() != '' && $('#hdn_Command_Name').val() == "DELETE") {
        showLoading();
        var obj = $('#hdnCurrentID').val();
        DeleteRight(obj);
    }
}

function ValidateSave() {
    showLoading();
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
    var Isvalid = true;

    if (ValidatePageSize() && Dealmode_G == 'APRV') {
        // Code for Maintaining approval remarks in session        
        if (SaveApprovalRemarks())
            Isvalid = true
        else
            Isvalid = false;
    }

    if (Isvalid && (Dealmode_G == dealMode_View || Dealmode_G == 'APRV')) {
        hideLoading();
        var tabName = $('#hdnTabName').val();
        BindPartialTabs(tabName);
    }
    hideLoading();
    return Isvalid;
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
                showAlert('E', 'Cannot edit Rights as corresponding Acquisition Deal is in Amendment state.');
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

function SaveApprovalRemarks() {
    var Isvalid = true;
    var Mode = Dealmode_G;

    if (Mode == 'APRV') {
        var approvalremarks = $('#approvalremarks').val();
        $.ajax({
            type: "POST",
            url: URL_SetSynApprovalRemarks,
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

function Show_Error_Popup(search_Titles, Page_Size, Page_No, Rights_Code) {
    $("#hdnSynDealCode").val(Rights_Code);

    $.ajax({
        type: "POST",
        url: URL_Show_Error_Popup,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            searchForTitles: search_Titles,
            PageSize: Page_Size,
            PageNo: Page_No,
            RightsCode: Rights_Code,
            ErrorMsg: $("#ddlErrorType").val()
        }),
        async: false,
        success: function (result) {
            if (result == "true")
                redirectToLogin();
            else {
                $("#BindErrorPopup").html(result);
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });

    $('#popupShowError').modal();
    initializeExpander();
    initializeChosen();
    setChosenWidth('#lbTitle_ErrorPopup', '85%');
    hideLoading();
}
function Reprocess() {
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_Reprocess,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Rights_Code: $("#hdnSynDealCode").val()
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.RedirectTo != '') {
                    showLD = 'N';
                    $('#popupShowError').modal('hide');
                    BindGridNew($("#G")[0], 'Y');
                    $(document.getElementsByClassName('modal-open')).removeClass('modal-open');
                    $(document.getElementsByClassName('modal-backdrop')).remove();  // background not hiding
                    showAlert('S', result.Message);
                }
                else {
                    $('#popupShowError').modal('hide');
                    showAlert('E', result.Message);
                    return false;
                }
            }
            // hideLoading();
        },
        error: function (result) {
            $('#popupShowError').modal('hide');
            showAlert('e', result.responseText)
        }
    });
}

function CancelSaveDeal() {
    $('#hdn_Command_Name').val('CANCEL_SAVE_DEAL');
    showAlert("I", ShowMessage.AllunsavedData, "OKCANCEL");
}

function Save_Success(message) {
    //  hideLoading();    
    if (message == "true") {
        redirectToLogin();
    }
    else {
        if (message.Status.toUpperCase() == "SA") {
            $.ajax({
                type: "POST",
                url: URL_Syn_Approve_Reject,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    user_Action: 'A',
                    approvalremarks: ""
                }),
                async: false,
                success: function (data) {
                    var tabName = $('#hdnTabName').val();
                    BindPartialTabs(tabName);
                }
            });
        }
        //hideLoading();
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
}

function Cancel_Rights() {
    BindPartialTabs(pageRights_List);
}

function ButtonEvents(mode, rCode, tCode, episodeFrom, episodeTo, pCode, isHB, isSynAcqMapp) {
    // showLoading();
    $.ajax({
        type: "POST",
        url: URL_ButtonEvents,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            MODE: mode,
            RCode: rCode,
            PCode: pCode,
            TCode: tCode,
            Episode_From: episodeFrom,
            Episode_To: episodeTo,
            IsHB: isHB,
            Is_Syn_Acq_Mapp: isSynAcqMapp
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                BindPartialTabs(result.TabName);
                //   hideLoading();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}



function Show_Restriction_Remark_popup(Counter) {
    showLoading();
    var Remark = $("#hdnRemarks_" + Counter).val();
    var RightCode = $("#" + Counter + "_hdnRightCode").val();
    var TitleCode = $("#" + Counter + "_hdnTitleCode").val();
    var EpisodeFrom = $("#" + Counter + "_hdnEpisodeFrom").val();
    var EpisodeTo = $("#" + Counter + "_hdnEpisodeTo").val();
    var PlatformCode = $("#" + Counter + "_hdnPlatformCode").val();
    if (Remark != "") {
        $("#lblRestRemark").text(Remark);
        $.ajax({
            type: "POST",
            url: ShowRestriction_Remarks_Popup_URL,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            async: true,
            data: JSON.stringify({
                RightsCode: RightCode,
                Title_Code: TitleCode,
                Episode_From: EpisodeFrom,
                Episode_To: EpisodeTo,
                Platform_Code: PlatformCode
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                var strHTML = '';
                strHTML = strHTML + '<thead><tr>'
                strHTML = strHTML + '<th style="width:15%;">' + ShowMessage.Title + '</th>'
                strHTML = strHTML + '<th style="width:15%;">' + ShowMessage.Platform + '</th>'
                strHTML = strHTML + '<th style="width:15%;">' + ShowMessage.Region + '</th>'
                strHTML = strHTML + '<th style="width:15%;">' + ShowMessage.RestrictionRemark + '</th>'
                strHTML = strHTML + '<th style="width:15%;">' + ShowMessage.TitleLanguage + '</th>'
                strHTML = strHTML + '<th style="width:10%;">' + ShowMessage.Subtitling + '</th>'
                strHTML = strHTML + '<th style="width:15%;">' + ShowMessage.Dubbing + '</th>'
                strHTML = strHTML + '</tr></thead>'
                if (result != '') {
                    for (var i = 0; i < result.length; i++) {
                        strHTML = strHTML + '<tr>'
                        strHTML = strHTML + '<td>' + result[i].Title_Name + '</td>'
                        strHTML = strHTML + '<td>'
                        strHTML = strHTML + '<div class="expandable">' + result[i].Platform_Name + '</div>'
                        strHTML = strHTML + '</td>'
                        strHTML = strHTML + '<td>'
                        strHTML = strHTML + '<div class="expandable">' + result[i].Country_Name + '</div>'
                        strHTML = strHTML + '</td>'
                        strHTML = strHTML + '<td>'
                        strHTML = strHTML + '<div class="expandable">' + result[i].Restriction_Remarks + '</div>'
                        strHTML = strHTML + '</td>'
                        strHTML = strHTML + '<td>' + result[i].Is_Title_Language_Right + '</td>'
                        strHTML = strHTML + '<td>'
                        strHTML = strHTML + '<div class="expandable">' + result[i].SubTitle_Lang_Name + '</div>'
                        strHTML = strHTML + '</td>'
                        strHTML = strHTML + '<td>'
                        strHTML = strHTML + '<div class="expandable">' + result[i].Dubb_Lang_Name + '</div>'
                        strHTML = strHTML + '</td>'
                        strHTML = strHTML + '</tr>'
                    }
                }
                $('#tblRestRemarks').html(strHTML);
                $('#popAddDealMovie').modal();
                hideLoading();
                initializeExpander();
            },
            error: function (result) {
                hideLoading();
            }
        });

    }
}

function CheckRightStatus() {
    debugger;
    var pendingRecord = 0;
    $(".clsTdAction").each(function () {
        var refCloseTitle = $(this).find("input[id*='hdnRefCloseTitle']").val();
        if (refCloseTitle != 'Y') {
            var rightStatus = $(this).find("input[id*='hdnRightStatus']").val();
            if (rightStatus == "P") {
                var rightCode = $(this).find("input[id*='hdnRightCode']").val();
                if (isNaN(rightCode))
                    rightCode = 0;

                if (rightCode > 0) {
                    debugger;
                    var btnEdit = $(this).find("a[id*='btnEdit']");
                    var btnDelete = $(this).find("a[id*='btnDelete']");
                    var btnClone = $(this).find("a[id*='btnClone']");
                    var btnShowError = $(this).find("a[id*='btnShowError']");
                    var imgLoading = $(this).find("img[id*='imgLoading']");

                    $.ajax({
                        type: "POST",
                        url: URL_GetSynRightStatus,
                        traditional: true,
                        enctype: 'multipart/form-data',
                        contentType: "application/json; charset=utf-8",
                        async: false,
                        data: JSON.stringify({
                            rightCode: rightCode,
                            dealCode: 0
                        }),
                        success: function (result) {
                            //showAlert('S', result.RecordStatus,'OK');
                            if (result == "true") {
                                redirectToLogin();
                            }

                            if (result.RecordStatus == "E") {
                                // Error
                                btnShowError[0].style.display = '';
                                btnEdit[0].style.display = '';
                                btnDelete[0].style.display = '';
                                btnClone[0].style.display = '';
                                imgLoading[0].style.display = "none";
                                $(this).find("input[id*='hdnRightStatus']").val("E");
                            }
                            else if (result.RecordStatus == "C") {
                                // Completed
                                btnEdit[0].style.display = '';
                                btnDelete[0].style.display = '';
                                btnClone[0].style.display = '';
                                btnShowError[0].style.display = 'none';
                                imgLoading[0].style.display = "none";
                                $(this).find("input[id*='hdnRightStatus']").val("C");
                            }
                            else if (result.RecordStatus == "P") {
                                // Processing
                                btnEdit[0].style.display = 'none';
                                btnDelete[0].style.display = 'none';
                                btnClone[0].style.display = 'none';
                                btnShowError[0].style.display = 'none';
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
    if (pendingRecord > 0) {
        setTimeout(CheckRightStatus, 5000);
    }
}
