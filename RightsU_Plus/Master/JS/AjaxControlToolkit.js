// JScript File
var controlToFocus;
function AlertModalPopup(ctl, message) {
    var obj = $get('lblMessage');
    obj.innerHTML = message;
    obj = $find('MPExtAlert')
    if (AjaxControlToolkit.ValidatorCalloutBehavior != null) {
        if (AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout != null) {
            AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout.hide();
        }
    }
    obj.show();
    if (obj._OkControlID != null) {
        $get(obj._OkControlID).focus();
    }
    controlToFocus = ctl;
}
//Added By Dada For new alert message for Success 25Jan2013
function AlertModalPopupSuccess(ctl, message) {
    var obj = $get('lblMessageSuccess');
    obj.innerHTML = message;
    obj = $find('MPExtAlertSuccess')
    if (AjaxControlToolkit.ValidatorCalloutBehavior != null) {
        if (AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout != null) {
            AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout.hide();
        }
    }
    obj.show();
    if (obj._OkControlID != null) {
        $get(obj._OkControlID).focus();
    }
    controlToFocus = ctl;
}
//Added By Dada For new alert message for Err 25Jan2013
function AlertModalPopupErr(ctl, message) {
    var obj = $get('lblMessageErr');
    obj.innerHTML = message;
    obj = $find('MPExtAlertErr')
    if (AjaxControlToolkit.ValidatorCalloutBehavior != null) {
        if (AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout != null) {
            AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout.hide();
        }
    }
    obj.show();
    if (obj._OkControlID != null) {
        $get(obj._OkControlID).focus();
    }
    controlToFocus = ctl;
}
//Added By Dada For new alert message for Warn 25Jan2013
function AlertModalPopupWarn(ctl, message) {
    var obj = $get('lblMessageWarn');
    obj.innerHTML = message;
    obj = $find('MPExtAlertWarn')
    if (AjaxControlToolkit.ValidatorCalloutBehavior != null) {
        if (AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout != null) {
            AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout.hide();
        }
    }
    obj.show();
    if (obj._OkControlID != null) {
        $get(obj._OkControlID).focus();
    }
    controlToFocus = ctl;
}
//Added By Dada For new alert message for Info 25Jan2013
function AlertModalPopupInfo(ctl, message) {
    var obj = $get('lblMessageInfo');
    obj.innerHTML = message;
    obj = $find('MPExtAlertInfo')
    if (AjaxControlToolkit.ValidatorCalloutBehavior != null) {
        if (AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout != null) {
            AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout.hide();
        }
    }
    obj.show();
    if (obj._OkControlID != null) {
        $get(obj._OkControlID).focus();
    }
    controlToFocus = ctl;
}
function SetFocus() {
  //  debugger
    if (controlToFocus != null && controlToFocus != "undefined") {
        if (typeof controlToFocus == "object") {
            $get(controlToFocus.id).focus();
        }
        else {
            if (typeof controlToFocus == "string") {
                $get(controlToFocus).focus();
            }
        }
    }
}
function ShowConfirmSMS(btnDelete) {
    var confirmExt = $find('CBExtDelete');
    confirmExt._displayConfirmDialog();
    if ($get('btnConfirmCancel')) {
        $get('btnConfirmCancel').focus();
    }
    confirmExt.set_postBackScript(RegisterPostBack(btnDelete))
    return false;
}

function ShowActiveSms(btnDelete, message) {
    var confirmExt = $find('CBExtDelete');
    var lblmessage = $get('lblConfirmText');
    lblmessage.innerHTML = message;
    confirmExt._displayConfirmDialog();
    if ($get('btnConfirmCancel')) {
        $get('btnConfirmCancel').focus();
    }
    confirmExt.set_postBackScript("HandleClientOK();" + RegisterPostBack(btnDelete))
    return false;
}

function TransferMessage(message, url) {
    var obj = $get('lblMessage');
    obj.innerHTML = message;
    obj = $find('MPExtAlert')
    obj._OnOkScript = "TransferUrl('" + url + "');";
    if (AjaxControlToolkit.ValidatorCalloutBehavior != null) {
        if (AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout != null) {
            AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout.hide();
        }
    }
    obj.show();
    if (obj._OkControlID != null) {
        $get(obj._OkControlID).focus();
    }
}

function TransferUrl(url) {
    window.location = url;
}

//Added By Dada For new alert message of TransferMessage 24Jan2013
function TransferMessageSuccess(message, url) {
    var obj = $get('lblMessageSuccess');
    obj.innerHTML = message;
    obj = $find('MPExtAlertSuccess')
    obj._OnOkScript = "TransferUrl('" + url + "');";
    if (AjaxControlToolkit.ValidatorCalloutBehavior != null) {
        if (AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout != null) {
            AjaxControlToolkit.ValidatorCalloutBehavior._currentCallout.hide();
        }
    }
    obj.show();
    if (obj._OkControlID != null) {
        $get(obj._OkControlID).focus();
    }
}

//Added By Yogesh For Getting click of Cancel button  Event from ShowActiveSms 562008
function HandleConfirmCancel() {
}
function HandleClientOK() {
}