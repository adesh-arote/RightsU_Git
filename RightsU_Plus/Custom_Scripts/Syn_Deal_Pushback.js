$(document).ready(function () {
    $('.modal').modal({
        backdrop: 'static',
        keyboard: false,
        show: false
    })
    $('#txtPageSize').numeric({
        max: 100,
        min: 1
    });
    $('#ddlTitleCode').SumoSelect();

    if (parseInt(Record_Locking_Code_G) > 0) {
        var fullUrl = URL_Refresh_Lock
        Call_RefreshRecordReleaseTime(Record_Locking_Code_G, fullUrl);
    }
    var txtAcqRemarks = document.getElementById('txtAcqRemarks');
    if (txtAcqRemarks != null)
        countChar(txtAcqRemarks);
    document.getElementById('TotalselectedPlatform').innerHTML = parseInt(0);
})

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
var SelectedTitles = "";
var ViewType = "";
$(document).ready(function () {
    BindGrid(null);
    //$("#btnShowAll").click(function () {
    //    if (ValidatePageSize()) {
    //        $("#ddlTitleCode").find("option").attr("selected", false);
    //        $("#ddlTitleCode")[0].sumo.reload();
    //        $("#ddlRegionn").find("option").attr("selected", false);
    //        $("#ddlRegionn")[0].sumo.reload();
    //        //$('#lstReleaseUnit').val('B').trigger("chosen:updated");
    //        $('#hdnTVCode').val('');
    //        $("#G").prop("checked", true);
    //        ClearTitleValues();
    //        document.getElementById('TotalselectedPlatform').innerHTML = parseInt(0)
    //        $('.sumo_Region > .optWrapper.multiple > .options li ul li.opt').removeClass('selected')
    //        BindRegionList();
    //        BindGridNew($("#G")[0], 'N', 'Y');
            

    //    }
    //});

    $("#ddlTitleCode").change(function () {
        SelectedTitles = $(this).val();
    });
});

function ClearTitleValues() {
    $("#ddlTitleCode").find("option").attr("selected", false);
    $("#ddlTitleCode").val('')[0].sumo.reload();
}

function BindGrid(obj) {
    showLoading();
    var ViewType = "";
    var regionCode = "";
    var exclusiveRights = "";
    if ($('#ddlRegionn').val() == null)
        regionCode = "";
    else
        regionCode = $('#ddlRegionn').val().join(',');

    //exclusiveRights = $('#lstReleaseUnit').val();
    var platformcode = $('#hdnTVCode').val();
    var Rights_PageNo = 0;
    var TitleCode = '';
    var page_index = 0;
    if (obj == null) {
        ViewType = "G";
        if (Pushback_View_G != null) {
            $('#' + Pushback_View_G)[0].checked = true;
            ViewType = Pushback_View_G;
        }
        if (Pushback_Titles_G != null && Pushback_Titles_G != '')
            TitleCode = Pushback_Titles_G;
        if (Pushback_PageSize_G != null && Pushback_PageSize_G != '0')
            $('#txtPageSize').val(Pushback_PageSize_G);
        if (Pushback_PageNo_G != null && Pushback_PageNo_G != '0')
            page_index = parseInt(Pushback_PageNo_G) - 1;
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
            async: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                Selected_Title_Code: TitleCode,
                view_Type: ViewType,
                txtpageSize: txtpageSize,
                page_index: page_index,
                IsCallFromPaging: 'N',
                RegionCode: regionCode,
                PlatformCode: platformcode,
                ExclusiveRight: "B"
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                $('.div_BindGrid').html(result);
                SetPaging($('#txtPageSize').val());
                setNumericForPagingSize();
                initializeExpander();
                hideLoading();
                CheckRightStatus();
            },
            error: function (result) {
                //alert('Error: '+ result.responseText);
            }
        });
    }
}

