$(document).ready(function () {
    debugger
    $('.modal').modal({
        backdrop: 'static',
        keyboard: false,
        show: false
    })
    if (recordLockingCode_G > 0)
        Call_RefreshRecordReleaseTime(recordLockingCode_G, URL_Global_Refresh_Lock);


    if (View_Type_Search != '')
        $('#' + View_Type_Search)[0].checked = true;
    else
        View_Type_Search = 'G';

    $("#txtPageSize").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false
    });

    Bind_Grid(View_Type_Search, 0, 'F','Y');
    //$("#btnShowAll").click(function () {
    //    if (ValidatePageSize()) {
    //        $("#ddlTitleCode")[0].sumo.reload();
    //        showLoading();
    //        $.ajax({
    //            type: "POST",
    //            url: URL_ShowAll,
    //            traditional: true,
    //            enctype: 'multipart/form-data',
    //            contentType: "application/json; charset=utf-8",
    //            success: function (result) {
    //                if (result == "true") {
    //                    redirectToLogin();
    //                }
    //                $('#G')[0].checked = true; $("#ddlTitleCode").find("option").attr("selected", false);
    //                $("#ddlTitleCode")[0].sumo.reload();
    //                $("#ddlRegionn").find("option").attr("selected", false);
    //                $("#ddlRegionn")[0].sumo.reload();
    //                $('#lstReleaseUnit').val('B').trigger("chosen:updated");
    //                $('.sumo_Region > .optWrapper.multiple > .options li ul li.opt').removeClass('selected')
    //                document.getElementById('TotalselectedPlatform').innerHTML = parseInt(0)
    //                BindRegionList(); 
    //                $('#hdnTVCode').val('')
    //                Bind_Grid('G', 0, 'C','Y');
    //                hideLoading();
    //            },
    //            error: function (result) {
    //            }
    //        });
    //    }
    //});
});

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

function PageSize_OnChange() {
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    var IsValid = ValidatePageSize();
    if (IsValid) {
        var viewtype = $('input[name=optViewType]:checked').val();
        Bind_Grid(viewtype, 0, 'Y');
    }
    else
        return false;
}
function pageBinding() {
    var viewtype = $('input[name=optViewType]:checked').val();
    Bind_Grid(viewtype, 0, 'Y');
}
function ClearTitleValues() {
    $("#ddlTitleCode").find("option").attr("selected", false);
    $("#ddlTitleCode")[0].sumo.reload();
}

function OpenPopup(id) {
    $('#' + id).modal();
}

function Edit_Pushback(obj) {
    if (!ValidatePageSize())
        return false;
    showLoading();
    var PushbackCode = $("#" + obj + "_hdnRightCode").val();
    var TitleCode = $("#" + obj + "_hdnTitleCode").val();
    var PlatformCode = $("#" + obj + "_hdnPlatformCode").val();
    var EpisodeFrom = $("#" + obj + "_hdnEpisodeFrom").val();
    var EpisodeTo = $("#" + obj + "_hdnEpisodeTo").val();
    var View = $('input[name=optViewType]:checked').val();
    var Title_Code_Serch = $("#ddlTitleCode").val() == null ? '' : $("#ddlTitleCode").val().join(',');
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
            $('#lbTitle_Popup,#lbTerritory_Popup,#lb_Sub_Language_Popup,#lb_Dubb_Language_Popup').SumoSelect();
            $('#lbTitle_Popup')[0].sumo.reload();
            $('#lbTerritory_Popup')[0].sumo.reload();
            $('#lb_Sub_Language_Popup')[0].sumo.reload();
            $('#lb_Dubb_Language_Popup')[0].sumo.reload();
            setChosenWidth('#lbTitle_Popup', '92%');
            OpenPopup('popEditRevHB');
            hideLoading();
        },
        error: function (result) {
            alert('Error');
        }
    });
}


function Clone_Pushback(obj) {
    debugger;
    if (!ValidatePageSize())
        return false;
    showLoading();
    var PushbackCode = $("#" + obj + "_hdnRightCode").val();
    var TitleCode = $("#" + obj + "_hdnTitleCode").val();
    var PlatformCode = $("#" + obj + "_hdnPlatformCode").val();
    var EpisodeFrom = $("#" + obj + "_hdnEpisodeFrom").val();
    var EpisodeTo = $("#" + obj + "_hdnEpisodeTo").val();
    var View = $('input[name=optViewType]:checked').val();
    var Title_Code_Serch = $("#ddlTitleCode").val() == null ? '' : $("#ddlTitleCode").val().join(',');
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
            $('#lbTitle_Popup,#lbTerritory_Popup,#lb_Sub_Language_Popup,#lb_Dubb_Language_Popup').SumoSelect();
            $('#lbTitle_Popup')[0].sumo.reload();
            $('#lbTerritory_Popup')[0].sumo.reload();
            $('#lb_Sub_Language_Popup')[0].sumo.reload();
            $('#lb_Dubb_Language_Popup')[0].sumo.reload();
            setChosenWidth('#lbTitle_Popup', '92%');
            OpenPopup('popEditRevHB');
            hideLoading();
        },
        error: function (result) {
            alert('Error');
        }
    });
}



