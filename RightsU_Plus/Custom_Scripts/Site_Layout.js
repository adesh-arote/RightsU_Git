$(document).ready(function () {
    bindApprovalList('A');
});
function Validate_Record_Site(dealCode, dealType) {
    debugger;
    var valid = true;
    var moduleCode = 30;
    if (dealType == "S")
        moduleCode = 35;
    else if (dealType == "M")
        moduleCode = 163;
    $.ajax({
        type: "POST",
        url: URL_Validate_Deal_Approve_List,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            dealCode: dealCode,
            moduleCode: moduleCode,
            usersCode: UsersCode_G
        }),
        success: function (result) {
            result = result.split('~');
            var Record_Locking_Code = result[1];
            if (Record_Locking_Code != 'undefined' && Record_Locking_Code > 0) {

                if (dealType == "A" || dealType == "S") {
                    dealType = dealType + '_';
                }

                var New_href = $('#' + dealType + dealCode).attr('href').replace("RecordLockingCode", Record_Locking_Code);
                $('#' + dealType + dealCode).attr('href', New_href);
            }
            if (result == "true") {
                redirectToLogin();
            }
            else {
                if (result[0] == 'S') {
                    valid = true;
                }
                else {
                    if (result[0].indexOf('approved') != -1) {
                        bindApprovalList(result[0]);
                        valid = false;
                        showAlert("E", result[0]);
                    }
                    else {
                        valid = false;
                        showAlert("E", result[0]);
                    }
                }
            }
        },
        error: function (result) { }
    });

    return valid;
}

function loadNavMenu(tabName, id) {
    $.ajax({
        type: "POST",
        url: URL_GetMenu,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            TabName: tabName
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                $("#" + id).html(result);
                initializeSubMenu();
                togglePanelVisibility(id);
            }
        },
        error: function (result) { }
    });
}
function searchApproveList() {
    debugger;
    var tabName = 'A';
    if ($("#liAcq").hasClass('active'))
    { tabName = 'A'; }
    if ($("#liSyn").hasClass('active'))
    { tabName = 'S'; }
    if ($("#liBoth").hasClass('active'))
    { tabName = 'B'; }
    bindApprovalList(tabName);
}
function bindApprovalList(TabName) {
    debugger;
    var common_search = $('#srchCommonAppr').val();
    $.ajax({
        type: "POST",
        url: URL_GetApprovalList,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            commonSearch: common_search
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                var strHTML = '', liClass = "acq", index = 0;
                for (var i = 0; i < result.length; i++) {
                    if (TabName == result[i].Type || TabName == 'B') {
                        if (result[i].Type == "A") {
                            var url = URL_Deal_For_Approval_Acq;
                            liClass = "acq";
                        }
                        else if (result[i].Type == "S") {
                            var url = URL_Deal_For_Approval_Syn;
                            liClass = "syn";
                        }
                        else {
                            var url = URL_Deal_For_Approval_Music;
                            liClass = "acq";
                        }
                        strHTML = strHTML + '<li class="' + liClass + '">'
                        strHTML = strHTML + '<a id =' + result[i].Type + result[i].Deal_Code + ' href="' + url.replace('Deal_Code', result[i].Deal_Code)
                            + '" onclick = "return Validate_Record_Site(' + result[i].Deal_Code + ',\'' + result[i].Type + '\')";><ul>'
                        strHTML = strHTML + '<li class="agreementNo">' + result[i].Agreement_No + '</li>'
                        strHTML = strHTML + '<li class="date">' + result[i].Last_Updated_Time + '</li>'
                        if (result[i].Vendor_Name.length > 30)
                            strHTML = strHTML + '<li>' + result[i].Vendor_Name.substring(0, 25) + "..." + '</li>'
                        else
                            strHTML = strHTML + '<li>' + result[i].Vendor_Name + '</li>'
                        if (result[i].Title_Name.length > 30)
                            strHTML = strHTML + '<li>' + result[i].Title_Name.substring(0, 25) + "..." + '</li>'
                        else
                            strHTML = strHTML + '<li>' + result[i].Title_Name + '</li>'

                        strHTML = strHTML + '</ul></a></li>'
                    }
                }
                $('#approvalCount').text(result.length);
                $('#review').html(strHTML);
            }
        },
        error: function (result) { }
    });
    $('.leftPanel > ul').height($(window).height() - 120);
}
