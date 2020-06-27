// function to create preference list as per the requirement 
function module(objPassed) {
    module_selection = new String;
    module_selection = "";
    for (i = 0; i < objPassed.length; i++) {
        if (objPassed.options[i].selected != 0) {
            module_selection += objPassed.options[i].value + "#";
        }
    }
    module_selection = module_selection.substring(0, (module_selection.length - 1))
    return module_selection;
}
// end of creation preference list 


//function to check if all the characters are spaces
function checkblank(textval) {
    isblank = new String
    isblank = "";
    isblank1 = new String
    isblank1 = "";

    for (j = 0; j < textval.length; j++) {
        if (textval.substring(j, j + 1) == ' ') { isblank = isblank + '1'; }
        else { isblank = isblank + '0'; }
        isblank1 = isblank1 + '1';
    }
    //		alert(isblank +'  '+ isblank1);
    if (isblank == isblank1) { textval = ""; return false; }
    else { return true; }
}
// end of function checkblank



//function to check if the text field is null or only spaces
function checktext(textvalue, message) {
    var str = "";
    var str = textvalue.value;
    if (!(checkblank(str))) {
        alert(message);
        textvalue.select()
        return false
    }
    else {
        return true
    }
}
// end of function checktext

function openCenteredWindow(url, height, width, name, parms) {

    var left = Math.floor((screen.width - width) / 2);
    var top = Math.floor((screen.height - height) / 2);

    var winParms = "top=" + top + ",left=" + left + ",height=" + height + ",width=" + width;

    if (parms) { winParms += "," + parms; }

    var win = window.open(url, name, winParms);

    if (parseInt(navigator.appVersion) >= 4) { win.window.focus(); }
    return win;
}

//Function to close child window
//Function created by Geeta


var Child // Variable used to assign child window

function CloseChildWindow() {
    if (Child != null)//Checking whether child window exists
    {
        Child.close()
    }
}


// function to check  textarea value null or spaces or maximum limit crosses
function checktextarea(textvalue, message, limit) {
    var str = "";
    var str = textvalue.value;
    if ((str.length > limit || str.length < 3) || (!(checkblank(str)))) {
        alert('Error : ' + message + limit + ' characters\n' + '          You entered text with Length ' + str.length);
        textvalue.focus()
        return false;
    }
    else {
        return true;
    }

}
// end of function checktextarea

//function to check email
function checkemail(textval, message) {
    var str = "";
    var atrate = 0;
    var str = textval.value;

    if (str == "") {
        alert(message)
        textval.select()
        return false;
    }
    else {
        for (var i = 0; i < str.length; i++) {
            var ch = str.substring(i, i + 1);
            if (
					((ch < "a" || "z" < ch) && (ch < "A" || "Z" < ch)) &&
					(ch < "0" || "9" < ch) &&
					(ch != '_') &&
					(ch != '-') &&
					(ch != '@') &&
					(ch != '.')
				) {
                alert(message)
                textval.select()
                return false;
            }
        }

        if ((str.indexOf('@') == -1) || (str.indexOf('.') == -1) || (str.indexOf(' ') > 0)) {
            alert(message)
            textval.select()
            return false
        }
        for (var i = 0; i < str.length; i++) {
            var ch = str.substring(i, i + 1);
            if (ch == '@')
                atrate = atrate + 1;
        }
        if (atrate > 1) {
            alert(message)
            textval.select()
            return false
        }
        if (textval.value.length < 6) {
            //alert('Invalid E-mail Id.');
            return false;
        }
    }
    return true
}

//end of function checkemail
function checkemailWithNoAlert(textval) {
    var str = "";
    var atrate = 0;
    var str = textval.value;

    if (str == "") {
        //	alert(message)
        textval.select()
        return false;
    }
    else {
        for (var i = 0; i < str.length; i++) {
            var ch = str.substring(i, i + 1);
            if (
					((ch < "a" || "z" < ch) && (ch < "A" || "Z" < ch)) &&
					(ch < "0" || "9" < ch) &&
					(ch != '_') &&
					(ch != '-') &&
					(ch != '@') &&
					(ch != '.')
				) {
                //	alert(message)
                textval.select()
                return false;
            }
        }

        if ((str.indexOf('@') == -1) || (str.indexOf('.') == -1) || (str.indexOf(' ') > 0)) {
            //alert(message)
            textval.select()
            return false
        }
        for (var i = 0; i < str.length; i++) {
            var ch = str.substring(i, i + 1);
            if (ch == '@')
                atrate = atrate + 1;
        }
        if (atrate > 1) {
            //alert(message)
            textval.select()
            return false
        }
        if (textval.value.length < 6) {
            //alert('Invalid E-mail Id.');
            return false;
        }
    }
    return true
}
//
function allowOnlyNumber(val, allowZero) {
    if (event.keyCode > 47 && event.keyCode < 58) {
        if ((val.value == '') && (event.keyCode == 48) && !allowZero) {
            event.returnValue = false;
        }
        else
            event.returnValue = true;
    }
    else
        event.returnValue = false;

}
//Written by anita to allow integer without & with zero )
function allowOnlyNumberWithoutORWithZero(val, allowZero) {
    if (event.keyCode > 47 && event.keyCode < 58) {
        if ((event.keyCode == 48) && !allowZero) {
            event.returnValue = false;
        }
        else
            event.returnValue = true;
    }
    else
        event.returnValue = false;

}

//function to check for numeric data only
function checknumval(numval, message) {
    var str = "";
    var str = numval.value;
    if (str != "") {
        if (String((str) * 1) == "NaN") {
            alert('The entry is not a number')
            numval.select()
            return false
        }
    }
    else // if it is null
    {
        alert(message)
        numval.select()
        return false
    }
    return true
}

////	function checknumval(numval)
////	{
////	
////		var str="";
////		var str=numval.value;
////		alert(str);
////		if (str != "") 
////		{
////			if (String((str)*1)=="NaN")
////			{
////				alert('The entry is not a number')
////				numval.select()
////				return false
////			}
////		}
////		
////	return true
////    }
//end of function checknumval

//function to check for drop down selection
function checkdropdown(objPassed, message) {
    if (objPassed.options[objPassed.selectedIndex].value == "")
    //if(objPassed.value =="") 
    {
        alert(message)
        objPassed.focus()
        return false
    }
    else {
        return true
    }
}
//end of function

//function to check the date & return date format
function checkDates(strdd, strmm, stryy, Adate) {
    var dd_index = strdd.selectedIndex;
    var mm_index = strmm.selectedIndex;
    if (strdd.options[dd_index].value == "DD" || strmm.options[mm_index].value == "MM" || String((stryy.value) * 1) == "NaN") {
        alert("Please fill the Date ");
        strdd.focus();
        return false
    }
    else {
        var new_dob = new String()
        new_dob = strmm.options[mm_index].value + '/' + strdd.options[dd_index].value + '/' + stryy.value.substring(2, stryy.value.length)
        var indate = new_dob;

        if (indate.indexOf("-") != -1) { var sdate = indate.split("-") }
        else if (indate.indexOf("/") != -1) { var sdate = indate.split("/") }

        var chkDate = new Date(Date.parse(indate))
        var cmpDate = (chkDate.getMonth() + 1) + "/" + (chkDate.getDate()) + "/" + (chkDate.getYear())
        var indate2 = (Math.abs(sdate[0])) + "/" + (Math.abs(sdate[1])) + "/" + (Math.abs(sdate[2]))

        if (indate2 != cmpDate) {
            alert("Invalid Date Format (DD-MON-YYYY)");
            strdd.focus();
            return false;
        }
        else {
            Adate.value = new_dob;
            return true;
        }
    }

}
//end of function checkdate

