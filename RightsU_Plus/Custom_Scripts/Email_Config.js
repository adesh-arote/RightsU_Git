
function CloseApprovalRemark() {
    $('#popApprovalRemark').modal('hide');
}
function BindGrid() {
    hideLoading();
    $.ajax({
        type: "POST",
        url: URL_BindGrid,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                $("#dvEConfiglList").html(result);
                initializeTooltip();
            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}
function AddEditConfigure(ConfigCode) {
    hideLoading();
    $.ajax({
        type: "POST",
        url: URL_AddEditConfigure,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            EmailConfigCode: ConfigCode
        }),
        async: false,
        success: function (result) {
            if (result == "true") {
                redirectToLogin();
            }
            else {
                initializeChosen();
                $("#dvEConfiglList").html(result);

            }
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
    BindUserGrid('', '');
}
function BindUserGrid(commandName, dummyGuid) {
      if (commandName == 'CANCEL') {
        $("#IsAddEdit").val('N');
    }
    if (CheckIsAddEdit()) {
        if ((commandName == 'ADD' || commandName == 'EDIT') && $("#IsAddEdit").val() != 'Y') {
            $("#IsAddEdit").val('Y');
        }
        showLoading();
        $.ajax({
            type: "POST",
            url: URL_BindUserGrid,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                CommandName: commandName,
                DummyGuid: dummyGuid
            }),
            async: false,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    if (dummyGuid == "VIEW") {
                        $('#popApprovalRemark').modal();
                        $("#divUsers").html(result);
                        $("#divCc").html(result);
                        $("#divBcc").html(result);
                        hideLoading();
                    }
                    else
                        $("#divEmailUsers").html(result);
                    $('#lstBusinessUnit,#lstChannel').SumoSelect();
                    if ($('#lstBusinessUnit')[0] != undefined)
                        $('#lstBusinessUnit')[0].sumo.reload();
                    if ($('#lstChannel')[0] != undefined)
                        $('#lstChannel')[0].sumo.reload();
                    hideLoading();
                }
                initializeTooltip();
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
}
function CheckIsAddEdit() {
    if ($("#IsAddEdit").val() == 'Y') {
        showAlert("E", "Please Complete Add/Edit Operation First");
        return false;
    }
    return true;
}
function EmailFreqChange(callFrom) {
    initializeChosen();
    if (callFrom == 'P') {
        $("#txtTimeLag").val('12:00AM')
        $('#EmailFreqDays').val('1')
    }
    if ($("#EmailFreq") != undefined)
        var EmailFreq = $("#EmailFreq").val();
    if ($("#EmailFreqDays") != undefined && $("#EmailFreqDays") != undefined && EmailFreq != undefined) {
        if (EmailFreq == "M") {
            if ($('#EmailFreqDays_chosen') != undefined)
                $('#EmailFreqDays_chosen').attr('style', 'inline-block');
            //document.getElementById("EmailFreqDays").style.display = 'inline-block';
            document.getElementById("txtTimeLag").style.display = 'inline-block';
            document.getElementById("lblDay").style.display = 'inline-block';
            document.getElementById("lblTime").style.display = 'inline-block';

        }
        else if (EmailFreq == "D") {
            document.getElementById("EmailFreqDays").style.display = 'none';
            document.getElementById("txtTimeLag").style.display = 'inline-block';
            document.getElementById("lblDay").style.display = 'none';
            document.getElementById("lblTime").style.display = 'inline-block';
            if ($('#EmailFreqDays_chosen') != undefined)
                $('#EmailFreqDays_chosen').attr('style', 'display: none');

        }
        else {
            document.getElementById("EmailFreqDays").style.display = 'none';
            document.getElementById("txtTimeLag").style.display = 'none';
            document.getElementById("lblDay").style.display = 'none';
            document.getElementById("lblTime").style.display = 'none';
            if ($('#EmailFreqDays_chosen') != undefined)
                $('#EmailFreqDays_chosen').attr('style', 'display: none');
        }
    }
}
function save() {
       var IsValid = true;
    if (CheckIsAddEdit()) {
        var Isvalid = true;
        var message = "";
        var Email_Config_Detail_Code = 0;
        if ($('#hdnEmailConfigDetailCode').val() != '' && $('#hdnEmailConfigDetailCode').val() != null)
            Email_Config_Detail_Code = $('#hdnEmailConfigDetailCode').val();
        var chkDisplay = false;
        if ($('#chkDisplay') != undefined)
            if ($('#chkDisplay').prop("checked"))
                chkDisplay = 'Y'
            else
                chkDisplay = 'N'
        var EmailFreq = null;
        if ($('#EmailFreq') != undefined)
            EmailFreq = $('#EmailFreq').val()

        hideLoading();
        var NotDays = '0';
        var NotTime = null;
        if (EmailFreq == "M") {
            if ($('#EmailFreqDays').val() != undefined)
                NotDays = $('#EmailFreqDays').val()
        }
        if (EmailFreq == "M" || EmailFreq == "D") {
            if ($('#txtTimeLag').val() != undefined)
                NotTime = $('#txtTimeLag').val()
            if (NotTime == null || NotTime == "") {
                $('#txtTimeLag').addClass("required")
                Isvalid = false;
            }
            else
                $("#txtTimeLag").removeClass('required');
        }
        if ($('#hdnAllowConfig').val() != 'Y') {
            NotDays = '0';
            NotTime = null;
            EmailFreq = "";
        }
        if (Isvalid) {
            $.ajax({
                type: "POST",
                url: URL_Save,
                traditional: true,
                enctype: 'multipart/form-data',
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({
                    DisplayOnScreen: chkDisplay,
                    EmailFrequency: EmailFreq,
                    NotificationDays: NotDays,
                    NotificationTime: NotTime
                })
                ,
                async: false,
                success: function (result) {
                    if (result == "true") {
                        redirectToLogin();
                    }
                    else {
                        $('#finalSave').val('Y');
                        showAlert('S', 'Data Saved Successfully');
                        var recordLockingCode = parseInt($('#hdnRecordLockingCode').val())
                        if (recordLockingCode > 0)
                            ReleaseRecordLock(recordLockingCode, URL_Release_Lock);
                        $('#hdnRecordLockingCode').val('');
                        BindGrid();
                    }
                },
                error: function (result) {
                    alert('Error: ' + result.responseText);
                }
            });
        }
    }
}
function validateOnCancel() {
    if (CheckIsAddEdit()) {
        $('#finalSave').val('Y');
        showAlert('I', 'All unsaved data will be lost, still want to go ahead?', 'OKCANCEL');
    }
}
function handleOk() {
    if ($('#finalSave').val() == 'Y') {
        var recordLockingCode = parseInt($('#hdnRecordLockingCode').val())
        if (recordLockingCode > 0)
            ReleaseRecordLock(recordLockingCode, URL_Release_Lock);
        $('#hdnRecordLockingCode').val('');
        BindGrid();
    }
    if ($('#finalSave').val() == 'D')
        DeleteUser($('#hdnDeleteId').val());
}
function PopulateUser(dummyGuid) {
      if ($('#lstBusinessUnit').val() != undefined && $('#lstBusinessUnit').val() != null) {
        $('#lstBusinessUnit').SumoSelect();
        $('#lstBusinessUnit')[0].sumo.reload();
    }
    var type = $('#Type:checked').val();
    showLoading();
    $.ajax({
        type: "POST",
        url: URL_PopulateUsers,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            BUCodes: $('#lstBusinessUnit').val(),
            Type: type,
            DummyGuid: dummyGuid,
            CcCodes: $('#lstCcUser').val(),
            BccCodes: $('#lstBccUser').val()                       
        })
        ,
        async: false,
        success: function (result) {
            var commandname = $("#hdnCommandName").val();
            if (type == 'U') {
                debugger;
                $('#lstUser,#lstCcUser,#lstBccUser').SumoSelect();
                $("#divUser,#divCc,#divBcc").show();

                $("#divUserEmail,#divCcuserEmail,#divBccuserEmail").hide();
                $("#divGrp").hide();
                $('#lstGroup').val('');
                $('#lstUser,#lstCcUser,#lstBccUser').empty();
                $('#lstUser,#lstCcUser,#lstBccUser').val('');
                $(result.lst).each(function (index, item) {
                    $('#lstUser').append($("<option>").val(this.Value).text(this.Text));
                    $('#lstCcUser').append($("<option>").val(this.Value).text(this.Text));
                    $('#lstBccUser').append($("<option>").val(this.Value).text(this.Text));
                });
                $('#lstUser').val(result.selectedUsers);
                $('#lstCcUser').val(result.selectedCc);
                $('#lstBccUser').val(result.selectedBcc);
                $('#lstUser')[0].sumo.reload();
                $('#lstCcUser')[0].sumo.reload();
                $('#lstBccUser')[0].sumo.reload();
                $("#lstGroup_chosen").hide();
            }
            else if (type == "G") {
                debugger;
                if ($('#lstUser')[0].sumo != undefined)
                    $('#lstUser')[0].sumo.unload();
                $("#divUserEmail,#divCcuserEmail,#divBccuserEmail").hide();
                $('#lstGroup,#lstCcUser,#lstBccUser').SumoSelect();
                $("#divGrp,#divCc,#divBcc").show();
                $("#divUser").hide();
                $("#lstUser").val('');
                $('#lstGroup,#lstCcUser,#lstBccUser').empty();
                $('#lstGroup,#lstCcUser,#lstBccUser').val('');
                $(result.lstG).each(function (index, item) {
                    $('#lstGroup').append($("<option>").val(this.Value).text(this.Text));
                });
                $(result.selectedCcBcclist).each(function (index, item) {
                    $('#lstCcUser').append($("<option>").val(this.Value).text(this.Text));
                    $('#lstBccUser').append($("<option>").val(this.Value).text(this.Text));
                });
                $('#lstGroup').val(result.selectedGroup);
                $('#lstCcUser').val(result.selectedCc);
                $('#lstBccUser').val(result.selectedBcc);
                $('#lstGroup').trigger("chosen:updated");
                $('#lstCcUser')[0].sumo.reload();
                $('#lstBccUser')[0].sumo.reload();
                $("#lstGroup_chosen").show();
                initializeChosen();
                $("#lstUser").hide();
            }
            else {
                debugger;
                  if ($('#lstUser')[0].sumo != undefined)
                      $('#lstUser')[0].sumo.unload();
             
                  $("#lstUser,#lstGroup").val('');
                  $("#divUser,#divGrp").hide();
                  $('#divCc,#divBcc').hide();
                  $("#divUserEmail,#divCcuserEmail,#divBccuserEmail").show();
                  $('#txtuseremail,#txtccuseremail,#txtbccuseremail').show();                               
            }      
            hideLoading();
        },
        error: function (result) {
            alert('Error: ' + result.responseText);
        }
    });
}
function ValidateEmail(email) {
      var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
    if (email.match(mailformat)) {
           return true;
    }
    else {
         return false;
    }
}
function SaveUser(dummyGuid) {
    debugger;
     $("[required='required']").removeAttr("required");
    $('.required').removeClass('required');
    
    var IsValid = true;
    var type=$("#Type:checked").val();
    if (type == "E") {
        var arruseremail, arrccuseremail, arrbccuseremail = [];             
        arruseremail = $('#txtuseremail').val().trim(/\n/).split(',');       
        arrccuseremail  = $('#txtccuseremail').val().trim(/\n/).split(',');
        arrbccuseremail = $('#txtbccuseremail').val().trim(/\n/).split(',');
        if ($('#txtuseremail').val() == undefined || $.trim($('#txtuseremail').val())=="") {
            $('#txtuseremail').addClass('required');
            showAlert("E", "User Email ID cannot be empty");
            IsValid = false;
        }
        $.each(arruseremail, function (index, value) {
            if ($.trim(value) != '') {               
                if (!ValidateEmail(value)) {
                    showAlert("E", value + " is an Invalid User EmailID");
                    $('#txtuseremail').addClass('required');
                    IsValid = false;
                }              
            }
        })
        $.each(arrccuseremail, function (index,item) {
            if (item != '') {
                if (!ValidateEmail(item)) {
                    showAlert("E", "Invalid Email Id in CC User Email ID");
                    $('#txtccuseremail').addClass('required');
                    IsValid = false;
                }
            }
        })
        $.each(arrbccuseremail, function (index, email) {
            if (email != '') {
                if (!ValidateEmail(email)) {
                    showAlert("E", "Invalid Email Id in BCC User Email ID");
                    $('#txtbccuseremail').addClass('required');
                    IsValid = false;
                }
            }
        })
    }
    if ($('#lstGroup').val() == '' && $('#lstGroup') != undefined)

        $("#lstChannel").val()
    if ($("#hdnIsBusinessUnit").val() == 'Y') {
        var BusinessUnit = $("#lstBusinessUnit").val();
        if (BusinessUnit == '' || BusinessUnit == null) {
            IsValid = false;
            $("#divBusinessUnit").addClass("required");
        }
        else
            $("#divBusinessUnit").removeClass('required');
    }
    else
        var BusinessUnit = '0';
    if ($("#hdnIsChannel").val() == "Y") {
        var ChannelCode = $("#lstChannel").val();
        if (ChannelCode == '' || ChannelCode == null) {
            IsValid = false;
            $("#divChannel").addClass("required");
        }
        else
            $("#divChannel").removeClass('required');
    }
    else
        var ChannelCode = '0';
    var type = $('#Type:checked').val()
    if (type == 'G') {
        var UsersCode = $('#lstGroup').val();
        var CcCode = $('#lstCcUser').val();
        var BccCode = $('#lstBccUser').val();
        if (UsersCode == '' || UsersCode == null) {
            IsValid = false;
            $("#divGrp").addClass("required");
        }
        else
            $("#divGrp").removeClass('required');
    }
    else if(type == 'U') {
        var UsersCode = $('#lstUser').val();
        var CcCode = $('#lstCcUser').val();
        var BccCode = $('#lstBccUser').val();
        if (UsersCode == '' || UsersCode == null) {
            IsValid = false;
            $("#divUser").addClass("required");
        }
       
        else
            $("#divUser").removeClass('required');
    }
    
    if (IsValid) {
        $("#IsAddEdit").val('N');
        showLoading();
        $.ajax({
            type: "POST",
            url: URL_UserSave,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                BuCodes: BusinessUnit,
                ChannelCodes: ChannelCode,
                UsersCodes: UsersCode,
                CcCodes: CcCode,
                BccCodes: BccCode,
                Type: type,
                DummyGuid: dummyGuid,
                UserEmails:arruseremail,   
                CcuserEmails:arrccuseremail ,
                BccuserEmails:arrbccuseremail
            }),
            async: false,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
                else {
                    if (result.Status == "S") {
                        showAlert('S', result.Message);
                        $('#finalSave').val('');
                        BindUserGrid('', '');
                    }
                    else {
                        showAlert("E", result.Message);
                    }
                }
                hideLoading();
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
    }
}
function DeleteConfirmation(dummyGuid) {
    $('#hdnDeleteId').val(dummyGuid);
    $('#finalSave').val('D');
    showAlert("I", "Are you sure, you want to delete this record?", 'OKCANCEL');
    return false;
}
function DeleteUser(dummyGuid) {
    if (CheckIsAddEdit()) {
        hideLoading();
        $.ajax({
            type: "POST",
            url: URL_UserDelete,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                DummyGuid: dummyGuid
            })
            ,
            async: false,
            success: function (result) {
                if (result == "true") {
                    redirectToLogin();
                }
            },
            error: function (result) {
                alert('Error: ' + result.responseText);
            }
        });
        BindUserGrid('', '');
    }
}