﻿$(document).on('keyup', 'textarea', function () {
    var count = $(this).val().length;
    if (this.id === "txt_Resolution_Remarks") {
        $("#spn_ResRemark").html(count + "/4000");
    }
    else {
        $("#spn_ObjRemark").html(count + "/4000");
    }
});

$("#popupFadeP").click(function (event) {
    event.stopPropagation();
});
function SetMaxDt() {
    setMinMaxDates('txtStart', '', $('#txtEnd').val());
}
function SetMinDt() {
    setMinMaxDates('txtEnd', $('#txtStart').val(), '');
}

function BindObjectionType(TypeCode = 0) {

    $.ajax({
        type: "POST",
        url: URL_BindObjectionType,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        success: function (result) {
            if (result === "true") {
                redirectToLogin();
            }
            else {

                $("#ddlObjType").empty();

                $("#ddlObjType").append($("<option>").val(""));
                var lstObj_Type_Group = result.lstObjType.map(item => item.Obj_Type_Group)
                    .filter((value, index, self) => self.indexOf(value) === index);

                $(lstObj_Type_Group).each(function (index, item) {
                    $("#ddlObjType").append('<optgroup label="' + item + '">');
                    $(result.lstObjType).each(function (index, itemOT) {
                        if (this.Obj_Type_Group === item) {
                            $("#ddlObjType").children('optgroup[label="' + item + '"]').append($("<option>").val(this.Code).text(this.Obj_Type_Name));
                        }
                    });
                });
            }
            if (TypeCode > 0) {
                $("#ddlObjType").val(TypeCode).trigger("chosen:updated");
            }
            else {
                $("#ddlObjType").trigger("chosen:updated");
            }
            $("#ddlObjType_chosen").css("width", "35%");
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}
function CountryTerritoryMapping(pCodes = "", mapFor = "") {

    var TitleCode = $("#hdnTitleCode").val();
    var RecordType = $("#hdnRecordType").val();
    var RecordCode = $("#hdnRecordCode").val();
    var Type = $("input[name='rb_CT']:checked").val();

    $.ajax({
        type: "POST",
        url: URL_BindCountryTerritory,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Type: Type,
            pCodes: pCodes,
            mapFor: mapFor,
            TitleCode: TitleCode,
            RecordType: RecordType,
            RecordCode: RecordCode
        }),
        async: false,
        success: function (result) {
            if (result === "true") {
                redirectToLogin();
            }
            else {
                $("#ddlCT").empty();
                $(result.lstCT).each(function (index, item) {
                    $("#ddlCT").append($("<option>").val(this.Value).text(this.Text));
                });
                $("#ddlCT")[0].sumo.reload();

                if (mapFor === "LP") {
                    $("#ddlLP").empty();
                    $("#ddlLP").append($("<option>").val("Please Select"));
                    $(result.lstLP).each(function (index, item) {
                        $("#ddlLP").append($("<option>").val(this.Value).text(this.Text));
                    });
                    $("#ddlLP").trigger("chosen:updated");
                }
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}
function ClosePopup(isView = "N") {
    if (isView === "N") {
        $('#pCount').text($('#Rights_PlatformplatformCnt').text());
        if ($('#pCount').text() != "0") {
            $('#txtStart,#txtEnd').val("").attr('required', false);
            CountryTerritoryMapping($("#hdnTVCodes").val(), "LP");
        }
    }
    $('#popupFadeP').hide('slow');
}

function SaveTitleObjection(TOC = 0) {
    debugger;
    if (!validateSave()) {
        return false;
    }

    var PlatformCodes = $("#hdnTVCodes").val();
    var CntTerr = $("input[name='rb_CT']:checked").val();
    var CTCodes = $("#ddlCT").val();
    var LPCodes = $("#ddlLP").val();
    var SD = $("#txtStart").val();
    var ED = $("#txtEnd").val();
    var ObjType = $("#ddlObjType").val();
    var ObjRemarks = $("#txt_Objection_Remarks").val().trim();
    var ResRemarks = $("#txt_Resolution_Remarks").val().trim();
    var Title_Status = $("#ddlTitle_Status").val();

    $.ajax({
        type: "POST",
        url: URL_SaveTitleObjection,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            PlatformCodes: PlatformCodes,
            CntTerr: CntTerr,
            CTCodes: CTCodes,
            LPCodes: LPCodes,
            SD: SD,
            ED: ED,
            ObjType: ObjType,
            ObjRemarks: ObjRemarks,
            ResRemarks: ResRemarks,
            TitleCode: $("#hdnTitleCode").val(),
            RecordType: $("#hdnRecordType").val(),
            RecordCode: $("#hdnRecordCode").val(),
            Title_Status: Title_Status,
            TOC: TOC
        }),
        async: false,
        success: function (result) {
            if (result === "true") {
                redirectToLogin();
            }
            else {
                if (result.Status === "S") {
                    showAlert("S", "Record saved successfully");
                    //var URL = '/Title_Objection_List';
                    //window.location.href = URL;
                    backToList();
                }
                else {
                    showAlert("E", "Combination Conflicts Other Title Objection");
                }
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}

function validateSave() {
    debugger;
    $("[required='required']").removeAttr("required");
    $('.required').removeClass('required');

    var isValid = true;

    var PlatformCodes = $("#hdnTVCodes").val();
    var CTCodes = $("#ddlCT").val();
    var LPCodes = $("#ddlLP").val();
    var SD = $("#txtStart").val();
    var ED = $("#txtEnd").val();
    var ObjType = $("#ddlObjType").val();
    var ObjRemarks = $("#txt_Objection_Remarks").val().trim();
    var ResRemarks = $("#txt_Resolution_Remarks").val().trim();


    if (PlatformCodes === "") {
        isValid = false;
        showAlert("E", "Please select atleast one platform.");
    }
    if (ObjType === "") {
        isValid = false
        $('#ddlObjType').attr('required', true);
    }
    if (ObjRemarks === "") {
        isValid = false;
        $('#txt_Objection_Remarks').val("").attr('required', true);
    }
    if (ResRemarks === "") {
        isValid = false;
        $('#txt_Resolution_Remarks').val("").attr('required', true);
    }
    if (SD === "") {
        isValid = false;
        $('#txtStart').attr('required', true);
    }
    if (ED === "") {
        $('#txtEnd').attr('required', true);
    }
    if (CTCodes === null) {
        isValid = false;
        $('#divddlCT').addClass('required');
    }
    if (LPCodes === "Please Select" || LPCodes === "") {
        isValid = false;
        $('#ddlLP').attr('required', true);
        $("#ddlLP").val("").trigger("chosen:updated");
    }

    return isValid;
}

function dateCheck(callFor, dateFrom, dateTo, dateCheck) {
    var c = dateCheck.split('/');
    var check = new Date(c[2], parseInt(c[1]) - 1, c[0]);

    var fDate, lDate, cDate;
    fDate = Date.parse(dateFrom);
    lDate = Date.parse(dateTo);
    cDate = Date.parse(check);

    if (cDate <= lDate && cDate >= fDate) {
        return true;
    }

    if (callFor === "Start Date") {
        $('#txtStart').val("").attr('required', true);
    }
    else {
        $('#txtEnd').val("").attr('required', true);
    }

    showAlert("E", callFor + " Should be between License Period");
    return false;
}