//new window open disclaimer

function getCurrentDate() {
    var td = new Date();
    var d = td.getDate();
    var m = td.getMonth();
    m++;
    var y = td.getFullYear();
    var tdate = d + '/' + m + '/' + y; //dd/mm/yyyy
    return tdate;
}

function validateDate_DMY(earlierdate, laterdate) {


    if (earlierdate == '' && laterdate == '') { return true; }

    var earlierdate_array = earlierdate.split("/");
    var laterdate_array = laterdate.split("/");

    // incomming format dd/mm/yyyy

    // creating date object of format yyyy,mm,dd
    // month january = 0 , february = 1, and so on.

    var e_yy = earlierdate_array[2];
    var e_dd = earlierdate_array[0];
    var e_mm = earlierdate_array[1] - 1;

    var l_yy = laterdate_array[2];
    var l_dd = laterdate_array[0];
    var l_mm = laterdate_array[1] - 1;

  //  debugger;
    // new date format (yy,mm,dd)
    var earlier_date = new Date(e_yy, e_mm, e_dd);
    var later_date = new Date(l_yy, l_mm, l_dd);

    var difference = later_date.getTime() - earlier_date.getTime();
    if (difference <= 0) {
        return false;
    } else {
        return true;
    }

}

function compareDates_DMY(earlierdate, laterdate) {


    if (earlierdate == '' && laterdate == '') { return true; }

    var earlierdate_array = earlierdate.split("/");
    var laterdate_array = laterdate.split("/");

    // incomming format dd/mm/yyyy

    // creating date object of format yyyy,mm,dd
    // month january = 0 , february = 1, and so on.

    var e_yy = earlierdate_array[2];
    var e_dd = earlierdate_array[0];
    var e_mm = earlierdate_array[1] - 1;

    var l_yy = laterdate_array[2];
    var l_dd = laterdate_array[0];
    var l_mm = laterdate_array[1] - 1;

    // new date format (yy,mm,dd)
    var earlier_date = new Date(e_yy, e_mm, e_dd);
    var later_date = new Date(l_yy, l_mm, l_dd);

    var difference = later_date.getTime() - earlier_date.getTime();

    return difference;

}


function descc(name) {
    game = window.open(name, "", "height=300,width=450,resizable=1,navigationbar=0,status=0,menubar=0,location=0,scrollbars=yes")
}

function fnEnterKey(buttonToClick) {

    if (event.keyCode == 13) {

        event.cancelBubble = true;
        event.returnValue = false;
        document.getElementById(buttonToClick).click();
    }
}

function keyPressHandler(e) {
    var kC = (window.event) ?    // MSIE or Firefox?
                     event.keyCode : e.keyCode;
    var Esc = (window.event) ?
                    27 : e.DOM_VK_ESCAPE // MSIE : Firefox  

    if (kC == Esc) {
        e.returnValue = false;
        return false;
    }
    return true;
}

// Function To Check Character Data Only

function chkname(fieldnm) {
    var fieldValue = fieldnm.value;
    fieldValue = fieldValue;
    var valid = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ";
    var ok = "yes";
    var temp;
    if (fieldValue.length > 0) {
        for (var i = 0; i < fieldValue.length; i++) {
            temp = "" + fieldValue.substring(i, i + 1);
            if (valid.indexOf(temp) == "-1") {
                ok = "no";
            }
        }
    }
    else {
        ok = "no";
    }
    if (ok == "no") {
        alert("Invalid entry!");
        fieldnm.focus();
        fieldnm.select();
        return false;
    }
}

// End Function

//Function To Check Num Data only.
//str = ClientId Of The Respective Control.
//msg = Msg To Be Shown.

function chkNum(str, msg) {
    var valid = "1234567890";
    if (str.value.length > 0) {
        for (var i = 0; i < str.value.length; i++) {
            temp = "" + str.value.substring(i, i + 1);
            if (valid.indexOf(temp) == "-1") {
                alert(msg);
                str.focus();
                return false;
            }
        }
    }
    return true;
}

//End

// Function For Checking String Length
//str = ClientId Of The Respective Control.
//msg = Msg To Be Shown.

function chklen(str) {
    var inValid = "<>";
    if (str.value.length <= 0 || str.value == "") {
        alert("Please enter search criteria");
        str.focus();
        return false;
    }
    if (str.value.length > 0) {
        for (var i = 0; i < str.value.length; i++) {
            temp = "" + str.value.substring(i, i + 1);
            if (inValid.indexOf(temp) >= "0") {
                alert("Please enter proper search criteria");
                str.focus();
                str.value = "";
                return false;
            }
        }
    }
    return true;
}

// Allow only integer but not zero at first place
function OnlyIntNotZeroAtFstPlace(obj) {
    obj = document.getElementById(obj);
    var val = obj.value;
    //var val=obj.value;                                              
    if (event.keyCode < 48 || event.keyCode > 57)
        event.returnValue = false;

    else if ((val == '' || document.selection.type == 'Text') && (event.keyCode == 48))
        event.returnValue = false;
    else
        event.returnValue = true;
}

function chkStr(str, msg) {
    var inValid = "<>";
    var strValue = str.value.replace(/^\s+/, '').replace(/\s+$/, '');
    strValue = strValue.replace(/&nbsp;/, '');
    if (strValue.length <= 0 || strValue == "") {
        alert(msg);
        str.value = "";
        str.focus();
        return false;
    }
    if (strValue.length > 0) {

        for (var i = 0; i < strValue.length; i++) {
            temp = "" + strValue.substring(i, i + 1);
            if (inValid.indexOf(temp) >= "0") {
                alert("InValid String.");
                str.focus();
                str.value = "";
                return false;
            }
        }
    }

    //
    return true;
}
// End Function

//Function For Checking DropDown List Selected Index
//str = ClientId Of The Respective Control.
//msg = Msg To Be Shown.

function chkddl(str, msg) {
    var strValue = str.selectedIndex;
    if (strValue < "1") {
        alert(msg);
        str.focus();
        return false;
    }
    return true;
}
//End Function

function doNotAllowTag() {
    if (event.keyCode == 60 || event.keyCode == 62) {
        event.returnValue = false;

    }
}


// Function For not allowing to enter wild characters used in sql percentage(%) and underscore(_)  Of String


function doNotAllowSQLTag() {

    if (event.keyCode == 37 || event.keyCode == 95) {
        event.returnValue = false;

    }
}




