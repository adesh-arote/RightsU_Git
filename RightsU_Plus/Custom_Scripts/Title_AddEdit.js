
$(document).ready(function () {
    $('#ddlProducer').SumoSelect();
    $('#ddlDirector').SumoSelect();
    $('#ddlCountry').SumoSelect();
    $('#ddlGenres').SumoSelect();
    $('#ddlStarCast').SumoSelect();
    $('#lbRoles').SumoSelect();

    BindRoles();

    $("#hdnConfirmationtype").val('');
    showLoading();
    BindExtended();
    var Synopsis = document.getElementById("Synopsis");

    if (Synopsis != null)
        countChar(Synopsis);

    $("#imgTitle").on("click", function () {
        $("#uploadFile").click();
    });

    //setChosenWidth("#ddlProducer", "85%");
    //setChosenWidth("#ddlDirector", "85%");
    //setChosenWidth("#ddlStarCast", "95%");
    //SetDisableTalent();
    hideLoading();

    //$("#txtTitle_Name").keydown(function (event) {
    //    //alert(event.keyCode);
    //    var labelValue = $("#txtTitle_Name").val();
    //    //if (isNaN(labelValue))
    //    //    labelValue = 0;
    //    //if (event.keyCode == 8 || event.keyCode == 46) {
    //    //    $("#lblCharacters").html(labelValue - 1);
    //    //}
    //    //else {
    //    //    $("#lblCharacters").html(labelValue + 1);
    //    //}
    //    $("#lblTitleHead").text(labelValue);
    //});

    $('#txtTitle_Name').keyup(function () {
        $('#lblTitleHead').text(this.value);
    });
});

function SetDisableTalent() {
    var str = "3";
    var producer_array = str.split(',');
    var Director_array = str.split(',');
    var StarCast_array = str.split(',');

    $("#ddlProducer option").each(function () {
        if ($.inArray($(this)[0].value, producer_array) != -1)
            $(this)[0].disabled = true;
    });
    $("#ddlDirector option").each(function () {
        if ($.inArray($(this)[0].value, Director_array) != -1)
            $(this)[0].disabled = true;
    });
    $("#ddlStarCast option").each(function () {
        if ($.inArray($(this)[0].value, StarCast_array) != -1)
            $(this)[0].disabled = true;
    });

    $("#ddlProducer")[0].sumo.reload();
    $("#ddlDirector")[0].sumo.reload();
    $("#ddlStarCast")[0].sumo.reload();
}
function fileCheck(obj) {
    var fileExtension = ['jpeg', 'jpg', 'png', 'gif', 'bmp'];

    if ($.inArray($(obj).val().split('.').pop().toLowerCase(), fileExtension) == -1) {
        alert("Only '.jpeg','.jpg', '.png', '.gif', '.bmp' formats are allowed.");
        return false;
    }

    if (obj.files && obj.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#imgTitle').attr('src', e.target.result);
        }
        reader.readAsDataURL(obj.files[0]);
    }

    return true;
}

//function btnCancel() {
//    debugger
//    var URL = URL_TitleList_Cancel;
//    URL = URL.replace("Code", pageNo);
//    URL = URL.replace("amp;", "");
//    window.location.href = URL;
//    //var URL = URL_TitleList_Cancel;
//    //URL = URL.replace("Code", pageNo);
//    //URL = URL.replace("Deal_Type_Code", dealTypeCode);
//    //URL = URL.replace("Title_Name", searchedTitle);
//    //URL = URL.replace("Page_Size", pageSize);
//    //URL = URL.replace("amp;", "");
//    //URL = URL.replace("amp;", "");
//    //URL = URL.replace("amp;", "");
//    //URL = URL.replace("amp;", "");
//    //URL = URL.replace("amp;", "");
//    //window.location.href = URL;
//}
function BindExtended(vmode) {
    showLoading();
    var TitleCode = title_Code;
    $.ajax({
        type: "POST",
        url: URL_BindFieldNamedd,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            TitleCode: TitleCode,
            mode: vmode
        }),
        success: function (result) {
            //ddl_first_col = result;
            $('.divgvAdditionalField').html(result);
            initializeChosen();
            initializeTooltip();
            hideLoading();
        },
        error: function (result) {
            //alert('Error: '+ result.responseText);
        }
    });
}

function isNumber(evt) {
    evt = (evt) ? evt : window.event;
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        return false;
    }
    return true;
}

function isValidTime(text) {
    var regexp = new RegExp(/^[0-9]+(\.[0-5][0-9])?$/)
    return regexp.test(text);
}

