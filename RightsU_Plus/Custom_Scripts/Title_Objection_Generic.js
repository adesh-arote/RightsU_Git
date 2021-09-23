$(document).on('keyup', 'textarea', function () {
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
            if (TypeCode > 0) 
            {
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
function CountryTerritoryMapping() {
    

    var Type = $("input[name='rb_CT']:checked").val();

    $.ajax({
        type: "POST",
        url: URL_BindCountryTerritory,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            Type: Type
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
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
            hideLoading();
        }
    });
}
function ClosePopup() {
    $('#pCount').text($('#Rights_PlatformplatformCnt').text());
    $('#popupFadeP').hide('slow');
}

function SaveTitleObjection(TOC = 0) {

    var PlatformCodes = $("#hdnTVCodes").val();
    var CntTerr = $("input[name='rb_CT']:checked").val();
    var CTCodes = $("#ddlCT").val();
    var LPCodes = $("#ddlLP").val();
    var SD = $("#txtStart").val();
    var ED = $("#txtEnd").val();
    var ObjType = $("#ddlObjType").val();
    var ObjRemarks = $("#txt_Objection_Remarks").val();
    var ResRemarks = $("#txt_Resolution_Remarks").val();
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
                    var URL = '/Title_Objection_List';
                    window.location.href = URL;
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