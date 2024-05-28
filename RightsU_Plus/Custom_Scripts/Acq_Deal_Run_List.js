var validateSaveCalledManually = false;
$(document).ready(function () {
    showLoading();
    if (recordLockingCode_G > 0)
        Call_RefreshRecordReleaseTime(recordLockingCode_G, URL_Global_Refresh_Lock);

    $('#optGroup').click(function () {
        $('#divChGroup').show();
        $('#divChIndividual').hide();
    });
    $('#optIndividual').click(function () {
        $('#divChGroup').hide();
        $('#divChIndividual').show();
    });
    $('#rdoCountry').click(function () {
        $('#divCountry').show();
        $('#divTerritory').hide();
    });
    $('#rdoTerritory').click(function () {
        $('#divTerritory').show();
        $('#divCountry').hide();
    });
    $('#rdoDubSingle').click(function () {
        $('#divDubSingle').show();
        $('#divDubGrp').hide();
    });
    $('#rdoDubGroup').click(function () {
        $('#divDubGrp').show();
        $('#divDubSingle').hide();
    });
    $('#rdoSubSingle').click(function () {
        $('#divSubSingle').show();
        $('#divSubGrp').hide();
    });
    $('#rdoSubGroup').click(function () {
        $('#divSubGrp').show();
        $('#divSubSingle').hide();
    });

    /**/
    $('#rdoCountryHB').click(function () {
        $('#divCountryHB').show();
        $('#divTerritoryHB').hide();
    });
    $('#rdoTerritoryHB').click(function () {
        $('#divTerritoryHB').show();
        $('#divCountryHB').hide();
    });
    $('#rdoDubSingleHB').click(function () {
        $('#divDubSingleHB').show();
        $('#divDubGrpHB').hide();
    });
    $('#rdoDubGroupHB').click(function () {
        $('#divDubGrpHB').show();
        $('#divDubSingleHB').hide();
    });
    $('#rdoSubSingleHB').click(function () {
        $('#divSubSingleHB').show();
        $('#divSubGrpHB').hide();
    });
    $('#rdoSubGroupHB').click(function () {
        $('#divSubGrpHB').show();
        $('#divSubSingleHB').hide();
    });

    setChosenWidth('#Channel_Cluster', '55%');

    if (meesage_G != '') {
        showAlert('S', meesage);
        $.ajax({
            type: "POST",
            url: URL_ResetMessageSession,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            async: false,
            data: JSON.stringify({}),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }

    //$("select#Title_Code.form_input.chosen-select").val(arrRunTitles_G).trigger('chosen:updated');

    // using default options
    $('#txtPageSize').numeric({
        max: 100
    });
    $('#txtPageSize').val(runPageSize_G);
    LoadGrid(runPageNo_G);
    if ($('#Pagination'))
        SetPaging();
});
function DealType(obj2) {
    if (obj2.value == "1") {
        document.getElementById("subDealMovie").style.display = '';
        document.getElementById("movieSearchBand").style.display = '';
        document.getElementById("optDealFor").style.display = '';
        document.getElementById("optDealFor2").style.display = 'none';
    }
    if (obj2.value == "2") {
        document.getElementById("subDealMovie").style.display = 'none';
        document.getElementById("movieSearchBand").style.display = 'none';
        document.getElementById("optDealFor").style.display = 'none';
        document.getElementById("optDealFor2").style.display = '';
    }
}
function ModeAcquisition(obj) {
    if (obj.value == "1") {
        document.getElementById("showAcquisition").innerHTML = "Assignor";
    }
    if (obj.value == "2") {
        document.getElementById("showAcquisition").innerHTML = "Licensor";
    }
    if (obj.value == "3") {
        document.getElementById("showAcquisition").innerHTML = "Producer/ Line Producer";
    }
}
function DealFor(obj3) {
    if (obj3.value == "1") {
        document.getElementById("subDealMovie").style.display = '';
        document.getElementById("movieSearchBand").style.display = '';
        document.getElementById("subDealProgram").style.display = 'none';
        document.getElementById("ProgramSearchBand").style.display = 'none';
        document.getElementById("ddlOtherFor").disabled = false;
    }
    if (obj3.value == "2") {
        document.getElementById("subDealMovie").style.display = 'none';
        document.getElementById("movieSearchBand").style.display = 'none';
        document.getElementById("subDealProgram").style.display = '';
        document.getElementById("ProgramSearchBand").style.display = '';
        document.getElementById("ddlOtherFor").disabled = false;
    }
    if (obj3.value == "3") {
        document.getElementById("subDealMovie").style.display = 'none';
        document.getElementById("movieSearchBand").style.display = 'none';
        document.getElementById("subDealProgram").style.display = 'none';
        document.getElementById("ProgramSearchBand").style.display = 'none';
        document.getElementById("ddlOtherFor").disabled = true;
    }
}
function showOverflow(obj2) {
    if (obj2.value == "1" || obj2.value == "3") {
        document.getElementById("RevenueSharing").style.display = 'none';
    }
    if (obj2.value == "2") {
        document.getElementById("RevenueSharing").style.display = '';
    }
}
function searchClick() {
    debugger;

    //showAlert('E', 'Select title to search');


    if ($("#Title_Code1").val() != null || $('#lbChannelCluster').val() != "0" || $('#lbChannel').val() != null)
        LoadGrid(0);
    else
        showAlert('E', 'Select atleast One of the above search Criteria.');
      
}
function showAllClick() {
    debugger;
    $('#Title_Code1')[0].sumo.unSelectAll();
    $('#lbChannel')[0].sumo.unSelectAll();
    $("#lbChannelCluster").val('').trigger("chosen:updated");
    LoadGrid(0); 
}
function ValidateAdd() {
    if (isRightsAdded_G == 'N') {
        showAlert("E", "Please add Rights first");
        hideLoading();
        return false;
    }
    else
        if (!ValidateSave()) {
            return false;
        }
        else {
            return true;
        }
}
function ValidateDelete(NoOfRunsScheduled, Acq_Deal_Run_Code) {

    if (parseInt(NoOfRunsScheduled) > 0) {
        showAlert("E", "Can not delete run defintion as reference exist in schedule.")
        return false;
    }
    else {
        $('#hdnCommandName').val('D');
        $('#Acq_Deal_Run_Code').val(Acq_Deal_Run_Code);
        showAlert('I', "Are you sure want to delete this Run Definition?", 'OKCANCEL');
    }
}
function handleOk() {
    if ($('#hdnCommandNameAllShow') != undefined || $('#hdnCommandNameAllShow').val() != "" || $('#hdnCommandNameAllShow') != null)
        var j = $('#hdnCommandNameAllShow').val().split(',');
    if ($('#hdnCommandName').val() == 'D') {
        showLoading();
        var acqDealRunCode = $('#Acq_Deal_Run_Code').val();
        $.ajax({
            type: "POST",
            url: URL_Delete,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                id: acqDealRunCode
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                LoadGrid(0);
                showAlert("S", "Run Definition Deleted Successfully.");
                hideLoading();
                $("#Title_Code1").empty();
                $(result.Title).each(function (index, item) {
                    $("#Title_Code1").append($("<option />").val(this.Value).text(this.Text));

                });
                $("#Title_Code1")[0].sumo.reload();
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
                hideLoading();
            }
        });
    }
    else if ($('#hdnCommandName').val() == 'SD') {
        location.href = URL_Cancel;
    }
    else if (j[0] == 'AllShow') {
        var control = j[1];
        DeleteData(control);
    }
    else if (j[0] == 'SaveShow') {
        SaveShow();
    }


}
function handleCancel() {
    $('#hdnCommandName').val('');
    if ($('#hdnCommandNameAllShow') != undefined || $('#hdnCommandNameAllShow').val() != "" || $('#hdnCommandNameAllShow') != null)
        var j = $('#hdnCommandNameAllShow').val().split(',');

    if (j[0] == 'SaveShow') {
        $('#' + j[1]).attr('checked', false);
    }
    $('#hdnCommandNameAllShow').val('');
}
function LoadGrid(page_index) {
    debugger;

    showLoading();
    var searchText = '', lbChannel = '';

    if ($("#Title_Code1").val() != null)
        searchText = $("#Title_Code1").val().join(',');

    if ($('#lbChannel').val() != null)
        lbChannel = $("#lbChannel").val().join(',');

    var txtPageSize = $('#txtPageSize').val();
    $.ajax({
        type: "POST",
        url: URL_BindRun,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        data: JSON.stringify({
            hdnTitleCode: searchText,
            PageNumber: page_index,
            PageSize: txtPageSize,
            lbChannel: lbChannel,
            lbChannelCluster : $('#lbChannelCluster').val()
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            $('#grdRun').html(result);
            SetPaging();
            initializeExpander();
            hideLoading();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}
function applyPaging() {
    if ($('#txtPageSize').val() == '' || parseInt($('#txtPageSize').val()) == 0) {
        $('#txtPageSize').addClass('required');
        return false;
    }
    else {
        LoadGrid(0);
    }
}
function pageBinding() {
    LoadGrid(0);
}
function ValidateSave() {
    showLoading();
    var Isvalid = true;
    // Code for Maintaining approval remarks in session
    if (dealMode_G == dealMode_Approve) {
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
                hideLoading();
            }
        });
    }
    else if (dealMode_G != dealMode_View) {
        //if ($("select#Channel_Cluster.form_input.chosen-select").val() != '0') {
        $.ajax({
            type: "POST",
            url: URL_SaveChannelCluster,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            async: true,
            data: JSON.stringify({
                Channel_Cluster_Code: $("select#Channel_Cluster.form_input.chosen-select").val()
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

    //Code end for approval
    if (Isvalid && !validateSaveCalledManually) {
        hideLoading();
        var tabName = $('#hdnTabName').val();
        BindPartialTabs(tabName);
    }
    else
        hideLoading();
    return Isvalid;
}
function SaveDeal() {
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
    // Code for Maintaining approval remarks in session
    if (dealMode_G != 'APRV') {

        $.ajax({
            type: "POST",
            url: URL_SaveChannelCluster,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            async: true,
            data: JSON.stringify({
                Channel_Cluster_Code: $("select#Channel_Cluster.form_input.chosen-select").val()
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                hideLoading();
                $('#hdnCommandName').val('SD');
                if (dealMode_G == 'E')
                    showAlert('S', 'Deal Updated Successfully', 'OK');
                else
                    showAlert('S', 'Deal Saved Successfully', 'OK');

                if (result.Status == "SA") {
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
            },
            error: function (result) {
                Isvalid = false;
            }
        });


    }

    return Isvalid;
}

//function CommitDeal() {
//    //showLoading();
//    if ($("#txtAcqRemarks").val() != "") {
//        var Isvalid = true;
//        $.ajax({
//            type: "POST",
//            url: URL_Commit,
//            traditional: true,
//            enctype: 'multipart/form-data',
//            contentType: "application/json; charset=utf-8",
//            data: JSON.stringify({
//                remarks: $("#txtAcqRemarks").val()
//            }),
//            async: false,
//            success: function (data) {
//                location.href = URL_Index
//            },
//            error: function (result) {
//                Isvalid = false;
//            }
//        });
//    }
//    else {
//        showAlert('E', 'Please Enter Remark');
//        Isvalid = false;
//    }
//    return Isvalid;
//}

function CancelSaveDeal() {
    $('#hdnCommandName').val('SD');
    showAlert("I", 'All unsaved data will be lost, still want to go ahead?', "OKCANCEL");
}
function ButtonEvents(id) {
    validateSaveCalledManually = true;
    if (ValidateAdd()) {
        $.ajax({
            type: "POST",
            url: URL_ButtonEvents,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            async: false,
            data: JSON.stringify({
                id: id
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    hideLoading();
                    BindPartialTabs(result.TabName);
                    $('#ddlPTitle').SumoSelect();
                    $('#ddlPTitle').each(function () {
                        $(this)[0].sumo.reload();
                    });
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }

    validateSaveCalledManually = false;
}