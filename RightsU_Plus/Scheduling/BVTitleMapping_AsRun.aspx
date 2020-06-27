<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BVTitleMapping_AsRun.aspx.cs" Inherits="BVTitleMapping_AsRun" MasterPageFile="~/Home.Master"
    UnobtrusiveValidationMode="None" %>

<%@ Register TagPrefix="UTO" Namespace="UTOFrameWork.FrameworkClasses" Assembly="RightsU_Plus" %>


<%--<!DOCTYPE html>
<html xmlns="">
<head id="Head1" runat="server">
    <title></title>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">
    <%--<link href="../CSS/Master_ASPX.css" rel="stylesheet" />--%>
    <%--<link rel="stylesheet" type="text/css" href="../Master/Stylesheet/star_rights.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
    <link rel="stylesheet" type="text/css" href="../Master/StyleSheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />--%>


    <%--<link href="../Master/Stylesheet/jquery.multiselect.css" rel="stylesheet" />
    <link href="../CSS/jquery-ui.css" rel="stylesheet" />
    <link href="../CSS/chosen.min.css" rel="stylesheet" />
    <link href="../CSS/jquery-ui.css" rel="stylesheet" />
    <link href="../CSS/Rights_Tab.css" rel="stylesheet" />--%>

    <%--<script type="text/javascript" src="../jQuery/Ver_1.7.2/jquery.min.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>
    <%--<script type="text/javascript" src="../Javascript/JQuery/jquery-ui.min.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>
    <%-- <script src="../JS_Core/chosen.jquery.min.js"></script>
    <script src="../JS_Core/jquery-ui.min.js"></script>
    <script src="../Master/JS/multiSelection.js"></script>
    <script src="../Master/JS/Master.js"></script>
    <script src="../Master/JS/Ajax.js"></script>
    <script src="../Master/JS/AjaxControlToolkit.js"></script>
    <script src="../JS_Core/chosen.jquery.min.js"></script>
    <script src="../Master/JS/AjaxUpdater.js"></script>
    <script src="../Master/JS/jquery.datepick.ext.js"></script>
    <script src="../Master/JS/jquery.datepick.js"></script>
    <script src="../JS_Core/jquery.watermarkinput.js"></script>
    <script src="../JS_Core/jquery.plugin.js"></script>--%>
    <link href="../CSS/jquery-ui.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" rel="stylesheet" />
    <link href="../CSS/Master_ASPX.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" rel="stylesheet" />

    <script type="text/javascript" src="../JS_Core/jquery.expander.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="../Master/JS/master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="../Master/JS/common.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script src="../JS_Core/jquery.watermarkinput.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="../Master/JS/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script src="../JS_Core/watermark.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="../Master/JS/AjaxUpdater.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    

    <script type="text/javascript" src="../Master/JS/Ajax.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <%--<script src="../JS_Core/chosen.jquery.min.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>
    <script language="javascript" type="text/javascript" src="../Master/JS/HTTP.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../JS_Core/jquery-1.11.1.min.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