// Function For Checking Max Length Of String
// str = ClientId Of The Respective Control.
// maxlen = Maxium Allowable Length For That String.
// msg = Alert String For That Validation.

function chkmaxlen(str, maxlen, msg) {
    if (str.value.length > maxlen) {
        alert(msg);
        return false;
    }
    return true;
}

// End Function

// Flag Used For whether number is float(true) or integer(false) nos for no of integer part, dec for no of digits after decimal	point    
function checkNumbers(val, flag, nos, dec) {
    if (event.keyCode < 46 || event.keyCode > 57 || event.keyCode == 47) {
        event.returnValue = false;
    }
    if (event.keyCode == 47 && flag == 'true') {
        event.returnValue = false;
    }

    var val2 = val.value;

    if (val2.indexOf(".") == -1) {
        if (event.keyCode != 46) {
            if (val2.length >= nos)
                event.returnValue = false;
        }
    }
    else {
        if (event.keyCode != 47) {
            if (val2.length >= nos + dec + 1)
                event.returnValue = false;
        }
    }

    var varArr = val.value.split('.');

    if (varArr.length > 1 && event.keyCode == 46) {

        event.returnValue = false;
    }
    if (varArr.length > 1) {

        if (varArr[1].length > dec - 1)
            event.returnValue = false;
    }

    if (event.keyCode == 47 && flag == 'true') {
        var val1 = val.value

        for (i = 0; i < val1.length; i++) {
            if (val1.charAt(i) == ".") {
                event.returnValue = false;
            }
        }
    }

}

//checking only  number field WITH 9 DIGIT AND TWO DECIMAL
function allowOnlyNumberWithDec(val) {

    if (event.keyCode < 46 || event.keyCode > 57 || event.keyCode == 47) {
        event.returnValue = false;
        //	alert("pls enter number only");
    }
    var val2 = val.value


    if (val2.length >= 9 && val2.indexOf(".") == -1 && event.keyCode != 46) {
        event.returnValue = false;
    }
    if (event.keyCode == 46) {
        var val1 = val.value
        for (i = 0; i < val1.length; i++) {

            if (val1.charAt(i) == ".") {
                event.returnValue = false;
            }
        }
        if (event.keyCode == 46 && val1.length == 0) {
            val.value = '0';
        }

    }
}

//allow to decimal only
function allowTwodecimal(obj) {
    var val = obj.value;
    if (val.indexOf(".") != -1) {
        var arrval = val.split('.');
        if (arrval[1].length > 1) {
            event.returnValue = false;
        }
    }
}

//Function For Checking SubscriberId
function allowOnlySubscriberId(val) {
    var pflag = true;
    var cnt = 0;

    if (event.keyCode == 13) {
        event.returnValue = false;
    }
    else {
        if (val == "") {
            pflag = true
        }

        if (val.value.length < 4) {
            if (event.keyCode == 47) {
                event.returnValue = false;
                //alert("Please enter proper subscriber ID.");
                AlertModalPopup(val, 'Please enter proper subscriber ID')
            }
        }

        if (val.value.length > 4) {
            if (event.keyCode == 47)
                event.returnValue = false;
        }

        if ((event.keyCode < 48 || event.keyCode > 57) && ((event.keyCode != 47) || !(pflag))) {
            event.returnValue = false;
            //alert("Please enter proper subscriber ID.");
            AlertModalPopup(val, 'Please enter proper subscriber ID')
        }
        if ((event.keyCode == 47)) {
            pflag = false;
        }
    }
}
//End Function         


//only for integer only


function allowOnlyIntNumbers(val) {
    
    var pflag = true;
    var cnt = 0;
    if (val == "") {
        pflag = true
    }
    //if((event.keyCode < 48 || event.keyCode > 57) && ((event.keyCode != 46)||!(pflag)))
    if (event.keyCode < 48 || event.keyCode > 57) {
        event.returnValue = false;
        //alert("Please enter number only");
    }
    //		if ((event.keyCode == 46))
    //	      {
    //			pflag = false
    //		   cnt++;
    //		  }

}

//only for intgers only 

// Function to Clear txtbx value for Show All
function fnClear() {
    var arrTxt = fnClear.arguments;
    for (var i = 0; i < fnClear.arguments.length; i++) {
        var txt = document.getElementById(arrTxt[i]);
        if (txt.type == 'text') {
            txt.value = "";
        }
        else if (txt.type == 'select-one') {
            txt.selectedIndex = 0;
        }
    }
    return true;
}
// End Function


//function to chk html tags in string
function chkTags(str) {
    var inValid = "<>";
    var strValue = str.value.replace(/^\s+/, '').replace(/\s+$/, '');
    strValue = strValue.replace(/&nbsp;/, '');
    for (var i = 0; i < strValue.length; i++) {
        temp = "" + strValue.substring(i, i + 1);
        if (inValid.indexOf(temp) >= "0") {
            alert("InValid String.");
            str.focus();
            str.value = "";
            return false;
        }
    }
    return true;
}





//  //trim functions
// function Trim(str, chars) {
//    return Ltrim(Rtrim(str, chars), chars);
//}

//function Ltrim(str, chars) {
//    chars = chars || "\\s";
//    return str.replace(new RegExp("^[" + chars + "]+", "g"), "");
//}

//function Rtrim(str, chars) {
//    chars = chars || "\\s";
//    return str.replace(new RegExp("[" + chars + "]+$", "g"), "");
//}


// Function for Both trim (Left & Right)
function trim(str) {
    return ltrim(rtrim(str));
}
// Function for Left trim 
function ltrim(str) {
    for (var k = 0; k < str.length && isWhitespace(str.charAt(k)); k++);
    return str.substring(k, str.length);
}
// Function for Right trim 
function rtrim(str) {
    for (var j = str.length - 1; j >= 0 && isWhitespace(str.charAt(j)); j--);
    return str.substring(0, j + 1);
}
// Function to check wheather whitespace or not
function isWhitespace(charToCheck) {
    var whitespaceChars = " \t\n\r\f";
    return (whitespaceChars.indexOf(charToCheck) != -1);
}


//function to check selectd Check Box Vlaues , Radio button Values (This is for user to Selest Atleast One Item )
//chklist For Checkbox.clientId / Radio.clientId

function CheckChecbox(chklist, chklistmsg) {
    var chklistcount = chklist.cells.length;
    var i = 0;
    var j = 0;
    var arrayOfCheckBoxes = chklist.getElementsByTagName("input");
    for (i = 0; i < chklistcount; i++) {
        if (arrayOfCheckBoxes[i].checked) {
            j++;
        }

    }
    if (j <= 0) {
        alert("Please select atleast one " + chklistmsg)
        return false;
    }
    else {
        return true;
    }
}

//function to check selectd  ListBox items(This is for user to Selest Atleast One Item )
//listBox For  listbox.clientid

function CheckChecList(chklist, chklistmsg) {
    var chklistcount = chklist.length;
    if (chklistcount == 0) {
        //alert("Please select atleast one " + chklistmsg)
        return false;
    }
    else {
        return true;
    }
}

