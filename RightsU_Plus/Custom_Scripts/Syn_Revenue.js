var tmp_pageNo = 0;
$(document).ready(function () {
    $('.modal').modal({
        backdrop: 'static',
        keyboard: false,
        show: false
    })
    initializeExpander();
    initializeTooltip();

    $('#lblTotalFixedDealCost').text(TotalFixedDealCost_G);
    LoadSynDealRevenue(0, 'Y');

    $("#txtCurrencyExchangeRate").numeric({
        allowMinus: false,
        allowThouSep: false,
        allowDecSep: true,
        maxPreDecimalPlaces: 10,
        maxDecimalPlaces: 3
    });

    $('#btnSaveDeal,#btnSaveApproveDeal').click(function () {
        if ($(this).val().toUpperCase() == "SAVE & APPROVE") {
            $('input[name=hdnReopenMode]').val('RO');
        }
        else {
            $('input[name=hdnReopenMode]').val('E');
        }
    });
    if (Record_Locking_Code_G > 0) {
        var fullUrl = Refresh_Lock_Full_URL;
        Call_RefreshRecordReleaseTime(Record_Locking_Code_G, fullUrl);
    }
});
var tmp_AcqDealCostCode, CommandName;
var tmp_acqDealCostTypeCode, tmp_rowIndex;

function DeleteCost(Acq_Deal_Cost_Code) {
    if ($('#txtPageSize').val() != "") {
        CommandName = "Cost";
        tmp_AcqDealCostCode = Acq_Deal_Cost_Code;

        showAlert("I", ShowMessage.AreyousureyouwanttodeletethisRevenue, "OKCANCEL");
    }
}

function handleOk() {

    if (CommandName == "Cost") {
        showLoading();
        $.ajax({
            type: "POST",
            url: DeleteRecord_URL,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                costCodeId: tmp_AcqDealCostCode
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                } else {
                    hideLoading();
                    if (result.Message == "Y") {
                        showAlert('S', ShowMessage.Revenuedeletedsuccessfully);
                        LoadSynDealRevenue(tmp_pageNo, 'N');
                        $('#lblTotalFixedDealCost').text(result.TotalFixedDealCost);
                    } else {
                        showAlert('error', ShowMessage.ThisFixedFees);
                        return false;
                    }
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }

        });
    } else if (CommandName == "CostType") {
        $.ajax({
            type: "POST",
            url: DeleteCostType_URL,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            dataType: "html",
            data: JSON.stringify({
                AcqDealCostTypeCode: tmp_acqDealCostTypeCode,
                rowIndex: tmp_rowIndex
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                } else {
                    $('#tabCostHead').html(result);
                    initializeChosen();
                    initializeTooltip();
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    } else if (CommandName == "AddExp") {
        showLoading();
        $.ajax({
            type: "POST",
            url: DeleteAdditionalExpense_URL,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            dataType: "html",
            data: JSON.stringify({
                rowIndex: tmp_rowIndex
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                } else {
                    $('#tabAdditionalExp').html(result);
                    initializeChosen();
                    initializeTooltip();
                    hideLoading();
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    } else if (CommandName == "StdRet") {
        showLoading();
        $.ajax({
            type: "POST",
            url: DeleteStandardReturns_URL,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            dataType: "html",
            data: JSON.stringify({
                rowIndex: tmp_rowIndex
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                } else {
                    $('#tabStdReturns').html(result);
                    initializeChosen();
                    initializeTooltip();
                    hideLoading();
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
    else if (CommandName == "CANCEL_SAVE_DEAL") {
        location.href = Cancel_Revenue_URL;
    }
    else if (CommandName == "SV") {
        if ($('#hdnTabName').val() == '') {
            window.location.href = Index_SL_URL;
        }
    }

}

function handleCancel() { }

function ValidateSave() {
    if ($('#txtPageSize').val() != "") {
        showLoading();
        var Isvalid = true;
        // Code for Maintaining approval remarks in session        
        if (Mode_RG == 'APRV') {
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
                    Isvalid = true;
                },
                error: function (result) {
                    Isvalid = false;
                }
            });
        } else
            Isvalid = true;
        if (Mode_RG == dealMode_View || Mode_RG == 'APRV') {
            hideLoading();
            var tabName = $('#hdnTabName').val();
            BindPartialTabs(tabName);
        }
        hideLoading();
        //Code end for approval
        return Isvalid;
    }
}

function RemoveReqClass() {
    $('.required').removeClass('required');
}

function LoadSynDealRevenue(pagenumber, isLoad) {
    showLoading();
    if (pagenumber < 0) {
        pagenumber = 0;
    }
    var txtPageSize = 10;
    if (isLoad == "N") {
        if ($('#txtPageSize') != null || $('#txtPageSize') != '')
            txtPageSize = parseInt($('#txtPageSize').val());
    }
    tmp_pageNo = pagenumber;

    $.ajax({
        type: "POST",
        url: BindGridSynDealRevenue_URL,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        data: JSON.stringify({
            txtPageSize: txtPageSize,
            page_No: pagenumber
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            } else {
                $('#dvDealSynRevenueList').html(result);
                initializeTooltip();
                hideLoading();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}

function UpdateCurrExRate() {
    RemoveReqClass();
    var strVal = $('#txtCurrencyExchangeRate').val()
    $('#hdnCurrencyExchangeRate').val(strVal);
}

function AddEditRevenue(SynDealRevenueCode, CommandName) {
    if ($('#txtPageSize').val() != "") {
        $('#txtCurrencyExchangeRate').removeClass('required');

        if ($('#txtCurrencyExchangeRate').val() == "" && CommandName != "View") {
            $('#txtCurrencyExchangeRate').attr('required', true);
            return false;
        } else if ($('#txtCurrencyExchangeRate').val() != "" && parseFloat($('#txtCurrencyExchangeRate').val()) == 0 && CommandName != "View") {
            $('#txtCurrencyExchangeRate').addClass('required', true);
            return false;
        } else {
            showLoading();
            var txtExchangeRate = $('#txtCurrencyExchangeRate').val();
            $.ajax({
                type: "POST",
                url: PartialAddEditDealCost_URL,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                dataType: "html",
                data: JSON.stringify({
                    SynDealRevenueCode: SynDealRevenueCode,
                    ExchangeRate: txtExchangeRate,
                    CommandName: CommandName
                }),
                success: function (result) {
                    if (result == "true") {
                        redirectToLogin();
                    } else {
                        hideLoading();
                        $('#dvSynDealRevenueList').html(result);
                        $('#popAddEditRevenue').modal();
                        initializeChosen();
                        initializeTooltip();
                    }
                },
                error: function (result) {
                    alert('Error: ' + result.responseText);
                }

            });
        }
    }
}


function Save_Success(message) {
    debugger;
    hideLoading();
    if (message == "true") {
        redirectToLogin();
    }
    else {
        if (message.Success_Message != "") {
            CommandName = "SV"
            showAlert('S', message.Success_Message, 'OK');
        }
        else {
            debugger;
            var tabName = $('#hdnTabName').val();
            BindPartialTabs(tabName);
        }
    }
    if (message.Status == "SA") {
        debugger;
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
                //alert('Save_Success_Revenue');
            }
        });
    }
    hideLoading();
    return false;
}

function CancelSaveDeal() {
    CommandName = "CANCEL_SAVE_DEAL";
    showAlert("I", ShowMessage.Allunsaved, "OKCANCEL");
}
