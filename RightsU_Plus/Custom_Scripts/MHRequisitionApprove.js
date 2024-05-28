function addNumeric() {
    $(".pagingSize").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        max: 99,
        min: 1
    });
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

    var index = pageNo - 1;
    $('#hdnPageNo').val(pageNo);

    var opt = null;
    opt = { callback: pageselectCallback };
    opt["items_per_page"] = recordPerPage;
    opt["num_display_entries"] = pagePerBatch;
    opt["num"] = 10;
    opt["prev_text"] = "<<";
    opt["next_text"] = ">>";
    opt["current_page"] = index;
    $("#Pagination").pagination(recordCount, opt);
}
function pageselectCallback(page_index, jq) {
    debugger;

    if (!ValidatePageSize())
        return false;

    var pageNo = page_index + 1
    $('#hdnPageNo').val(pageNo);
    if (IsCall == 'Y') {
        if ($('#hdnMHRequestTypeCode').val() == "1") {
            SaveMHRequestDetails_List();
        } else {
            BindMHRequestDetails_List(0, "")
        }

    }
    else
        IsCall = 'Y';

}
function txtPageSize_OnChange() {
    debugger;
    $("[required='required']").removeAttr("required");
    $('.required').removeClass('required');

    if (!ValidatePageSize())
        return false;

    if ($('#hdnMHRequestTypeCode').val() == "1") {
        SaveMHRequestDetails_List();
    } else {
        BindMHRequestDetails_List(0, "")
    }
    //BindMHRequestDetails_List(0, "")
    SetPaging();
}
function ValidatePageSize() {
    var recordPerPage = $('#txtPageSize').val()
    if ($.trim(recordPerPage) != '') {
        var pageSize = parseInt(recordPerPage);
        if (pageSize > 0)
            return true;
    }
    $('#txtPageSize').attr('required', true)
    return false
}
function btnSearch_OnClick() {

    $('.required').removeClass('required');
    $("[required='required']").removeAttr("required");

    if (!ValidatePageSize())
        return false;

    $('#hdnPageNo').val(1);
    var searchText = $.trim($('#searchCommon').val());

    if (searchText == '') {
        $('#searchCommon').val('')
        $('#searchCommon').attr('required', true)
        return false;
    }
    SearchMHRequestDetails(searchText);
}
function btnShowAll_OnClick() {
    debugger;
    if (!ValidatePageSize())
        return false;

    $('#hdnPageNo').val(1);
    $('#searchCommon').attr('required', false)
    $('#searchCommon').val('');
    SearchMHRequestDetails("");
}
function BindMHRequestDetails_List(MHRequestDetailsCode, commandName) {
    debugger;
    var pageNo = $('#hdnPageNo').val();
    var recordPerPage = $('#txtPageSize').val();
    var MHRequestTypeCode = $('#hdnMHRequestTypeCode').val();
    var Status = $('#hdnStatus').val();
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_BindMHRequestDetails_List,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        data: JSON.stringify({
            pageNo: pageNo,
            recordPerPage: recordPerPage,
            MHRequestDetailsCode: MHRequestDetailsCode,
            commandName: commandName,
            MHRequestTypeCode: MHRequestTypeCode,
            Status: Status
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                $('#divMHRequestDetails_List').empty();
                $('#divMHRequestDetails_List').html(result);
                initializeExpander();
                initializeTooltip();
                hideLoading();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}
function SearchMHRequestDetails(searchText) {
    debugger;
    $("#searchCommon").val(searchText);
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_SearchMHRequestDetails,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            searchText: searchText,
            tabName: $('#hdnTabName').val()
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                $('#hdnPageNo').text(1);
                $('#lblRecordCount').text(result.Record_Count);
                $("#hdnRecordCount").val(result.Record_Count);
                SetPaging()
                BindMHRequestDetails_List(0, "");
                hideLoading();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}
function SaveMHRequestDetails_List() {
    debugger
    var returnVal = true;
    $('.required').removeClass('required');
    var i = $("#tblConsume tr:nth-child(1) td:first").text().trim();
    var lstCML = new Array();
    var tblConsume = $("#tblConsume tr:not(:has(th))");

    tblConsume.each(function () {
        debugger
        var _MHRDCode = 0, _remarks = "", _isApprove;
        _MHRDCode = parseInt($("#hdnMHRD_" + i).val());
        _remarks = $('#MHRDRemarks_' + i).val();
        _isApprove = $('#chkCreateNewOther_' + i).prop("checked");

        lstCML.push({
            MHRDCode: _MHRDCode, Remarks: _remarks, IsApprove: _isApprove
        });
        i++;
    });

    if (lstCML.length > 0) //recordEffectedCount > 0 ||  length > 0 ||
    {
        $.ajax({
            type: "POST",
            url: URL_SaveMHRequestDetails_List,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                lstCML: lstCML
            }),
            async: false,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    if (result == "S")
                        BindMHRequestDetails_List(0, "")
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
    return returnVal;
}

lstRequestDetails = [{ MHRequestDetailCode: '', MusicTitleCode: '', TitleCode: '', Remarks: '', Status: '' }];

function FinalApprove(Is_Approve) {
    debugger;
    var atLeastOneIsChecked = $('input[name="chkType"]:checked');
    var NotChecked = $('input[name="chkType"]:not(:checked)');

    if (atLeastOneIsChecked.length == 0) {
        showAlert("E", "Please select atleast one record");
        return false;
    }
    else {
        if (NotChecked.length > 0 && atLeastOneIsChecked.length > 0) {
            if (Is_Approve == 'A')
                Is_Approve = 'PA';
            else
                Is_Approve = 'PR';
        }
        for (var i = 0; i < atLeastOneIsChecked.length; i++) {
            var id = atLeastOneIsChecked[i].id;
            var MHRequestDetailCode = id.replace('chk_', '');
            var MusicTitleCode = $('#' + id.replace('chk_', 'hdnMusicTitleCode_')).val();
            var TitleCode = $('#' + id.replace('chk_', 'hdnMusicTitleCode_')).val();
            var txtRemark = ($('#' + id.replace('chk_', 'txtRemark_')).val()).trim();
            var IsApprove = $('#' + id.replace('chk_', 'hdnIsApprove_')).val();

            var CreateMap = $('#' + id.replace('chk_', 'hdnCreateMap_')).val();
            if (CreateMap == '' && (MusicTitleCode != '' || TitleCode != '')) {
                CreateMap = 'M';
            }
            debugger;
            if ($('#' + id.replace('chk_', 'hdnMusicTitleCode_')).val() == '' && Is_Approve != 'PR' && Is_Approve != 'R') {
                if (!$('#' + id.replace('chk_', 'MapToExsisting_')).prop('disabled')) {
                    $('#' + id.replace('chk_', 'MapToExsisting_')).addClass("required");
                    return false;
                }
            }
            else {
                $('#' + id.replace('chk_', 'MapToExsisting_')).removeClass("required");
                lstRequestDetails.push({
                    MHRequestDetailCode: MHRequestDetailCode,
                    MusicTitleCode: MusicTitleCode,
                    MusicAlbumCode: TitleCode,
                    Remarks: txtRemark,
                    Status: IsApprove,
                    CreateMap: CreateMap
                })
            }
        }
        lstRequestDetails.splice(0, 1);
        var SpecialInst = $('#txtSpecialInst').val();
        $.ajax({
            type: "POST",
            url: URL_FinalMovieMusicApprove,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                lstRequestDetails: lstRequestDetails,
                SpecialInstruction: SpecialInst,
                MHRequestCode: $('#hdnMHRequestCode').val(),
                IsApprove: Is_Approve,
                Type: $('#hdnType').val()
            }),
            async: false,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    BindPartialView("LIST", 0);
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
}

function finalConsApprove(key) {
    debugger;
    SaveMHRequestDetails_List();
    var SpecialInst = $('#txtSpecialInst').val();
    var MHRequestCode = $('#hdnMHRequestCode').val();
    $.ajax({
        type: "POST",
        url: URL_finalConsApprove,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            SpecialInst: SpecialInst,
            MHRequestCode: MHRequestCode,
            key: key
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result.Status == "S") {
                    showAlert("S", result.Message);
                    BindPartialView("LIST", 0);
                }
                else if (result.Status == "E") {
                    showAlert("E", result.Message);
                }
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}

function checkAll() {
    var IsCheck = $('#chkAll').prop("checked");
    $('.checkboxAll').prop('checked', IsCheck);
    if ($('#chkAll').prop("checked")) {
        var x = document.getElementsByClassName("checkboxAll"); x;
        var i;
        for (i = 0; i < x.length; i++) {
            selectCurrent(x[i].id);
        }
    }
}
function selectCurrent(chkBox) {
    debugger;
    if ($('.checkboxAll:checked').length == $('.checkboxAll').length) {
        $("#chkAll").prop("indeterminate", false);
        $('#chkAll').prop('checked', true);
    } else {
        if ($('.checkboxAll:checked').length > 0) {
            $("#chkAll").prop("indeterminate", true);
        }
        else { $("#chkAll").prop("indeterminate", false); }
        $('#chkAll').prop('checked', false);
    }
    var IsCheck = $(this).prop('checked');
};
function countChar(val) {
    var max = 500;
    var len = val.val().length;

    if (len >= max)
        val.val(val.val().substring(0, max));

    $('.charNum').text(val.val().length.toString() + '/' + max.toString());
}