function requestQueryString(strvar) {
    // alert(" query string variable : "  + strvar);
    // var strExpression = "/\b"+ strvar + "\= *([^\&]+)/" || "\\s";;
    //   
    //  var str=location.search.match
    //alert(str[0]);
    // return str[1];
    return null;
}

var ObjButton = null;
function OnConfirmationMessageClick(Result) {
    // Signature for WebForm_DoPostBackWithOptions with descriptive parameter names.
    // WebForm_DoPostBackWithOptions(WebForm_PostBackOptions(eventTarget, eventArgument, validation, 
    // validationGroup, actionUrl, trackFocus, clientSubmit)) 
    if (Result == 1) {
        WebForm_DoPostBackWithOptions(new WebForm_PostBackOptions(ObjButton.name, '', true, '', '', true, true));
    }
}

function RegisterPostBack(btnDelete) {
    return "WebForm_DoPostBackWithOptions(new WebForm_PostBackOptions('" + btnDelete.name + "', '', true, '', '', true, true))";
}

function confirmMessage(strMsg, btnSave) {

    ObjButton = btnSave;
    wwMDConfirmationMessage.showDialog(strMsg, '');
    document.getElementById('MessageBoxCancel1').onblur = function check() { var doc = document.getElementById('MessageBoxOk1'); try { doc.focus(); } catch (er) { } };
    document.getElementById('MessageBoxOk1').onblur = function check1() { var doc = document.getElementById('MessageBoxCancel1'); try { doc.focus(); } catch (er) { } };
    document.getElementById('MessageBoxCancel1').onkeydown = function checkArr() { if (event.keyCode == 37 && document.getElementById('MessageBoxOk1').focus() == true) document.getElementById('MessageBoxOk1').focus(); else if (event.keyCode == 13 || event.keyCode == 32) return true; return false; };
    document.getElementById('MessageBoxOk1').onkeydown = function checkArr() { if (event.keyCode == 39 && document.getElementById('MessageBoxCancel1').focus() == true) document.getElementById('MessageBoxCancel1').focus(); else if (event.keyCode == 13 || event.keyCode == 32) return true; return false; };
    document.getElementById('MessageBoxCancel1').focus();
    return false;

}


function canEditRecord(hfEditRecord) {
    if (hfEditRecord.value == "0") {
        wwMDMessage.showDialog('<b><font color=Red>Please complete Add /Edit operation first</font></b>', '');
        document.getElementById('MessageBoxOk').focus();
        return false;
    }
    return true;
}

function canEditForDelete(hfEditRecord, strMsg, btnSave) {
    if (!canEditRecord(hfEditRecord)) {
        return false;
    }
    else if (!confirmMessage(strMsg, btnSave)) {
        return false;
    }
    return true;
}


function canEditForShowAll(hfEditRecord, txtFocus) {
    if (!canEditRecordAjax(hfEditRecord)) {
        return false;
    }
    else {
        var arrTxt = canEditForShowAll.arguments;
        for (var i = 0; i < canEditForShowAll.arguments.length; i++) {
            var txt = arrTxt[i];
            if (txt.type == 'text') {
                txt.value = "";
            }
            else if (txt.type == 'select-one') {
                txt.selectedIndex = 0;
            }
        }

    }
    return true;
}

function allowOnlyTwodecimal(obj) {
    var val = obj.value;

    if (event.keyCode < 46 || event.keyCode > 57 || event.keyCode == 47) {
        event.returnValue = false;
    }

    if (val.indexOf(".") != -1) {
        var arrval = val.split('.');

        if (isNaN(arrval[0])) {
            event.returnValue = false;
        }

        if (event.keyCode == 46) {
            event.returnValue = false;
        }

        if (arrval[1].length > 1) {
            event.returnValue = false;
        }

    }
}

function allowOnlyTwodecimalLimit(obj, _length) {
    var val = obj.value;
    if (val.length >= 9 && val.indexOf(".") == -1 && event.keyCode != 46) {
        event.returnValue = false;
    }
    if (event.keyCode < 46 || event.keyCode > 57 || event.keyCode == 47) {
        event.returnValue = false;
    }

    if (val.indexOf(".") != -1) {
        var arrval = val.split('.');

        // alert(_length);
        //if(arrval[0].length>_length)
        //{
        // alert('2');
        //  event.returnValue = false;
        // }

        if (isNaN(arrval[0])) {
            event.returnValue = false;
        }

        if (event.keyCode == 46) {
            event.returnValue = false;
        }

        if (arrval[1].length > 1) {
            event.returnValue = false;
        }

    }
}

function canEditRecordAjax(hfEditRecord) {
    var hfVal;
    if (typeof hfEditRecord == "object") {
        hfVal = hfEditRecord.value;
    }
    else {
        if (typeof hfEditRecord == "string") {
            hfVal = hfEditRecord;
        }
    }

    var index = hfVal.indexOf('#');
    var focusOn = "";
    var canEdit = "";
    if (index != -1) {
        var field_Array = hfVal.split("#");
        canEdit = field_Array[0];
        focusOn = field_Array[1];
        if (canEdit == 0) {
            if (focusOn != null) {
                AlertModalPopup(focusOn, "Please complete Add /Edit operation first")
                return false;
            }
            else {
                AlertModalPopup(null, "Please complete Add /Edit operation first")
                return false;
            }
        }

    }
    else {
        if (hfEditRecord.value == "0") {
            AlertModalPopup(null, "Please complete Add /Edit operation first")
            return false;
        }

    }
    return true;
}

function canEditForDeleteAjax(hfEditRecord, strMsg, btnSave) {
    if (!canEditRecordAjax(hfEditRecord)) {
        return false;
    }
    else if (!ShowActiveSms(btnSave, strMsg)) {
        return false;
    }
    return true;
}
//---------To check Character Count ----------
function countChar(txt, msgDiv, len) {
    var txt = document.getElementById(txt);
    var msgDiv = document.getElementById(msgDiv);
    count = txt.value.length;
    if (count <= Number(len)) {
        charLeft = Number(len) - count;
        val = charLeft + " character(s) left...";
        if (charLeft == 0) {
            msgDiv.innerHTML = "<font color=red font-family=Arial,Helvetica,sans-serif;font-size=10px>" + val + "</font>";
        }
        else {
            msgDiv.innerHTML = "<font color=green font-family=Arial,Helvetica,sans-serif font-size=10px>" + val + "</font>";
        }
    }
    else {
        txt.value = txt.value.substring(0, len);
        msgDiv.innerHTML = "<font color=red font-family=Arial,Helvetica,sans-serif;font-size=10px>0 characters ...</font>";
    }
}

function countRemarkChar(txt, msgDiv, len) {
    // this function does not change text color
    var txt = document.getElementById(txt);
    var msgDiv = document.getElementById(msgDiv);
    count = txt.value.length;
    if (count <= Number(len)) {
        charLeft = Number(len) - count;
        val = charLeft + " character(s) left...";
        msgDiv.innerHTML = val;
    }
    else {
        txt.value = txt.value.substring(0, len);
        msgDiv.innerHTML = "<font color=red font-family=Arial,Helvetica,sans-serif;font-size=10px>0 characters ...</font>";
    }
}