function ValidateDelete(obj) {
    if (!ValidatePageSize())
        return false;
    $('#hdnCurrentID').val(obj);
    $('#hdnCommandName').val('DELETE');
    showAlert('I', "Are you sure you want to delete this " + PushbackText + "?", 'OKCANCEL');
}
function handleCancel() {
}
function handleOk() {
    showLoading();
    var Pushback_PageNo = pushbackPageNo_G;
    if ($('#hdnCurrentPageNo').val() != undefined && $('#hdnCurrentPageNo').val() != '')
        Pushback_PageNo = $('#hdnCurrentPageNo').val();
    var page_Index = parseInt(Pushback_PageNo) - 1;
    if ($('#hdnCommandName').val() != undefined && $('#hdnCommandName').val() != '' && $('#hdnCommandName').val() == "DELETE") {
        var obj = $('#hdnCurrentID').val();
        var TitleCode = $("#" + obj + "_hdnTitleCode").val();
        var DealCode = $("#Deal_Code").val();
        var PlatformCode = $("#" + obj + "_hdnPlatformCode").val();
        var EpisodeFrom = $("#" + obj + "_hdnEpisodeFrom").val();
        var EpisodeTo = $("#" + obj + "_hdnEpisodeTo").val();
        var RightCode = $("#" + obj + "_hdnRightCode").val();
        var View = $('input[name=optViewType]:checked').val();
        var Title_Code_Serch = $("#ddlTitleCode").val() == null ? '' : $("#ddlTitleCode").val().join(',');
        var txtpageSize = $('#txtPageSize').val();
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
                View_Type: View,
                Title_Code_Serch: Title_Code_Serch,
                txtpageSize: txtpageSize,
                PageNo: Pushback_PageNo
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                $('#dvAcq_Pushback_List').html(result);
                SetPaging(txtpageSize);
                initializeExpander();
                initializeTooltip();
                hideLoading();
                showAlert('S', PushbackText + ' deleted successfully');
                Bind_Grid('G', 0, 'C', 'Y');
                BindRightsFilterData();
                
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
    var Title_Code_Search = $("#ddlTitleCode").val() == null ? '' : $("#ddlTitleCode").val().join(',');
    var View = $('input[name=optViewType]:checked').val();
    $.ajax({
        type: "POST",
        url: URL_Add,
        traditional: true,
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
            $('#lbTitle_Popup,#lbTerritory_Popup,#lb_Sub_Language_Popup,#lb_Dubb_Language_Popup').SumoSelect();
            $('#lbTitle_Popup')[0].sumo.reload();
            $('#lbTerritory_Popup')[0].sumo.reload();
            $('#lb_Sub_Language_Popup')[0].sumo.reload();
            $('#lb_Dubb_Language_Popup')[0].sumo.reload();
            setChosenWidth('#lbTitle_Popup', '92%');
            OpenPopup('popEditRevHB');
            hideLoading();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}
function BindDropdown(rb_name) {
    var selectedValue = $('input[name=' + rb_name + ']:radio:checked').val();
    var selectedId = '';
    if (selectedValue == 'I' || selectedValue == 'G')
        selectedId = 'lbTerritory_Popup';
    else if (selectedValue == 'SL' || selectedValue == 'SG')
        selectedId = 'lb_Sub_Language_Popup';
    else if (selectedValue == 'DL' || selectedValue == 'DG')
        selectedId = 'lb_Dubb_Language_Popup';
    $.ajax({
        type: "POST",
        url: URL_BindDropDown_Popup,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            str_Type: selectedValue
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
            $("#" + selectedId)[0].sumo.reload();
            if (selectedValue == 'I' || selectedValue == 'G')
                fillTotal();

            else if (selectedId =='lb_Sub_Language_Popup')
                fillTotal('HLS');

            else if (selectedId == 'lb_Dubb_Language_Popup')
                fillTotal('HLD');

        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}
function Bind_Grid(rd_value, page_index, IsCallFromPaging, showAll) {
        showLoading();
    var regionCode = "";
    var isValid = true;
    if ($('#ddlRegionn').val() == null)
        regionCode = "";
    else
        regionCode = $('#ddlRegionn').val().join(',');;
    //if (Viewbag.DupRecords > 0) {
    //    Show_Validation_Popup("", "5", 0);
    //    return false;
    //}

    var platformcode = $('#hdnTVCode').val();
    if (showAll == "N") {
        if ($("#ddlTitleCode").val() == null && $('#ddlRegionn').val() == null && $('#hdnTVCode').val() == "") {
            showAlert('E', 'Please select atleast one criteria to view', "ddlTitleCode");
            hideLoading();
            isValid = false;
        }
    }
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");
    if (!ValidatePageSize()) {
        if (View_Type_Search != '')
            $('#' + View_Type_Search)[0].checked = true;
        return false;
    }
    //if (($("#ddlTitleCode").val() == null && rd_value != 'G') && IsCallFromPaging != "Y") {
    //    $('#G')[0].checked = true;
    //    $("#divTitle_Code").addClass("required");
    //    showAlert('error', 'please select atleast one title');
    //    return false;
    //}
    //else {
        var txtpageSize = $("#txtPageSize").val();
        if ($("#ddlTitleCode").val() != null && $("#ddlTitleCode").val() != '')
            selectedTitleCode_G = $("#ddlTitleCode").val().join(',');
        else
            selectedTitleCode_G = "";

        if (IsCallFromPaging == "F" && pushbackRecordCount_G > '0') {
            page_index = pushbackPageNo_G;
            page_index = parseInt(page_index) - 1;
            rd_value = View_Type_Search;
            txtpageSize = pushbackPageSize_G;
        }

        if (IsCallFromPaging == "C") {
            rd_value = $('input[name=optViewType]:checked').val();
            //if (rd_value == 'G') {
            //    ClearTitleValues();
            //    selectedTitleCode_G = '';
            //}
        }
        if (IsCallFromPaging == "F") {
            IsCallFromPaging = "S";
        }
        if (isValid) {
            $.ajax({
                type: "POST",
                url: URL_Bind_Grid_List,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                dataType: "html",
                data: JSON.stringify({
                    Selected_Title_Code: selectedTitleCode_G,
                    view_Type: rd_value,
                    txtpageSize: txtpageSize,
                    page_index: page_index,
                    IsCallFromPaging: IsCallFromPaging,
                    RegionCode: regionCode,
                    PlatformCode: platformcode

                }),
                success: function (result) {
                    if (result == "true") {
                        redirectToLogin();
                    }
                    debugger;
                    $('#dvAcq_Pushback_List').html(result);
                    //OnSuccess();
                    SetPaging(txtpageSize);
                    setNumericForPagingSize();
                    initializeExpander();
                    initializeTooltip();
                    hideLoading();
                },
                error: function (result) {
                    alert('Error: ' + result.responseText);
                }
            });
}
}
function OnSuccess(Error_Message) {
    //debugger;
    //hideLoading();
    //if (Error_Message == "ERROR") {
    //    Show_Validation_Popup("", 5, 0);
    //}
    //else if (message != "") {
    //    MessageFrom = "SV"
    //    showAlert('S', message, 'OK');
    //}
}
function Show_Validation_Popup(search_Titles, Page_Size, Page_No) {
    debugger;
    $.ajax({
        type: "POST",
        url: "Acq_Pushback/Show_Validation_Popup",//'@Url.Action("Show_Validation_Popup", "Acq_Pushback")',
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
function ValidateSave() {
    showLoading();
    var Isvalid = true;

    // Code for Maintaining approval remarks in session
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
        },
                error: function (result) {
            Isvalid = false;
    }
    });
    }
    else
        Isvalid = true;

    if (Isvalid) {
        hideLoading();
        var tabName = $('#hdnTabName').val();
        BindPartialTabs(tabName);
        }
    hideLoading();

    //Code end for approval
    return Isvalid;
    }
    function fillTotal(check) {
        var selectedCount = 0, selectedRegion = '';

        if (check == 'HLS') {

            if ($("#lb_Sub_Language_Popup option:selected").length > 0) {
                $("#lb_Sub_Language_Popup option:selected").each(function () {
                if (selectedRegion == '') {
                    selectedRegion = $(this).val();
                }
                else {
                    selectedRegion = selectedRegion + ',' +$(this).val();
                }
                    selectedCount++
        });
        }
        $('#lblLanguageCount').html(selectedCount);

    }
    else if(check == 'HLD') {
        if ($("#lb_Dubb_Language_Popup option:selected").length > 0) {
            $("#lb_Dubb_Language_Popup option:selected").each(function () {
                if (selectedRegion == '') {
                    selectedRegion = $(this).val();
                }
                else {
                    selectedRegion = selectedRegion + ',' +$(this).val();
            }
                selectedCount++
    });
        }
        $('#lblDubbingCount').html(selectedCount);
    }

    else {
        if ($("#lbTerritory_Popup option:selected").length > 0) {
            $("#lbTerritory_Popup option:selected").each(function () {
                if (selectedRegion == '') {
                    selectedRegion = $(this).val();
                }
                else {
                    selectedRegion = selectedRegion + ',' +$(this).val();
            }
                selectedCount++
    });
        }
        $('#RCount').html(selectedCount);
    }
}
