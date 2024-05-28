<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="Title_Avail_Language_New.aspx.cs" MasterPageFile="~/Home.Master"
    Inherits="Title_Avail_Language_New" %>

<%@ Register TagPrefix="UTO" Namespace="UTOFrameWork.FrameworkClasses" Assembly="RightsU_Plus" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" 
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">
    <link rel="stylesheet" href="../CSS/jquery-ui.css" />
    <link rel="stylesheet" href="../CSS/chosen.min.css" />
    <link rel="stylesheet" href="../CSS/common.css" />
    <link rel="stylesheet" href="../Master/stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
    <%--<link href="../CSS/Master_ASPX.css" rel="stylesheet" />--%>
    <script type="text/javascript" src="../Master/JS/master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/common.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/AjaxUpdater.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/Ajax.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/HTTP.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery-ui.min.js"></script>
    <script type="text/javascript" src="../JS_Core/common.concat.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../JS_Core/jquery.expander.js"></script>
    <script type="text/javascript" src="../JS_Core/autoNumeric-1.8.1.js"></script>
    <script type="text/javascript" src="../JS_Core/chosen.jquery.min.js"></script>
   <%-- <link href="../CSS/ui.datepick.css" rel="stylesheet" />--%>
    <%--New Date Pick--%>
    <link rel="stylesheet" href="../CSS/jquery.datepick.css" />
    <link rel="stylesheet" href="../CSS/ui-start.datepick.css" />
    <script type="text/javascript" src="../JS_Core/jquery.plugin.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.watermarkinput.js"></script>
    <script type="text/javascript" src="../JS_Core/watermark.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.datepick.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.datepick.ext.js"></script>
    <link rel="stylesheet" href="../CSS/Master_ASPX.css" />
   <%-- <script src="../Master/JS/multiSelection.js"></script>
    <script src="../Master/JS/multiple_listbox.js"></script>--%>
    <%--<link href="../Master/Stylesheet/star_rights.css" rel="stylesheet" />--%>

    <%--<link href="../stylesheet/star_rights.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" rel="stylesheet" />--%>
   

    <%--Start Chosen--%>
    <%--<link rel="stylesheet" type="text/css" href="../stylesheet/chosen.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
    <script type="text/javascript" src="../Javascript/JQuery/chosen.jquery.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>
    <%--End Chosen--%>



  <%--  <style type="text/css">
        /*Datepick css start*/
        select, textarea
        {
            font-family: Arial,Helvetica,Sans-serif;
            font-size: 100%;
            text-align: left;
        }

        .demo .ui-datepicker-row-break
        {
            font-size: 100%;
        }

        .ui-datepicker td
        {
            padding: 0px;
            vertical-align: inherit;
        }

        .ui-datepicker-header.ui-widget-header.ui-helper-clearfix.ui-corner-all
        {
            width: 180px;
        }

        table.ui-datepicker-calendar
        {
            width: 181px;
        }
        /*Datepick css end*/

        .chosen-container .chosen-results li.active-result
        {
            color: black;
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

        #divConfirmReport
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

        .content2
        {
            width: 500px;
            max-height: 180px;
            height: 150px;
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

            .content2 .X
            {
                float: right;
                height: 35px;
                left: 22px;
                position: relative;
                top: -25px;
                width: 34px;
            }

                .content2 .X:hover
                {
                    cursor: pointer;
                }

        .popupHeading
        {
            width: 30%;
            min-width: 31%;
            height: 3%;
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
            /*max-height:470px;*/
            overflow: auto;
        }

        #divConfirmReport
        {
            margin-top: 25px;
            width: 95%;
            height: 150px;
            float: left;
            height: 200px;
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
    </style>--%>
    <style type="text/css">
        /*Datepick css start*/
        select, textarea
        {
            font-family: Arial,Helvetica,Sans-serif;
            font-size: 100%;
            text-align: left;
        }

        .demo .ui-datepicker-row-break
        {
            font-size: 100%;
        }

        .ui-datepicker td
        {
            padding: 0px;
            vertical-align: inherit;
        }

        .ui-datepicker-header.ui-widget-header.ui-helper-clearfix.ui-corner-all
        {
            width: 180px;
        }

        table.ui-datepicker-calendar
        {
            width: 181px;
        }
        /*Datepick css end*/

        input[type=image]
        {
            float: left;
            border: none;
            border-radius: 0;
            padding: 0;
            margin: 0;
        }

        a#lbSelectTitles img
        {
            height: 22px;
            position: relative;
            top: 5px;
            background-color: #fff;
            left: 11px;
        }

        /*.overlay_common
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
        }*/


        .popup
        {
            width: 88%;
            margin: auto;
            top: 10%;
            display: none;
            position: absolute;
        }

        #TitlePopup
        {
            z-index: 8001;
        }

        #divNamesPopup
        {
            z-index: 8001;
        }

        #overlay
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
            z-index: 8000;
        }

        .popupHeading
        {
            width: 30%;
            min-width: 31%;
            height: 8%;
        }

        .textFont
        {
            color: #686868;
            font-size: 20px;
            font-family: sans-serif;
            text-shadow: 1px 1px 1px #E0E0E0;
        }

        .popup
        {
            width: 87%;
            margin: auto;
            top: 10%;
            display: none;
            position: absolute;
            z-index: 8001;
        }

        #PlatformPopup
        {
            z-index: 8001;
        }

        .content
        {
            width: 500px;
            height: 613px;
            margin: auto;
            background: #f3f3f3;
            position: relative;
            z-index: 103;
            padding: 10px;
            padding-left: 40px;
            border-radius: 5px;
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
#divPlatform
        {
            width: 95%;
            float: left;
            height: 500px;
            margin-top: 10px;
            /*max-height:470px;*/
            overflow: auto;
        }
        #divTitle
        {
            width: 96%;
            height: 305px;
            float: left;
            overflow: auto;
        }

        #divButtonPanel
        {
            width: 95%;
            float: left;
            padding-top: 10px;
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

        .chosen-container .chosen-results li.group-result
        {
            color: black;
            background-color: gainsboro;
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
            iframe#ReportFrameReportViewer1
            {
                height: 78% !important;
            }
        }

        div#oReportDiv
        {
            overflow: initial !Important;
        }

        #tblMin
        {
            margin-left: 12%;
        }

        .pagingborder
        {
            font-family: Corbel;
            font-size: 14px;
            border: 0 !important;
        }

        table.mainReports
        {
            background-color: #ffffff;
            height: 140px;
            /* padding: 0; */
            /* margin:0; */
            width: 94%;
        }

        #ReportViewer1 > iframe
        {
            height: 91% !important;
        }

        iframe#ReportFrameReportViewer1
        {
            height: 78% !important;
        }

        div#oReportDiv
        {
            overflow: initial !Important;
        }

        input#CphdBody_btnSearch
        {
            height: 30px;
            width: 110px;
        }

        h3.accordion-header.ui-accordion-header
        {
            background-color: #DEDEDE;
            color: #333;
        }

        .ui-accordion-content > table
        {
            width: 100%;
            border-spacing: 1px;
            border: 0;
            background-color: #fff;
            color: #555;
        }

            .ui-accordion-content > table > tbody > tr > td
            {
                border: 1px solid #aaa;
            }

        .ui-accordion .ui-accordion-content
        {
            padding: 0;
            overflow: visible;
        }

        .ui-tooltip
        {
            position: absolute;
            top: 50px !important;
            left: 500px !important;
            font-size: 12px;
            max-height: 650px;
            overflow-y: auto;
        }

        .tabCountry, .tabTerritory
        {
            display: inline-block;
            width: 48%;
            height: 25px;
            float: left;
            font-family: inherit;
            font-weight: 100;
            padding: 5px 3px 0 3px;
            margin: 0;
            border: 0;
            box-shadow: none;
            background-color: #ffffff !important;
        }

        .tabCountry
        {
            color: #333;
            font-weight: 500;
            text-decoration: underline;
        }

        .tabTerritory
        {
            cursor: pointer;
        }

        .platformTree table
        {
            width: initial;
        }

        #lstRegion_chosen > ul, #lstWithoutExcludedRegion_chosen > ul, #lbSubtitling_chosen > ul,
        #lbLanguage_chosen > ul, #lstLTerritory_chosen > ul
        {
            min-height: 83px;
        }

        .reportViewer > iframe
        {
            height: 91% !important;
        }

        iframe#ReportFrameReportViewer1
        {
            height: 78% !important;
        }

        div#oReportDiv
        {
            overflow: initial !Important;
        }

        .reportViewer
        {
            display: inline-block;
            border-style: Solid;
            border-color: #eee;
            border-width: 10px;
            height: 600px !Important;
            width: 100%;
        }

            .reportViewer table
            {
                width: initial;
            }

        #divConfirmReport
        {
            z-index: 8001;
        }

        #divConfirmReport
        {
            margin-top: 25px;
            width: 88%;
            height: 150px;
            float: left;
            height: 200px;
        }

        .content2
        {
            width: 500px;
            max-height: 300px;
            /*height: 190px;*/
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

            .content2 .X
            {
                float: right;
                height: 35px;
                left: 22px;
                position: relative;
                top: -25px;
                width: 34px;
            }

                .content2 .X:hover
                {
                    cursor: pointer;
                }

        .tbleRadio
        {
            width: 55%;
            padding: 5px 3px;
            margin-top: 8px;
            margin-left: 5px;
        }

        #CphdBody_divPlatformFilter
        {
            margin-top: 10px !Important;
        }

        #CphdBody_divPlatformGroup
        {
            margin-top: 10px !Important;
        }
        #CphdBody_uctabPTV_trView table
        {
            width: 0% !important;
            padding: 1%;
            display: table !important;
        }
        .ui-helper-reset
        {
            font-size: 13px !important;
        }
    </style>
    <script language="javascript" type="text/javascript">
        //$('.tabbable a').click(function (e) {
        //    e.preventDefault()
        //})
        var dateWatermarkFormat = "DD/MM/YYYY";
        var dateWatermarkColor = '#999';
        var dateNormalkColor = '#000';
        /*Start Code for Popup*/
        var overlay = $('<div id="overlay" class="overlay_common"></div>');
        function ClosePopup() {
            $('#PlatformPopup').hide();
            overlay.appendTo(document.body).remove();
            return false;
        }
        function OpenPopup() {
            overlay.show();
            overlay.appendTo(document.body);
            $('#PlatformPopup').show("fast");
            return false;
        }

        //Start choosen
        $(document).ready(function () {
            $('#<%=txtfrom.ClientID %>').datepick('option', 'minDate', $.datepick.today());
            $('#<%=txtto.ClientID %>').datepick('option', 'minDate', $.datepick.today());

            if ($('#<%=txtfrom.ClientID %>').val() != 'DD/MM/YYYY' && $('#<%=txtfrom.ClientID %>').val() != '')
                $('#<%=txtto.ClientID %>').datepick('option', 'minDate', $('#<%=txtfrom.ClientID %>').datepick('getDate')[0] || null);

            if ($('#<%=txtto.ClientID %>').val() != 'DD/MM/YYYY' && $('#<%=txtto.ClientID %>').val() != '')
                $('#<%=txtfrom.ClientID %>').datepick('option', 'maxDate', $('#<%=txtto.ClientID %>').datepick('getDate')[0] || null);
            AssignChosenJQuery();
           // AssignDateJQuery();
        });

        function AssignDateJQuery() {
                
            debugger;
            var dateWatermarkFormat = $('#<%= hdnDateWatermarkFormat.ClientID %>').val();
            var fromDate = $('#<%=txtfrom.ClientID %>').val();
            var toDate = $('#<%=txtto.ClientID %>').val();

            if (fromDate == dateWatermarkFormat) {
                fromDate = "";
                $('#<%=txtfrom.ClientID %>').val(fromDate);
            }
            if (toDate == dateWatermarkFormat) {
                toDate = "";
                $('#<%=txtto.ClientID %>').val(toDate);
            }

            if ($('#<%= txtto.ClientID %>').val() == "") {
                $('#<%= txtto.ClientID %>').val("DD/MM/YYYY");
                $('#<%=txtto.ClientID %>').css('color', dateWatermarkColor);
            }

            $('.dateRange').datepick({
                onSelect: customRange, dateFormat: 'dd/mm/yyyy', pickerClass: 'demo',
                autoSize: true,
                renderer: $.datepick.themeRollerRenderer,
                onClose: CloserDate,
                onShow: function () {
                    $('.ui-datepicker-cmd-clear').hide();
                }
            });
            function customRange(dates) {
                
                if (this.id == 'txtfrom') {
                    if ($('#<%=txtfrom.ClientID %>').val() != 'DD/MM/YYYY' && $('#<%= txtfrom.ClientID %>').val() != '') {
                        $('#<%=txtto.ClientID %>').datepick('option', 'minDate', dates[0] || null);
                        $('#<%=txtfrom.ClientID %>').css('color', dateNormalkColor);
                    }
                    else {
                        $('#<%=txtto.ClientID %>').datepick('option', { minDate: null });
                        $('#<%=txtfrom.ClientID %>').val(dateWatermarkFormat);
                        $('#<%=txtfrom.ClientID %>').css('color', dateWatermarkColor);
                    }
                }
                else {
                    if ($('#<%=txtto.ClientID %>').val() != 'DD/MM/YYYY' && $('#<%=txtto.ClientID %>').val() != '') {
                        $('#<%=txtfrom.ClientID %>').datepick('option', 'maxDate', dates[0] || null);
                        $('#<%=txtto.ClientID %>').css('color', dateNormalkColor);
                    }
                    else {
                        $('#<%=txtfrom.ClientID %>').datepick('option', { maxDate: null });
                        $('#<%=txtto.ClientID %>').val(dateWatermarkFormat);
                        $('#<%=txtto.ClientID %>').css('color', dateWatermarkColor);
                    }
                }
            }
            $('.dateRange').Watermark(dateWatermarkFormat);


            //$('.milestoneDateRange').dateEntry({dateFormat: 'dmy/' });
            //$('.milestoneDateRange').Watermark(dateWatermarkFormat);

            if (fromDate != "")
                $('#<%=txtfrom.ClientID %>').val(fromDate);

            if (toDate != "")
                $('#<%=txtto.ClientID %>').val(toDate);
        }

        function InitializeStartDate() {
            $('#<%=txtfrom.ClientID %>').datepick('option', 'minDate', $.datepick.today());
            $('#<%=txtto.ClientID %>').datepick('option', 'minDate', $.datepick.today());
        }

        function clearDate(date) {
            if (date == 'txtfrom') {
                $('#<%=txtto.ClientID %>').datepick('option', { minDate: null });
                $('#<%=txtfrom.ClientID %>').val(dateWatermarkFormat);
                $('#<%=txtfrom.ClientID %>').css('color', dateWatermarkColor);
            }
            else {
                $('#<%=txtfrom.ClientID %>').datepick('option', { maxDate: null });
                $('#<%=txtto.ClientID %>').val(dateWatermarkFormat);
                $('#<%=txtto.ClientID %>').css('color', dateWatermarkColor);
            }

        }

        
        function AssignChosenJQuery() {
            var maxSelectedOption = <%= this.MaxSelectedOption %>

                $('.Chosenlb').chosen({
                    width: "95%",
                    placeholder_text_multiple: "-- Please Select --",
                    placeholder_text_single: "-- Please Select --"
                });

            $('.ChosenTitle').chosen();
    }
        function triggerChoosen() {
            $(".Chosenlb").trigger("chosen:updated");
            $('.ChosenTitle').trigger("chosen:updated");
        }

        function Assign_Css() {
            $("#<%=ReportViewer1.ClientID %> table").each(function (i, item) {
                $(item).css('display', 'inline-block');
                $(item).css('width', 'initial');
            });

            $("#<%=ReportViewer1.ClientID %> table.aspNetDisabled").each(function (i, item) {
                $(item).css('display', 'none');
            });
        }
        function ValidateTitle() {
            //if ($('#lsMovie.ChosenTitle')[0].value == '') {
            //    AlertModalPopup(lsMovie, 'Please select atleast one title.');
            //    return false;
            //}
            var lsMovie = $('#<%= lsMovie.ClientID %>');
            if (!$('#<%= chkIsOriginalLanguage.ClientID %>')[0].checked && $("[id*=<%=chkDubbingSubtitling.ClientID %>] input:checked").length == 0) {
                AlertModalPopup(lsMovie, 'Please select atleast one language type.');
                return false;
            }

            if ($('#<%= txtfrom.ClientID %>').val() == 'DD/MM/YYYY' || $('#<%= txtfrom.ClientID %>').val() == '') {
                AlertModalPopup(lsMovie, 'Please select Available from date.');
                return false;
            }

            var txtfrom = $('#<%= txtfrom.ClientID %>');
            var txtto = $('#<%= txtto.ClientID %>');

            if ($(":radio[id*=<%=rblDateCriteria.ClientID %>]")[1].checked == true && txtto.value == '') {
                AlertModalPopup(lsMovie, 'Please select Available to date.');
                return false;
            }
            var rightSD = new Date(MakeDateFormate(txtfrom.val()));
            var rightED = new Date(MakeDateFormate(txtto.val()));
            if (rightSD > rightED) {
                AlertModalPopup(lsMovie, 'Available From Date cannot be greater than Available To Date');
                return false;
            }

            overlay.show();
            overlay.appendTo(document.body);

            $('#trReportName').hide();
            $('#trblank').show();
            $('#<%= txtReportName.ClientID %>').val('');
            $("#<%= rdQueryNo.ClientID %>").prop("checked", true)

            $('#divConfirmReport').show("fast");
            return false;
            //return true;
        }

        function CloseQueryPopup() {
            $('#divConfirmReport').hide();
            overlay.appendTo(document.body).remove();
            return false;
        }

        function SetReportNameVisibility(filter) {
            if (filter == 'Y') {
                $('#trReportName').show();
                $('#trblank').hide();

            }
            else {
                $('#trReportName').hide();
                $('#trblank').show();
            }
        }

        function CheckTab(tab) {
            //if (tab == "S" && $('#btnSchedule').attr("src") == "../images/r_ScheduledReport.jpg")
            //    return false;
            //if (tab == "Q" && $('#btnQuery').attr("src") == "../images/r_SavedReport.jpg")
            //    return false;
            debugger;
            if (tab == "S" && $('#<%= hdnTabVal.ClientID %>').val() == "S") {
                $('#<%= btnSchedule.ClientID %>').addClass('active');
                $('#<%= btnQuery.ClientID %>').removeClass('active');
                return false;
            }
            if (tab == "Q" && $('#<%= hdnTabVal.ClientID %>').val() == "Q") {
                $('#<%= btnSchedule.ClientID %>').removeClass('active');
                $('#<%= btnQuery.ClientID %>').addClass('active');
                return false;
            }
            return true;
        }

        function validateReportType() {
            if ($('#<%= rdQueryYes.ClientID %>').is(':checked') && $('#<%= txtReportName.ClientID %>').val().trim() == "") {
                AlertModalPopup($('#<%= txtReportName.ClientID %>'), 'Please enter report name');
                $('#<%= txtReportName.ClientID %>').focus();
                return false;
            }

            if ($('#<%= rdQueryYes.ClientID %>').is(':checked')) {
                var count = "";

                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: '../Master/ProcessResponseRequest.aspx?action=ChkDuplicateReportName&ReportName=' + $('#<%= txtReportName.ClientID %>').val().trim(),
                    async: false,
                    success: function (response) {
                        count = response;
                    }
                });

                if (parseInt(count, 0) > 0) {
                    AlertModalPopup($('#<%= txtReportName.ClientID %>'), 'Report name already exists, please use another name');
                    $('#<%= txtReportName.ClientID %>').focus();
                    return false;
                }
            }

            $('#divConfirmReport').hide();
            overlay.appendTo(document.body).remove();
            return true;
        }

        function sliceOption() {
            var countrycount = $("#<%=lstLTerritory.ClientID %> option").filter(function () {
                return $(this).val().indexOf('C') > -1
            }).length;

            var territoryCount = $("#<%=lstLTerritory.ClientID %> option").filter(function () {
                return $(this).val().indexOf('T') > -1
            }).length;
            $("#<%=lstLTerritory.ClientID %> option").filter(function () {
                return $(this).val().indexOf('T') > -1
            }).slice(0, territoryCount).wrapAll('<optgroup label="Territory"></optgroup>');

            $("#<%=lstLTerritory.ClientID %> option").filter(function () {
                return $(this).val().indexOf('C') > -1
            }).slice(0, countrycount).wrapAll('<optgroup label="Country"></optgroup>');

        }


        function sliceLanguageOption() {
            var groupcount = $("#<%= lbLanguage.ClientID %> option").filter(function () {
                return $(this).val().indexOf('G') > -1
            }).length;

            var languageCount = $("#<%= lbLanguage.ClientID %> option").filter(function () {
                return $(this).val().indexOf('L') > -1
            }).length;
            $("#<%= lbLanguage.ClientID %> option").filter(function () {
                return $(this).val().indexOf('G') > -1
            }).slice(0, groupcount).wrapAll('<optgroup label="Language Group"></optgroup>');

            $("#<%= lbLanguage.ClientID %> option").filter(function () {
                return $(this).val().indexOf('L') > -1
            }).slice(0, languageCount).wrapAll('<optgroup label="Language"></optgroup>');

        }
        function triggerChoosen() {
            $(".Chosenlb").trigger("chosen:updated");
            $('.ChosenTitle').trigger("chosen:updated");
        }
        function ValidateMandatoryField() {
            if (!checkblank(document.getElementById('<%=txtSearch.ClientID %>').value)) {
                AlertModalPopup(document.getElementById('<%= btnSearch_plt %>'), 'Please enter Platform / Rights');
                return false;
            }
            // return true;
        }
        function chkAddYear() {

            //$(":radio[name=rblDateCriteria]").change(function (e) {
            //    if ($(this).val() == 'FL')
            //        document.getElementById('tdAddYear').style.display = '';
            //    else
            //        document.getElementById('tdAddYear').style.display = 'none';
            //    document.getElementById('chkAddYear').checked = false;
            //});

            $('#<%= chkAddYear.ClientID %>').change(function () {
                debugger;
                var txtto = $('#<%= txtto.ClientID %>');
                if ($(this).is(":checked")) {
                    var txtfrom = $('#<%= txtfrom.ClientID %>');

                    var rightSD = new Date(MakeDateFormate(txtfrom.val()));
                    var newDate = CalculateEndDate(rightSD, 1, 0);
                    txtto.val(newDate);
                }
                else
                    txtto.val('');
            });


        }
        function CalculateEndDate(startDate, year, month) {
            var yearToMonth = 12 * year;
            month = month + yearToMonth;
            startDate.setMonth(startDate.getMonth() + month);
            startDate.setDate(startDate.getDate() - 1);
            var newDateStr = ConvertDateToCurrentFormat(startDate);
            return newDateStr;
        }

        function CloserDate(date) {
            if (date.length == 0) {
                if (this.id == '<%=txtfrom.ClientID %>') {
                    $('#<%=txtto.ClientID %>').datepick('option', { minDate: $.datepick.today() });
                    $('#<%=txtfrom.ClientID %>').val(dateWatermarkFormat);
                    $('#<%=txtfrom.ClientID %>').css('color', dateWatermarkColor);
                }
                else if (this.id == '<%=txtto.ClientID %>') {
                    $('#<%=txtfrom.ClientID %>').datepick('option', { maxDate: null });
                    $('#<%=txtto.ClientID %>').val(dateWatermarkFormat);
                    $('#<%=txtto.ClientID %>').css('color', dateWatermarkColor);
                }
        }
    }
        function ConvertDateToCurrentFormat(objDate) {
            var dd = objDate.getDate();
            var mm = objDate.getMonth() + 1; //January is 0!
            var yyyy = objDate.getFullYear();

            if (dd < 10)
                dd = '0' + dd

            if (mm < 10)
                mm = '0' + mm

            var newDate = dd + '/' + mm + '/' + yyyy;
            return newDate;
        }


        function RefreshStatus(lblID, lblFile, lblMail, intCode, lblIntCode) {
            //var params = "action=RefreshTitleAvailReportStatus&Avail_Report_Schedule_Code=" + intCode;
            //var value = AjaxUpdater.Update('GET', '../ProcessResponseRequest.aspx', getResponse, params);
            //debugger;
            //lblID.innerHTML = Ajax.request.responseText;
            if (intCode == lblIntCode.innerHTML) {
                $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: '../Master/ProcessResponseRequest.aspx?action=RefreshTitleAvailReportStatus&Avail_Report_Schedule_Code=' + intCode,
                    async: false,
                    success: function (response) {
                        var str = response.split('~');
                        lblFile.innerHTML = str[0];
                        lblMail.innerHTML = str[1];
                        lblID.innerHTML = str[2];
                    }
                });
            }
        }

        function refreshStatus(lblID, lblFile, lblMail, intCode, lblIntCode) {
            var IntervalCode = setInterval("RefreshStatus(" + lblID + ", " + lblFile + ", " + lblMail + ", " + intCode + ", " + lblIntCode + ")", 5000);
        }

        function getResponse() { }

    </script>


    <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0">
    </asp:ScriptManager>
    <div class="top_area">
        <h2 class="pull-left">Title Availability </h2>
        <div class="right_nav pull-right">
            <ul>
                <li>Business Unit</li>
                <li>
                    <asp:DropDownList ID="ddlBusinessUnit" runat="server" AutoPostBack="true" CssClass="select" OnSelectedIndexChanged="ddlBusinessUnit_SelectedIndexChanged"></asp:DropDownList>
                </li>
            </ul>
        </div>
    </div>
    <asp:UpdatePanel ID="upGridView" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table width='100%' border='0' cellpadding='0' cellspacing='0' align='center'>             
                <tr id="trSearch" runat="server">
                    <td>
                        <div class="search_area">
                        <table width='100%' border='0' cellpadding='0' cellspacing='0' align='center' valign='top'
                            class="main2">
                            <tr>
                                <td class='pagingborder' width="33%">
                                    <table align="center" border="0" cellpadding="2" cellspacing="0" style="width: 100%"
                                        valign="top">
                                        <tr>
                                            <td align="left" width="15%" height="35px"><b>Title</b></td>
                                            <td width="85%">
                                                <%--<asp:ListBox ID="lsMovie" class="ChosenTitle" runat="server" Width="99%"></asp:ListBox>--%>
                                                <asp:ListBox ID="lsMovie" runat="server" class="ChosenTitle" Width="95%" SelectionMode="Multiple"></asp:ListBox>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td width="33%" valign="middle" align="left" class="pagingborder" style="vertical-align: top; height: 100%;">
                                    <table align="center" border="0" cellpadding="2" cellspacing="0" style="width: 100%"
                                        valign="top">
                                        <tr>
                                            <td colspan="3" align="left" width="15%">Region</td>
                                            <td width="85%">
                                                <%--<asp:ListBox ID="lstLTerritory" class="Chosenlb" runat="server" Width="95%" ></asp:ListBox>--%>
                                                    <asp:ListBox ID="lstLTerritory" runat="server" class="Chosenlb"
                                                                Height="25px" Width="95%" SelectionMode="Multiple"></asp:ListBox>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td class="pagingborder" width="34%" align="center" rowspan="2">
                                    <table border="0" cellpadding="2" cellspacing="0" style="width: 100%" valign="top">
                                        <tr>
                                            <td>
                                                <asp:RadioButtonList runat="server" ID="rblDateCriteria" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rblDateCriteria_SelectedIndexChanged">
                                                    <asp:ListItem Selected="True" Text="Flexi Date" Value="FL"></asp:ListItem>
                                                    <asp:ListItem Text="Fixed Date" Value="FI"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                            <td id="tdAddYear" runat="server">
                                                <asp:CheckBox ID="chkAddYear" Text="Add 1 Year" onclick="return chkAddYear();" runat="server" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center" style="width: 60%;">Available From : 
                                                <asp:TextBox ID="txtfrom" Width="77px" MaxLength="50" AutoPostBack="true"  CssClass="text dateRange"
                                                        runat="server" onkeypress="return false;" onkeydown="return false;"></asp:TextBox>
                                                <a href="#" onclick="clearDate('txtfrom');">clear</a>
                                                <asp:HiddenField ID="hdnDateWatermarkFormat" runat="server" />
                                            </td>
                                            <td>To : <asp:TextBox ID="txtto" Width="77px" MaxLength="50" CssClass="text dateRange" AutoPostBack="true"
                                                    runat="server" onkeypress="return false;" onkeydown="return false;"></asp:TextBox>

                                                <a href="#" onclick="clearDate('txtto');">clear</a>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>

                            <tr>
                                <td class='pagingborder' width="66%" colspan="2">
                                    <table border="0" cellpadding="2" cellspacing="0" style="width: 100%" valign="top">
                                        <tr>
                                            <td align="left" width="10%">Platform</td>
                                            <td width="30%">
                                                <asp:LinkButton ID="lnkbtnPltform" runat="server" OnClick="lnkbtnPltform_Click" CommandName="PD"
                                                    Text="Select Platforms" Style="float: left; font-weight: bold;"></asp:LinkButton>
                                                <asp:HiddenField ID="hdnPlatform" runat="server" Visible="false" />
                                            </td>
                                            <td align="left" width="10%">Report On</td>
                                            <td width="30%">
                                                <asp:RadioButtonList ID="rdlNode" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Text="Parent Node" Value="P" />
                                                    <asp:ListItem Text="Child Node" Value="C" Selected="True" />
                                                </asp:RadioButtonList>
                                            </td>

                                        </tr>
                                    </table>
                                </td>
                                <%--<td style="width: 34%" class="pagingborder" align="center">
                                                    <table align="center" border="0" cellpadding="2" cellspacing="0" style="width: 100%"
                                                        valign="top">
                                                        <tr>
                                                                       
                                                        </tr>
                                                    </table>
                                                </td>--%>
                            </tr>
                            <tr>
                                <td width="33%" class="pagingborder">
                                    <asp:RadioButtonList ID="rdbGroupBy" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Text="Language wise" Value="L" Selected="True" />
                                        <asp:ListItem Text="Country wise" Value="C" />
                                    </asp:RadioButtonList>
                                </td>
                                <%-- <td class="pagingborder" width="33%">
                                                    <table align="center" border="0" cellpadding="2" cellspacing="0" style="width: 100%"
                                                        valign="top">
                                                        <tr>
                                                                       
                                                        </tr>
                                                    </table>
                                                </td>--%>
                                <td style="width: 67%" class="pagingborder" align="center" colspan="2">
                                    <table align="center" border="0" cellpadding="2" cellspacing="0" style="width: 100%"
                                        valign="top">
                                        <tr>
                                            <td style="width: 15%;">
                                                <asp:CheckBox ID="chkIsOriginalLanguage" Text="Title Language" runat="server" Checked="true" />
                                            </td>
                                            <td style="width: 33%;">
                                                <asp:CheckBoxList ID="chkDubbingSubtitling" runat="server" RepeatDirection="Horizontal">
                                                    <asp:ListItem Text="Subtitling" Value="S" />
                                                    <asp:ListItem Text="Dubbing" Value="D" />
                                                </asp:CheckBoxList>
                                            </td>
                                            <td colspan="3" align="left" width="11%">Language</td>
                                            <td width="35%">
                                                <%--<asp:ListBox ID="lbLanguage" class="Chosenlb" runat="server" Width="99%" Height="25px"></asp:ListBox>--%>
                                                <asp:ListBox ID="lbLanguage" runat="server" class="Chosenlb"
                                                                Height="140px" Width="95%" SelectionMode="Multiple"></asp:ListBox>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 66%" align="left" class="pagingborder" colspan="2">
                                    <asp:CheckBox ID="chkShowRemarks" Text="Show Remarks" runat="server" Checked="true" Visible="false" />
                                </td>
                                <td align="right" class="pagingborder" style="width: 34%; border-top: none; border-bottom: none; border-right: none;">
                                    <asp:Button ID="btnSearch" runat="server" CssClass="button"
                                        ValidationGroup="SEARCH" Text="Generate Report" Width="150px" OnClientClick="return ValidateTitle();" />
                                    <asp:Button ID="btnback" Width="60px" Visible="false" runat="server" OnClick="btnback_Click" CssClass="button"
                                        Text="Back" /></td>
                            </tr>
                            <tr>
                                <td>
                                    <div class='popup' id="divConfirmReport">
                                        <div class='content2' id="divContent2">
                                            <img src="../images/fancy_close.png" alt='quit' class='X' id='Img2' onclick="CloseQueryPopup()" />
                                            <table width='100%' border='0' cellspacing="2" cellpadding="2" align='center' valign='top'>
                                                <tr>
                                                    <td style="width: 50%">Do you want to save this report ? &nbsp;</td>
                                                    <td>
                                                        <asp:RadioButton runat="server" ID="rdQueryYes" GroupName="rdQuery" Text="Yes" onclick="SetReportNameVisibility('Y');" />&nbsp;
                                                                    <asp:RadioButton runat="server" ID="rdQueryNo" GroupName="rdQuery" Checked="true" Text="No" onclick="SetReportNameVisibility('N');" />
                                                    </td>
                                                </tr>
                                                <tr id="trReportName" style="display: none;">
                                                    <td>Report Name</td>
                                                    <td>
                                                        <asp:TextBox runat="server" ID="txtReportName" Width="200px" MaxLength="500" CssClass="text"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr id="trblank" style="display: block;">
                                                    <td colspan="2">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td align="center" colspan="2">
                                                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="button" 
                                                            Style="cursor: pointer;" OnClientClick="return validateReportType();" 
                                                            OnClick="btnSubmitReport_Click" />
                                                        &nbsp;<input type="button" value="Close" class="button" style="cursor: pointer;" onclick="CloseQueryPopup()" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                    </table>
                        </div>
                    </td>
                </tr>
                <tr><td>&nbsp;</td></tr>                                  
                <tr>                                           
                    <td>
                        <div class="navigation_tabs">
                            <div class="tabbable ">
                                <ul class="nav nav-tabs nav-tab pull-left">
                                    <li runat="server" id="ScheduleLi">
                                        <asp:Button ID="btnSchedule" Height="27px" Text="Schedule" runat="server" OnClick="btnSchedule_Click" OnClientClick="return CheckTab('S');" />
                                        <span></span></li>
                                    <li runat="server" id="QueryLi" >
                                        <asp:Button ID="btnQuery" Height="27px" Text="Query" runat="server" OnClick="btnQuery_Click" OnClientClick="return CheckTab('Q');" />
                                        <span></span></li>
                                </ul>
                            </div>
                        </div>
                    </td>
                </tr> 
                <tr>
                    <td colspan="3">
                        <div class="table-wrapper">
                                <table  id="SavedQuery" runat="server">
                                    <tr>
                                        <td>
                                            <div class="paging_area clearfix">
                                                <div class="divBlock">
                                                    <div style="float: left;">
                                                        <span class="pull-left">Total Records:
                                                                            <asp:Label ID="lblTotal" runat="server" Text="0"></asp:Label>&nbsp;
                                                                            <asp:Label ID="lblMdt" runat="server" CssClass="lblmandatory" Text="(*) Mandatory Field" Visible="False"></asp:Label>
                                                        </span>
                                                    </div>
                                                    <div style="float: right;">
                                                        <asp:DataList ID="dtLst" runat="server" RepeatDirection="Horizontal" OnItemCommand="dtLst_ItemCommand"
                                                            OnItemDataBound="dtLst_ItemDataBound">
                                                            <ItemTemplate>
                                                                <asp:Button ID="btnPager" CssClass="pagingbtn" Text='<%#  ((UTOFrameWork.FrameworkClasses.AttribValue)Container.DataItem).Attrib %>'
                                                                    CommandArgument='<%#  ((UTOFrameWork.FrameworkClasses.AttribValue)Container.DataItem).Val %>'
                                                                    runat="server" />
                                                            </ItemTemplate>
                                                        </asp:DataList>
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="">
                                            <asp:GridView ID="gvSchedule" runat='server' CssClass='table table-bordered table-hover' AllowSorting='True' HeaderStyle-CssClass='tableHd'
                                    CellPadding="3" AlternatingRowStyle-CssClass='rowBg' Width='100%' AutoGenerateColumns='False'
                                                DataKeyNames="Avail_Report_Schedule_Code" OnRowDeleting="gvSchedule_RowDeleting" OnRowCommand="gvSchedule_RowCommand" OnRowDataBound="gvSchedule_RowDataBound">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Report Name">
                                                        <ItemTemplate>
                                                            <div class="expandable">
                                                                <asp:Label ID="lblReportName" runat="server" Text='<%# Eval("ReportName") %>'></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="15%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Title">
                                                        <ItemTemplate>
                                                            <div class="expandable">
                                                                <asp:Label ID="lblTitle_Names" runat="server" Text='<%# Eval("Title_Names") %>'></asp:Label>
                                                                <asp:Label ID="lblAvail_Report_Schedule_Code" runat="server" Text='<%# Eval("Avail_Report_Schedule_Code") %>' Style="display: none;"></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="10%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Platform">
                                                        <ItemTemplate>
                                                            <div class="expandable">
                                                                <asp:Label ID="lblPlatform_Names" runat="server" Text='<%# Eval("Platform_Names") %>'></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="10%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Region">
                                                        <ItemTemplate>
                                                            <div class="expandable">
                                                                <asp:Label ID="lblCountry_Names" runat="server" Text='<%# Eval("Country_Names") %>'></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="10%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Language">
                                                        <ItemTemplate>
                                                            <div class="expandable">
                                                                <asp:Label ID="lblLanguage_Names" runat="server" Text='<%# Eval("Language_Names") %>'></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="10%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Node">
                                                        <ItemTemplate>
                                                            <div class="expandable">
                                                                <asp:Label ID="lblNode" runat="server" Text='<%# Eval("Node") %>'></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="5%" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Dubbing">
                                                        <ItemTemplate>
                                                            <div class="expandable">
                                                                <asp:Label ID="lblIs_Dubbing" runat="server" Text='<%# Eval("Is_Dubbing") %>'></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="4%" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Subtitling">
                                                        <ItemTemplate>
                                                            <div class="expandable">
                                                                <asp:Label ID="lblIs_Subtitling" runat="server" Text='<%# Eval("Is_Subtitling") %>'></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="4%" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Report By">
                                                        <ItemTemplate>
                                                            <div class="expandable">
                                                                <asp:Label ID="lblGroupBy" runat="server" Text='<%# Eval("GroupBy") %>'></asp:Label>
                                                            </div>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="5%" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Start Date">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblStartDate" runat="server" Text='<%# Eval("StartDate") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="7%" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="End Date">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblEndDate" runat="server" Text='<%# Eval("EndDate") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="7%" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="File Name">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblFileName" runat="server" Text='<%# Eval("Report_File_Name") %>'></asp:Label>
                                                            <asp:LinkButton ID="hlnkFileName" runat="server" CausesValidation="False" CommandName="DOWNLOAD" Text='<%# Eval("Report_File_Name") %>' Visible="false"></asp:LinkButton>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="10%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Mail Sent">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblMailSent" runat="server" Text='<%# Eval("Email_Status") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="5%" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Status">
                                                        <ItemTemplate>
                                                            <%--<asp:Timer ID="Timer1" runat="server" Interval="5000" OnTick="Timer1_Tick"></asp:Timer>--%>
                                                            <asp:Label ID="lblReport_Status" runat="server" Text='<%# Eval("Report_Status") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle Width="8%" HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Action">
                                                        <ItemTemplate>
                                                            <asp:Button ID="btnDelete" runat="server" Text="Delete" CssClass="button" CommandName="DELETE" OnClientClick="javascript:return ShowActiveSms(this, 'Are you sure, you want to delete ?', this);" />
                                                            <asp:Button ID="btnGenerate" runat="server" Text="Re-Schedule" CssClass="button" CommandName="GENERATE"
                                                                CommandArgument='<%# DataBinder.Eval(Container, "RowIndex") %>' OnClientClick="javascript:return ShowActiveSms(this, 'Are you sure you want to re-generate this query ?', this);" />
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                                </div>
                                            <asp:HiddenField runat="server" ID="hdnTabVal" EnableViewState="true" />
                                        </td>
                                    </tr>
                        </table>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:UpdatePanel ID="UpPlatformPopup" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div class='popup' id="PlatformPopup">
                                        <div class='content'>
                                            <img src="../images/fancy_close.png" alt='quit' class='X' id='Img1' onclick="ClosePopup()" />
                                            <div class="popupHeading textFont" style="float: left;">
                            Platform / Rights
                        </div>
                                            <div style="float: right;">
                                                <asp:TextBox ID="txtSearch" runat="server" MaxLength="100"></asp:TextBox>
                                                <asp:Button ID="btnSearch_plt" runat="server" CssClass="button" Text="Search" OnClientClick="return ValidateMandatoryField();" OnClick="btnSearch_plt_Click" />
                                                <asp:Button ID="btnShowAll_plt" runat="server" CssClass="button" Text="Show All" OnClick="btnShowAll_plt_Click" />
                                            </div>
                                            <div id="divPlatform">
                                                <ucPTV:ucTab ID="uctabPTV" runat="server" />
                                            </div>
                                            <div id="divButtonPanel">
                                                <asp:Button ID="btnSavePlatform" runat="server" Text="Save" CssClass="button" Style="cursor: pointer;" OnClick="btnSavePlatform_Click" />
                                                <input type="button" value="Close" class="button" style="cursor: pointer;" onclick="ClosePopup()" />
                                            </div>
                                        </div>
                                    </div>
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="lnkbtnPltform" EventName="Click" />
                                    <asp:AsyncPostBackTrigger ControlID="btnSearch_plt" EventName="Click" />
                                </Triggers>
                            </asp:UpdatePanel>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnSearch" />
            <%--<asp:PostBackTrigger ControlID="btnSchedule" />
            <asp:PostBackTrigger ControlID="btnQuery" />--%>
            <asp:AsyncPostBackTrigger ControlID="btnback" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="rblDateCriteria" EventName="SelectedIndexChanged" />
            <%--<asp:AsyncPostBackTrigger ControlID="btnSearch_plt" EventName="Click" />--%>
        </Triggers>
        
    </asp:UpdatePanel>
 
    <rsweb:ReportViewer ID="ReportViewer1" runat="server" ShowParameterPrompts="false"
        BorderStyle="Solid" Visible="false" Style="width: 100%;">
    </rsweb:ReportViewer>
               
    <script type="text/javascript">
        function initlyExpander() {
            $.expander.defaults.slicePoint = 50;
            $('div.expandable').expander({
                slicePoint: 50,  // default is 100
                expandPrefix: '...', // default is '... '
                expandText: '<span style="color:blue">...read more</span>', // default is 'read more'
                collapseTimer: 0,  // re-collapses after 5 seconds; default is 0, so no re-collapsing, // re-collapses after 5 seconds; default is 0, so no re-collapsing
                userCollapseText: '<span style="color:blue">[^]</span>'  // default is 'read less'
            });
        }

        $(document).ready(function () {
            initlyExpander();
            AssignChosenJQuery();
        });

        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
        function EndRequestHandler(sender, args) {
            initlyExpander();
            AssignChosenJQuery();
            AssignDateJQuery();
        }
    </script>
</asp:Content>
