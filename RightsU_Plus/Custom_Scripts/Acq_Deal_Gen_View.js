$(document).ready(function () {
    $('#ddlTitle_Search_List').SumoSelect();
    if (recordLockingCode_G > 0)
        Call_RefreshRecordReleaseTime(recordLockingCode_G, URL_Global_Refresh_Lock);

    $("input.pagingSize").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        max: 100,
        min: 1
    });

    if (pageNo_G > 0 && pageSize_G > 0) {
        $('#txtPageSize').val(pageSize_G)
        $('#hdnPageNo').val(pageNo_G)
    }
    else {
        $('#txtPageSize').val('10')
        $('#hdnPageNo').val('1')
    }

    ChangeLabelName();
    BindTitleLabel(true);
    $("#ddlTitle_Search_List").val(searchCodes_G.split(','))[0].sumo.reload();
    BindTitleGridview();
});

function ChangeLabelName() {
    var lblLicensor = document.getElementById('lblLicensor');
    if (lblLicensor != null) {
        if (roleCode_G == Role_Assignment)
              //lblLicensor.innerHTML = "Assignor";
            lblLicensor.innerHTML = ShowMessage.lblForAssignor;//lblForAssignor = Assignor

            else if (roleCode_G == Role_License)
                 //lblLicensor.innerHTML = "Licensor";
            lblLicensor.innerHTML = ShowMessage.lblForLicensor;//lblForLicensor = Licensor

    else if (roleCode_G == Role_Own_Production)
    //lblLicensor.innerHTML = "Producer/ Line Producer";
            lblLicensor.innerHTML = ShowMessage.lblForProducerLineProducer;//lblForProducerLineProducer = Producer / Line Producer
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

    if (!ValidatePageSize())
        return false;

    var pageNo = page_index + 1
    $('#hdnPageNo').val(pageNo);
    if (IsCall == 'Y')
        BindTitleGridview();
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

    return false
}
function txtPageSize_OnChange() {
    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");

    if (!ValidatePageSize())
        return false;
    var pageSize = parseInt($('#txtPageSize').val());

    BindTitleGridview();
    SetPaging();
}
function BindTitleLabel(bindSearch) {
    if (dealTypeCode_G > 0) {
        $.ajax({
            type: "POST",
            url: URL_BindTitleLabel,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                dealTypeCode: dealTypeCode_G
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

function hideStarCast() {
    debugger
    $('.MoreActionDiv').hide('slow');
}
function BindTitleGridview() {
    var pageNo = $('#hdnPageNo').val();
    var recordPerPage = $('#txtPageSize').val();
    $.ajax({
        type: "POST",
        url: URL_BindTitleGridview,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            dealTypeCode: dealTypeCode_G,
            masterDealMovieCode: masterDealMovieCode_G,
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
    initializeExpander();
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

    if (!ValidatePageSize())
        return false;

    var arrSelectedTitles = $("#ddlTitle_Search_List").val();
    titleCodes = arrSelectedTitles.join(',');
    if (arrSelectedTitles != null)
        SearchTitle(titleCodes);
        else
            //showAlert("E", "Please select atleast one title", 'ddlTitle_Search_List')
        showAlert("E", ShowMessage.MsgForSelectTitle, 'ddlTitle_Search_List')//MsgForSelectTitle = Please select atleast one title
}
function SearchTitle(titleCode) {
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
                    BindTitleLabel(false);
                }
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}
function ValidateSave() {
    debugger;
    showLoading();
    if (dealMode_G == 'APRV') {
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
                else {
                    Isvalid = true;
                }
            },
            error: function (result) {
                Isvalid = false;
            }
        });
    }

    hideLoading();
    var tabName = $('#hdnTabName').val()
    BindPartialTabs(tabName);
    return false;
}