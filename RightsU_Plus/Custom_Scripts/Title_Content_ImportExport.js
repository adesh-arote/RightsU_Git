$(document).ready(function () {
    $("#btnSearch").on("click", function () {
        debugger;
        $('.required').removeClass('required');
        $("[required='required']").removeAttr("required");

        var searchText = $.trim($('#searchCommon').val());
        var episodeFrom = $.trim($('#txtEpisodeFrom').val());
        var episodeTo = $.trim($('#txtEpisodeTo').val());

        var returnVal = true;

        if (searchText == '') {
            $('#searchCommon').attr('required', true)
            returnVal = false;
        }
        if (episodeFrom == '') {
            $('#txtEpisodeFrom').attr('required', true)
            returnVal = false;
        }
        if (episodeTo == '') {
            $('#txtEpisodeTo').attr('required', true)
            returnVal = false;
        }

        if (parseInt(episodeFrom) > parseInt(episodeTo)) {
            $('#txtEpisodeTo').addClass('required');
            showAlert("E", "Episode From cannot be greater then Episode To");
            returnVal = false;
        }

        if (returnVal)
            SearchProgram(false, searchText, episodeFrom, episodeTo);
        else
            return false;
    });
    $("#searchCommon").on("keyup", function () {
        debugger;
        var selectedtxt = $('#searchCommon').val()
        var txt = selectedtxt.split('﹐');
        var iscomplete = true;
        if (txt[txt.length - 1].trim() == "")
            iscomplete = false;
        if (iscomplete) {
            $("#searchCommon").autocomplete({
                focus: function () {
                    // prevent value inserted on focus
                    return false;
                },
                search: function (e, u) {
                    $(this).addClass('loader');
                },
                source: function (request, response) {
                    var param = {
                        searchPrefix: $('#searchCommon').val()
                    };
                    $.ajax({
                        url: URL_PopulateContent,
                        data: JSON.stringify(param),
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataFilter: function (data) { return data; },
                        success: function (data) {
                            response($.map(data, function (v, i) {
                                $('#searchCommon').removeClass('loader');
                                return {
                                    label: v.Content_Name,
                                    val: v.Content_Name
                                }
                            }))
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            alert("Error" + textStatus);
                        }
                    });
                },
                select: function (event, i) {
                    var text = this.value.split(/﹐\s*/);
                    text.pop();
                    text.push(i.item.value);
                    text.push("");
                    this.value = text;
                    this.value = text.join("﹐");
                    return false;
                },
                minLength: 2,
                open: function (event, ui) {
                    $(".ui-autocomplete").css("position", "absolute");
                    $(".ui-autocomplete").css("max-height", "200px");
                    $(".ui-autocomplete").css("overflow-y", "auto");
                    $(".ui-autocomplete").css("overflow-x", "hidden");
                    $(".ui-autocomplete").css("z-index", "2147483647");
                },

            });
        }
        else
            return false;
    });
});

function addNumeric() {
    $(".pagingSize").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: false,
        max: 999,
        min: 1
    });
}

function txtPageSize_OnChange(txtID) {
    debugger;
    $("[required='required']").removeAttr("required");
    $('.required').removeClass('required');
    if (!ValidatePageSize(txtID))
        return false;

    if (txtID == "txtPageSize") {
        BindProgramList();
        SetPaging("LIST_PAGE");
    }
    else if (txtID == "txtPageSizePopup") {
        BindMusicTrackList();
        SetPaging("MUSIC_TRACK_POPUP");
    }
}
function setDefaultPaging(txtId) {
    debugger
    var pageSize = $('#' + txtId).val();
    if (pageSize < 1 || pageSize == "") {
        $('#' + txtId).val('10');
        if (txtId == "txtPageSize") {
            BindProgramList();
            SetPaging("LIST_PAGE");
        }
        else if (txtId == "txtPageSizePopup") {
            BindMusicTrackList();
            SetPaging("MUSIC_TRACK_POPUP");
        }
    }
}