//-------To validate Phone Number
function allowPhoneNo(obj) {
    var val = obj.value;
    if (event.keyCode != 45)
        if (event.keyCode != 44)
        if (event.keyCode != 43)
        if (event.keyCode != 35)
        if (event.keyCode != 40)
        if (event.keyCode != 41)
        if (event.keyCode < 48 || event.keyCode > 57)
        event.returnValue = false;

    if (val.indexOf("-") != -1 && event.keyCode == 45)
        event.returnValue = false;
    if (val.indexOf("+") != -1 && event.keyCode == 43)
        event.returnValue = false;
    if (val.indexOf("#") != -1 && event.keyCode == 35)
        event.returnValue = false;

    if (val.indexOf("(") != -1 && event.keyCode == 40)
        event.returnValue = false;
    if (val.indexOf(")") != -1 && event.keyCode == 41)
        event.returnValue = false;
    if (obj.value.substring(obj.value.length - 1, obj.value.length) == ',' && event.keyCode == 44)
        event.returnValue = false;
}



function doNotAllowSpace() {
    if (event.keyCode == 32) {
        event.returnValue = false;

    }
}
function CheckMaxLength(obj, maxLen, controlName) {
    if (obj.value.length > maxLen) {
        //obj.value = obj.value.substring(0, maxLen-1);
        //alert(controlName+" should be less than "+maxLen+" characters");
        return false;
    }
    return true;
}



function checkNumbers1(val, flag, nos) {
    TxtVal = val.value;
    if (event.keyCode < 46 || event.keyCode > 57 || event.keyCode == 47) {
        event.returnValue = false;
    }
    if (event.keyCode == 47 && flag == 'true') {
        event.returnValue = false;
    }

    var val2 = val.value;
    if (val2.indexOf(".") == -1) {
        if (event.keyCode != 46) {
            if (val2.length >= nos)
                event.returnValue = false;
        }
    }
    else {
        if (event.keyCode != 47) {
            if (val2.length >= nos + 3)
                event.returnValue = false;
        }
    }

    var varArr = val.value.split('.');
    if (varArr.length > 1 && (event.keyCode == 190 || event.keyCode == 46 || event.keyCode == 110)) {
        var reg3 = /\./g;
        var reg3Array = reg3.exec(TxtVal);
        if (reg3Array != null) {

            var reg3Right = TxtVal.substring(reg3Array.index + reg3Array[0].length);
            reg3Right = reg3Right.replace(reg3, '');
            reg3Right = 2 > 0 ? reg3Right.substring(0, 2) : reg3Right;
            TxtVal = TxtVal.substring(0, reg3Array.index) + '.' + reg3Right;
            val.value = TxtVal;
            return false;
        }

        return false;
    }

    if (varArr.length > 1) {

        if (varArr[1].length > 1) {
            if (varArr[1].length > 2) {
                var a = TxtVal.indexOf(".");
                var Sub = TxtVal.substring(a, a + 3);
                var tex = TxtVal.substring(0, a);
                TxtVal = TxtVal.substring(0, TxtVal.indexOf(".")) + Sub;
                val.value = TxtVal;
                return false;
            }

            else if (varArr[0].length > nos) {
                first = TxtVal.substring(0, (TxtVal.indexOf(".")));
                second = TxtVal.indexOf(".")
                third = TxtVal.substring(second, (TxtVal.indexOf(".") + 3));
                if (first.length > nos) {
                    firstNew = TxtVal.substring(0, (nos));
                }
                val.value = firstNew + third;
                return false;
            }
        }
    }

    else {
        if (val.value.indexOf(".") == -1) {
            if (varArr[0].length > nos) {
                val.value = val.value.substring(0, nos);
                return false;
            }
        }
    }
    if (event.keyCode == 47 && flag == 'true') {
        var val1 = val.value
        for (i = 0; i < val1.length; i++) {
            if (val1.charAt(i) == ".") {
                event.returnValue = false;
            }
        }
    }

}

function allowOnlyDecimalNumbers() {
    if (event.keyCode < 46 || event.keyCode > 57 || event.keyCode == 47)
        event.returnValue = false;
    else
        event.returnValue = true;
}


// Flag Used For whether number is float(true) or integer(false) nos for no of integer part, dec for no of digits after decimal	point    
function checkNumbersOnKeyUp(val, flag, nos, dec) {
    TxtVal = val.value;
    if (event.keyCode < 46 || event.keyCode > 57 || event.keyCode == 47) {
        event.returnValue = false;
    }
    if (event.keyCode == 47 && flag == 'true') {
        event.returnValue = false;
    }

    var val2 = val.value;
    if (val2.indexOf(".") == -1) {
        if (event.keyCode != 46) {
            if (val2.length >= nos)
                event.returnValue = false;
        }
    }
    else {
        if (event.keyCode != 47) {
            if (val2.length >= nos + dec + 1)
                event.returnValue = false;
        }
    }

    var varArr = val.value.split('.');
    if (varArr.length > 1 && (event.keyCode == 190 || event.keyCode == 46 || event.keyCode == 110)) {
        var reg3 = /\./g;
        var reg3Array = reg3.exec(TxtVal);
        if (reg3Array != null) {

            var reg3Right = TxtVal.substring(reg3Array.index + reg3Array[0].length);
            reg3Right = reg3Right.replace(reg3, '');
            reg3Right = dec > 0 ? reg3Right.substring(0, dec) : reg3Right;
            TxtVal = TxtVal.substring(0, reg3Array.index) + '.' + reg3Right;
            val.value = TxtVal;
            return false;
        }

        return false;
    }

    if (varArr.length > 1) {

        if (varArr[1].length > 1) {
            if (varArr[1].length > dec) {
                var a = TxtVal.indexOf(".");
                var Sub = TxtVal.substring(a, a + dec + 1);
                var tex = TxtVal.substring(0, a);
                TxtVal = TxtVal.substring(0, TxtVal.indexOf(".")) + Sub;
                val.value = TxtVal;
                return false;
            }

            else if (varArr[0].length > nos) {
                first = TxtVal.substring(0, (TxtVal.indexOf(".")));
                second = TxtVal.indexOf(".")
                third = TxtVal.substring(second, (TxtVal.indexOf(".") + dec + 1));
                if (first.length > nos) {
                    firstNew = TxtVal.substring(0, (nos));
                }
                val.value = firstNew + third;
                return false;
            }
        }
    }

    else {
        if (val.value.indexOf(".") == -1) {
            if (varArr[0].length > nos) {
                val.value = val.value.substring(0, nos);
                return false;
            }
        }
    }
    if (event.keyCode == 47 && flag == 'true') {
        var val1 = val.value
        for (i = 0; i < val1.length; i++) {
            if (val1.charAt(i) == ".") {
                event.returnValue = false;
            }
        }
    }

}

