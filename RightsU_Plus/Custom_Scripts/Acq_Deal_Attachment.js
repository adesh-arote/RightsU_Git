$(document).ready(function () {
    if (message_G != '')
        showAlert("S", message_G);

    $('.expandable').expander({
        slicePoint: 20,
        expandPrefix: '',
        expandText: ShowMessage.ReadMore,//ReadMore = read more
        collapseTimer: 0,
        userCollapseText: '<span>[^]</span>'
    });

    LoadAcqDealAttachment(0, 'Y');

    if (recordLockingCode_G > 0)
        Call_RefreshRecordReleaseTime(recordLockingCode_G, URL_Global_Refresh_Lock);
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
    if (CheckEditMode()) {
        $('.required').removeClass('required');
        $("[required='required']").removeAttr("required");
        var IsValid = ValidatePageSize();
        if (IsValid) {
            LoadAcqDealAttachment(0, 'Y');
        }
        else
            return false;
    }
}
function pageBinding() {
    LoadAcqDealAttachment(0, 'Y');
}
function CheckEditMode() {
    if (IsAddEditMode == 'Y') {
        message = ShowMessage.MsgForAddEdit;//MsgForAddEdit = Please complete Add/Edit operation first
        showAlert('E', message);
        return false;
    }
    else
        return true;
}
function checkForsave(NewRow) {
    debugger;
    canSave = 0;
    $('.required').removeClass('required');
    var returnVal = true;
    var ddlTitle_Code = $("#Title_Code").val();
    var Attachment_Title = $("#Attachment_Title").val();
    var Document_Type_Code = $("#Document_Type_Code").val();
    var Attachment_File_Name = $("#Attachment_File_Name").val();

    
     if (Attachment_Title == "0" || Attachment_Title == "") {
        $('#Attachment_Title').addClass('required');
        canSave = 1;
        returnVal = false;
    }
    else if (Document_Type_Code == "0") {
        $('#Document_Type_Code').addClass('required');
        canSave = 1;
        returnVal = false;
    }
    else if (Attachment_File_Name == "" || Attachment_File_Name == null) {
        if (NewRow == 0) {
            $('#Attachment_File_Name').addClass('required');
            canSave = 1;
            returnVal = false;
        }
    }
    if (returnVal) {
        debugger;
        var Acq_Deal_Attachment_Code = 0
        if (NewRow == 1) {
            Acq_Deal_Attachment_Code = $("#Acq_Deal_Attachment_Code").val();
        }

        var Title_Code = $("#Title_Code option:selected").text();
        $("#Title_Name").val(Title_Code);

        var files = $("#Attachment_File_Name").get(0).files;
        if (files.length > 0) {
            SaveFile();
        }
        SaveAttachment(Acq_Deal_Attachment_Code, ddlTitle_Code, Attachment_Title, Document_Type_Code);
    }
}
function SaveFile() {
    debugger;
    var data = new FormData();
    var files = $("#Attachment_File_Name").get(0).files;
    if (files.length > 0) {
        data.append("InputFile", files[0]);
    }
    $.ajax({
        url: URL_SaveFile,
        type: "POST",
        processData: false,
        contentType: false,
        data: data,
        async:false,
        success: function (response) {
            if (response == "true") {
                redirectToLogin();
            }
        },
        error: function (er) {
            debugger;
           // alert(er);
        }
    });
}
function SaveAttachment(Acq_Deal_Attachment_Code, Title_Code, Attachment_Title, Document_Type_Code) {
    var pageNo = $('#hdnpage_index').val();
    var data = new FormData();
    var files = $("#Attachment_File_Name").get(0).files;
    var Attachment_File_Name = "";
    if (files.length > 0) {
        Attachment_File_Name = files[0].name;        
    }

    $.ajax({
        type: "POST",
        url: URL_Save,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        data: JSON.stringify({
            Acq_Deal_Attachment_Code: Acq_Deal_Attachment_Code,
            Title_Code: Title_Code,
            Attachment_Title: Attachment_Title,
            Document_Type_Code: Document_Type_Code,
            Attachment_File_Name: Attachment_File_Name
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                hideLoading();
                initializeTooltip();
                var strMessage = ShowMessage.MsgForAttAdd;//MsgForAttAdd = Attachment added successfully
                if (Acq_Deal_Attachment_Code > 0)
                    strMessage = ShowMessage.MsgForAttUpd;//MsgForAttUpd = Attachment updated successfully
                showAlert('S', strMessage);
                IsAddEditMode = "N";
                LoadAcqDealAttachment(pageNo, 'Y');
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}
function OnDeleteClick(Acq_Deal_Attachment_Code) {
    if (CheckEditMode()) {
        PaymentIntCode = Acq_Deal_Attachment_Code;
        showAlert("I", ShowMessage.MsgForAttConf, "OKCANCEL");//MsgForAttDelete = Are you sure want to delete this attachment?
    }
}
function handleOk() {
    var txtPageSize = $("#txtPageSize").val();
    var pageNo = $('#hdnpage_index').val();
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_Delete,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        dataType: "html",
        data: JSON.stringify({
            Acq_Deal_Attachment_Code: PaymentIntCode,
            txtPageSize: txtPageSize,
            pageNo: pageNo
        }),
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                hideLoading();
                initializeTooltip();
                $('#dvDealAcqAttachment').html(result);
                showAlert('S', ShowMessage.MsgForAttDelete);//MsgForAttDelete = Attachment deleted successfully
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}
function handleCancel() {
    return false;
}
function ValidateSave() {
    
    if (CheckEditMode()) {
        var Isvalid = true;
        showLoading();
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
                    else {
                        Isvalid = true;
                    }
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
}
/*Bind Attachment Grid*/
function LoadAcqDealAttachment(pagenumber, isLoad) {
    debugger
    showLoading();
    var txtPageSize = $("#txtPageSize").val();
    $.ajax({
        type: "POST",
        url: URL_BindGridAcqAttachment,
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
            }
            else {
                $('#dvDealAcqAttachment').html(result);
                SetPaging(txtPageSize);
                hideLoading();
                initializeTooltip();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}
/*On Add or Cancel Click*/
function AddCancelAttachment(isAdd) { 
    if ($("#txtPageSize").val() == "") {
        return false;
    }
    var txtPageSize = $("#txtPageSize").val();
     var pageNo = $('#hdnpage_index').val();
    if (isAdd == "0" || (CheckEditMode() && isAdd == "1")) {
        if (isAdd == "0")
            IsAddEditMode = "N";
        else
            IsAddEditMode = "Y";
        showLoading();
        $.ajax({
            type: "POST",
            url: URL_Create,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            dataType: "html",
            data: JSON.stringify({
                isAdd: isAdd,
                txtPageSize: txtPageSize,
                pageNo: pageNo

            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    $('#dvDealAcqAttachment').html(result);
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
}
/*Edit Attachment*/
function EditAttachment(Acq_Deal_Attachment_Code) {
    var txtPageSize = $("#txtPageSize").val();
    var pageNo = $('#hdnpage_index').val();
    //showLoading();
    if (CheckEditMode()) {
        IsAddEditMode = "Y";
        $.ajax({
            type: "POST",
            url: URL_Edit,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            dataType: "html",
            data: JSON.stringify({
                Acq_Deal_Attachment_Code: Acq_Deal_Attachment_Code,
                txtPageSize: txtPageSize,
                pageNo:pageNo
            }),
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    $('#dvDealAcqAttachment').html(result);
                    initializeChosen();
                    initializeDatepicker();
                    initializeTooltip();
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
}