function Save() {
    showLoading();
    var hdnProducer = "";
    var hdnDirector = "";
    var hdnGenres = "";
    var hdnStarCast = "";
    var hdnCountry = ""

    var Isvalid = true;
    if ($("#hdnRowNum").val() != "" && $("#hdnRowNum").val() != null) {
        showAlert("e", "Please complete add/edit operation.", "");
        hideLoading();
        return false;
    }

    if ($("#Deal_Type_Code").val() == null || $("#Deal_Type_Code").val() == "") {
        //showAlert("e", "Please select title type", "");
        $("#Deal_Type_Code").addClass("required");
        hideLoading();
        return false;
    }

    if ($("#Title_Language_Code").val() == null || $("#Title_Language_Code").val() == "" || $("#Title_Language_Code").val() == 0) {
        //showAlert("e", "Please select atleast one title language", "");
        $("#Title_Language_Code").addClass("required");
        hideLoading();
        return false;
    }


    if ($.trim($('#Year_Of_Production').val()) != '') {
        //alert($.trim($('#Year_Of_Production').val()))
        var YOP = parseInt($.trim($('#Year_Of_Production').val()))
        if (YOP < 1900) {
            showAlert("E", "Year of Release should be greater than 1900", "");
            hideLoading();
            return false;
        }
    }

    if ($.trim($("#Duration_In_Min").val()) != '') {
        //showAlert("e", "Please select atleast one title language", "");
        if (!isValidTime($("#Duration_In_Min").val())) {
            hideLoading();
            showAlert("E", "Invalid Duration(Min)", "");
            //   $("#Duration_In_Min").addClass("required");

            return false;
        }
    }

    if ($.trim($("#txtTitle_Name").val()) == '') {
        //showAlert("e", "Please enter title name", "");
        $("#txtTitle_Name").addClass("required");
        hideLoading();
        return false;
    }
    else {

        //alert($("#ddlProducer").val());

        if ($("#ddlProducer").val() != null)
            hdnProducer = $("#ddlProducer").val().join(',');
        if ($("#ddlDirector").val() != null)
            hdnDirector = $("#ddlDirector").val().join(',');
        if ($("#ddlGenres").val() != null)
            hdnGenres = $("#ddlGenres").val().join(',');
        if ($("#ddlStarCast").val() != null)
            hdnStarCast = $("#ddlStarCast").val().join(',');
        if ($("#ddlCountry").val() != null)
            hdnCountry = $("#ddlCountry").val().join(',');
        else
            hdnCountry = "";

        $("#hdnProducer").val(hdnProducer);
        $("#hdnDirector").val(hdnDirector);
        $("#hdnGenres").val(hdnGenres);
        $("#hdnStarCast").val(hdnStarCast);
        $("#hdnCountry").val(hdnCountry);
    }


    $.ajax({
        type: "POST",
        url: URL_fillUDT,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({
            hdnDirector: $("#hdnDirector").val(),
            hdnKeyStarCast: $("#hdnStarCast").val(),
            hdnProducer: $("#hdnProducer").val()
        }),
        async: false,
        success: function (result) {
            if (typeof result.Error !== "undefined" && result.Error != "") {
                showAlert('E', result.Error, '');
                Isvalid = false;
            }
            else {
                Isvalid = true;
            }
        },
        error: function (result) { }
    });

    var ISDuplicate = ""
    var NewTitleName = $("#txtTitle_Name").val();

    if (NewTitleName != "" && Isvalid == true) {
        $.ajax({
            type: "POST",
            url: URL_ValidateIsDuplicate,
            traditional: true,
            enctype: 'multipart/form-data',
            async: false,
            data: JSON.stringify({
                TitleName: NewTitleName,
                DealTypeCode: $("#Deal_Type_Code").val()
            }),
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                if (result.Message != "") {
                    ISDuplicate = result.Message;
                    showAlert("E", ISDuplicate);
                    Isvalid = false;
                }
            },
            error: function (result) {
            }
        });
    }

    hideLoading();
    return Isvalid;
}

