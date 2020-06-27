<%@ Page Language="C#" EnableEventValidation="false" AutoEventWireup="true"
    Inherits="Reports_rptDealQuery" CodeBehind="rptDealQuery.aspx.cs" MasterPageFile="~/Home.Master" UnobtrusiveValidationMode="None" %>

<%@ Register TagPrefix="UTO" Namespace="UTOFrameWork.FrameworkClasses" Assembly="RightsU_Plus" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" 
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">
    <link rel="stylesheet" href="../Master/stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />

    <script type="text/javascript" src="../Master/JS/master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/common.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/AjaxUpdater.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/Ajax.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/multiSelection.js"></script>
    <script type="text/javascript" src="../Master/JS/HTTP.js"></script>

    <script type="text/javascript" src="../JS_Core/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery-ui.min.js"></script>
    <script type="text/javascript" src="../JS_Core/common.concat.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <%--Start Chosen--%>
    <script type="text/javascript" src="../JS_Core/chosen.jquery.min.js"></script>
    <link href="../CSS/chosen.min.css" rel="stylesheet" />
    <%--End Chosen--%>

    <style type="text/css">
        DIV.auto1 { 
            vertical-align: top;
            overflow: auto;
            width: 1000px;
            height: 365px;
        }

        .chosen-container .chosen-results li {
            color: initial;
        }

        /*Datepick css start*/

        select, textarea {
            font-family: Arial,Helvetica,Sans-serif;
            font-size: 100%;
        }

        .demo .ui-datepicker-row-break {
            font-size: 100%;
        }

        .ui-datepicker td {
            padding: 0px;
            vertical-align: inherit;
        }

        .ui-datepicker-header.ui-widget-header.ui-helper-clearfix.ui-corner-all {
            width: 180px;
        }

        table.ui-datepicker-calendar {
            width: 181px;
        }

        .reportViewer {
            border-style: Solid;
            height: 600px !Important;
            margin-top: 15px;
            width: 100%;
        }

        .reportViewer table {
            width: initial;
        }

        td.tabBorder4 > div > div {
            background-color: #fff;
            padding: 12px 10px;
        }
        .imgBracket {height: 100%;}
    </style>
    <script type="text/javascript">
    var dateWatermarkFormat = "DD/MM/YYYY";
    var dateWatermarkColor = '#999';
    var dateNormalkColor = '#000';

    $(document).ready(function () {
        CreateTablepostback();
        Load();
    });

    function Load() {
        AssignChosenJQuery();
        AssignDateJQuery();
        AssignReportViewerCSS();
    }

    function AssignReportViewerCSS() {
            <%--$("#<%=ReportViewer1.ClientID %> table").each(function (i, item) {
                $(item).css('display', 'inline-block');
            });

            $("#<%=ReportViewer1.ClientID %> table.aspNetDisabled").each(function (i, item) {
                $(item).css('display', 'none');
            });

            $("div#oReportDiv").css('overflow', 'initial');--%>
    }

    function AssignChosenJQuery() {
        try {
            $('.Chosenlb').chosen({ width: "auto" });
            $('.Chosenlb100').chosen({ width: "1000px" });
            $('#<%= ddlcolList.ClientID %>').chosen({ width: "180px" });
        }
        catch (e) { }
    }

    function AssignDateJQuery() {
        debugger;
        var fromDate = $('#txtfrom').val();
        var toDate = $('#txtto').val();

        if (fromDate == dateWatermarkFormat) {
            fromDate = "";
            $('#txtfrom').val(fromDate);
        }

        if (toDate == dateWatermarkFormat) {
            toDate = "";
            $('#txtto').val(toDate);
        }

        $('.dateRange').datepick({
            onSelect: customRange, dateFormat: 'dd/mm/yyyy', pickerClass: 'demo',
            autoSize: true,
            renderer: $.datepick.themeRollerRenderer
        });

        function customRange(dates) {
            if (this.id == 'txtfrom') {
                if ($('#txtfrom').val() != 'DD/MM/YYYY' && $('#txtfrom').val() != '') {
                    $('#txtto').datepick('option', 'minDate', dates[0] || null);
                    $('#txtfrom').css('color', dateNormalkColor);
                }
                else {
                    $('#txtto').datepick('option', { minDate: null });
                    $('#txtfrom').val(dateWatermarkFormat);
                    $('#txtfrom').css('color', dateWatermarkColor);
                }
            }
            else {
                if ($('#txtto').val() != 'DD/MM/YYYY' && $('#txtto').val() != '') {
                    $('#txtfrom').datepick('option', 'maxDate', dates[0] || null);
                    $('#txtto').css('color', dateNormalkColor);
                }
                else {
                    $('#txtfrom').datepick('option', { maxDate: null });
                    $('#txtto').val(dateWatermarkFormat);
                    $('#txtto').css('color', dateWatermarkColor);
                }
            }
        }

        $('.dateRange').Watermark(dateWatermarkFormat);

        if (fromDate != "")
            $('#txtfrom').val(fromDate)

        if (toDate != "")
            $('#txtto').val(toDate)
    }

    function ClearSelectedOptions() {
        $('.Chosenlb100 option').prop('selected', false);
        $('.Chosenlb100').trigger('chosen:updated')
    }

    function hasOptions(obj) {
        if (obj != null && obj.options != null) { return true; }
        return false;
    }

    function MoveSelectUp(fromObj, Btn, hdnValue) {
        var from = document.getElementById(fromObj);
        var upBtn = document.getElementById(Btn);

        if (!hasOptions(from))
            return;

        var selectedOpt = from.options[0]; //dummy
        var prevOpt = from.options[0]; //dummy
        var selectedIndx = 0;

        for (var i = 0; i < from.options.length; i++) {
            var selectedOpt = from.options[i];

            if (i > 0)
                prevOpt = from.options[i - 1];

            if (selectedOpt.selected) {
                selectedIndx = i;
                break;
            }
        }

        if (selectedIndx < 1)
            return;

        from.options[i - 1] = new Option(selectedOpt.text, selectedOpt.value, false, false);
        from.options[i] = new Option(prevOpt.text, prevOpt.value, false, false);

        if (i - 1 > 0) {
            from.selectedIndex = i - 1;
            upBtn.focus();
        }

        hdnVar = document.getElementById(hdnValue);
        showSelectedListWithOutSort(from, hdnVar, '~', null);
    }

    function showSelectedListWithOutSort(sourceListBox, destinationText, delimiter, output_string) {
        var size = sourceListBox.length;
        var str = "";

        var unSortedArray = new Array();
        var sortedArray = new Array();
        var arrayCounter = 0;

        for (i = 0; i < size; i++)
            if (sourceListBox[i].value != '') {
                unSortedArray[arrayCounter++] = sourceListBox[i].value;

                if (output_string != null)
                    output_string.value += sourceListBox[i].text + ", ";
            }

        sortedArray = unSortedArray;

        if (delimiter == null) delimiter = "#";


        for (i = 0; i < sortedArray.length; i++)
            str += sortedArray[i] + delimiter;

        if (output_string != null)
            output_string.value = output_string.value.substring(0, (output_string.value.length - 2))

        str = str.substring(0, (str.length - 1))
        destinationText.value = str;
        return str;
    }

    function MoveSelectDown(fromObj, Btn, hdnValue) {
        debugger
        var from = document.getElementById(fromObj);
        var dnBtn = document.getElementById(Btn);

        if (!hasOptions(from))
            return;

        var selectedOpt = from.options[0]; //dummy
        var NextOpt = from.options[0]; //dummy
        var selectedIndx = from.options.length + 2;

        for (var i = 0; i < from.options.length; i++) {
            var selectedOpt = from.options[i];
            if (selectedOpt.selected) {
                selectedIndx = i;
                break;
            }
        }

        if (selectedIndx >= from.options.length - 1)
            return;

        NextOpt = from.options[i + 1];

        from.options[i + 1] = new Option(selectedOpt.text, selectedOpt.value, false, false);
        from.options[i] = new Option(NextOpt.text, NextOpt.value, false, false);

        if (i < from.options.length - 2) {
            from.selectedIndex = i + 1;
            dnBtn.focus();
        }

        hdnVar = document.getElementById(hdnValue);
        showSelectedListWithOutSort(from, hdnVar, '~', null);
    }

    //show three main panel
    function showdiv(divname) {
        debugger;
        var rptType = document.getElementById('<%= hdnReportType.ClientID %>');

        if (divname == 'divCondition') {
            document.getElementById("divCondition").style.display = 'block';
            document.getElementById("divcols").style.display = 'none';
            document.getElementById("divresult").style.display = 'none';
            document.getElementById("<%= divReport.ClientID %>").style.display = 'none';
            document.getElementById("<%= imgcriteria.ClientID %>").src = "../images/criteriaOn.png";
            document.getElementById("<%= imgcolumns.ClientID %>").src = "../images/columnsOff.png";
            document.getElementById("<%= imgresults.ClientID %>").src = "../images/resultOff.png";

            document.getElementById("<%= imgcriteria.ClientID %>").disabled = true;
            document.getElementById("<%= imgcolumns.ClientID %>").disabled = false;
            document.getElementById("<%= imgresults.ClientID %>").disabled = false;
        }

        if (divname == 'divcols') {
            document.getElementById("divcols").style.display = 'block'
            document.getElementById("divCondition").style.display = 'none'
            document.getElementById("divresult").style.display = 'none'
            document.getElementById("<%= divReport.ClientID %>").style.display = 'none'
                document.getElementById("<%= imgcolumns.ClientID %>").src = "../images/columnsOn.png";
                document.getElementById("<%= imgcriteria.ClientID %>").src = "../images/criteriaOff.png";
                document.getElementById("<%= imgresults.ClientID %>").src = "../images/resultOff.png";
                document.getElementById("<%= imgcriteria.ClientID %>").disabled = false;
                document.getElementById("<%= imgcolumns.ClientID %>").disabled = true;
                document.getElementById("<%= imgresults.ClientID %>").disabled = false;
            }

            if (divname == 'divresult') {
                document.getElementById("divresult").style.display = 'block'
                document.getElementById("<%= divReport.ClientID %>").style.display = 'block'
                document.getElementById("divcols").style.display = 'none'
                document.getElementById("divCondition").style.display = 'none'
                document.getElementsByName("<%= imgresults.ClientID %>").src = "../images/resultOff.png";
                document.getElementById("<%= imgcriteria.ClientID %>").disabled = false;
                document.getElementById("<%= imgcolumns.ClientID %>").disabled = false;
                document.getElementById("<%= imgresults.ClientID %>").disabled = true;
            }
        }

        function fillMultiesChannel(lstRt, hdnValue) {
            var lstRt = document.getElementById(lstRt);
            var hdnValue = document.getElementById(hdnValue);
            showSelectedListWithOutSort(lstRt, hdnValue, '~', null);
        }

        function changedDivView(obj) {
            debugger;
            HideAllDive();
            var val = obj.value;
            var divname = 'CphdBody_divlist' + val;
            var test = document.getElementById(divname);
            ClearForm(val);

            if (val != 0) {
                var test = document.getElementById(divname);
                document.getElementById(divname).style.display = ''

                ShowHideDivOrAnd(val);
                SetFocus(obj);
            }
        }

        function ShowHideDivOrAnd(val) {
            debugger;
            // If search criteria contains Sub/Dub/Country, then OR condition cannot be selected.
            //  ~COU.Country_Code~ in ~'140','145','146','10'~and~S_Lang~ in ~'20'~and~D_Lang~ in ~'16','6'~and

            var strHidStr = document.getElementById("<%= hidStringAllCond.ClientID %>").value;
            var arrHidStringAllCond = strHidStr.split('~');
            var cntSubDubCountry = 0;

            try {
                if (arrHidStringAllCond.length > 1) {
                    for (var i = 0; i < arrHidStringAllCond.length; i = i + 5) {
                        if (arrHidStringAllCond[i + 1].indexOf("S_Lang") > -1)
                            cntSubDubCountry++;

                        if (arrHidStringAllCond[i + 1].indexOf("D_Lang") > -1)
                            cntSubDubCountry++;

                        if (arrHidStringAllCond[i + 1].indexOf("COU.Country_Code") > -1)
                            cntSubDubCountry++;
                    }
                }
            }
            catch (e) { }

            if (strHidStr == "")
                document.getElementById("DivOrAnd" + val).style.display = 'none';
            else {
                if (cntSubDubCountry == arrHidStringAllCond.length / 5)
                    document.getElementById("DivOrAnd" + val).style.display = 'none';
                else
                    document.getElementById("DivOrAnd" + val).style.display = '';
            }
        }

        function SetFocus(val) {
            if (val) {
                var hdAllIDlist = document.getElementById("theAutoIDFocusList");
                var strAllID = hdAllIDlist.value;
                var arrAllID = strAllID.split('~');
                var theID = arrAllID[val - 1];

                if (theID)
                    document.getElementById(theID).focus();
            }
        }

        function HideAllDive() {
            var count = parseInt(document.getElementById("<%= hdnColCount.ClientID %>").value)
            for (var i = 0; i <= count; i++) {
                var divname = 'CphdBody_divlist' + i;

                if (document.getElementById(divname))
                    document.getElementById(divname).style.display = 'none'
            }
        }

        function AddCondition(colName) {
            debugger;
            var hidStringAllCond = document.getElementById("<%= hidStringAllCond.ClientID %>");
            var tmpStr = '~' + colName;
            var colnum = document.getElementById("<%= ddlcolList.ClientID %>").value;
            var objcriterialist = document.getElementById("<%= ddlcolList.ClientID %>");
            var colText = objcriterialist[objcriterialist.selectedIndex].text;
            var objRbtn = document.getElementsByName("RadioInNotin" + colnum);
            var condition = findvalueradiobutton(objRbtn);
            var Listregion = document.getElementById("ddlValueList" + colnum);
            var selectedValues = $("#ddlValueList" + colnum).val() || [];

            if (selectedValues.length == 0) {
                AlertModalPopup(Listregion, "Please select item from list");
                return false;
            }

            var listval = "";
            var listText = "";

            for (var i = 0; i < Listregion.length; i++) {
                if (Listregion[i].selected) {
                    listval = listval + ",'" + Listregion[i].value + "'";
                    listText = listText + ", " + Listregion[i].text;
                }
            }

            //text to show user
            var userview = "";
            listText = listText.substring(1, listText.length);
            listval = listval.substring(1, listval.length);
            var query = "";

            if (condition == 1) {
                query = colName + ' in (' + listval + ')';
                userview = colText + ' in (' + listText + ')';
                tmpStr = tmpStr + '~' + ' in ~' + listval;
            }
            else {
                query = colName + ' not in (' + listval + ')'
                userview = colText + ' not in (' + listText + ')';
                tmpStr = tmpStr + '~' + ' not in ~' + listval;
            }

            var objradioAndOr = document.getElementsByName("radioandor" + colnum);
            var conditionAndOr = findvalueradiobutton(objradioAndOr);

            if (conditionAndOr == 1) {
                tmpStr = tmpStr + '~and'
                //save user  text
                document.getElementById("<%= hidUserText.ClientID %>").value = document.getElementById("<%= hidUserText.ClientID %>").value + "~" + userview;
                //save query
                //shriyal2 document.getElementById("hidstringAnd").value = document.getElementById("hidstringAnd").value +"~"+ query ;
                //   addNewRecord(colnum,query,"listconditionAND");
            }
            else {
                tmpStr = tmpStr + '~or'
                query = 'OR!' + query
                //save user  text
                document.getElementById("<%= hidUserText.ClientID %>").value = document.getElementById("<%= hidUserText.ClientID %>").value + "~ OR " + userview;
                //save query
                //shriyal2 document.getElementById("hidstringAnd").value = document.getElementById("hidstringAnd").value +"~"+ query ;
                // addNewRecord(colnum,query,"listconditionAND");
            }

            hidStringAllCond.value = hidStringAllCond.value + tmpStr;
            //--alert('hidUserText:' + document.getElementById("hidUserText").value);              
            //--alert('hidstringAnd:' + document.getElementById("hidstringAnd").value);
            //--alert('hidStringAllCond:' + hidStringAllCond.value);
            //hide div

            document.getElementById("<%= ddlcolList.ClientID %>").options[0].selected = true;
            var divname = 'CphdBody_divlist' + colnum;
            document.getElementById(divname).style.display = 'none'
            //remove item from dropdown list
            document.getElementById("<%= hidID.ClientID %>").value = document.getElementById("<%= hidID.ClientID %>").value + "~" + colnum + "$" + colText;
            //RemoveItemFormDropdownList(colnum);
            //create table again
            CreateTable();
            $('#<%= ddlcolList.ClientID %>').trigger("chosen:updated");
            return false;
        }

        function addNewRecord(id, colname, pass, tablename) {
            var tbl = document.getElementById(tablename);
            var newRow = tbl.insertRow(tbl.rows.length);
            var newCell0 = newRow.insertCell(0);
            var newCell1 = newRow.insertCell(1);
            var newCell2 = newRow.insertCell(2);

            newCell0.innerHTML = "<span class=normal>" + colname + "</span>";
            newCell0.setAttribute('width', '20%');
            newCell1.innerHTML = "<span class=normal>" + pass + "</span>";
            newCell1.setAttribute('width', '70%');
            newCell2.setAttribute('width', '10%');
            newCell2.setAttribute('align', 'center');
            newCell2.innerHTML = "&nbsp;&nbsp;<input type=button class='button' id =buttondelete value=Delete onclick='removerow(" + id + ")' />";

            RemoveItemFormDropdownList(id);
            $('#<%= ddlcolList.ClientID %>').trigger("chosen:updated");
        }

        function addDateCondition(colName) {
            addDateConditionCommon(colName, true);
        }

        //add date condition used in current code
        function addDateConditionCommon(colName, checkEndDt) {
            var hidStringAllCond = document.getElementById("<%= hidStringAllCond.ClientID %>");
            var objcriterialist = document.getElementById("<%= ddlcolList.ClientID %>");
            var tmpStr = '~' + colName;
            var colText = objcriterialist[objcriterialist.selectedIndex].text;
            var colnum = document.getElementById("<%= ddlcolList.ClientID %>").value;

            if (document.getElementById('txtDate1Field' + colnum).value == "") {
                AlertModalPopup(null, "Please select date");
                return false;
            }

            var objradio = document.getElementsByName("DateOption" + colnum);
            var condition = findvalueradiobutton(objradio);
            var Dateval = "";
            var DateText = "";
            var userview = "";
            var query = "";
            var Dateval = document.getElementById('txtDate1Field' + colnum).value;

            if (condition == 1) {
                query = colName + ' = ' + Dateval;
                userview = colText + ' = ' + Dateval;
                tmpStr = tmpStr + '~' + ' = ~' + Dateval;
            }

            if (condition == 2) {
                query = colName + ' > ' + Dateval;
                userview = colText + ' greater than ' + Dateval;
                tmpStr = tmpStr + '~' + ' > ~' + Dateval;
            }

            if (condition == 3) {
                query = colName + ' < ' + Dateval;
                userview = colText + ' less than ' + Dateval;
                tmpStr = tmpStr + '~' + ' < ~' + Dateval;
            }

            if (condition == 4) {
                if (checkEndDt)
                    if (document.getElementById('txtDate2Field' + colnum).value == "") {
                        AlertModalPopup(null, "Please select end date");
                        return false;
                    }

                if (checkEndDt || (checkEndDt == false && document.getElementById('txtDate2Field' + colnum).value != ""))
                    if (!validateDate_DMY(document.getElementById('txtDate1Field' + colnum).value, document.getElementById('txtDate2Field' + colnum).value)) {
                        AlertModalPopup(null, "Please select From date should be prior than To date");
                        return false;
                    }

                var datevalOth = document.getElementById('txtDate2Field' + colnum).value;

                if (datevalOth == "") {
                    userview = colText + ' after ' + Dateval;
                    query = colName + ' >= ' + Dateval;
                }
                else {
                    query = colName + ' between ' + Dateval + ' and ' + datevalOth;
                    userview = colText + ' between ' + Dateval + ' and ' + datevalOth;
                }

                tmpStr = tmpStr + '~' + ' between ~ ' + Dateval + ' and ' + datevalOth;
            }

            var objradioAndOr = document.getElementsByName("radioandor" + colnum);
            var conditionAndOr = findvalueradiobutton(objradioAndOr);

            if (conditionAndOr == 1) {
                tmpStr = tmpStr + '~and'
                document.getElementById("<%= hidUserText.ClientID %>").value = document.getElementById("<%= hidUserText.ClientID %>").value + "~" + userview;
            }
            else {
                tmpStr = tmpStr + '~or'
                query = 'OR!' + query
                document.getElementById("<%= hidUserText.ClientID %>").value = document.getElementById("<%= hidUserText.ClientID %>").value + "~ OR " + userview;
            }

            hidStringAllCond.value = hidStringAllCond.value + tmpStr;
            document.getElementById("<%= ddlcolList.ClientID %>").options[0].selected = true;
            var divname = 'CphdBody_divlist' + colnum;
            document.getElementById(divname).style.display = 'none'
            document.getElementById("<%= hidID.ClientID %>").value = document.getElementById("<%= hidID.ClientID %>").value + "~" + colnum + "$" + colText;
            CreateTable();
            RemoveItemFormDropdownList(colnum);
            $('#<%= ddlcolList.ClientID %>').trigger("chosen:updated");
            return false;
        }

        //add Dropdown Condation used in current code
        function AddDDLCondition(textcol) {

            var hidStringAllCond = document.getElementById("<%= hidStringAllCond.ClientID %>");
            var tmpStr = '~' + textcol;
            var objcriterialist = document.getElementById("<%= ddlcolList.ClientID %>");
            var colText = objcriterialist[objcriterialist.selectedIndex].text;
            var colnum = document.getElementById("<%= ddlcolList.ClientID %>").value;

            if (document.getElementById('ddlValueList' + colnum).value == "") {
                var tempCtrl = document.getElementById('ddlValueList' + colnum);
                AlertModalPopup(tempCtrl, "Please Select value");
                return false;
            }

            var objradio = document.getElementsByName("TextOption" + colnum);
            var condition = findvalueradiobutton(objradio);
            var query = "";
            var userText = "";
            var temp = "";
            var tstring = "";
            var tstring = trim(document.getElementById('ddlValueList' + colnum).value.replace(/\'/g, "''"))
            var ddl = document.getElementById('ddlValueList' + colnum);

            if (condition == 1) {
                query = "  " + textcol + " = '" + tstring + "'"
                userText = colText + " = " + ddl.options[ddl.selectedIndex].text;
                tmpStr = tmpStr + '~' + " = ~'" + tstring + "'";
            }
            else {
                query = "  " + textcol + " <> '" + tstring + "'"
                userText = colText + " Not Equal to " + ddl.options[ddl.selectedIndex].text;
                tmpStr = tmpStr + '~' + " <> ~'" + tstring + "'";
            }

            var objradioAndOr = document.getElementsByName("radioandor" + colnum);
            var conditionAndOr = findvalueradiobutton(objradioAndOr);

            if (conditionAndOr == 1) {
                tmpStr = tmpStr + '~and'
                document.getElementById("<%= hidUserText.ClientID %>").value = document.getElementById("<%= hidUserText.ClientID %>").value + "~" + userText;
            }
            else {
                tmpStr = tmpStr + '~or'
                document.getElementById("<%= hidUserText.ClientID %>").value = document.getElementById("<%= hidUserText.ClientID %>").value + "~ OR " + userText;
            }

            hidStringAllCond.value = hidStringAllCond.value + tmpStr;
            document.getElementById("<%= ddlcolList.ClientID %>").options[0].selected = true;
            var divname = 'CphdBody_divlist' + colnum;
            document.getElementById(divname).style.display = 'none'
            document.getElementById("<%= hidID.ClientID %>").value = document.getElementById("<%= hidID.ClientID %>").value + "~" + colnum + "$" + colText;
            CreateTable();
            $('#<%= ddlcolList.ClientID %>').trigger("chosen:updated");
        }

        function AddYesOrNoCondition(textcol) {

            var hidStringAllCond = document.getElementById("<%= hidStringAllCond.ClientID %>");
            var tmpStr = '~' + textcol;
            var objcriterialist = document.getElementById("<%= ddlcolList.ClientID %>");
            var colText = objcriterialist[objcriterialist.selectedIndex].text;
            var colnum = document.getElementById("<%= ddlcolList.ClientID %>").value;
            var objradio = document.getElementsByName("YesNoOption" + colnum);
            var condition = findvalueradiobutton(objradio);
            var query = "";
            var userText = "";
            var selectedval = condition.split("~");

            query = "  " + textcol + " = '" + selectedval[0] + "'";
            userText = colText + " in " + selectedval[1];
            tmpStr = tmpStr + '~' + " in ~'" + selectedval[0] + "'";

            var objradioAndOr = document.getElementsByName("radioandor" + colnum);
            var conditionAndOr = findvalueradiobutton(objradioAndOr);

            if (conditionAndOr == 1) {
                tmpStr = tmpStr + '~and'
                document.getElementById("<%= hidUserText.ClientID %>").value = document.getElementById("<%= hidUserText.ClientID %>").value + "~" + userText;
            }
            else {
                tmpStr = tmpStr + '~or'
                document.getElementById("<%= hidUserText.ClientID %>").value = document.getElementById("<%= hidUserText.ClientID %>").value + "~ OR " + userText;
            }

            hidStringAllCond.value = hidStringAllCond.value + tmpStr;
            document.getElementById("<%= ddlcolList.ClientID %>").options[0].selected = true;
            var divname = 'CphdBody_divlist' + colnum;
            document.getElementById(divname).style.display = 'none'
            document.getElementById("<%= hidID.ClientID %>").value = document.getElementById("<%= hidID.ClientID %>").value + "~" + colnum + "$" + colText;
            CreateTable();
            $('#<%= ddlcolList.ClientID %>').trigger("chosen:updated");
        }

        function AddTextCondition(textcol, texttype) {

            var hidStringAllCond = document.getElementById("<%= hidStringAllCond.ClientID %>");
            var tmpStr = '~' + textcol;
            var objcriterialist = document.getElementById("<%= ddlcolList.ClientID %>");
            var colText = objcriterialist[objcriterialist.selectedIndex].text;
            var colnum = document.getElementById("<%= ddlcolList.ClientID %>").value;

            if (Trim(document.getElementById('txtTextField' + colnum).value) == "") {
                var tempCtrl = document.getElementById('txtTextField' + colnum);
                AlertModalPopup(tempCtrl, "Please enter value");
                return false;
            }

            if (texttype == 'Number') {
                if (checknumval(document.getElementById('txtTextField' + colnum), "invalid numbers")) {
                    if (colText.toUpperCase() == 'YEAR OF RELEASE') {
                        if (document.getElementById('txtTextField' + colnum).value.indexOf('.') != -1) {
                            alert('Not a valid year!');
                            return false;
                        }
                    }
                }
                else
                    return false;
            }

            var objradio = document.getElementsByName("TextOption" + colnum);
            var condition = findvalueradiobutton(objradio);
            var query = "";
            var userText = "";
            var temp = "";
            var tstring = "";
            var tstring = trim(document.getElementById('txtTextField' + colnum).value.replace(/\'/g, "''"))

            if (condition == 1) {
                query = "  " + textcol + " = '" + tstring + "'"
                userText = colText + " = " + trim(document.getElementById('txtTextField' + colnum).value);
                tmpStr = tmpStr + '~' + " = ~'" + tstring + "'";
            }

            if (condition == 2) {
                if (texttype == 'Text') {
                    query = "  " + textcol + " like '" + tstring + "%'";
                    userText = colText + " starts with " + trim(document.getElementById('txtTextField' + colnum).value);
                    tmpStr = tmpStr + '~' + " like ~'" + tstring + "%'";
                }
                else {
                    query = "  " + textcol + " > '" + tstring + " '";
                    userText = colText + " greater than " + trim(document.getElementById('txtTextField' + colnum).value);
                    tmpStr = tmpStr + '~' + " > ~'" + tstring + "'";
                }
            }

            if (condition == 3) {
                if (texttype == 'Text') {
                    query = "  " + textcol + " like '%" + tstring + "%'"
                    userText = colText + " contains the word '" + trim(document.getElementById('txtTextField' + colnum).value) + "'";
                    tmpStr = tmpStr + '~' + " like ~'%" + tstring + "%'";
                }
                else {
                    query = "  " + textcol + " < '" + tstring + "'"
                    userText = colText + " less than " + trim(document.getElementById('txtTextField' + colnum).value);
                    tmpStr = tmpStr + '~' + " < ~'" + tstring + "'";
                }
            }

            var objradioAndOr = document.getElementsByName("radioandor" + colnum);
            var conditionAndOr = findvalueradiobutton(objradioAndOr);

            if (conditionAndOr == 1) {
                tmpStr = tmpStr + '~and'
                document.getElementById("<%= hidUserText.ClientID %>").value = document.getElementById("<%= hidUserText.ClientID %>").value + "~" + userText;
            }
            else {
                tmpStr = tmpStr + '~or'
                document.getElementById("<%= hidUserText.ClientID %>").value = document.getElementById("<%= hidUserText.ClientID %>").value + "~ OR " + userText;
            }

            hidStringAllCond.value = hidStringAllCond.value + tmpStr;
            document.getElementById("<%= ddlcolList.ClientID %>").options[0].selected = true;
            var divname = 'CphdBody_divlist' + colnum;
            document.getElementById(divname).style.display = 'none'
            document.getElementById("<%= hidID.ClientID %>").value = document.getElementById("<%= hidID.ClientID %>").value + "~" + colnum + "$" + colText;
            CreateTable();
            $('#<%= ddlcolList.ClientID %>').trigger("chosen:updated");
        }

        function showOtherDate() {
            var colnum = document.getElementById("<%= ddlcolList.ClientID %>").value;
            var objradio = document.getElementsByName("DateOption" + colnum);
            var condition = findvalueradiobutton(objradio);

            if (condition == 4)
                document.getElementById("tdDate" + colnum).style.display = "inline";
            else
                document.getElementById("tdDate" + colnum).style.display = "none";
        }
        function showcal(val) {
            var colnum = document.getElementById("<%= ddlcolList.ClientID %>").value;

            if (val == 1)
                call_makecalendar(document.getElementById("txtdateField" + colnum));
            else
                call_makecalendar(document.getElementById("txtotherdatefield" + colnum));
        }
        function removerow(i) {
            if (!DeleteConfirmMSg(i, "Are you sure, you want to delete this criteria ?"))
                return false;
        }

        function DeleteRow(i) {
            var table1 = document.getElementById("<%= listconditionAND.ClientID %>");
            var fromI = 0;
            var hidval = document.getElementById("<%= hidstringAnd.ClientID %>").value
            var hidid = document.getElementById("<%= hidID.ClientID %>").value
            var hiduserText = document.getElementById("<%= hidUserText.ClientID %>").value
            var idist = hidid.split('~');
            var conditionlist = hidval.split('~');
            var userTextList = hiduserText.split('~');
            var newval = "";
            var newid = "";
            var newusertext = "";

            if (userTextList.length == 2) //shriyal2  
            {
                document.getElementById("<%= ddlcolList.ClientID %>").options[0].selected = true;
                HideAllDive();
            }

            for (j = 1; j < userTextList.length; j++) //shriyal2
            {
                var itemval = idist[j].split('$');

                if (itemval[0] != i) {
                    newid = newid + "~" + idist[j];
                    newusertext = newusertext + "~" + userTextList[j];
                }
                else {
                    fromI = 4 * j - 3;  // 4: column ~ operation ~ value ~ AndOr
                    document.getElementById("<%= ddlcolList.ClientID %>").add(new Option(itemval[1], itemval[0]));
                }
            }

            document.getElementById("<%= hidID.ClientID %>").value = newid;
            document.getElementById("<%= hidUserText.ClientID %>").value = newusertext;
            ClearForm(i);
            CreateTable();
            ClearSelectedOptions();

            var hidStringAllCond = document.getElementById("<%= hidStringAllCond.ClientID %>");
            var hidStringAllCondStr = hidStringAllCond.value;

            arrHidStringAllCond = hidStringAllCondStr.split('~');
            newhidStringAllCondStr = "";

            for (k = 1; k < arrHidStringAllCond.length; k++) {
                if (k < fromI || k >= fromI + 4)
                    newhidStringAllCondStr = newhidStringAllCondStr + "~" + arrHidStringAllCond[k];
            }

            hidStringAllCond.value = newhidStringAllCondStr;
            $('#<%= ddlcolList.ClientID %>').trigger("chosen:updated");
            return false;
        }

        function RemoveItemFormDropdownList(id) {
            var obj = document.getElementById("<%= ddlcolList.ClientID %>")
            for (var i = 0; i < obj.length; i++) {
                if (obj.options[i].value == id)
                    obj.options[i] = null;
            }
        }
        function CreateTable() {
            //clear all rows;
            var table = document.getElementById('<%= listconditionAND.ClientID %>');
            var rows = table.rows;
            var hidid = document.getElementById("<%= hidID.ClientID %>").value
            var userText = document.getElementById("<%= hidUserText.ClientID %>").value;

            while (rows.length) // length=0 -> stop         
                table.deleteRow(rows.length - 1);

            if (hidid.length > 0) {
                var idist = hidid.split('~');
                var userlist = userText.split('~');

                for (j = 1; j < userlist.length; j++) {
                    var itemval = idist[j].split('$');
                    addNewRecord(itemval[0], itemval[1], userlist[j], "<%= listconditionAND.ClientID %>");
                }
            }
        }
        function CreateTablepostback() {
            debugger;
            var hidval = document.getElementById("<%= hidstringAnd.ClientID %>").value
            var hidid = document.getElementById("<%= hidID.ClientID %>").value

            if (hidid.length > 0) {
                CreateTable();
                document.getElementById("<%= imgcriteria.ClientID %>").src = "../images/criteriaOff.png";
                document.getElementById("<%= ddlcolList.ClientID %>").options[0].selected = true;
            }
            else {
                document.getElementById("divCondition").style.display = 'block'
                document.getElementById("divcols").style.display = 'none'
                document.getElementById("divresult").style.display = 'none'
                document.getElementById("<%= divReport.ClientID %>").style.display = 'none'
            }
        }

        function getColListvalue() {
            debugger;

            var hidUserText = document.getElementById("<%= hidUserText.ClientID %>").value; //shriyal2
            var hdnCol = document.getElementById("<%= hdnCol.ClientID %>").value; //Tushar

            if (hdnCol == "") {
                AlertModalPopup(ddlCriteria, "Please select column to be displayed");
                return false;
            }

            if (hidUserText.length == 0) {
                var ddlCriteria = document.getElementById("<%= ddlcolList.ClientID %>");

                if (ddlCriteria.value == "0")
                    AlertModalPopup(ddlCriteria, "Please select criteria from list");
                else
                    AlertModalPopup(ddlCriteria, "Please add at least one condition");

                showdiv('divCondition');
                return false;
            }

            document.getElementById("divresult").style.display = 'block'
            document.getElementById("<%= divReport.ClientID %>").style.display = 'block'
            document.getElementById("divcols").style.display = 'none'
            document.getElementById("divCondition").style.display = 'none'
        }
        function findvalueradiobutton(objradio) {
            for (var i = 0; i < objradio.length; i++) {
                if (objradio[i].checked == true) {
                    condition = objradio[i].value
                    return condition;
                }
            }
        }
        function Restoreradiovalue(obj, val) {
            for (var i = 0; i < obj.length; i++) {
                if (obj[i].value == val)
                    obj[i].checked = true;
            }
        }
        function CancelClick(id) {
            document.getElementById('<%= ddlcolList.ClientID %>').options[0].selected = true;
            $('#<%= ddlcolList.ClientID %>').trigger('chosen:updated');

            ClearSelectedOptions();
            HideAllDive();
            ClearForm(id);
        }
        function ClearForm(id) {
            if (document.getElementById('txtTextField' + id))
                document.getElementById('txtTextField' + id).value = "";

            if (document.getElementsByName('TextOption' + id))
                Restoreradiovalue(document.getElementsByName('TextOption' + id), "1");

            if (document.getElementsByName("radioandor" + id))
                Restoreradiovalue(document.getElementsByName("radioandor" + id), "1");

            if (document.getElementsByName('StatusOption' + id))
                Restoreradiovalue(document.getElementsByName('StatusOption' + id), "1");

            if (document.getElementsByName('SendOption' + id))
                Restoreradiovalue(document.getElementsByName('SendOption' + id), "1");

            if (document.getElementsByName("RadioInNotin" + id))
                Restoreradiovalue(document.getElementsByName("RadioInNotin" + id), "1");

            if (document.getElementsByName("DateOption" + id))
                Restoreradiovalue(document.getElementsByName("DateOption" + id), "1");

            if (document.getElementById('txtDate1Field' + id))
                document.getElementById('txtDate1Field' + id).value = "";

            if (document.getElementById('txtotherdatefield' + id))
                document.getElementById('txtotherdatefield' + id).value = "";

            if (document.getElementById("LstSelectedList" + id) != null)
                RestoreListBox(document.getElementById("LstValueList" + id), document.getElementById("LstSelectedList" + id))

            if (document.getElementById("divlistotherdate" + id))
                document.getElementById("divlistotherdate" + id).style.display = "none";
        }
        function RestoreListBox(objList, objselectedList) {
            var countval = objselectedList.length;
            for (var i = 0; i < countval; i++) {
                objList.add(new Option(objselectedList.options[0].text, objselectedList.options[0].value));
                objselectedList.options[0] = null;
            }
            //sortlist(objList) ;
        }

        function DeleteConfirmMSg(btnDelete, message) {
            var confirmExt = $find('CBExtDelete');
            var lblmessage = $get('lblConfirmText');
            lblmessage.innerText = message;
            confirmExt._displayConfirmDialog();

            if ($get('btnConfirmCancel'))
                $get('btnConfirmCancel').focus();

            confirmExt.set_postBackScript("DeleteRow(" + btnDelete + ");");
            return false;
        }

        function ToggleAll(cbAllId, tblOfColsId) {
            var tblOfCols = document.getElementById(tblOfColsId);
            var cbAll = document.getElementById(cbAllId);
            var cbVal = cbAll.checked;
            var aTR;

            if (tblOfCols) {
                var rCnt = 0;
                rCnt = tblOfCols.rows.length;

                if (rCnt > 1) {
                    for (i = 1; i < rCnt; i++) {
                        aTR = tblOfCols.rows[i];
                        aTR.cells[1].children[0].checked = cbVal;
                    }
                }
            }
            else {
                alert('check id:' + tblOfColsId)
            }
        }

        function child(url) {
            self.showModalDialog(url, "List of Errors", "status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;dialogWidth:400px;dialogHeight:250px;scroll:yes")
            return;
        }


        // ----------- Commented code -----------
        function addDateConditionOptEndDt(colName) { }

        function moveAll(From, To) {
            var fromObj = document.getElementById(From);// $("#"+From);
            var toObj = document.getElementById(To);
            var fromObjLen = fromObj.options.length;
            for (var i = 0; i < fromObjLen; i++) {
                if (fromObj.options[0] != null)
                    fromObj.options[0].selected = true;

                move(From, To)
            }
        }

        function move(fromObj, toObj) {
            var from = document.getElementById(fromObj); //$("#" + fromObj);
            var to = document.getElementById(toObj); //$("#" + toObj);

            //comment by sachin by :sachin
            //new function written for move item in two list box 
            if (!hasOptions(from)) { return; }
            for (var i = 0; i < from.options.length; i++) {
                var o = from.options[i];
                if (o.selected) {
                    if (!hasOptions(to)) { var index = 0; } else { var index = to.options.length; }
                    to.options[index] = new Option(o.text, o.value, false, false);
                }
            }
            // Delete them from original
            for (var i = (from.options.length - 1) ; i >= 0; i--) {
                var o = from.options[i];
                if (o.selected) {
                    from.options[i] = null;
                }
            }
            //	if ((arguments.length<3) || (arguments[2]==true)) {
            //		sortSelect(from);
            //	sortSelect(to);
            //		}
            from.selectedIndex = -1;
            to.selectedIndex = -1;
            if (from.options.length > 0) {
                from.options[0].focus();
                from.options[0].selected = true;
            }
        }

        function imgResultClientClick() {
            debugger;
            return getColListvalue(); showLoading(); CreateTablepostback(); showdiv('divresult'); changeimg(this)
        }

        function CheckForSave() {

            if ($("#<%=txtQName.ClientID%>").val().trim() == "") {
                $("#" + "<%=txtQName.ClientID%>").attr('required', true);
                return false;
            }

        }
        function RemoveRequiredValidation() {   
            $("#" + "<%=txtQName.ClientID%>").attr('required', false);
        }
    </script>

    <asp:ScriptManager ID="smDealQryRpt" runat="server" AsyncPostBackTimeout="0">
    </asp:ScriptManager>
    <table align="center" border="0" cellpadding="0" valign='top' cellspacing="0" width="98%">
        <tr height="25">
            <td align="right" style="width: 100%">
                <div class="title_block dotted_border clearfix">
                    <h2 class="pull-left">
                        <asp:Label ID="lblVwType" runat="server" Text=""></asp:Label>
                        Query Report
                    </h2>
                </div>
            </td>
        </tr>
        <tr>
            <td class="normal" style="width: 100%" valign="top">
                <asp:UpdatePanel ID="upDealQryRpt" runat="server" ChildrenAsTriggers="true" UpdateMode="Conditional">
                    <ContentTemplate>
                        <table cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td class="normal">
                                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                            <td colspan="4">&nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="normal1" valign="bottom" style="width: 86px;">
                                                <img src="../images/criteriaOn.png" runat="server" style="cursor: pointer; height: 28px;" id="imgcriteria"
                                                    border="0" alt="Query Criteria" onclick="javascript:CreateTablepostback();showdiv('divCondition')" />
                                            </td>
                                            <td valign="bottom" style="width: 95px;">
                                                <img src="../images/columnsOff.png" style="cursor: pointer" runat="server" id="imgcolumns"
                                                    border="0" alt="Query Columns" onclick="javascript:CreateTablepostback();showdiv('divcols')" />
                                            </td>
                                            <td valign="bottom">
                                                <asp:ImageButton ID="imgresults" runat="server" AlternateText="Query Result" ImageUrl="../images/resultOff.png"
                                                    OnClientClick="javascript:return imgResultClientClick();"
                                                    OnClick="imgresults_Click"
                                                    style="vertical-align: middle;border: 0;max-width: 100%;height: auto;padding: 0px;" />
                                            </td>
                                            <td class="normal1" width="70%"></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" class="tabBorder4">
                                    <div class="tab-content table-wrapper" style="margin-bottom: 10px">
                                        <div id="divCondition" style="display: none">
                                            <table width='100%' border='0' cellpadding='0' cellspacing='0' align='center' valign='top'>
                                                <tr>
                                                    <td class='normal'>
                                                        <table width="100%" cellpadding="2" cellspacing="0" align="center" border="0" runat="server"
                                                            id="htblCrit" class="paging">
                                                            <tr>
                                                                <td class="white">&nbsp;&nbsp;Select Criteria&nbsp;&nbsp;
                                                                    <asp:DropDownList ID="ddlcolList" runat="server" CssClass="select">
                                                                        <asp:ListItem Value="0" Selected="True">----select -----</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr height="25">
                                                    <td class="search" style="padding-top: 15px">&nbsp;&nbsp;List of Conditions&nbsp; &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="normal">
                                                        <table class="table table-bordered table-hover">
                                                            <tr>
                                                                <th width="20%">Criteria</th>
                                                                <th width="70%" align="center">Condition</th>
                                                                <th width="10%">Action</th>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <asp:Table ID="listconditionAND" runat="server" CssClass="table table-bordered table-hover">
                                                        </asp:Table>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div id="divcols" style="display: none">
                                            <table width="100%" cellpadding="0" cellspacing="0" class="main" align="center" border="0">
                                                <tr style="display: none">
                                                    <td class="normal" align="center">
                                                        <b>Columns to be displayed in result</b>
                                                    </td>
                                                </tr>
                                                <tr style="display: none">
                                                    <td align="center">
                                                        <table cellpadding="5" cellspacing="0" align="center" class="main" border="0" id="Table1x"
                                                            width="98%">
                                                            <tr>
                                                                <td width="50%" align="right">
                                                                    <input id="cbSelAll" type="checkbox" runat="server" />
                                                                </td>
                                                                <td>&nbsp;
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="center">
                                                        <div class="auto1" id="auto" style="width: 98%">
                                                            <table cellpadding="5" cellspacing="0" align="center" cssclass="main" border="1"
                                                                runat="server" id="htblDisp">
                                                            </table>
                                                        <asp:UpdatePanel runat="server">
                                                             <ContentTemplate>
                                                            <table border="0" cellpadding="2" cellspacing="0" valign="top" style="width: 8%"
                                                                align="center">
                                                                <tr>
                                                                    <td colspan='1' align="center" style="padding: 5px 0 25px 0;">
                                                                        <b>Columns to be displayed in result</b>
                                                                    </td>
                                                                    <td colspan='2' id ="chkAlternateLanguage_temp"style="padding-bottom: 14px;">
                                                                        <asp:CheckBoxList ID="chkAlternateLanguage" runat="server" OnSelectedIndexChanged="chkAlternateLanguage_SelectedIndexChanged" AutoPostBack="True" RepeatDirection="Horizontal">
                                                                        </asp:CheckBoxList>
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td>
                                                                       <asp:ListBox ID="lsCol" runat="server" class="select" ondblclick="move('CphdBody_lsCol','CphdBody_lsrCol');fillMultiesChannel('CphdBody_lsrCol', 'CphdBody_hdnCol');"
                                                                            Width="250px" Height="250" SelectionMode="Multiple"></asp:ListBox>
                                                                       <AjaxToolkit:ListSearchExtender ID="ListSearchExtender2" runat="server" PromptCssClass="ListSearchExtenderPrompt"
                                                                            TargetControlID="lsCol">
                                                                        </AjaxToolkit:ListSearchExtender>
                                                                    </td>
                                                                    <td>
                                                                        <input type="button" onclick="moveAll('CphdBody_lsCol', 'CphdBody_lsrCol'); fillMultiesChannel('CphdBody_lsrCol', 'CphdBody_hdnCol');"
                                                                            id="Button1" runat="server" class="button" value=">>" style="cursor: hand; margin: 9px 7px;" /><br>
                                                                        <input type="button" onclick="move('CphdBody_lsCol', 'CphdBody_lsrCol'); fillMultiesChannel('CphdBody_lsrCol', 'CphdBody_hdnCol');"
                                                                            id="Button3" runat="server" class="button" value=" > " style="cursor: hand; margin: 9px 7px;" /><br>
                                                                        <input type="button" onclick="move('CphdBody_lsrCol', 'CphdBody_lsCol'); fillMultiesChannel('CphdBody_lsrCol', 'CphdBody_hdnCol');"
                                                                            id="Button4" runat="server" class="button" value=" < " style="cursor: hand; margin: 9px 7px;" />
                                                                        <input type="button" onclick="moveAll('CphdBody_lsrCol', 'CphdBody_lsCol'); fillMultiesChannel('CphdBody_lsrCol', 'CphdBody_hdnCol');"
                                                                            id="Button2" runat="server" class="button" value="<<" style="cursor: hand; margin: 9px 7px;" />
                                                                    </td>
                                                                    <td width="35%">
                                                                        <asp:ListBox ID="lsrCol" runat="server" class="select" Width="250px" Height="250"
                                                                            SelectionMode="Multiple" ondblclick="move('CphdBody_lsrCol', 'CphdBody_lsCol');fillMultiesChannel('CphdBody_lsrCol', 'CphdBody_hdnCol');"></asp:ListBox>
                                                                        <AjaxToolkit:ListSearchExtender ID="lserCol" runat="server" PromptCssClass="ListSearchExtenderPrompt"
                                                                            TargetControlID="lsrCol">
                                                                        </AjaxToolkit:ListSearchExtender>
                                                                        <asp:HiddenField ID="hdnCol" runat="server" />
                                                                    </td>
                                                                    <td>
                                                                        <img title='Up' src="../images/scroll-up.gif" onclick="MoveSelectUp('CphdBody_lsrCol', 'UP', 'CphdBody_hdnCol');"
                                                                            alt="" style="cursor: hand; min-width: 8px;" id="UP" />
                                                                        <br />
                                                                        <br />
                                                                        <br />
                                                                        <br />
                                                                        <br />
                                                                        <img title='Down' src="../images/scroll-down.gif" onclick="MoveSelectDown('CphdBody_lsrCol', 'Down', 'CphdBody_hdnCol');"
                                                                            alt="" style="cursor: hand; min-width: 8px;" id="Down" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                             </ContentTemplate>                                                            
                                                            <Triggers>
                                                                <asp:AsyncPostBackTrigger ControlID="chkAlternateLanguage" EventName="SelectedIndexChanged" />
                                                             </Triggers>
                                                        </asp:UpdatePanel>

                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div id="divresult" class="normal" width="100%">
                                            <table width='100%' border='0' cellpadding='0' cellspacing='0' align='center' valign='top'>
                                                <tr>
                                                    <td class='normal'>
                                                        <table width="100%" cellpadding="3" cellspacing="0" align="left" border="0" class="paging">
                                                            <tr>
                                                                <td class='white' align="right" width="10%">
                                                                    <%--Query ID:--%>
                                                                    <asp:TextBox ID='txtQid' runat="server" ReadOnly="True" Width="39px"
                                                                        Style="display: none" CssClass="text"></asp:TextBox>
                                                                    <b>Query Name: </b>
                                                                </td>
                                                                <td class='white' width="15%">
                                                                    <asp:TextBox ID='txtQName' runat="server" CssClass="text" ValidationGroup="SAVE"
                                                                        Width="200px"></asp:TextBox>
                                                                </td>
                                                                <td class='white' style="text-align: right;">
                                                                    <b>Visibility: </b>
                                                                </td>
                                                                <td style="padding-left: 10px; width: 275px;">
                                                                    <asp:RadioButtonList ID="rblVisibility" runat="server" RepeatDirection="Horizontal">
                                                                        <asp:ListItem Value="PR" Text="Private" Selected="True"></asp:ListItem>
                                                                        <asp:ListItem Value="RO" Text="Role Based"></asp:ListItem>
                                                                        <asp:ListItem Value="PU" Text="Public"></asp:ListItem>
                                                                    </asp:RadioButtonList>
                                                                </td>
                                                                <td class="normal" align="right">
                                                                    <asp:RequiredFieldValidator ID="rfvQName" runat="server" ControlToValidate="txtQName"
                                                                        Display="None" ErrorMessage="Please enter Query Name." SetFocusOnError="True"
                                                                        ValidationGroup="SAVE" ForeColor="Black"></asp:RequiredFieldValidator>
                                                                    <%--<AjaxToolkit:ValidatorCalloutExtender ID="ValidatorCalloutExtender1" runat="server"
                                                                        TargetControlID="rfvQName">
                                                                    </AjaxToolkit:ValidatorCalloutExtender>--%>
                                                                    &nbsp; &nbsp;
                                                                        <asp:Button Text='Save Query' runat="server" ID="btnSaveQuery" OnClientClick="return CheckForSave();" CssClass="btn btn-primary"
                                                                            OnClick="btnSaveQuery_Click" ValidationGroup="SAVE" />
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" class="normal" colspan="2">
                                                        <table runat="server" id="Reporttable" width="100%" class="search" cellpadding="3"
                                                            cellspacing="0">
                                                            <tr>
                                                                <td align="left" class="normal" id="tdlbl" runat="server">
                                                                    <asp:Label ID="lblrecordcount" runat="server"></asp:Label>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table>
                                                <tr id="divReport" runat="server" width="100%" height="540px">
                                                    <td class="normal" style="height: 540px">
                                                        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="100%" Height="99%" Style="display: table"
                                                            ShowParameterPrompts="False" BorderStyle="Solid" CssClass="reportViewer">
                                                        </rsweb:ReportViewer>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>

                        <asp:HiddenField ID="hidstringAnd" runat="server" />
                        <asp:HiddenField ID="hidStringAllCond" runat="server" />
                        <asp:HiddenField ID="hidID" runat="server" />
                        <asp:HiddenField ID="hidUserText" runat="server" />
                        <asp:HiddenField ID="hdnFlag" runat="server" />
                        <asp:HiddenField ID="hdnColCount" runat="server" />
                        <asp:HiddenField ID="hdnQID" runat="server" />
                        <asp:HiddenField ID="hdnQName" runat="server" />
                        <asp:HiddenField ID="hdnReportType" runat="server" />
                    </ContentTemplate>
                    <Triggers>
                        <asp:PostBackTrigger ControlID="imgresults" />
                        <asp:AsyncPostBackTrigger ControlID="btnBack" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
 
            </td>
        </tr>


        <tr>
            <td align="center">
                <asp:Button ID="btnBack" runat="server" Text="Back" CssClass="btn btn-primary" OnClick="btnBack_Click" OnClientClick="return RemoveRequiredValidation();" />

            </td>
        </tr>
    </table>

    <asp:Literal ID="litGetWidIDListForFocus" runat="server"></asp:Literal>

   <%--New Date Pick--%>
    <link rel="stylesheet" href="../CSS/jquery-ui.css" />
    <link rel="stylesheet" href="../CSS/jquery.datepick.css" />
    <link rel="stylesheet" href="../CSS/ui-start.datepick.css" />
    <script type="text/javascript" src="../JS_Core/jquery.plugin.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.watermarkinput.js"></script>
    <script type="text/javascript" src="../JS_Core/watermark.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.datepick.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.datepick.ext.js"></script>
    <%--New Date Pick--%>
</asp:Content>