function BindGridNew(obj, IsCallFromPaging, ShowAll) {
    showLoading();
    var regionCode = "";
    var exclusiveRights = "";
    var isValid = true;
    if ($('#ddlRegionn').val() == null)
        regionCode = "";
    else
        regionCode = $('#ddlRegionn').val().join(',');

   // exclusiveRights = $('#lstReleaseUnit').val();
    var platformcode = $('#hdnTVCode').val();
    if (ShowAll == "N") {
        if ($("#ddlTitleCode").val() == null && $('#ddlRegionn').val() == null && $('#hdnTVCode').val() == "") {
            showAlert('E', ShowMessage.Pleaseselectatleastonecriteriatoview, "ddlTitleCode");
            hideLoading();
            isValid = false;
        }
    }
    $('.ddlTitleCode').removeClass("required");
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
            //if (ViewType != "G") {
            //    if (TitleCode != '')
            //        TitleCode = $("#ddlTitleCode").val().join(',');
            //    else {
            //        $('.ddlTitleCode').addClass("required");
            //        showAlert('info', 'Please select atleast one title to view', "ddlTitleCode");
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
                async: true,
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
                    ExclusiveRight: "B"
                }),
                success: function (result) {
                    if (result == "true") {
                        redirectToLogin();
                    }
                    $('.div_BindGrid').html(result);
                    SetPaging($('#txtPageSize').val());
                    initializeExpander();
                    hideLoading();
                    CheckRightStatus();
                },
                error: function (result) {
                    hideLoading();
                    //alert('Error: '+ result.responseText);
                }
            });
        }
    }
    else {
        if (Pushback_View_G != null)
            $('#' + Pushback_View_G)[0].checked = true;
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
        showAlert('error', ShowMessage.Cannotdeleterightasitisalreadysyndicated);
        hideLoading();
    }
    else {
        $.ajax({
            type: "POST",
            url: URL_DeletePushback,
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
                BindGridNew($("#G")[0], 'Y');
                  BindRightsFilterData();
                hideLoading();
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
        showAlert('I', ShowMessage.Areyousureyouwanttodeletethisright, 'OKCANCEL');
    }
}

function handleCancel() {
}

function handleOk() {
    var obj = $('#hdnCurrentID').val();
    DeleteRight(obj);
}

function ValidateSave() {
    showLoading();
    var Isvalid = true;
    if (ValidatePageSize()) {
        // Code for Maintaining approval remarks in session        
        if (Mode_G == 'APRV') {
            if (SaveApprovalRemarks())
                Isvalid = true
            else
                Isvalid = false;
        }
    }
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
    var Mode = Mode_G;
    if (Mode == 'APRV') {
        var approvalremarks = $('#approvalremarks').val();
        $.ajax({
            type: "POST",
            url: URL_SetApprovalRemarks,
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
    showLoading();
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
    initializeChosen();
    initializeExpander();
    hideLoading();
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
//                        var btnDelete = innerDivElement.find(".glyphicon-trash");
//                        var btnShowError = innerDivElement.find(".glyphicon-exclamation-sign");
//                        var imgLoading = innerDivElement.find("img[id*='imgLoading']");

//                        if (result == "E") {
//                            //Error
//                            btnShowError[0].style.display = '';
//                            btnEdit[0].style.display = '';
//                            btnDelete[0].style.display = '';
//                            imgLoading[0].style.display = "none";
//                        }
//                        else if (result == "C") {
//                            // Completed
//                            btnEdit[0].style.display = '';
//                            btnDelete[0].style.display = '';
//                            btnShowError[0].style.display = 'none';
//                            imgLoading[0].style.display = "none";
//                        }
//                        else if (result == "P") {
//                            // Processing
//                            btnShowError[0].style.display = 'none';
//                            btnEdit[0].style.display = 'none';
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
//    setTimeout(CheckRightStatus, 10000);
//}

function OpenPopup(id) {
    $('#' + id).modal();
}

function Edit_Pushback(obj) {
    debugger;
    if (!ValidatePageSize())
        return false;
    showLoading();
    //    $("#hdnSave_Message").val('');
    var PushbackCode = $("#" + obj + "_hdnRightCode").val();
    var TitleCode = $("#" + obj + "_hdnTitleCode").val();
    var PlatformCode = $("#" + obj + "_hdnPlatformCode").val();
    var EpisodeFrom = $("#" + obj + "_hdnEpisodeFrom").val();
    var EpisodeTo = $("#" + obj + "_hdnEpisodeTo").val();
    var View = $('input[name=optViewType]:checked').val();
    var Title_Code_Serch = $("#Title_Code").val() == null ? '' : $("#Title_Code").val().join(',');
    if (ValidateRightsTitleWithAcq(PushbackCode, TitleCode, EpisodeFrom, EpisodeTo)) {
        $.ajax({
            type: "POST",
            url: URL_Edit_Pushback,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                PushbackCode: PushbackCode,
                TitleCode: TitleCode,
                PlatformCode: PlatformCode,
                EpisodeFrom: EpisodeFrom,
                EpisodeTo: EpisodeTo,
                View_Type: View,
                Title_Code_Search: Title_Code_Serch
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                $('#popEditRevHB').html(result);
                //setChosenWidth('#lbTitle_Popup', '92%');
                initializeDatepicker();
                $("#txtRight_Start_Date").datepicker();
                $("#txtRight_End_Date").datepicker();
                initializeDateRange('txtRight_Start_Date', 'txtRight_End_Date');
                OpenPopup('popEditRevHB');
                hideLoading();
            },
            error: function (result) {
                alert('Error');
            }
        });
    }
}

function Clone_Pushback(obj) {
    if (!ValidatePageSize())
        return false;
    showLoading();
    //    $("#hdnSave_Message").val('');
    var PushbackCode = $("#" + obj + "_hdnRightCode").val();
    var TitleCode = $("#" + obj + "_hdnTitleCode").val();
    var PlatformCode = $("#" + obj + "_hdnPlatformCode").val();
    var EpisodeFrom = $("#" + obj + "_hdnEpisodeFrom").val();
    var EpisodeTo = $("#" + obj + "_hdnEpisodeTo").val();
    var View = $('input[name=optViewType]:checked').val();
    var Title_Code_Serch = $("#Title_Code").val() == null ? '' : $("#Title_Code").val().join(',');
    if (ValidateRightsTitleWithAcq(PushbackCode, TitleCode, EpisodeFrom, EpisodeTo)) {
        $.ajax({
            type: "POST",
            url: URL_Clone_Pushback,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                PushbackCode: PushbackCode,
                TitleCode: TitleCode,
                PlatformCode: PlatformCode,
                EpisodeFrom: EpisodeFrom,
                EpisodeTo: EpisodeTo,
                View_Type: View,
                Title_Code_Search: Title_Code_Serch
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                $('#popEditRevHB').html(result);
                //setChosenWidth('#lbTitle_Popup', '92%');
                initializeDatepicker();
                $("#txtRight_Start_Date").datepicker();
                $("#txtRight_End_Date").datepicker();
                initializeDateRange('txtRight_Start_Date', 'txtRight_End_Date');
                OpenPopup('popEditRevHB');
                hideLoading();
            },
            error: function (result) {
                alert('Error');
            }
        });
    }
}





function Add(id) {
    if (!ValidatePageSize())
        return false;
    showLoading();
    var Title_Code_Search = $("#Title_Code").val() == null ? '' : $("#Title_Code").val().join(',');
    var View = $('input[name=optViewType]:checked').val();
    $.ajax({
        type: "POST",
        url: URL_Add,
        traditional: true,
        async: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        data: JSON.stringify({
            View_Type_Search: View,
            Title_Code_Search: Title_Code_Search
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            $('#popEditRevHB').html(result);
            //setChosenWidth('#lbTitle_Popup', '92%');
            OpenPopup('popEditRevHB');
            hideLoading();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}

function OnSuccess(message) {
    hideLoading();
    if (message == "ERROR") {
        Show_Validation_Popup("", 5, 0);
    }
    else if (message != "") {
        $('#popEditRevHB').modal('hide');
        showAlert('S', message);
        var Pushback_PageNo = 0;
        if ($('#hdnCurrentPageNo').val() != undefined && $('#hdnCurrentPageNo').val() != '')
            Pushback_PageNo = $('#hdnCurrentPageNo').val();
        var page_Index = parseInt(Pushback_PageNo) - 1;
        var rd_value = $('input[name=optViewType]:checked').val();
        BindGridNew(null, 'Y');
       BindRightsFilterData();
    }
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
            hideLoading();
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.RedirectTo != '') {
                    showLD = 'N';
                    $('#popupShowError').modal('hide');
                    $(document.getElementsByClassName('modal-open')).removeClass('modal-open');     // scroll not coming after hiding popup
                    showAlert('S', ShowMessage.ReverseHoldbackReprocessedSuccessfully);
                    $(document.getElementsByClassName('modal-backdrop')).remove();  // background not hiding
                    BindGridNew($("#G")[0], 'Y');
                }
                else {
                    $('#popupShowError').modal('hide');
                    showAlert('E', result.Message);
                    return false;
                }
            }
        },
        error: function (result) {
            $('#popupShowError').modal('hide');
            showAlert('e', result.responseText)
        }
    });
}

function ValidateRightsTitleWithAcq(RCode, TCode, Episode_From, Episode_To) {
    var Isvalid = true;
    showLoading();
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
            if (result == "true") {
                redirectToLogin();
            }
            if (result == "VALID")
                Isvalid = true;
            else {
                showAlert('E', ShowMessage.CannoteditReverseHoldbackascorrespondingAcquisitionDeal)
                Isvalid = false;
            }
            hideLoading();
        },
        error: function (result) {
            Isvalid = false;
        }
    });
    //Code end for approval
    return Isvalid;
}