function AddTalent(Type) {
    debugger;
    $("#talent_name").val('');
    SelectRole(Type);
    $("#popAddTalent").modal();
    if (Dir_G == 'RTL') {
        $('.SumoSelect > .optWrapper.multiple > .options li.opt span, .SumoSelect .select-all > span').css("right", '-3px');
        $('.SumoSelect > .optWrapper > .options li.opt label, .SumoSelect > .CaptionCont, .SumoSelect .select-all > label').css("padding-right", "22px")
        $('.SumoSelect > .optWrapper > .options li.opt label, .SumoSelect > .CaptionCont, .SumoSelect .select-all > label').css("direction", "LTR")

    }
}
function SelectRole(roleType) {
    $('#lbRoles').val(roleType.toString())
    $('#lbRoles')[0].sumo.reload();
    $('#lbRoles').siblings('div.optWrapper').find('li.selected').addClass('disabled');
}
function AddExtendedColumn() {
    debugger;
    $("#Extended_Metadata").val('');
   // SelectRole(Type);
    $("#popAddExtendedMetadata").modal();
    if (Dir_G == 'RTL') {
        $('.SumoSelect > .optWrapper.multiple > .options li.opt span, .SumoSelect .select-all > span').css("right", '-3px');
        $('.SumoSelect > .optWrapper > .options li.opt label, .SumoSelect > .CaptionCont, .SumoSelect .select-all > label').css("padding-right", "22px")
        $('.SumoSelect > .optWrapper > .options li.opt label, .SumoSelect > .CaptionCont, .SumoSelect .select-all > label').css("direction", "LTR")

    }
}

//function SelectRole(roleType) {
//    $('#lbRoles').val(roleType.toString())
//    $('#lbRoles')[0].sumo.reload();
//    $('#lbRoles').siblings('div.optWrapper').find('li.selected').addClass('disabled');
//}

function SaveExtendedMetadata(IsValidate) {
    debugger
    //var count = ($('#tbl_Additional_Fileds tr').length - 1);
    //count = $("#hdnRowNum").val();
    var Error = "", str = "";
    var ExtendedMetadata = "";
    var cmnURL = '';
    if (IsValidate == 'ExtendedMetadata')
        cmnURL = URL_SaveExtendedMetadata;
    if ($.trim($("#Extended_Metadata").val()) != "")
        ExtendedMetadata = $("#Extended_Metadata").val();
    else {
        $("#Extended_Metadata").addClass("required");
       // showAlert("E", "Please Enter Extended Metadata Value Name", "");
        Error = "E";
        return false;
    }
       // showLoading();
        $.ajax({
            type: "POST",
            url: cmnURL,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                ExtendedColumnValue: ExtendedMetadata
            }),
            success: function (result) {
                debugger;
                $("#popAddExtendedMetadata").modal('hide');
                if (typeof result.ExtendedColumnError !== "undefined" && result.ExtendedColumnError != "") {
                    showAlert('E', result.ExtendedColumnError, '');
                    $("#popAddExtendedMetadata").modal();
                }
                $("#" + $("#hdnRowNum").val() + '_ddlControlType').append("<option selected='selected' value=" + result.Value + ">" + result.Text + "</option>");
                $("#" + $("#hdnRowNum").val() + '_ddlControlType').trigger("chosen:updated");
                
                //AppendExtendedMetadata(selMulti, result);
                
            }
        });
}



function ValidateSave(IsValidate) {
    debugger
    var Error = "", str = "";
    var ArrRoles = rolesList;
    var sList = "";
    var TalentName = "";
    var Gender = "";
    var cmnURL = '';
    if (IsValidate == 'validate')
        cmnURL = URLSave;
    else
        cmnURL = URL_SaveTalent;
    if ($.trim($("#talent_name").val()) != "")
        TalentName = $("#talent_name").val();
    else {
        $("#talent_name").addClass("required");
        showAlert("E", "Please Enter Talent Name", "");
        Error = "E";
    }
    sList = $('#lbRoles').val();
    $.each(sList, function (idx, val) {
        str += val + ",";
    });
    sList = str;

    Gender = $('input[name=sex]:checked', '#talent_popup').val();

    if (Error == "") {
        if (parseInt(Gender) == 1)
            Gender = "F";
        else if (parseInt(Gender) == 0)
            Gender = "M";
        else if (parseInt(Gender) == 2)
            Gender = "N";

        showLoading();
        $.ajax({
            type: "POST",
            url: cmnURL,
            traditional: true,
            enctype: 'multipart/form-data',
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify({
                Roles: sList,
                TalentName: TalentName,
                Gender: Gender
            }),
            success: function (result) {
               
                if (typeof result.TalentError !== "undefined" && result.TalentError != "") {
                    showAlert('E', result.TalentError, '');
                    $("#popAddTalent").modal();
                }
                else if (typeof result.TalentConfirmation !== "undefined" && result.TalentConfirmation !== "") {
                    $('#hdnMainConfirmationtype').val('talent');
                    $("#hdnConfirmationtype").val('talent');
                    showAlert("I", result.TalentConfirmation, "OKCANCEL");
                    $("#popAddTalent").modal();
                }
                else {
                     $("#" + $("#hdnRowNum").val() + '_ddlControlType').append("<option selected='selected' value=" + result.Value + ">" + result.Text + "</option>");
                     $("#" + $("#hdnRowNum").val() + '_ddlControlType').trigger("chosen:updated");
                    $('#hdnMainConfirmationtype').val('');
                    $("#hdnConfirmationtype").val('');
                    var alternatetabname = $('#hdnAlternateTalenttab').val();
                    var direction = $('#hdnDirection').val();
                    var SelectedRoles = "";
                    var selMulti = $.map($("#lbRoles option:selected"), function (el, i) {
                        return $(el).text();
                    });
                    SelectedRoles = selMulti.join(", ")
                    var ddlProducer = "";
                    var ddlDirector = "";
                    var ddlStarCast = "";
                    if (alternatetabname == "AL") {
                        ddlProducer = "#ddlProducers";
                        ddlDirector = "#ddlDirectors";
                        ddlStarCast = "#ddlStarCasts";
                    }
                    else {
                        ddlProducer = "#ddlProducer";
                        ddlDirector = "#ddlDirector";
                        ddlStarCast = "#ddlStarCast";
                    }

                    var Arr = SelectedRoles.toString().trim(',').split(',');
                    for (var i = 0; i < Arr.length; i++) {
                        var currentVal = Arr[i];
                        var currentValTrim = currentVal.trim();
                        if (currentValTrim != "") {
                            if (currentValTrim == "Producer") {
                                AppendTalent(ddlProducer, result);
                            }
                            if (currentValTrim == "Director") {
                                AppendTalent(ddlDirector, result);
                            }
                            if (currentValTrim == "Star Cast") {
                                AppendTalent(ddlStarCast, result);
                            }
                        }
                    }
                    $("#popAddTalent").modal('hide');
                    if (direction == "RTL") {
                        sumoselectChange();
                    }
                }
                hideLoading();
            },
            error: function (result) { }
        });
        hideLoading();
    }
    else $("#popAddTalent").modal();  
    IsValidate = '';
}