function clearText(txtVal) {
    var txtVal = document.getElementById(txtVal);
    if (txtVal) {
        txtVal.value = '';
    }


}

function limiter(txtname, count) {

    var tex = document.getElementById(txtname).value;
    var len = tex.length;
    if (len > count) {
        tex = tex.substring(0, count);
        document.getElementById(txtname).value = tex;
        return false;
    }
}
function echeck(str) {
    var at = "@"
    var dot = "."
    var lat = str.indexOf(at)
    var lstr = str.length
    var ldot = str.indexOf(dot)
    if (str.indexOf(at) == -1) {
        alert("Please enter proper email id")
        return false
    }

    if (str.indexOf(at) == -1 || str.indexOf(at) == 0 || str.indexOf(at) == lstr) {
        alert("Please enter proper email id")
        return false
    }

    if (str.indexOf(dot) == -1 || str.indexOf(dot) == 0 || str.indexOf(dot) == lstr) {
        alert("Please enter proper email id")
        return false
    }

    if (str.indexOf(at, (lat + 1)) != -1) {
        alert("Please enter proper email id")
        return false
    }

    if (str.substring(lat - 1, lat) == dot || str.substring(lat + 1, lat + 2) == dot) {
        alert("Please enter proper email id")
        return false
    }

    if (str.indexOf(dot, (lat + 2)) == -1) {
        alert("Please enter proper email id")
        return false
    }

    if (str.indexOf(" ") != -1) {
        alert("Please enter proper email id")
        return false
    }

    return true
}


//Added by GURU on 31-03-09
//-------
////Put this on onKeyUp and onChange of Multiline Textbox//////
//-------
function MultilineCount(text, len) {
    var text = document.getElementById(text);
    var maxlength = new Number(len); // Change number to your max length.
    if (text.value.length > maxlength) {
        text.value = text.value.substring(0, maxlength);
        event.returnValue = false;
    }
}

// Flag Used For whether number is float(true) or integer(false) nos for no of integer part, dec for no of digits after decimal	point    
function checkNumbersOnKeyUp(val, flag, nos, dec) {
    TxtVal = val.value;
    if (event.keyCode < 46 || event.keyCode > 57 || event.keyCode == 47) {
        event.returnValue = false;
    }
    if (event.keyCode == 47 && flag == 'true') {
        event.returnValue = false;
    }

    var val2 = val.value;
    if (val2.indexOf(".") == -1) {
        if (event.keyCode != 46) {
            if (val2.length >= nos)
                event.returnValue = false;
        }
    }
    else {
        if (event.keyCode != 47) {
            if (val2.length >= nos + dec + 1)
                event.returnValue = false;
        }
    }

    var varArr = val.value.split('.');
    if (varArr.length > 1 && (event.keyCode == 190 || event.keyCode == 46 || event.keyCode == 110)) {
        var reg3 = /\./g;
        var reg3Array = reg3.exec(TxtVal);
        if (reg3Array != null) {

            var reg3Right = TxtVal.substring(reg3Array.index + reg3Array[0].length);
            reg3Right = reg3Right.replace(reg3, '');
            reg3Right = dec > 0 ? reg3Right.substring(0, dec) : reg3Right;
            TxtVal = TxtVal.substring(0, reg3Array.index) + '.' + reg3Right;
            val.value = TxtVal;
            return false;
        }

        return false;
    }

    if (varArr.length > 1) {

        if (varArr[1].length > 1) {
            if (varArr[1].length > dec) {
                var a = TxtVal.indexOf(".");
                var Sub = TxtVal.substring(a, a + dec + 1);
                var tex = TxtVal.substring(0, a);
                TxtVal = TxtVal.substring(0, TxtVal.indexOf(".")) + Sub;
                val.value = TxtVal;
                return false;
            }

            else if (varArr[0].length > nos) {
                first = TxtVal.substring(0, (TxtVal.indexOf(".")));
                second = TxtVal.indexOf(".")
                third = TxtVal.substring(second, (TxtVal.indexOf(".") + dec + 1));
                if (first.length > nos) {
                    firstNew = TxtVal.substring(0, (nos));
                }
                val.value = firstNew + third;
                return false;
            }
        }
    }

    else {
        if (val.value.indexOf(".") == -1) {
            if (varArr[0].length > nos) {
                val.value = val.value.substring(0, nos);
                return false;
            }
        }
    }
    if (event.keyCode == 47 && flag == 'true') {
        var val1 = val.value
        for (i = 0; i < val1.length; i++) {
            if (val1.charAt(i) == ".") {
                event.returnValue = false;
            }
        }
    }

}

function chkLoginName(fieldnm, msg, chkmsg) {
    var fieldValue = fieldnm.value;
    fieldValue = fieldValue.replace(/^\s+/, '');
    fieldValue = fieldValue.replace(/&nbsp;/, '');
    var valid = "\!@#$%^&*()+={}[]|:;<>,.?/";
    var temp;
    if (fieldValue.length > 0) {
        for (var i = 0; i < fieldValue.length; i++) {
            temp = "" + fieldValue.substring(i, i + 1);
            if (valid.indexOf(temp) >= "0" || temp == " ") {
                alert(msg);
                fieldnm.focus();
                return false;
            }
        }
    }
    if (fieldValue.length == 0) {
        alert(chkmsg);
        fieldnm.focus();
        return false;
    }
    return true;
}

// Added by Adesh
// If user try to paste the special tags call this script on onkeyup or onblur
function functionforReplaceTag(txt) {
    var txtVal = txt.value;
    txtVal = txtVal.replace('>', '&gt;')
    txtVal = txtVal.replace('<', '&lt;')
    txt.value = txtVal;
}
function checkAllOnKeyPress(event, buttonToClick, txt) {
    if (doNotAllowTag(event) && fnEnterKey(event, buttonToClick)) {
        return true;
    }
    return false;
}
function checkAllOnKeyPressWithoutSpace(event, buttonToClick, txt) {
    if (doNotAllowTags(event) && fnEnterKeys(event, buttonToClick) && removeSpaces(event, txt)) {
        return true;
    }
    return false;
}


// Function that does not allow HTML tags('<' & '>')
function doNotAllowTags(event) {
    if (event == null) {
        return false;
    }
    var keyCode = (window.Event) ? event.which : event.keyCode;
    if (keyCode == 60 || keyCode == 62) {
        event.cancelBubble = true;
        event.returnValue = false;
        return false;
    }
    return true;
}

// Function to click button when hit ENTER key
function fnEnterKeys(event, buttonToClick) {
    if (event == null) {
        return false;
    }
    var keyCode = (window.Event) ? event.which : event.keyCode;
    if (keyCode == 13) {
        event.cancelBubble = true;
        event.returnValue = false;
        document.getElementById(buttonToClick).click();
        return false;
    }
    return true;
}

//Function to remove space 
function removeSpaces(event, txt) {
    if (event == null) {
        return false;
    }
    var keyCode = (window.Event) ? event.which : event.keyCode;
    if (keyCode == 32) {
        event.cancelBubble = true;
        event.returnValue = false;
        document.getElementById(txt).focus();
        return false;
    }
    return true;
}
// End