function CheckRightStatus() {
    var pendingRecord = 0;
    $("#clsLiAction").each(function () {
        var refCloseTitle = $(this).find("input[id*='hdnRefCloseTitle']").val();
        if (refCloseTitle != 'Y') {
            var rightStatus = $(this).find("input[id*='hdnRightStatus']").val();
            if (rightStatus == "P") {
                var rightCode = $(this).find("input[id*='hdnRightCode']").val();
                if (isNaN(rightCode))
                    rightCode = 0;

                if (rightCode > 0) {
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
                            if (result == "true") {
                                redirectToLogin();
                            }

                            if (result.RecordStatus == "E") {
                                // Error
                                btnEdit[0].style.display = '';
                                btnDelete[0].style.display = '';
                                btnShowError[0].style.display = '';
                                imgLoading[0].style.display = "none";
                                $(this).find("input[id*='hdnRightStatus']").val("E");
                            }
                            else if (result.RecordStatus == "C") {
                                // Completed
                                btnEdit[0].style.display = '';
                                btnDelete[0].style.display = '';
                                btnShowError[0].style.display = 'none';
                                imgLoading[0].style.display = "none";
                                $(this).find("input[id*='hdnRightStatus']").val("C");
                            }
                            else if (result.RecordStatus == "P") {
                                // Processing
                                btnEdit[0].style.display = 'none';
                                btnDelete[0].style.display = 'none';
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

    if (pendingRecord > 0)
        setTimeout(CheckRightStatus, 5000);
}
function fillTotal(check) {
    var selectedCount = 0, selectedRegion = '';
    if (check == 'LS') {
        if ($("#lb_Sub_Language_Popup option:selected").length > 0) {
            $("#lb_Sub_Language_Popup option:selected").each(function () {
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
    else if (check == 'LD') {
        if ($("#lb_Dubb_Language_Popup option:selected").length > 0) {
            $("#lb_Dubb_Language_Popup option:selected").each(function () {
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

    else{
        if ($("#lbTerritory_Popup option:selected").length > 0) {
            $("#lbTerritory_Popup option:selected").each(function () {
                if (selectedRegion == '') {
                    selectedRegion = $(this).val();
                }
                else {
                    selectedRegion = selectedRegion + ',' + $(this).val();
                }
                selectedCount++
            });
        }
        $('#RCount').html(selectedCount);

    }
    
}