<script src="../JS_Core/jquery.plugin.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../JS_Core/common.concat.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script src="../JS_Core/jquery.expander.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script src="../JS_Core/jquery-ui.min.js"></script>
    <link rel="Stylesheet" href="../Master/Stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
    <script src="../JS_Core/chosen.jquery.min.js"></script>
    <script type="text/javascript" src="../JS_Core/autoNumeric-1.8.1.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <%--<script type="text/javascript" src="../J<script src="../Master/JS/AjaxControlToolkit.js"></script>avascript/mulitiSelection.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>
    <%--<script type="text/javascript" src="../Javascript/Popup-dd-mm-yyyy2.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>
    <%--<script type="text/javascript" src="../Javascript/Popup-dd-mm-yyyy.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>
    <%--<script type="text/javascript" src="../Javascript/Master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>
    <%--<script type="text/javascript" src="../Javascript/Ajax.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>
    <%--<script type="text/javascript" src="../Javascript/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>
    <%--<script type="text/javascript" src="../Javascript/alert.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>
    <%--<script type="text/javascript" src="../JavaScript/AjaxUpdater.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>
    <%--<script type="text/javascript" src="../Javascript/JQuery/chosen.jquery.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>



    <%--<style type="text/css">
        th.th2
        {
            border-right: #0976C9 1px solid;
            font-weight: bold;
            font-size: 12px;
            color: #ffffff;
            position: relative;
            background-color: #0976C9;
            text-align: center;
            z-index: 10;
        }

        .completionList
        {
            border: solid 1px #444444;
            margin: 1px;
            padding: 2px; /*height: 150px;*/
            overflow: auto;
        }

        /*Popup*/
        #overlay
        {
            position: fixed;
            border: 15px solid #ccc;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: #000;
            filter: alpha(opacity=70);
            -moz-opacity: 0.7;
            -khtml-opacity: 0.7;
            opacity: 0.7;
            z-index: 100;
            display: none;
        }

        .popup
        {
            width: 100%;
            margin: auto;
            top: 10%;
            display: none;
            position: absolute;
            z-index: 1001;
        }

        .popupHeading
        {
            color: #686868;
            width: 95%;
            min-width: 95%;
            height: 30px;
            font-size: 20px;
            font-family: sans-serif;
            text-shadow: 1px 1px 1px #E0E0E0;
        }

        .content_RunErrorPopup
        {
            height: 435px !important;
        }

        .content
        {
            width: 600px;
            height: 700px;
            margin: auto;
            background: #f3f3f3;
            position: relative;
            z-index: 103;
            padding: 10px;
            border-radius: 5px; /*box-shadow: 0 2px 5px #000;*/
            box-shadow: 5px 5px 5px #888888;
            font-family: Arial,Helvetica,sans-serif;
            font-size: 12px;
        }

            .content .x
            {
                float: right;
                height: 35px;
                left: 22px;
                position: relative;
                top: -25px;
                width: 34px;
            }

                .content .x:hover
                {
                    cursor: pointer;
                }


        #RunErrorPopupContent
        {
            overflow: auto;
            height: 400px;
            width: 100%;
        }
    </style>--%>
    <style type="text/css">
        select, textarea
        {
            font-family: Arial,Helvetica,Sans-serif;
            font-size: 100%;
            text-align: left;
        }

        img
        {
            vertical-align: middle;
            border: 0;
            /* max-width: 100%; */
            height: auto;
        }

        .chosen-container .chosen-results li.active-result
        {
            color: black;
            text-align: left;
        }

        .chosen-container .chosen-results li.no-results
        {
            color: black;
        }

        .overlay_common
        {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: #000;
            filter: alpha(opacity=70);
            -moz-opacity: 0.7;
            -khtml-opacity: 0.7;
            opacity: 0.7;
            display: none;
        }

        #overlay
        {
            z-index: 8000;
        }

        .popup
        {
            width: 100%;
            margin: auto;
            top: 10%;
            display: none;
            position: absolute;
        }

        #PlatformPopup
        {
            z-index: 8001;
        }

        .content
        {
            width: 500px;
            max-height: 650px;
            height: 625px;
            margin: auto;
            background: #f3f3f3;
            position: relative;
            z-index: 103;
            padding: 10px;
            padding-left: 40px;
            border-radius: 5px; /*box-shadow: 0 2px 5px #000;*/
            box-shadow: 5px 5px 5px #888888;
            font-family: Arial,Helvetica,sans-serif;
            font-size: 12px;
        }

            .content .X
            {
                float: right;
                height: 35px;
                left: 22px;
                position: relative;
                top: -25px;
                width: 34px;
            }

                .content .X:hover
                {
                    cursor: pointer;
                }

        .popupHeading
        {
            width: 50%;
            height: 5%;
            color: #686868;
            font-size: 20px;
            font-family: sans-serif;
            text-shadow: 1px 1px 1px #E0E0E0;
        }

        #divPlatform
        {
            width: 95%;
            float: left;
            height: 500px;
            margin-top: 10px;
            /*max-height:470px;*/
            overflow: auto;
        }

        #divButtonPanel
        {
            width: 95%;
            float: left;
            padding-top: 10px;
        }

        .chosen-container-multi .chosen-choices li.search-field
        {
            height: 27px !Important;
        }

        #ReportViewer1 > iframe
        {
            height: 91% !important;
        }

        @media screen and (-webkit-min-device-pixel-ratio:0)
        {
            /* CSS Statements that only apply on webkit-based browsers (Chrome, Safari, etc.) */
            iframe#ReportFrameReportViewer1
            {
                height: 78% !important;
            }
        }

        div#oReportDiv
        {
            overflow: initial !Important;
        }

        .chosen-container .chosen-results li.group-result
        {
            color: black;
            background-color: gainsboro;
        }

        .pagingborder
        {
            font-family: Verdana,Helvetica,sans-serif;
            font-size: 14px;
            color: #FFFFFF;
            background-color: #03B8EF;
            border: 0px solid #FFFFFF !important;
            text-transform: uppercase;
        }

        table.mainReports
        {
            border-collapse: initial;
            border: 1px solid #0672BA;
            background-color: #ffffff;
            /* border-bottom-left-radius: 0.5em;
            border-bottom-right-radius: 0.5em;*/
            border-radius: 0.5em;
            height: 140px;
            padding: 0px 0px;
            margin: 0px;
            width: 100%;
        }

        .buttonReports
        {
            font-size: 20px;
            color: #FFFFFF;
            border-bottom: thin solid #535353;
            border-right: thin solid #535353;
            font-family: Arial, Helvetica, sans-serif;
            background-color: #0976C9;
            /* border-style: outset; #0976C9*/
            cursor: pointer;
            border-left-width: thin;
            border-top-width: thin;
            padding-top: 2px;
            padding-left: 5px;
            padding-right: 5px;
            padding-bottom: 2px;
            width: 100%;
            line-height: 35px;
            border-radius: 0.5em;
            text-transform: uppercase;
            letter-spacing: 5px;
            text-shadow: 2px 2px #000000;
        }

        .spanCss
        {
            color: blue;
        }

        #CphdBody_uctabPTV_trView table
        {
            width: 0% !important;
            padding: 1%;
            display: table !important;
        }
        .ui-autocomplete {
	position: relative;
	top: 0;
	left: 0;
	cursor: default;
    max-height:200px;
    max-width:250px;
    overflow-y:auto;
    overflow-x:hidden;
    z-index:2147483647;
}
      
    </style>
    <script type="text/javascript">

        var overlay = $('<div id="overlay"></div>');

        $(document).ready(function () {
            InitializeChosen();

            //$("*[id$=gvTitleMapping] input[id$=txtEpisodeNo]").autocomplete({

            //source: function (request, response) {
            //    var param = { keyword: $('#gvTitleMapping_ctl02_txtEpisodeNo').val() };            
            //    $.ajax({
            //        url: "BVTitleMapping_shows.aspx/Test",
            //        data: JSON.stringify(param),
            //        dataType: "json",
            //        type: "POST",
            //        contentType: "application/json; charset=utf-8",
            //        dataFilter: function (data) { return data; },
            //        success: function (data) {
            //            
            //            response($.map(data.d, function (item) {
            //                return {
            //                    value: item
            //                }
            //            }))
            //        },
            //        error: function (XMLHttpRequest, textStatus, errorThrown) {
            //            
            //            alert("Error" + textStatus);
            //        }
            //    });
            //},
            //select: function (event, ui) {

            //},
            //minLength: 2
            //});
        });

        function ValidateEpisodeNo(obj) {
            
            var gvid = obj.id;
            var lblEpisodeStart = document.getElementById(gvid.replace('txtEpisodeNo', 'lblEpisodeStart'));
            var lblEpisodeEnd = document.getElementById(gvid.replace('txtEpisodeNo', 'lblEpisodeEnd'));
            var txtEpisodeNo = document.getElementById(gvid.replace('txtEpisodeNo', 'txtEpisodeNo'));

            if (parseInt(obj.value) < parseInt($(lblEpisodeStart).val()) || parseInt(obj.value) > parseInt($(lblEpisodeEnd).val())) {
                AlertModalPopup(txtEpisodeNo, "Please enter episode number between " + parseInt($(lblEpisodeStart).val()) + " and " + parseInt($(lblEpisodeEnd).val()));
                $(obj).focus();
            }
        }

        function GetEpisodeNo(obj) {
            
            var Method = "/GetDealTitles";
            var gvid = obj.id;
            //var hdnVal = gvid.replace('txtDealTitles', 'lblEpisodeNo');

            var lblScheduleDate = document.getElementById(gvid.replace('txtDealTitles', 'lblScheduleDate'));
            var lblScheduleTime = document.getElementById(gvid.replace('txtDealTitles', 'lblScheduleTime'));
            var txtEpisodeNo = document.getElementById(gvid.replace('txtDealTitles', 'txtEpisodeNo'));
            var lblDealTitleCode = document.getElementById(gvid.replace('txtDealTitles', 'lblDealTitleCode'));
            var lblEpisodeStart = document.getElementById(gvid.replace('txtDealTitles', 'lblEpisodeStart'));
            var lblEpisodeEnd = document.getElementById(gvid.replace('txtDealTitles', 'lblEpisodeEnd'));
            var scheduleDate_Time = lblScheduleDate.innerText + ' ' + lblScheduleTime.innerText;

            if (obj.val == "") {
                $(lblDealTitleCode).val('');
                $(lblEpisodeStart).val('');
                $(lblEpisodeEnd).val('');
                //$(txtEpisodeNo).val('');
            }

            $("*[id$=gvTitleMapping] input[id$=" + obj.id + "]").autocomplete({
                
                source: function (request, response) {
                    
                    var param = { keyword: obj.value, scheduleDate_Time: scheduleDate_Time };
                    $.ajax({
                        url: '<%=ResolveUrl("~/Web_Service")%>' + Method,
                        data: JSON.stringify(param),
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataFilter: function (data) { return data; },
                        success: function (data) {
                            $(lblDealTitleCode).val('');
                            response($.map(data, function (v, i) {
                                return {
                                    label: v.split('~')[0],
                                    val: v.split('~')[1]
                                }
                               
                            }))
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            
                            alert("Error" + textStatus);
                        }
                    });
                },
                select: function (event, ui) {
                    
                    var test = ui.item.val.split('^');

                    //if (test[0] > 0)
                    //    document.getElementById(hdnVal).innerHTML = test[0];

                    //if (test.length == 3 && test[1] == test[2]) {
                    //    $(txtEpisodeNo).val(test[1]);
                    //    $(txtEpisodeNo).attr("disabled", "disabled");
                    //}
                    //else {
                    //    //$(txtEpisodeNo).val('');
                    //    $(txtEpisodeNo).removeAttr("disabled");
                    //}

                    if (test[1] != null)
                        $(lblEpisodeStart).val(test[1]);
                    else
                        $(lblEpisodeStart).val('0');

                    if (test[2] != null)
                        $(lblEpisodeEnd).val(test[2]);
                    else
                        $(lblEpisodeEnd).val('0');

                    $(lblDealTitleCode).val(test[0]);
                    //alert(hdnVal + ''  + ui.item.val);
                },
                minLength: 3,
                open: function (event, ui) {
                    $(".ui-autocomplete").css("position", "relative");
                    $(".ui-autocomplete").css("max-height", "200px");
                    $(".ui-autocomplete").css("max-width", "250px");
                    $(".ui-autocomplete").css("overflow-y", "auto");
                    $(".ui-autocomplete").css("overflow-x", "hidden");
                    $(".ui-autocomplete").css("z-index", "2147483647");
                }
            });
        }

        function blockTitleSelection(chkBox) {
           
            var chkBoxId = chkBox.id;
            var lblIntCode = document.getElementById(chkBoxId.replace('chkIgnore', 'lblIntCode'));
            var chkCheckAll = document.getElementById(chkBoxId.replace('chkIgnore', 'chkCheckAll'));
            var txtDealTitles = document.getElementById(chkBoxId.replace('chkIgnore', 'txtDealTitles'));
            var txtEpisodeNo = document.getElementById(chkBoxId.replace('chkIgnore', 'txtEpisodeNo'));

            if ($(chkBox).prop("checked")) {
                $(txtDealTitles).val('');
                //$(txtEpisodeNo).val('');

                $(chkCheckAll).prop('checked', true);
                $(txtDealTitles).attr("disabled", "disabled");
                $(txtEpisodeNo).attr("disabled", "disabled");
            }
            else {
                $(chkCheckAll).removeAttr("disabled");
                $(chkCheckAll).prop('checked', false);
            }

            IntCodeInHdnField(chkCheckAll.id, lblIntCode.innerText);
        }

        function InitializeChosen() {
            $('.chosenDrop').chosen('Select Title');
        }

        function ClosePopup(popupId) {
            $('#' + popupId).hide();
            overlay.appendTo(document.body).remove();
            return false;
        }

        function OpenPopup(popupId) {
            overlay.show();
            overlay.appendTo(document.body);
            $('#' + popupId).show("fast");
            return false;
        }

        function ExecuteSynchronously(url, method, args) {
            var executor = new Sys.Net.XMLHttpSyncExecutor();
            var request = new Sys.Net.WebRequest();            				             // Instantiate a WebRequest. 

            request.set_url(url + '/' + method);                                         // Set the request URL.
            request.set_httpVerb('POST');            					                 // Set the request verb. 
            request.get_headers()['Content-Type'] = 'application/json; charset=utf-8';   // Set request header. 
            request.set_executor(executor);            					                 // Set the executor. 
            request.set_body(Sys.Serialization.JavaScriptSerializer.serialize(args));    // Serialize arguments into JSON string. 

            request.invoke();															 // Execute the request.

            if (executor.get_responseAvailable()) {
                return (executor.get_object());
            }

            return (false);
        }

        //function selectAll(id) {
        //    var frm = document.forms[0];
        //    var altYN = 'Y';
        //    for (i = 0; i < frm.elements.length; i++) {
        //        if (frm.elements[i].type == "checkbox") {
        //            frm.elements[i].checked = document.getElementById(id).checked;
        //            changeColor(frm.elements[i], altYN);
        //            if (altYN == 'Y')
        //                altYN = 'N'
        //            else
        //                altYN = 'Y'
        //        }
        //    }
        //}

        function changeColor(CheckBoxObj, altYN) {
            if (CheckBoxObj.checked == true) {
                CheckBoxObj.parentNode.parentNode.parentNode.style.backgroundColor = "#f5f5f5";
            }
            else {
                if (altYN == "Y")
                    CheckBoxObj.parentNode.parentNode.parentNode.style.backgroundColor = "#FFF";
                else
                    CheckBoxObj.parentNode.parentNode.parentNode.style.backgroundColor = "#FFF";
            }
        }

        function textReadOnly(id) {
            var fm = document.forms[0];

            for (i = 0; i < fm.elements.length; i++) {
                if (fm.elements[i].type == "textbox") {
                    document.getElementById("txtReleaseDate").setAttribute("readonly", "true");
                }
            }
        }

        function validateSearch() {
            var lbBVTitleSearch = $get('<%=lbBVTitleSearch.ClientID %>');

            if (lbBVTitleSearch.selectedOptions.length == "") {
                AlertModalPopup('lbBVTitleSearch', 'Please enter search criteria');
                return false;
            }
            else
                return true;
        }

        function ValidateOnFinalSave(source, args) {
            var lbBVTitleSearch = document.getElementById('<%= lbBVTitleSearch.ClientID %>');
            var tmpGvWOAssignment = document.getElementById("<%= gvTitleMapping.ClientID %>");
            var counter = 0;
            var hdnIntCode = document.getElementById('hdnIntCode');

            if (hdnIntCode.value == '')
                AlertModalPopup(lbBVTitleSearch, "Please select atleast one CheckBox");

            var arrstr = tmpGvWOAssignment.id + "_ctl";

            for (var i = 0; i < gvTitleMapping.rows.length-1; i++) {
                var c = i
                //if (parseInt(i, 10) < 9)
                //    c = "0" + parseInt(i + 1);
                //else
                //    c = parseInt(i + 1);

                //for (var i = 1; i <= tmpGvWOAssignment.rows.length; i++) {
                //    if (parseInt(i) < 10)
                //        var c = "0" + i;
                //    else 
                //        var c = i;

                //var ddlDealTitle = document.getElementById(arrstr + c + "_ddlDealTitle");
                //var chkTitle = document.getElementById(arrstr + c + "_chkCheckAll");
                //var lblEpisodeNo = document.getElementById(arrstr + c + "_lblEpisodeNo");
                //var lblBVTitleName = document.getElementById(arrstr + c + "_lblBVTitleName");
                //var chk = document.getElementById(arrstr + c + "_chkIgnore");

                //var ddlDealTitle = document.getElementById("<%=gvTitleMapping.ClientID%>_ddlDealTitle_" + c);
                var chkTitle = document.getElementById("<%=gvTitleMapping.ClientID%>_chkCheckAll_" + c);
                var lblEpisodeNo = document.getElementById("<%=gvTitleMapping.ClientID%>_lblEpisodeNo_" + c);
                var lblBVTitleName = document.getElementById("<%=gvTitleMapping.ClientID%>_lblBVTitleName_" + c);
                var chk = document.getElementById("<%=gvTitleMapping.ClientID%>_chkIgnore_" + c);

                if (chk.checked == true && chkTitle.checked == true) {
                    counter++;
                }

                if (chk.checked == false) {
                    if (chkTitle) {
                        if (chkTitle.checked == true) {
                            counter++;

                            //if (ddlDealTitle.value == "0" && chk.checked == false) {
                            //    AlertModalPopup(ddlDealTitle, "Please select either Ignore or Deal title to Map");
                            //    args.IsValid = false;
                            //    return;
                            //}

                            //if (ddlDealTitle.value == "0")
                            //{
                            //    AlertModalPopup(ddlDealTitle, "Please select Deal title to Map");
                            //    args.IsValid = false;
                            //    return;
                            //}
                            //else {
                            //    var MappedDealTitleCode = BVEpisodeNo = 0;
                            //    MappedDealTitleCode = ddlDealTitle.value;
                            //    BVEpisodeNo = lblEpisodeNo.innerText;

                            //    //var params = "action=ValidateTitleEpisodeRange&MappedTitleCode=" + MappedDealTitleCode + "&BVEpisodeNo=" + BVEpisodeNo;
                            //    //var str = AjaxUpdater.Update('GET', '../ProcessResponseRequest.aspx', getResponse, params);

                            //    //if (Ajax.request.responseText == "N") {
                            //    //	AlertModalPopup(lbBVTitleSearch, "BV Title '" + lblBVTitleName.innerText + "' having episode no. outside the deal title episode range defined");
                            //    //	args.IsValid = false;
                            //    //	return;
                            //    //}

                            //    var result = ExecuteSynchronously('../WebServices/AutoCompleteTitle.asmx', 'ValidateBVEpiWithTitleEpiRange',
                            //    {
                            //        MappedTitleCode: MappedDealTitleCode, BVEpisodeNo: BVEpisodeNo
                            //    });

                            //    if (result.d == "Y") 
                            //        args.IsValid = true;
                            //    else if (result.d == "N")
                            //        args.IsValid = false;
                            //}

                        }
                    }
                }
            }

            if (counter == 0) {
                AlertModalPopup(lbBVTitleSearch, "Please select atleast one CheckBox");
                args.IsValid = false;
            }

            if ((tmpGvWOAssignment.rows.length - 1) == 0) {
                AlertModalPopup(lbBVTitleSearch, "No Records have been affected");
                args.IsValid = false;
                return;
            }
        }

        function ValidateOnPageChange(source, args) {
            var lbBVTitleSearch = document.getElementById("<%= lbBVTitleSearch.ClientID %>");
            var tmpGvWOAssignment = document.getElementById("<%= gvTitleMapping.ClientID %>");
            var counter = 0;
            var hdnIntCode = document.getElementById('hdnIntCode');

            //		    if (hdnIntCode.value == '')
            //		        AlertModalPopup(lbBVTitleSearch, "Please select atleast one CheckBox");

            var arrstr = tmpGvWOAssignment.id + "_ctl";
            //for (var i = 2; i <= tmpGvWOAssignment.childNodes[0].childNodes.length; i++) 
            for (var i = 0; i <= tmpGvWOAssignment.rows.length-1; i++) {
                //if (parseInt(i) < 10)
                //    var c = "0" + i;
                //else
                    var c = i;

                //var ddlDealTitle = document.getElementById(arrstr + c + "_ddlDealTitle");
                //var chkTitle = document.getElementById(arrstr + c + "_chkCheckAll");
                // var lblEpisodeNo = document.getElementById(arrstr + c + "_lblEpisodeNo");
                // var lblBVTitleName = document.getElementById(arrstr + c + "_lblBVTitleName");
                // var chk = document.getElementById(arrstr + c + "_chkIgnore");

                //var txtDealTitles = document.getElementById(arrstr + c + "_txtDealTitles");
                //var txtEpisodeNo = document.getElementById(arrstr + c + "_txtEpisodeNo");
                //var lblDealTitleCode = document.getElementById(arrstr + c + "_lblDealTitleCode");

                var ddlDealTitle = document.getElementById("<%=gvTitleMapping.ClientID%>_ddlDealTitle_" + c);
                var chkTitle = document.getElementById("<%=gvTitleMapping.ClientID%>_chkCheckAll_" + c);
                var lblEpisodeNo = document.getElementById("<%=gvTitleMapping.ClientID%>_lblEpisodeNo_" + c);
                var lblBVTitleName = document.getElementById("<%=gvTitleMapping.ClientID%>_lblBVTitleName_" + c);
                var chk = document.getElementById("<%=gvTitleMapping.ClientID%>_chkIgnore_" + c);

                var txtDealTitles = document.getElementById("<%=gvTitleMapping.ClientID%>_txtDealTitles_" + c);
                var txtEpisodeNo = document.getElementById("<%=gvTitleMapping.ClientID%>_txtEpisodeNo_" + c);
                var lblDealTitleCode = document.getElementById("<%=gvTitleMapping.ClientID%>_lblDealTitleCode_" + c);

                //if (chk.checked == true && chkTitle.checked == true) {
                //    counter++;
                //}

                if (chkTitle) {
                    if (chkTitle.checked == true) {
                        if (chkTitle.checked == true) {
                            counter++;
                            
                            if (!chk.checked && ($(lblDealTitleCode).val() == '' || $(lblDealTitleCode).val() == '0')) {
                                AlertModalPopup(txtDealTitles, "Please select either Ignore or Deal title to Map");
                                args.IsValid = false;
                                return;
                            }

                            if (!chk.checked && $(txtEpisodeNo).val() == '') {
                                AlertModalPopup(txtEpisodeNo, "Please enter episode number");
                                args.IsValid = false;
                                return;
                            }

                            //if (ddlDealTitle.value == "0" && chk.checked == false) {
                            //    AlertModalPopup(ddlDealTitle, "Please select either Ignore or Deal title to Map");
                            //    args.IsValid = false;
                            //    return;
                            //}
                            //else {
                            //    var MappedDealTitleCode = BVEpisodeNo = 0;
                            //    MappedDealTitleCode = ddlDealTitle.value;
                            //    BVEpisodeNo = lblEpisodeNo.innerText;

                            //    //var params = "action=ValidateTitleEpisodeRange&MappedTitleCode=" + MappedDealTitleCode + "&BVEpisodeNo=" + BVEpisodeNo;
                            //    //var str = AjaxUpdater.Update('GET', '../ProcessResponseRequest.aspx', getResponse, params);

                            //    //if (Ajax.request.responseText == "N") 
                            //    //{
                            //    //	AlertModalPopup(lbBVTitleSearch, "BV Title '" + lblBVTitleName.innerText  + "' having episode no. outside the deal title episode range defined");
                            //    //	args.IsValid = false;
                            //    //	return;
                            //    //}

                            //    var result = ExecuteSynchronously('../WebServices/AutoCompleteTitle.asmx', 'ValidateBVEpiWithTitleEpiRange',
                            //    {
                            //        MappedTitleCode: MappedDealTitleCode, BVEpisodeNo: BVEpisodeNo
                            //    });

                            //    if (result.d == "N") {
                            //        AlertModalPopup(lbBVTitleSearch, "BV Title '" + lblBVTitleName.innerText + "' having episode no. outside the deal title episode range defined");
                            //        args.IsValid = false;
                            //        return;
                            //    }
                            //}
                        }
                    }
                }
            }

            if ((tmpGvWOAssignment.rows.length - 1) == 0) {
                AlertModalPopup(lbBVTitleSearch, "No Records have been affected");
                args.IsValid = false;
                return;
            }
        }

        function validateCheckedRecords(source, args) {
            var hdnIntCode = document.getElementById('hdnIntCode');
        }

        function selectCurrent(chkBox) {
            //alert('hello');
            

            var chkBoxID = chkBox.id;
            var chkIgnore = document.getElementById(chkBoxID.replace('chkCheckAll', 'chkIgnore'));
            var txtDealTitles = document.getElementById(chkBoxID.replace('chkCheckAll', 'txtDealTitles'));
            var txtEpisodeNo = document.getElementById(chkBoxID.replace('chkCheckAll', 'txtEpisodeNo'));

            if ($(chkBox).prop("checked")) {
                $(txtDealTitles).removeAttr("disabled");
                $(txtEpisodeNo).removeAttr("disabled");
                //$(chkIgnore).removeAttr("disabled");
            }
            else {
                $(txtDealTitles).val('');
                //$(txtEpisodeNo).val('');

                $(chkIgnore).prop('checked', false);
                //$(chkIgnore).attr("disabled", "disabled");
                $(txtDealTitles).attr("disabled", "disabled");
                $(txtEpisodeNo).attr("disabled", "disabled");
            }
        }

        //function selectAllValue(id) {
        //    
        //    var headerChkBox = id;
        //    var hdnIntCode = document.getElementById('hdnIntCode');
        //    var gvTitleMapping = document.getElementById("gvTitleMapping");
        //    var altYN = 'Y';
        //    var arrstr = gvTitleMapping.id + "_ctl";

        //    for (var i = 1; i < gvTitleMapping.rows.length; i++) {
        //        //var checkBox = gvTitleMapping.rows[i].cells[0].childNodes[0];
        //        //var lblIntCode = gvTitleMapping.rows[i].cells[0].childNodes[2];
        //        //var IntCode = lblIntCode.innerHTML;
        //        //checkBox.checked = headerChkBox.checked;

        //        var rowNum = 0

        //        if (parseInt(i, 10) < 9)
        //            rowNum = "0" + parseInt(i + 1);
        //        else
        //            rowNum = parseInt(i + 1);

        //        var checkBox = document.getElementById(arrstr + rowNum + "_chkCheckAll");
        //        var lblIntCode = document.getElementById(arrstr + rowNum + "_lblIntCode");

        //        var chkIgnore = document.getElementById(arrstr + rowNum + "_chkIgnore");
        //        var txtDealTitles = document.getElementById(arrstr + rowNum + "_txtDealTitles");
        //        var txtEpisodeNo = document.getElementById(arrstr + rowNum + "_txtEpisodeNo");

        //        var IntCode = lblIntCode.innerHTML;
        //        checkBox.checked = headerChkBox.checked;

        //        if (checkBox.checked) {
        //            hdnIntCode.value.replace('!' + IntCode + '~', '');
        //            hdnIntCode.value = hdnIntCode.value + '!' + IntCode + '~';
        //            if (!chkIgnore.checked)
        //                $(txtDealTitles).removeAttr("disabled");
        //            //$(chkIgnore).removeAttr("disabled");
        //        }
        //        else {
        //            hdnIntCode.value = hdnIntCode.value.replace('!' + IntCode + '~', '');
        //            $(txtDealTitles).val('');
        //            $(txtEpisodeNo).val('');
        //            $(txtDealTitles).attr("disabled", "disabled");
        //            $(txtEpisodeNo).attr("disabled", "disabled");
        //            //$(chkIgnore).attr("disabled", "disabled");
        //            $(chkIgnore).attr('checked', false);
        //        }

        //        changeColor(checkBox, altYN);

        //        if (altYN == 'Y')
        //            altYN = 'N'
        //        else
        //            altYN = 'Y'
        //    }
        //}

        function selectAllValue(id) {
            
            var headerChkBox = id;
            var hdnIntCode = document.getElementById("<%= hdnIntCode.ClientID %>");
            var gvTitleMapping = document.getElementById("<%= gvTitleMapping.ClientID %>");
            var altYN = 'Y';
            var arrstr = gvTitleMapping.id + "_ctl";
            //var[] chk = id.val().split('_');
            for (var i = 0; i < gvTitleMapping.rows.length - 1; i++) {
                var rowNum = i;
                var checkBox = document.getElementById("<%=gvTitleMapping.ClientID%>_chkCheckAll_" + rowNum);
                var lblIntCode = document.getElementById("<%=gvTitleMapping.ClientID%>_lblIntCode_" + rowNum);

                var chkIgnore = document.getElementById("<%=gvTitleMapping.ClientID%>_chkIgnore_" + rowNum);
                var txtDealTitles = document.getElementById("<%=gvTitleMapping.ClientID%>_txtDealTitles_" + rowNum);
                var txtEpisodeNo = document.getElementById("<%=gvTitleMapping.ClientID%>_txtEpisodeNo_" + rowNum);

                var IntCode = lblIntCode.innerHTML;
                checkBox.checked = headerChkBox.checked;

                if (checkBox.checked) {
                    hdnIntCode.value.replace('!' + IntCode + '~', '');
                    hdnIntCode.value = hdnIntCode.value + '!' + IntCode + '~';
                    if (!chkIgnore.checked) {
                        $(txtDealTitles).removeAttr("disabled");
                        $(txtEpisodeNo).removeAttr("disabled");
                    }
                    $(chkIgnore).removeAttr("disabled");
                }
                else {
                    hdnIntCode.value = hdnIntCode.value.replace('!' + IntCode + '~', '');
                    $(txtDealTitles).val('');
                    //$(txtEpisodeNo).val('');
                    $(txtDealTitles).attr("disabled", "disabled");
                    $(txtEpisodeNo).attr("disabled", "disabled");
                    $(chkIgnore).attr("disabled", "disabled");
                    $(chkIgnore).attr('checked', false);
                }

                changeColor(checkBox, altYN);

                if (altYN == 'Y')
                    altYN = 'N'
                else
                    altYN = 'Y'
            }
        }


        function IntCodeInHdnField(idchk, IntCode) {
            
            var chkBox = document.getElementById(idchk);
            var hdnIntCode = document.getElementById("<%= hdnIntCode.ClientID%>");

            if (chkBox.checked) {
                hdnIntCode.value = hdnIntCode.value.replace('!' + IntCode + '~', '');
                hdnIntCode.value = hdnIntCode.value + '!' + IntCode + '~';
            }
            else {
                hdnIntCode.value = hdnIntCode.value.replace('!' + IntCode + '~', '');
            }
        }

        //function ValidateBVEpiWithTitleEpiRange(source, args) {

        //    var gvRow = source.id.slice(0, source.id.lastIndexOf('_') + 1);
        //    args.IsValid = true;
        //    //var ddlDealTitle = document.getElementById(gvRow + 'ddlDealTitle');
        //    var lblEpisodeNo = document.getElementById(gvRow + 'lblEpisodeNo');
        //    var MappedDealTitleCode = BVEpisodeNo = 0;

        //    if (ddlDealTitle.value > 0) {
        //        MappedDealTitleCode = ddlDealTitle.value;
        //        BVEpisodeNo = lblEpisodeNo.innerText;

        //        //var params = "action=ValidateTitleEpisodeRange&MappedTitleCode=" + MappedDealTitleCode + "&BVEpisodeNo=" + BVEpisodeNo;
        //        //var str = AjaxUpdater.Update('GET', '../ProcessResponseRequest.aspx', getResponse, params);
        //        //if (Ajax.request.responseText == "Y") 
        //        //	args.IsValid = true;
        //        //else 
        //        //	args.IsValid = false;

        //        var result = ExecuteSynchronously('../WebServices/AutoCompleteTitle.asmx', 'ValidateBVEpiWithTitleEpiRange',
        //        {
        //            MappedTitleCode: MappedDealTitleCode, BVEpisodeNo: BVEpisodeNo
        //        });

        //        if (result.d == "Y")
        //            args.IsValid = true;
        //        else if (result.d == "N")
        //            args.IsValid = false;
        //    }
        //}

        function CheckUnCheckIngnoreChk(chkClientID, gvTitleMapping, RowIndex) {

            var gvTitleMapping = document.getElementById("<%=gvTitleMapping.ClientID%>"); //Find the GridView
            var chkMain = document.getElementById(chkClientID);
            var arrstr = gvTitleMapping.id + "_ctl";
            //var chkHeader = document.getElementById("gvTitleMapping_ctl01_chkAllIgnore");

            //var hdnEditRecord = document.getElementById('hdnEditRecord');
            //if (canEditRecordAjax(hdnEditRecord)) { //--- {1

            //if (chkMain.checked) {
            var counter = 0;
            for (var i = 0; i < gvTitleMapping.rows.length-1; i++) {
                var rowNum = i;

                //if (parseInt(i, 10) < 9)
                //    rowNum = "0" + parseInt(i + 1);
                //else
                //    rowNum = parseInt(i + 1);

                var chk = document.getElementById("<%=gvTitleMapping.ClientID%>_chkIgnore_" + rowNum);
                var chkCheckAll = document.getElementById("<%=gvTitleMapping.ClientID%>_chkCheckAll_" + rowNum);
                //var ddlDealTitle = document.getElementById(arrstr + rowNum + "_ddlDealTitle");

                if (chk.checked) {
                    counter++;
                    //ddlDealTitle.selectedIndex = 0;
                    //ddlDealTitle.disabled = true;
                }
                else {
                    //chkCheckAll.disabled = false;
                    //ddlDealTitle.disabled = false;
                }
            }

            /*
            if (counter == (gvTitleMapping.rows.length - 1)) 
                chkHeader.checked = true;
            else 
                chkHeader.checked = false;
            */
            //}
            //else {
            //chkHeader.checked = false;
            //}
            //} //--- 1}
            //	        else {
            //	            return false;
        }
    </script>
    <%--</head>