// Added by Adesh

// If user try to paste the special tags call this script on onkeyup or onblur
function functionforReplaceTag(txt) {
    var txtVal = txt.value;
    txtVal = txtVal.replace('>', '&gt;')
    txtVal = txtVal.replace('<', '&lt;')
    txt.value = txtVal;
}

function AllowCharacterWithNumber() {
    if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 65 && event.keyCode <= 90) || (event.keyCode >= 97 && event.keyCode <= 122) || event.keyCode == 13)
        event.returnValue = true;
    else
        event.returnValue = false;
}

function AllowCharacterWithNumberandSpace() {
    if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode >= 65 && event.keyCode <= 90) || (event.keyCode >= 97 && event.keyCode <= 122) || event.keyCode == 13 || event.keyCode == 32)
        event.returnValue = true;
    else
        event.returnValue = false;
}

function AllowCharacterOnly() {
    if ((event.keyCode >= 65 && event.keyCode <= 90) || (event.keyCode >= 97 && event.keyCode <= 122) || event.keyCode == 13)
        event.returnValue = true;
    else
        event.returnValue = false;
}


function AllowCharacterWithSpace() {
    if ((event.keyCode >= 65 && event.keyCode <= 90) || (event.keyCode >= 97 && event.keyCode <= 122) || event.keyCode == 13 || event.keyCode == 32)
        event.returnValue = true;
    else
        event.returnValue = false;
}

function EscHandler(e) {
    var kC = (window.event) ? event.keyCode : e.keyCode;
    var Esc = (window.event) ? 27 : e.DOM_VK_ESCAPE // MSIE : Firefox  

    if (kC == Esc) {
        e.returnValue = false;
        return false;
    }
    return true;
}

//End

/*--------------------LOCKING-------------------------------*/
var IntervalCode;
function ReleaseLock() {
    IntervalCode = window.clearInterval(IntervalCode);
}
function refreshTime(code, classname) {
   // debugger
    var params = "action=refreshRecordLock&className=" + classname + "&code=" + code;
    AjaxUpdater.Update('GET', '../Master/ProcessResponseRequest.aspx', getResponse, params);
}
function refreshLock(code, classname) {
  //  debugger
    IntervalCode = setInterval("refreshTime(" + code + ",'" + classname + "')", 15000);
}
function getResponse() {
}
/*--------------------LOCKING-------------------------------*/

/*--------------------User Rights-------------------------------*/

var arrSystemRights = new Array();
arrSystemRights[0] = 1 //RightCodeForAdd
arrSystemRights[1] = 2 //RightCodeForEdit
arrSystemRights[2] = 3 //RightCodeForActivate 
arrSystemRights[3] = 4 //RightCodeForDeactivate
arrSystemRights[4] = 5 //RightCodeForReleaseLock 
arrSystemRights[5] = 6 //RightCodeForDelete
arrSystemRights[6] = 7 //RightCodeForView
arrSystemRights[7] = 8 // RightCodeForDealSendForApprove
arrSystemRights[8] = 9 // RightCodeForDealRelease
arrSystemRights[9] = 10 // RightCodeForClone
arrSystemRights[10] = 11 // RightCodefor Approve
arrSystemRights[11] = 12  // RightCode for Reject
arrSystemRights[12] = 13  //Right Code for Apply
arrSystemRights[13] = 16  //Right Code for Re-Apply
arrSystemRights[14] = 17  //Right Code for Obtain
arrSystemRights[15] = 18 //Right Code for btnAmendment
arrSystemRights[16] = 19 //Right Code for Amort
arrSystemRights[17] = 79 //AMENDMENT AFTER SYNDICATION
arrSystemRights[18] = 80 //BUSSINESS STATEMENT INFO
arrSystemRights[19] = 83 //O/S INFO DATA CAPTURE
arrSystemRights[20] = 85 //Grade Exception
arrSystemRights[21] = 87 //Boxset Title Mapping
arrSystemRights[22] = 86 //Royalty Exchange Rate
arrSystemRights[23] = 88 //Close Deal
arrSystemRights[24] = 89 //Re-Open Deal
arrSystemRights[25] = 90 //ASSIGN PLATFORMS
arrSystemRights[26]=71 //ACQ CONTENT
arrSystemRights[27] = 65//ACQ LINKDATA
arrSystemRights[28] = 98//Movie close
arrSystemRights[29] = 97//Forecast Revenue
arrSystemRights[30] = 116//Rollback to Privious version

var Deal_Type_Movie = 1
var Deal_Type_Content = 11;
var Deal_Type_Event = 22;
var Deal_Type_Format_Program = 13;
var Deal_Type_Documentary_Show = 9;
var Deal_Type_Other = 17;
var Deal_Type_Sports = 27;
var Deal_Type_Music = 5;
var Deal_Type_ContentMusic = 30;

var Deal_Program = "Deal_Program";
var Deal_Music = "Deal_Music";
var Deal_Movie = "Deal_Movie";
var Sub_Deal_Talent = "Sub_Deal_Talent";

function GetDealTypeCondition(selectedDealTypeCode) {
    if (selectedDealTypeCode == Deal_Type_Content || selectedDealTypeCode == Deal_Type_Sports || selectedDealTypeCode == Deal_Type_Format_Program
        || selectedDealTypeCode == Deal_Type_Event || selectedDealTypeCode == Deal_Type_Documentary_Show) {
        return Deal_Program;
    }
    else if (selectedDealTypeCode == Deal_Type_Music || selectedDealTypeCode == Deal_Type_ContentMusic)
        return Deal_Music;
    else if (selectedDealTypeCode == Deal_Type_Movie)
        return Deal_Movie;
    else
        return Sub_Deal_Talent;
}

function isVisibleButtonUserRights(button, right) {
    var hdnCurrentRights = document.getElementById('hdnRights');
    arrCurrentRights = hdnCurrentRights.value.split("~");
    if (right != null && right > 0) {
        for (i = 0; i < arrCurrentRights.length; i++) {
            if (arrCurrentRights[i] == right) {
                button.style.display = 'block'
                break;
            }
            else
                button.style.display = 'none'
        }
    }
}

/*--------------------User Rights-------------------------------*/

function allowOnlyIntegerNumber(event) {
    if (event == null) {
        return false;
    }
    var keyCode = (window.Event) ? event.which : event.keyCode;
    if ((keyCode < 48 || keyCode > 57) && keyCode != 0 && keyCode != 8 && keyCode != 9) {
        event.cancelBubble = true;
        event.returnValue = false;
        return false;
    }
    return true;
}