function ValidatePageSize(txtID) {
    var recordPerPage = $('#' + txtID).val()
    if ($.trim(recordPerPage) != '') {
        var pageSize = parseInt(recordPerPage);
        if (pageSize > 0)
            return true;
    }
    $('#' + txtID).attr('required', true)

    return false
}

function BindProgramList(changeMu) {
    debugger;
    var pageNo = $('#hdnPageNo').val();
    var recordPerPage = $('#txtPageSize').val();
    var titleContentCode = 0;
    if (changeMu != 'Y')
        titleContentCode = $('#hdnTitleContentCode').val();
    $.ajax({
        type: "POST",
        url: URL_BindProgramList,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        data: JSON.stringify({
            pageNo: pageNo,
            recordPerPage: recordPerPage,
            contentCodeForEdit: titleContentCode,
            Is_BulkImportExport: "Y"
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            $('#dvMusic_Program_List').html(result);
            addNumeric();
            initializeTooltip();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}

function SearchProgram(onLoad, searchText, episodeFrom, episodeTo, changeMu) {
    debugger;
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_SearchProgram,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            searchText: searchText,
            episodeFrom: episodeFrom,
            episodeTo: episodeTo
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (changeMu != 'Y') {
                    $('#hdnPageNo').text(1);
                    $('#lblRecordCount').text(result.Record_Count);
                    $("#hdnRecordCount").val(result.Record_Count);
                }
                if (result.Record_Count <= 0 && !onLoad)
                    showAlert("E", "Record not found");
                SetPaging("LIST_PAGE");
                BindProgramList(changeMu);
                hideLoading();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}
function SetPaging(callFor) {
    debugger;
    IsCall = 'N';

    var pageNo = 1, recordCount = 0, pagePerBatch = 0, recordPerPage = 0;
    if (callFor == "LIST_PAGE") {
        pageNo = parseInt($('#hdnPageNo').val());
        recordCount = parseInt($('#hdnRecordCount').val());
        pagePerBatch = parseInt($('#hdnPagePerBatch').val());
        recordPerPage = parseInt($('#txtPageSize').val());
    }
    else if (callFor == "MUSIC_TRACK_POPUP") {
        pageNo = parseInt($('#hdnPageNoPopup').val());
        recordCount = parseInt($('#hdnRecordCountPopup').val());
        pagePerBatch = parseInt($('#hdnPagePerBatchPopup').val());
        recordPerPage = parseInt($('#txtPageSizePopup').val());
    }

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
    var opt = null;
    if (callFor == "LIST_PAGE") {
        $('#hdnPageNo').val(pageNo);
        opt = { callback: pageselectCallback };
    }
    else if (callFor == "MUSIC_TRACK_POPUP") {
        $('#hdnPageNoPopup').val(pageNo);
        opt = { callback: pageselectCallback_Popup };
    }
    opt["items_per_page"] = recordPerPage;
    opt["num_display_entries"] = pagePerBatch;
    opt["num"] = 10;
    opt["prev_text"] = "<<";
    opt["next_text"] = ">>";
    opt["current_page"] = index;

    if (callFor == "LIST_PAGE")
        $("#Pagination").pagination(recordCount, opt);
    else if (callFor == "MUSIC_TRACK_POPUP") {
        $("#PaginationPopup").pagination(recordCount, opt);
    }
}
function pageselectCallback(page_index, jq) {
    $('.required').removeClass('required');

    if (!ValidatePageSize('txtPageSize'))
        return false;

    var pageNo = page_index + 1
    $('#hdnPageNo').val(pageNo);
    if (IsCall == 'Y')
        BindProgramList();
    else
        IsCall = 'Y';
}
function pageselectCallback_Popup(page_index, jq) {
    var pageNo = page_index + 1
    $('#hdnPageNoPopup').val(pageNo);
    if (IsCall == 'Y')
        BindMusicTrackList();
    else
        IsCall = 'Y';
}