<body>
    <form id="form1" runat="server">--%>
    <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0">
        <%--<Scripts>
            <asp:ScriptReference Path="~/Javascript/XMLHttpSyncExecutor.js" />
        </Scripts>
        <Services>
            <asp:ServiceReference Path="~/WebServices/AutoCompleteTitle.asmx" />
        </Services>--%>
    </asp:ScriptManager>
    <asp:UpdatePanel ID="updatePanelouter" runat="server">
        <ContentTemplate>
            <%-- <table align="center" border="0" cellpadding="0" cellspacing="0" width="98%">--%>
            <%--<tr>
                        <td align="right" class="normal">
                            <table align="center" class="head" border="0" cellpadding="3" cellspacing="0" width="100%">
                                <tr>
                                    <td align="left" class="white">&nbsp;&nbsp;
                                        <img align="absmiddle" alt='' border='0' src='../Images/red.gif'>
                                        &nbsp;&nbsp;ASRUN Title Mapping 
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>--%>
            <%--<tr>
                        <td align="center" class="normal">
                            <table align="center" border="0" cellpadding="3" cellspacing="0" width="100%" class="search">
                                <tr>
                                    <td align="left" class="normal" style="width: 20%">&nbsp;&nbsp;BV Title:
                                    </td>
                                    <td align="left" class="normal">
                                        <asp:ListBox runat="server" ID="lbBVTitleSearch" class="chosenDrop" multiple="true" Width="400px"
                                            SelectionMode="Multiple"></asp:ListBox>
                                        <asp:HiddenField ID="hdnBvTitle" runat="server" />
                                        &nbsp;
                                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                                            CssClass="button" ValidationGroup="Search" />
                                        &nbsp;
                                        <asp:Button ID="btnShowAll" runat="server" Text="ShowAll" OnClick="btnShowAll_Click"
                                            CssClass="button" CausesValidation="false" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>--%>
            <%--<tr>
                        <td class='normal'>
                            <table width='100%' border='0' class="paging" cellpadding='3' cellspacing='0' align='center'
                                valign='top'>
                                <tr>
                                    <td class='white'>&nbsp;&nbsp;Total records found:&nbsp;
									<asp:Label ID="lblTotal" runat="server" Text="0"></asp:Label>&nbsp;
									<asp:Label ID="lblMdt" runat="server" CssClass="lblmandatory" Text="(*) Mandatory Field"
                                        Visible="False"></asp:Label>
                                    </td>
                                    <td class='white' align='right'>
                                        <asp:DataList ID="dtLst" runat="server" RepeatDirection="Horizontal" OnItemCommand="dtLst_ItemCommand"
                                            OnItemDataBound="dtLst_ItemDataBound">
                                            <ItemTemplate>
                                                <asp:Button ID="btnPager" CssClass="pagingbtn" Text='<%#  ((AttribValue)Container.DataItem).Attrib %>'
                                                    CommandArgument='<%#  ((AttribValue)Container.DataItem).Val %>' runat="server"
                                                    ValidationGroup="MAP1" />
                                                <asp:TextBox runat="server" ID="txtDummy1" TabIndex="-1" Style="display: none"></asp:TextBox>
                                                <asp:CustomValidator runat="server" ID="cvValidateSavePageChange" ClientValidationFunction="ValidateOnPageChange"
                                                    ValidationGroup="MAP1" EnableClientScript="true" ControlToValidate="txtDummy1"
                                                    Display="None" SetFocusOnError="false" ValidateEmptyText="true"></asp:CustomValidator>
                                            </ItemTemplate>
                                        </asp:DataList>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>--%>
            <div class="title_block dotted_border clearfix">
                <h2 class="pull-left">BV Title Mapping Shows</h2>
                <div class="right_nav pull-right">
                    <ul>
                        <li>
                            <%--<asp:Button ID="btnAdd" runat="server" CssClass="btn btn-primary" Text="Add" OnClick="btnAdd_Click"
                                        Width="50px" />--%>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="search_area">
                <table class="table">
                    <tr>
                        <td class='normal' width="30%">&nbsp;&nbsp;BV Title:
                            <asp:ListBox runat="server" ID="lbBVTitleSearch" class="chosenDrop" multiple="true" Width="400px"
                                SelectionMode="Multiple"></asp:ListBox>
                            <asp:HiddenField ID="hdnBvTitle" runat="server" />
                        </td>
                        <td class='normal'>
                            <asp:Button ID="btnSearch" runat="server" CssClass="button" Text="Search" OnClick="btnSearch_Click" Width="60px" />&nbsp;
                            <asp:Button ID="btnShowAll" runat="server" CssClass="button" Text="Show All" OnClick="btnShowAll_Click" Width="60px" /></td>
                    </tr>
                </table>
            </div>
            <div class="paging_area clearfix">
                <div class="divBlock">
                    <div>
                        <span class="pull-left">Total Records:
                          <asp:Label ID="lblTotal" runat="server" Text="0"></asp:Label>&nbsp;
                          <asp:Label ID="lblMdt" runat="server" CssClass="lblmandatory" Text="(*) Mandatory Field"
                              Visible="False"></asp:Label>
                        </span>
                    </div>
                    <div>
                        <asp:DataList ID="dtLst" runat="server" RepeatDirection="Horizontal" OnItemCommand="dtLst_ItemCommand"
                            OnItemDataBound="dtLst_ItemDataBound">
                            <ItemTemplate>
                                <asp:Button ID="btnPager" CssClass="pagingbtn" Text='<%#  ((UTOFrameWork.FrameworkClasses.AttribValue)Container.DataItem).Attrib %>'
                                    CommandArgument='<%#  ((UTOFrameWork.FrameworkClasses.AttribValue)Container.DataItem).Val %>' runat="server" />
                                <asp:TextBox runat="server" ID="txtDummy1" TabIndex="-1" Style="display: none"></asp:TextBox>
                                <asp:CustomValidator runat="server" ID="cvValidateSavePageChange" ClientValidationFunction="ValidateOnPageChange"
                                    ValidationGroup="MAP1" EnableClientScript="true" ControlToValidate="txtDummy1"
                                    Display="None" SetFocusOnError="false" ValidateEmptyText="true"></asp:CustomValidator>
                            </ItemTemplate>
                        </asp:DataList>
                    </div>

                </div>
            </div>
            <%--<tr>
                        <td align='center' class="normal">--%>
            <div class="table-wrapper">
                <asp:GridView ID="gvTitleMapping" runat="server" Width="100%" CellPadding="3" CellSpacing="0" AutoGenerateColumns="false"
                    ShowHeader="true" CssClass='table table-bordered table-hover' DataKeyNames="IntCode" OnRowDataBound="gvTitleMapping_RowDataBound">
                    <Columns>
                        <asp:TemplateField HeaderText="CheckAll" ShowHeader="true">
                            <HeaderTemplate>
                                <asp:Label ID="lblCheckAll" runat="server" Text="Check All"></asp:Label>
                                <input id="chkAll" type="checkbox" runat="server" onclick="javascript: selectAllValue(this)" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <input id="chkCheckAll" type="checkbox" runat="server" onchange="selectCurrent(this);" />
                                <asp:Label ID="lblIntCode" Text='<%#Eval("IntCode") %>' runat="server" Style="display: none"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="border" Width="10%" HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Program Episode ID" HeaderStyle-Width="15%" ShowHeader="true">
                            <ItemTemplate>
                                <asp:Label ID="lblHouseIds" runat="server" Text='<%# Eval("Program_Episode_ID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="border" Width="15%" HorizontalAlign="left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="BV Title Name" HeaderStyle-Width="30%" ShowHeader="true">
                            <ItemTemplate>
                                <asp:Label ID="lblBVTitleName" runat="server" Text='<%# Eval("BVTitle") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="border" Width="25%" HorizontalAlign="left" />
                        </asp:TemplateField>
                        <%--<asp:TemplateField HeaderText="Episode No." HeaderStyle-Width="10%" ShowHeader="true">
                                        <ItemTemplate>
                                            <asp:Label ID="lblEpisodeNo" runat="server" Text='<%# Eval("EpisodeNumbers") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="border" Width="10%" HorizontalAlign="Right" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Program_Episode_ID" HeaderStyle-Width="12%" ShowHeader="true">
                                        <ItemTemplate>
                                            <asp:Label ID="lblProgram_Episode_ID" runat="server" Text='<%# Eval("Program_Episode_ID") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="border" Width="12%" HorizontalAlign="Right" />
                                    </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="Ignore" HeaderStyle-Width="5%" ShowHeader="true">
                            <ItemTemplate>
                                <input id="chkIgnore" type="checkbox" runat="server" onchange="blockTitleSelection(this);" />
                            </ItemTemplate>
                            <ItemStyle CssClass="border" Width="5%" HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Map To Deal Title:" HeaderStyle-Width="30%" ShowHeader="true">
                            <ItemTemplate>
                                <asp:TextBox ID="txtDealTitles" runat="server" disabled="disabled"  Width="250px" onkeyup="GetEpisodeNo(this)"  autocomplete="on"></asp:TextBox>
                                <asp:Label ID="lblScheduleDate" runat="server" Text='<%# Eval("Schedule_Item_Log_Date") %>' Style="display: none;"></asp:Label>
                                <asp:Label ID="lblScheduleTime" runat="server" Text='<%# Eval("Schedule_Item_Log_Time") %>' Style="display: none;"></asp:Label>
                                <asp:TextBox ID="lblDealTitleCode" runat="server" Style="display: none;"></asp:TextBox>
                                <asp:HiddenField ID="hdnDealTitleCode" runat="server" Value="0" />
                            </ItemTemplate>
                            <ItemStyle CssClass="border" Width="25%" HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="EpisodeNo" HeaderStyle-Width="12%" ShowHeader="true">
                            <ItemTemplate>
                                <asp:TextBox ID="txtEpisodeNo" runat="server" Width="50px" disabled="disabled" Text='<%# Eval("EpisodeNo") %>' MaxLength="4" onKeyPress="allowOnlyNumber(event);" onblur="ValidateEpisodeNo(this)"></asp:TextBox>
                                <asp:HiddenField ID="hdnEpisodeNo" runat="server" Value="0" />
                                <%--<asp:Label ID="lblEpisodeNo" runat="server"></asp:Label>--%>
                                <asp:TextBox ID="lblEpisodeStart" runat="server" Style="display: none;"></asp:TextBox>
                                <asp:TextBox ID="lblEpisodeEnd" runat="server" Style="display: none;"></asp:TextBox>
                            </ItemTemplate>
                            <ItemStyle CssClass="border" Width="15%" HorizontalAlign="center" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <%-- </td>
                    </tr>
                    <tr style="height: 5px;">
                        <td align="right" class="normal" style="background-image: url('../images/endtable.jpg');"></td>
                    </tr>
                    <tr>
                        <td align="center" class="normal">--%>
            <div class="bottom_action">
                <ul>
                    <li>
                        <asp:Button ID="btnMap" runat="server" Text="     MAP    " OnClick="btnMap_Click" CssClass="button"
                            ValidationGroup="MAP1" />
                    </li>
                    <li>
                        <asp:Button ID="btnCancel" runat="server" Text="  Cancel " CssClass="button" CausesValidation="false"
                            OnClick="btnCancel_Click" />
                    </li>
                </ul>
            </div>
            <%--</td>
                    </tr>
                </table>--%>
            <asp:TextBox runat="server" ID="txtDummy" TabIndex="-1" Style="display: none"></asp:TextBox>
            <asp:CustomValidator runat="server" ID="cvValidateSave" ClientValidationFunction="ValidateOnFinalSave"
                ValidationGroup="MAP" EnableClientScript="true" ControlToValidate="txtDummy"
                Display="None" SetFocusOnError="false" ValidateEmptyText="true"></asp:CustomValidator>

            <asp:HiddenField runat="server" ID="hdnSearch" />
            <asp:HiddenField runat="server" ID="hdnIntCode" />
            <asp:HiddenField runat="server" ID="hdnExternalTitleData" />

            <div class='popup' id="MappingErrorPopup">
                <div class='content content_MappingErrorPopup'>
                    <img src="../images/fancy_close.png" alt='quit' class='x' id='x' onclick="ClosePopup('MappingErrorPopup')" />
                    <div class="popupHeading">
                        <asp:Label ID="lblPopupHead" runat="server" Text="Episodes not found for the following titles :"></asp:Label>
                    </div>
                    <div id="MappingErrorPopupContent">
                        <asp:GridView ID="gvMappingException" runat="server" AutoGenerateColumns="false" CssClass="tblBorder"
                            Width="100%" AlternatingRowStyle-CssClass="rowBg" CellPadding="3" HeaderStyle-CssClass="tableHd">
                            <Columns>
                                <asp:TemplateField HeaderText="Title">
                                    <ItemTemplate>
                                        <asp:Label ID="lblITitle" runat="server" Text='<%# Eval("TitleName") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="border" Width="15%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Episode No">
                                    <ItemTemplate>
                                        <asp:Label ID="lblIEpisode" runat="server" Text='<%# Eval("EpisodeNo") %> '></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" CssClass="border" Width="15%" />
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <%--</form>--%>
    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
        function EndRequestHandler(sender, args) {
            InitializeChosen();
        }
    </script>
</asp:Content>
<%--</body>
</html>--%>
