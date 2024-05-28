$(document).ready(function () {
    $('#ddlTitle_Search_List').SumoSelect();
    var dealmode = Dealmode_SG_G;
    if (dealmode == 'APRV') {
        if (Record_Locking_Code_SG_G > 0) {
            var fullUrl = Refresh_Lock_SG_URL;
            Call_RefreshRecordReleaseTime(Record_Locking_Code_SG_G, fullUrl);
        }
    }

    $("input.pagingSize").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        max: 100,
        min: 1
    });

    if (General_PageNo_G > 0 && General_PageSize_G > 0) {
        $('#txtPageSize').val(General_PageSize_G)
        $('#hdnPageNo').val(General_PageNo_G)
    }
    else {
        $('#txtPageSize').val('10')
        $('#hdnPageNo').val('1')
    }

    BindTitleLabel(true);
    var searchCodes = General_Search_Title_Codes_G;
    $("select#ddlTitle_Search_List").val(searchCodes.split(','))[0].sumo.reload();
    BindTitleGridview();
});
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
    var dealTypeCode = Deal_Type_Code_G;
    if (dealTypeCode > 0) {
        $.ajax({
            type: "POST",
            url: BindTitleLabel_URL,
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

function BindTitleGridview() {
    var pageNo = $('#hdnPageNo').val();
    var dealTypeCode = Deal_Type_Code_G;
    var recordPerPage = $('#txtPageSize').val();
    $.ajax({
        type: "POST",
        url: BindTitleGridview_URL,
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
        showAlert("E", ShowMessage.Pleaseselectatleastonetitle, 'ddlTitle_Search_List')
}

function SearchTitle(titleCode) {
    $.ajax({
        type: "POST",
        url: SearchTitle_URL,
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
    showLoading();
    var Mode = Dealmode_SG_G;
    if (Mode == 'APRV') {
        var approvalremarks = $('#approvalremarks').val();
        $.ajax({
            type: "POST",
            url: SetSynApprovalRemarks_URL,
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