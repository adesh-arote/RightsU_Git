<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Title_Avail_Language_2.aspx.cs" Inherits="RightsU_WebApp.Reports.Title_Avail_Language_2" MasterPageFile="~/Home.Master" %>

<%@ Register TagPrefix="UTO" Namespace="UTOFrameWork.FrameworkClasses" Assembly="RightsU_Plus" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" 
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">

    <link rel="stylesheet" href="../CSS/jquery-ui.css" />
    <link rel="stylesheet" href="../CSS/chosen.min.css" />
    <link rel="stylesheet" href="../CSS/common.css" />
    <link rel="stylesheet" href="../CSS/Master_ASPX.css" />
    <link rel="stylesheet" href="../Master/stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />

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

    <%--New Date Pick--%>
    <link rel="stylesheet" href="../CSS/jquery.datepick.css" />
    <link rel="stylesheet" href="../CSS/ui-start.datepick.css" />
    <script type="text/javascript" src="../JS_Core/jquery.plugin.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.watermarkinput.js"></script>
    <script type="text/javascript" src="../JS_Core/watermark.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.datepick.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.datepick.ext.js"></script>

    <style type="text/css">
        /*Datepick css start*/
        select, textarea {
            font-family: Arial,Helvetica,Sans-serif;
            font-size: 100%;
            text-align: left;
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

        /*Datepick css end*/

        .overlay_common {
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

        #overlay {
            z-index: 8000;
        }

        .popup {
            width: 85%;
            margin: auto;
            top: 10%;
            display: none;
            position: absolute;
        }

        .content {
            width: 650px;
            max-height: 650px;
            height: 625px;
            margin: auto;
            background: #f3f3f3;
            position: relative;
            z-index: 103;
            padding: 10px;
            padding-left: 30px;
            border-radius: 5px;
            box-shadow: 5px 5px 5px #888888;
            font-family: Arial,Helvetica,sans-serif;
            font-size: 12px;
        }

            .content .X {
                float: right;
                height: 35px;
                left: 22px;
                position: relative;
                top: -25px;
                width: 34px;
            }

                .content .X:hover {
                    cursor: pointer;
                }

        .popupHeading {
            width: 30%;
            min-width: 31%;
            height: 3%;
            color: #686868;
            font-size: 20px;
            font-family: sans-serif;
            text-shadow: 1px 1px 1px #E0E0E0;
        }

        .chosen-container .chosen-results li.active-result {
            color: black;
            text-align: left;
        }

        .chosen-container .chosen-results li.no-results {
            color: black;
        }

        #PlatformPopup {
            z-index: 8001;
        }

        #divPlatform {
            width:100%;
            float: left;
            height: 500px;
            overflow: auto;
            margin-top: 20px;
        }

            #divPlatform table {
                width: initial;
            }

        #divButtonPanel {
            width: 95%;
            float: left;
            padding-top: 10px;
        }

        .chosen-container-multi .chosen-choices li.search-field {
            height: 27px !Important;
        }

        #ReportViewer1 > iframe {
            height: 91% !important;
        }

        @media screen and (-webkit-min-device-pixel-ratio:0) {
            iframe#ReportFrameReportViewer1 {
                height: 78% !important;
            }
        }

        div#oReportDiv {
            overflow: initial !Important;
        }

        .chosen-container .chosen-results li.group-result {
            color: black;
            background-color: gainsboro;
        }

        .pagingborder {
            font-family: Verdana,Helvetica,sans-serif;
            font-size: 14px;
            color: #FFFFFF;
            background-color: #aaa;
            border: 0px solid #FFFFFF !important;
            text-transform: uppercase;
        }

        table.mainReports {
            border-collapse: initial;
            border: 1px solid #aaa;
            background-color: #ffffff;
            border-radius: 4px;
            height: 140px;
            padding: 0px 0px;
            margin: 0px;
            width: 100%;
        }

        .reportViewer > iframe {
            height: 91% !important;
        }

        iframe#ReportFrameReportViewer1 {
            height: 78% !important;
        }

        div#oReportDiv {
            overflow: initial !Important;
        }

        .reportViewer {
            display: inline-block;
            border-style: Solid;
            height: 600px !Important;
            width: 100%;
        }

            .reportViewer table {
                width: initial;
            }
    </style>
    <script type="text/javascript">
        var dateWatermarkFormat = "DD/MM/YYYY";
        var dateWatermarkColor = '#999';
        var dateNormalkColor = '#000';
        var overlay = $('<div id="overlay" class="overlay_common"></div>');

        $(document).ready(function () {
            $("#<%=lbLanguage.ClientID %>").disabled = false;
            $('#<%=txtMonths.ClientID %>').autoNumeric('init', { vMax: '999', wEmpty: '0', mDec: 0 });
            $('#<%=txtYears.ClientID %>').autoNumeric('init', { vMax: '999', wEmpty: '0', mDec: 0 });
            AssignChosenJQuery();
        });

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

        function AssignChosenJQuery() {
            var maxSelectedOption = <%= this.MaxSelectedOption %>
            $('.Chosenlb').chosen('Select Title');
            //  $('.ChosenTitle').chosen('Select Title');
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
            var txtMonths = $get('<%=txtMonths.ClientID %>');
            var txtYears = $get('<%=txtYears.ClientID %>');

            if (document.getElementById('<%=hdnPlatform.ClientID %>').value == '')
                document.getElementById('<%=hdnPlatform.ClientID %>').value == '0';

            if ($('#<%=lsMovie.ClientID %>.ChosenTitle')[0].value == '' && $('#<%=lstLTerritory.ClientID %>.Chosenlb')[0].value == '' && $(":checkbox[id=<%=chkSpecficPlt.ClientID %>]")[0].checked == false && (document.getElementById('<%=hdnPlatform.ClientID %>').value == '0' || document.getElementById('<%=hdnPlatform.ClientID %>').value == '')) {
                var lsMovie = document.getElementById('<%=lsMovie.ClientID %>');
                AlertModalPopup(lsMovie, 'Please select atleast one Title, Region or Platform .');
                return false;
            }

            if (!$('#<%=chkIsOriginalLanguage.ClientID %>')[0].checked && $("[id*=<%=chkDubbingSubtitling.ClientID %>] input:checked").length == 0) {
                var lsMovie = document.getElementById('<%=lsMovie.ClientID %>');
                AlertModalPopup(lsMovie, 'Please select atleast one Language Type.');
                return false;
            }

            if ((txtMonths.value.trim() == '' && txtYears.value.trim() == '')) {
                AlertModalPopup(txtMonths, "Please enter Month and Year");
                return false;
            }

            //if ($('#txtfrom').val() == 'DD/MM/YYYY' || $('#txtfrom').val() == '') {
            //    AlertModalPopup(lsMovie, 'Please select Available from date.');
            //    return false;
            //}

            //var txtfrom = $get('txtfrom');
            //var txtto = $get('txtto');

            //if ($(":radio[name=rblDateCriteria]")[1].checked == true && (txtto.value == '' || txtto.value == 'DD/MM/YYYY')) {
            //    AlertModalPopup(lsMovie, 'Please select Available to date.');
            //    return false;
            //}
            //var rightSD = new Date(MakeDateFormate(txtfrom.value));
            //var rightED = new Date(MakeDateFormate(txtto.value));
            //if (rightSD > rightED) {
            //    AlertModalPopup(lsMovie, 'Available From Date cannot be greater than Available To Date');
            //    return false;
            //}

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
            var groupcount = $("#<%=lbLanguage.ClientID %> option").filter(function () {
                return $(this).val().indexOf('G') > -1
            }).length;

            var languageCount = $("#<%=lbLanguage.ClientID %> option").filter(function () {
                return $(this).val().indexOf('L') > -1
            }).length;

            $("#<%=lbLanguage.ClientID %> option").filter(function () {
                return $(this).val().indexOf('G') > -1
            }).slice(0, groupcount).wrapAll('<optgroup label="Language Group"></optgroup>');

            $("#<%=lbLanguage.ClientID %> option").filter(function () {
                return $(this).val().indexOf('L') > -1
            }).slice(0, languageCount).wrapAll('<optgroup label="Language"></optgroup>');
        }

        function ValidateMandatoryField() {
            if (!checkblank(document.getElementById('<%=txtSearch.ClientID %>').value)) {
                AlertModalPopup(document.getElementById('<%=btnSearch_plt.ClientID %>'), 'Please enter Platform / Rights');
                return false;
            }
        }

        //$(document).ready(function () {
        //    $(":radio[name=rblDateCriteria]").change(function (e) {
        //        if ($(this).val() == 'FL')
        //            document.getElementById('tdAddYear').style.display = '';
        //        else
        //            document.getElementById('tdAddYear').style.display = 'none';
        //        document.getElementById('chkAddYear').checked = false;
        //    });

        //    $('#chkAddYear').change(function () {
        //        var txtto = $get('txtto');
        //        if ($(this).is(":checked")) {
        //            var txtfrom = $get('txtfrom');

        //            var rightSD = new Date(MakeDateFormate(txtfrom.value));
        //            var newDate = CalculateEndDate(rightSD, 1, 0);
        //            txtto.value = newDate;
        //        }
        //        else
        //            txtto.value = '';
        //    });
        //})

        function CalculateEndDate(startDate, year, month) {
            var yearToMonth = 12 * year;
            month = month + yearToMonth;
            startDate.setMonth(startDate.getMonth() + month);
            startDate.setDate(startDate.getDate() - 1);
            var newDateStr = ConvertDateToCurrentFormat(startDate);
            return newDateStr;
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

        function ChkPlatformType() {
            strPGcount=document.getElementById('<%=hdnPGCount.ClientID %>').value;
            document.getElementById('<%=hdnIsMustHave.ClientID %>').value = '';
            document.getElementById('<%=hdnPlatformMH.ClientID %>').value = '';
            document.getElementById('<%=lnkbtPltMustHv.ClientID %>').innerHTML = 'Must Have';
            if (strPGcount > 0) {
                if ($(":checkbox[id=<%=chkSpecficPlt.ClientID %>]")[0].checked == true) {
                    document.getElementById('<%=lnkbtnPltform.ClientID %>').style.display = 'none';
                    document.getElementById('<%=ddlPlatformGroup.ClientID %>').style.display = '';
                }
                else {
                    document.getElementById('<%=lnkbtnPltform.ClientID %>').style.display = '';
                    document.getElementById('<%=ddlPlatformGroup.ClientID %>').style.display = 'none';
                }
            }
            else {
                AlertModalPopup(document.getElementById('<%=btnSearch_plt.ClientID %>'), 'No Platform Group available');
                $(":checkbox[id=<%=chkSpecficPlt.ClientID %>]")[0].checked = false;
                return false;
            }
        }
        function ChkExactMatch() {
            document.getElementById('<%=hdnIsMustHave.ClientID %>').value = '';
            document.getElementById('<%=hdnPlatformMH.ClientID %>').value = '';
            document.getElementById('<%=lnkbtPltMustHv.ClientID %>').innerHTML = 'Must Have';
        }

        function ValidateMustHave() {
            debugger;
            if ($(":checkbox[id=<%=chkExact.ClientID %>]")[0].checked == true) {
                AlertModalPopup(document.getElementById('<%=btnSearch_plt.ClientID %>'), 'Please un-check Exact Match');
                return false;
            }

            if (document.getElementById('<%=hdnPlatform.ClientID %>').value == '' && $(":checkbox[id=<%=chkSpecficPlt.ClientID %>]")[0].checked == false) {
                AlertModalPopup(document.getElementById('<%=btnSearch_plt.ClientID %>'), 'Please select Platforms first');
                return false;
            }

            return true;
        }

        function DDLLanguageOnType() {
            if ($("[id*=<%=chkDubbingSubtitling.ClientID %>] input:checked").length == 0) {
                document.getElementById('<%=lbLanguage.ClientID %>').disabled = true;
            }
            else {
                document.getElementById('<%=lbLanguage.ClientID %>').disabled = false;
            }
        }
    </script>

    <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0"></asp:ScriptManager>
    <div class="top_area">
        <h2 class="pull-left">Title Availability 2</h2>
        <div class="right_nav pull-right">
            <ul>
		    <li>Business Unit</li>
		    <li>       
                    <asp:DropDownList ID="ddlBusinessUnit" runat="server" AutoPostBack="true" CssClass="select"
                        OnSelectedIndexChanged="ddlBusinessUnit_SelectedIndexChanged">
                    </asp:DropDownList>
                </li>
	        </ul>
	    </div>
    </div>
    <table align='center' border='0' cellpadding='0' cellspacing='0' width='98%'>
        <tr>
            <td>
                <asp:UpdatePanel ID="upGridView" runat="server" ChildrenAsTriggers="true">
                    <ContentTemplate>
                       
                        <div>
                            <table width='100%' border='0' cellpadding='0' cellspacing='0' align='center'>
                               
                                <tr runat="server">
                                    <td>
                                        <table width='100%' border='0' cellpadding='0' cellspacing='0' align='center' valign='top'>
                                            <tr>
                                                <td colspan="5">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td style="width: 32%; text-align: center; vertical-align: top">
                                                    <table class="mainReports" cellspacing='0'>
                                                        <tr style="height: 25px;">
                                                            <td style="text-align: center;" class="pagingborder"><b>TITLE</b></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center;" class="">
                                                                <asp:ListBox ID="lsMovie" class="ChosenTitle" runat="server" Width="95%" SelectionMode="Multiple"></asp:ListBox></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="width: 2%;">&nbsp;</td>
                                                <td style="width: 32%; text-align: center; vertical-align: top">
                                                    <table class="mainReports" cellspacing='0'>
                                                        <tr style="height: 25px;">
                                                            <td style="text-align: center;" class="pagingborder"><b>Region</b></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center;" class="">
                                                                <asp:ListBox ID="lstLTerritory" class="Chosenlb" runat="server" Width="95%" Height="25px" SelectionMode="Multiple"></asp:ListBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td style="width: 2%;">&nbsp;</td>
                                                <td style="width: 32%; vertical-align: top">
                                                    <table class="mainReports" cellspacing='0'>
                                                        <tr style="height: 25px;">
                                                            <td style="text-align: center;" class="pagingborder" colspan="2"><b>Period</b></td>
                                                        </tr>
                                                        <tr style="height: 10px;">
                                                            <td colspan="2"></td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 25px;">&nbsp;</td>
                                                            <td class="">Start within
                                                                <asp:TextBox runat="server" ID="txtMonths" Width="30px" CssClass="text"></asp:TextBox>&nbsp;&nbsp;Months                                                                
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="width: 25px;">&nbsp;</td>
                                                            <td class="">For next &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:TextBox runat="server" ID="txtYears" Width="30px" CssClass="text"></asp:TextBox>
                                                                &nbsp;Years (Minimum)
                                                            </td>
                                                        </tr>
                                                        <tr style="height: 10px;">
                                                            <td colspan="2"></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr style="height: 20px;">
                                                <td colspan="5">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td style="text-align: center; vertical-align: top">
                                                    <table class="mainReports" cellspacing='0'>
                                                        <tr style="height: 25px;">
                                                            <td style="text-align: center;" class="pagingborder"><b>Platform</b></td>
                                                        </tr>
                                                        <tr style="height: 10px;"><td></td></tr>
                                                        <tr>
                                                            <td>
                                                                <asp:CheckBox runat="server" ID="chkSpecficPlt" Text="Platform Group" onclick="ChkPlatformType()" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center;">
                                                                <asp:LinkButton ID="lnkbtnPltform" runat="server" OnClick="lnkbtnPltform_Click" CommandName="PD"
                                                                    Text="Select Platforms" Style="font-weight: bold; text-decoration: underline"></asp:LinkButton>
                                                                <asp:DropDownList runat="server" ID="ddlPlatformGroup" Style="display: none; width: 120px" 
                                                                    Onchange="ChkExactMatch()"></asp:DropDownList>
                                                                        
                                                                <asp:HiddenField ID="hdnIsMustHave" runat="server" />
                                                                <asp:HiddenField ID="hdnPlatformMH" runat="server" />
                                                                <asp:HiddenField ID="hdnPlatform" runat="server" />
                                                                <asp:HiddenField ID="hdnPGCount" runat="server" />
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td style="text-align: center;">
                                                                <table align="center">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:CheckBox ID="chkExact" Text="Exact Match Platforms" runat="server" onclick="ChkExactMatch()" />
                                                                        </td>
                                                                        <td id="tdStroke">&nbsp;&nbsp;|&nbsp;&nbsp;</td>
                                                                        <td>
                                                                            <asp:LinkButton ID="lnkbtPltMustHv" runat="server" OnClientClick="return ValidateMustHave();" OnClick="lnkbtPltMustHv_Click" CommandName="MH"
                                                                                Text="Must Have" Style="font-weight: bold; text-decoration: underline"></asp:LinkButton>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr style="height: 10px;">
                                                            <td></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td>&nbsp;</td>
                                                <td style="text-align: center; vertical-align: top">
                                                    <table class="mainReports" cellspacing='0'>
                                                        <tr style="height: 25px;">
                                                            <td style="text-align: center;" class="pagingborder" colspan="2"><b>Language
                                                            </b></td>
                                                        </tr>
                                                        <tr style="height: 25px;">
                                                            <td class="" style="text-align: right">
                                                                <asp:CheckBox ID="chkIsOriginalLanguage" Text="Title Language" runat="server" Checked="true" />
                                                                 &nbsp;&nbsp;&nbsp;
                                                            </td>
                                                            <td class="" style="text-align: left">
                                                                <asp:CheckBoxList ID="chkDubbingSubtitling" runat="server" RepeatDirection="Horizontal">
                                                                    <asp:ListItem Text="Subtitling" Value="S" />
                                                                    <asp:ListItem Text="Dubbing" Value="D" />
                                                                </asp:CheckBoxList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="" colspan="2">
                                                                <asp:ListBox ID="lbLanguage" class="Chosenlb" runat="server" Width="95%" Height="25px" SelectionMode="Multiple"></asp:ListBox>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                                <td>&nbsp;</td>
                                                <td style="text-align: center; vertical-align: top">
                                                    <table class="mainReports" cellspacing='0'>
                                                        <tr style="height: 25px;">
                                                            <td style="text-align: center;" class="pagingborder" colspan="2"><b>Additional </b></td>
                                                        </tr>
                                                        <tr style="height: 10px;">
                                                            <td colspan="2"></td>
                                                        </tr>
                                                        <tr style="display: none;">
                                                            <td><b>Group By</b></td>
                                                            <td class="">
                                                                <asp:RadioButtonList ID="rdbGroupBy" runat="server" RepeatDirection="Horizontal">
                                                                    <asp:ListItem Text="Language wise" Value="L" Selected="True" />
                                                                    <asp:ListItem Text="Country wise" Value="C" />
                                                                </asp:RadioButtonList>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td><b>Remarks</b></td>
                                                            <td class="" style="text-align: left">
                                                                <asp:CheckBox ID="chkShowRemarks" Text="Show Remarks" runat="server" />
                                                            </td>
                                                        </tr>
                                                        <tr style="height: 10px;">
                                                            <td colspan="2"></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="5">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td colspan="5" align="center">
                                                    <asp:Button ID="btnSearch" OnClick="btnSearch_Click" runat="server" Text="Search"
                                                        CssClass="button" ValidationGroup="S E A R C H" OnClientClick="return ValidateTitle();" Style="width: 100%; font-weight:900;" />
                                                    <asp:Button ID="btnback" Visible="false" runat="server" OnClick="btnback_Click"
                                                        CssClass="buttonReports" Text="Back" /></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <asp:UpdatePanel ID="UpPlatformPopup" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <div class='popup' id="PlatformPopup">
                                    <div class='content'>
                                        <img src="../images/fancy_close.png" alt='quit' class='X' id='Img1' onclick="ClosePopup()" />
                                        <div class="popupHeading" style="float: left;">
                                            <asp:Label runat="server" ID="lblHeadingPopUp" Text="Platform / Rights"></asp:Label>
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
                                            <asp:Button ID="btnSavePlatform" runat="server" Text="Select Platform" CssClass="button" Style="cursor: pointer;" OnClick="btnSavePlatform_Click" />
                                            <input type="button" value="Close" class="button" style="cursor: pointer;" onclick="ClosePopup()" />
                                        </div>
                                    </div>
                                </div>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="lnkbtnPltform" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="lnkbtPltMustHv" EventName="Click" />
                                <asp:AsyncPostBackTrigger ControlID="btnSearch_plt" EventName="Click" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </ContentTemplate>
                    <Triggers>
                        <asp:PostBackTrigger ControlID="btnSearch" />
                        <asp:AsyncPostBackTrigger ControlID="btnback" EventName="Click" />
                        <%--<asp:AsyncPostBackTrigger ControlID="btnSearch_plt" EventName="Click" />--%>
                    </Triggers>
                </asp:UpdatePanel>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
        </tr>
        <%-- <tr>
                <td class="normal">
                    <rsweb:ReportViewer ID="ReportViewer1" runat="server" ShowParameterPrompts="false"
                        BorderStyle="Solid" Visible="false" Style="width: 100%;">
                    </rsweb:ReportViewer>
                </td>
            </tr>--%>
        <tr>
            <td></td>
        </tr>
    </table>
    <div>
        <rsweb:ReportViewer ID="ReportViewer1" ShowParameterPrompts="false" runat="server"
            Width="100%" Visible="false" CssClass="reportViewer">
        </rsweb:ReportViewer>
    </div>
    <%--</form>
</body>
</html>--%>
    <%-- <table border="0" cellpadding="2" cellspacing="0" style="width: 100%" valign="top">
<tr>
    <td>
        <asp:RadioButtonList runat="server" ID="rblDateCriteria" onclick="ChkRadio()" RepeatDirection="Horizontal">
            <asp:ListItem Selected="True" Text="Flexi Date" Value="FL"></asp:ListItem>
            <asp:ListItem Text="Fixed Date" Value="FI"></asp:ListItem>
        </asp:RadioButtonList>
    </td>
    <td id="tdAddYear" runat="server">
        <asp:CheckBox ID="chkAddYear" Text="Add 1 Year" runat="server" />
    </td>
</tr>
<tr>
    <td align="center" style="width: 60%;">Available From : 
        <asp:TextBox ID="txtfrom" Width="77px" MaxLength="50" CssClass="text dateRange" runat="server" onkeypress="return false;" onkeydown="return false;"></asp:TextBox>
        <a href="#" onclick="clearDate('txtfrom');">clear</a>
        <asp:HiddenField ID="hdnDateWatermarkFormat" runat="server" />
    </td>
    <td>To :
        <asp:TextBox ID="txtto" Width="77px" MaxLength="50" CssClass="text dateRange" runat="server" onkeypress="return false;" onkeydown="return false;"></asp:TextBox>

        <a href="#" onclick="clearDate('txtto');">clear</a>
    </td>
</tr>
</table>--%>
</asp:Content>