function AppendTalent(ddl, result) {
    var count = 0;
    $(ddl + " :selected").each(function (i, sel) {
        // alert($(sel).text());
        if ($(sel).text().toLowerCase() == result.Text.toLowerCase()) {
            count++;
        }
    });
    if (count == 0) {
        $(ddl).append("<option selected='selected' value=" + result.Value + ">" + result.Text + "</option>");
        $(ddl)[0].sumo.reload();
    }
}
//function AppendExtendedMetadata(ddl, result) {
//    var count = 0;
//    $(ddl + " :selected").each(function (i, sel) {
//        // alert($(sel).text());
//        if ($(sel).text().toLowerCase() == result.Text.toLowerCase()) {
//            count++;
//        }
//    });
//    if (count == 0) {
//        $(ddl).append("<option selected='selected' value=" + result.Value + ">" + result.Text + "</option>");
//        $(ddl)[0].sumo.reload();
//    }
//}

function OnSuccess(message) {
    showAlert('S', message, 'OK');
}

function handleOk() {
    if ($('#hdnMainConfirmationtype').val() == 'ExtendedColumn') {
        confirmed = true;
        DeleteExtended(dummyobj);
    }
    if ($('#hdnMainConfirmationtype').val() == 'talent') {
        if ($("#hdnConfirmationtype").val() == 'talent') {
            ValidateSave('validate');
        }
        else {
            var URL = URL_TitleList_Ok;
            URL = URL.replace("amp;", "");
            URL = URL.replace("amp;", "");
            window.location.href = URL;
        }
    }
}

function handleCancel() {
    if ($('#hdnMainConfirmationtype').val() == 'ExtendedColumn') {
        handleECancel();
    }
    else {
        $("#hdnRowNum").val('');
        $("#popAddTalent").modal('hide');
        $("#popAddExtendedMetadata").modal('hide'); 
    }
}

function BindRoles() {
    $.ajax({
        type: "POST",
        url: URL_BindRoles,
        traditional: true,
        enctype: 'multipart/form-data',
        contentType: "application/json; charset=utf-8",
        async: true,
        success: function (result) {

            if (result == "true") {
                redirectToLogin();
            }
            else {
                $.each(result.RoleList, function () {
                    $("#lbRoles").append($("<option />").val(this.Value).text(this.Text));
                });
                $("#lbRoles")[0].sumo.reload();
            }
        }
    });
}


//function WriteName(id, lblid) {
//    //document.getElementById('<% = Test.ClientID %>').value = document.getElementById('<% = txtT.ClientID %>').value;
//    //document.getElementById(lblid).value = document.getElementById(id).value;
//    //$("#lblTitleHead").val($("#" + id).val());
//    $("#lblTitleHead").text( $("#" + id).val() );
//}