// Flag Used For whether number is float(true) or integer(false) nos for no of integer part, dec for no of digits after decimal	point    
function checkNumbersOnKeyUp(val, flag, nos, dec) {
    TxtVal = val.value;
    if (event.keyCode < 46 || event.keyCode > 57 || event.keyCode == 47) {
        event.returnValue = false;
    }
    if (event.keyCode == 47 && flag == 'true') {
        event.returnValue = false;
    }

    var val2 = val.value;
    if (val2.indexOf(".") == -1) {
        if (event.keyCode != 46) {
            if (val2.length >= nos)
                event.returnValue = false;
        }
    }
    else {
        if (event.keyCode != 47) {
            if (val2.length >= nos + dec + 1)
                event.returnValue = false;
        }
    }

    var varArr = val.value.split('.');
    if (varArr.length > 1 && (event.keyCode == 190 || event.keyCode == 46 || event.keyCode == 110)) {
        var reg3 = /\./g;
        var reg3Array = reg3.exec(TxtVal);
        if (reg3Array != null) {

            var reg3Right = TxtVal.substring(reg3Array.index + reg3Array[0].length);
            reg3Right = reg3Right.replace(reg3, '');
            reg3Right = dec > 0 ? reg3Right.substring(0, dec) : reg3Right;
            TxtVal = TxtVal.substring(0, reg3Array.index) + '.' + reg3Right;
            val.value = TxtVal;
            return false;
        }

        return false;
    }

    if (varArr.length > 1) {

        if (varArr[1].length > 1) {
            if (varArr[1].length > dec) {
                var a = TxtVal.indexOf(".");
                var Sub = TxtVal.substring(a, a + dec + 1);
                var tex = TxtVal.substring(0, a);
                TxtVal = TxtVal.substring(0, TxtVal.indexOf(".")) + Sub;
                val.value = TxtVal;
                return false;
            }

            else if (varArr[0].length > nos) {
                first = TxtVal.substring(0, (TxtVal.indexOf(".")));
                second = TxtVal.indexOf(".")
                third = TxtVal.substring(second, (TxtVal.indexOf(".") + dec + 1));
                if (first.length > nos) {
                    firstNew = TxtVal.substring(0, (nos));
                }
                val.value = firstNew + third;
                return false;
            }
        }
    }

    else {
        if (val.value.indexOf(".") == -1) {
            if (varArr[0].length > nos) {
                val.value = val.value.substring(0, nos);
                return false;
            }
        }
    }
    if (event.keyCode == 47 && flag == 'true') {
        var val1 = val.value
        for (i = 0; i < val1.length; i++) {
            if (val1.charAt(i) == ".") {
                event.returnValue = false;
            }
        }
    }

}
function Trim(str) {
    while (str.substring(0, 1) == ' ') // check for white spaces from beginning
    {
        str = str.substring(1, str.length);
    }
    while (str.substring(str.length - 1, str.length) == ' ') // check white space from end
    {
        str = str.substring(0, str.length - 1);
    }

    return str;
}
 //Avoid right click
function right(e) {
if (navigator.appName == 'Netscape' && 
(e.which == 3 || e.which == 2))
return false;
else if (navigator.appName == 'Microsoft Internet Explorer' && 
(event.button == 2 || event.button == 3)) {
 
return false;
}
return true;
}

document.onmousedown=right;
document.onmouseup=right;
if (document.layers) window.captureEvents(Event.MOUSEDOWN);
if (document.layers) window.captureEvents(Event.MOUSEUP);
window.onmousedown=right;
window.onmouseup = right;

//------------All Methods Written by Abhay
function TrimAmount(text) {
    return text.replace(/^\s+|\s+$/g, "");
}
//taking the value and removing comma and returning the Number value.
function RemoveCommas(nStr) {
    var newVal = nStr.replace(/\,/g, '');
    x = newVal.split(' ');
    if (!isNaN(x[0])) {
        return x[0]
    }
    else if(!isNaN(x[1])){
        return x[1];
    }
    else{
        return nStr;
    }
}

//---------taking the numberValue and add comma
//---------CountryCode Must be INR or USD 
function addCommas(nStr) {
    nStr = TrimAmount(nStr);
    var code = ReadConfigurationSettings();
    code = code.toUpperCase();
    if (code == "INR") {
        return IndianFormat(nStr);
    }
    else if (code == "USD") {
        return USFormat(nStr);
    }
    else
        return nStr; //------if CountryCode doesNot match so returning as is it number without any changes.
}

//-------Pass the gridViewId and CellIndex, It will automatically add Comma in that cell's first control's value
function addCommaInCurrencyInGridView(gridrow, cellIndex) {
    var rowLen = gridrow.rows.length;
    if (rowLen > 0) {
        for (i = 2; i < rowLen; i++) {
            var val = gridrow.rows[i].cells[cellIndex].childNodes[0].innerText;
            if (val != "") {
                val = addCommas(val);
                gridrow.rows[i].cells[cellIndex].childNodes[0].innerText = val;
            }
        }
    }
}

//------This is for USFormat, It returns the string with addition of ' $' at the end
function USFormat(nStr) {
    var x = nStr.split('.');
    var x1 = x[0];
    var x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;
}

//------This is for IndianFormat, It returns the string with addition of ' INR' at the end
function IndianFormat(nStr) {
    var x = nStr.split('.');
    var x1 = x[0];
    var len = x1.length;
    if (len > 3) {
        var x2 = x1.substr(len - 3, 3);
        x1 = x1.substr(0, len - 3);

        var x3 = x.length > 1 ? '.' + x[1] : '';
        var rgx = /(\d+)(\d{2})/;
        while (rgx.test(x1)) {
            x1 = x1.replace(rgx, '$1' + ',' + '$2');
        }
        return x1 + "," + x2 + x3;
    }
    else {
        return nStr;
    }
}

function MakeDateFormate(dateInString) {
    if (dateInString != null || dateInString != "") {
        var array = dateInString.split('/');
        var month = parseFloat(array[1]);
        switch (month) {
            case 1:
                array[1] = "Jan";
                break;

            case 2:
                array[1] = "Feb";
                break;

            case 3:
                array[1] = "Mar";
                break;

            case 4:
                array[1] = "Apr";
                break;

            case 5:
                array[1] = "May";
                break;

            case 6:
                array[1] = "Jun";
                break;

            case 7:
                array[1] = "Jul";
                break;

            case 8:
                array[1] = "Aug";
                break;

            case 9:
                array[1] = "Sep";
                break;

            case 10:
                array[1] = "Oct";
                break;

            case 11:
                array[1] = "Nov";
                break;

            case 12:
                array[1] = "Dec";
                break;
        }
        var format = array[0] + " " + array[1] + " " + array[2];
        return format;
    }
    return "";
}

// Start Record Locking Code
var RecordLockInterval;
function ReleaseRecordLock() {
    RecordLockInterval = window.clearInterval(RecordLockInterval);
}
function RefreshRecordReleaseTime(code) {
    var params = "action=RFL&RLCode=" + code;
    AjaxUpdater.Update('GET', '../Master/ProcessResponseRequest.aspx', getResponse, params);
}
function Call_RefreshRecordReleaseTime(code) {
    RefreshRecordReleaseTime(code);
    RecordLockInterval = setInterval("RefreshRecordReleaseTime(" + code + ")", 15000);
}
// End Record Locking Code

//--------End Abhay
