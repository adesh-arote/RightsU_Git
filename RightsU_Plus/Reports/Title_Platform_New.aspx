<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Title_Platform_New.aspx.cs" Inherits="RightsU_Plus.Reports.Title_Platform_New" MasterPageFile="~/Home.Master" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" 
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<%@ Register TagPrefix="UTO" Namespace="UTOFrameWork.FrameworkClasses" Assembly="RightsU_Plus" %>

<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">

    <link rel="stylesheet" type="text/css" href="../CSS/jquery-ui.css" />

    <script type="text/javascript" src="../JS_Core/jquery-1.11.1.min.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../JS_Core/jquery-ui.min.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../JS_Core/jquery.plugin.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../JS_Core/jquery.expander.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <link rel="stylesheet" type="text/css" href="../CSS/chosen.min.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
    <script type="text/javascript" src="../JS_Core/chosen.jquery.min.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <%--New Date Pick--%>
    <link rel="stylesheet" type="text/css" href="../CSS/jquery.datepick.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
    <link rel="stylesheet" type="text/css" href="../CSS/ui-start.datepick.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
    <script type="text/javascript" src="../JS_Core/jquery.datepick.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../JS_Core/jquery.datepick.ext.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <%--New Date Pick--%>

    <script type="text/javascript" src="../JS_Core/autoNumeric-1.8.1.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <style type="text/css">
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

        a#lbSelectTitles img {
            height: 22px;
            position: relative;
            top: 5px;
            background-color: #fff;
            left: 11px;
        }

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
            width: 100%;
            margin: auto;
            top: 10%;
            display: none;
            position: absolute;
        }

        #TitlePopup {
            z-index: 8001;
        }

        #divNamesPopup {
            z-index: 8001;
        }

        .content {
            width: 650px;
            height: 420px;
            margin: auto;
            background: #f3f3f3;
            position: relative;
            z-index: 103;
            padding: 10px;
            padding-left: 40px;
            border-radius: 5px;
            box-shadow: 5px 5px 5px #888888;
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

        #divTitle {
            width: 96%;
            height: 305px;
            float: left;
            overflow: auto;
        }

        #divButtonPanel {
            width: 95%;
            float: left;
            padding-top: 10px;
        }

        .chosen-container .chosen-results li.active-result {
            color: black;
            text-align: left;
        }

        .chosen-container .chosen-results li.no-results {
            color: black;
        }

        .chosen-container .chosen-results li.group-result {
            color: black;
            background-color: gainsboro;
        }

        .chosen-container-multi .chosen-choices li.search-field {
            height: 27px !Important;
        }

        /*#ReportViewer1 > iframe {
            height: 91% !important;
        }

        @media screen and (-webkit-min-device-pixel-ratio:0) {
            iframe#ReportFrameReportViewer1 {
                height: 78% !important;
            }
        }*/

        div#oReportDiv {
            overflow: initial !Important;
        }

        #tblMin {
            margin-left: 12%;
        }

        .pagingborder {
            font-family: Corbel;
            font-size: 14px;
            color: #FFFFFF;
            border: 0 !important;
        }

        table.mainReports {
            background-color: #ffffff;
            height: 140px;
            padding: 0;
            margin: 0;
            width: 100%;
        }

        /*#ReportViewer1 > iframe {
            height: 91% !important;
        }

        iframe#ReportFrameReportViewer1 {
            height: 78% !important;
        }*/

        div#oReportDiv {
            overflow: initial !Important;
        }

        .ui-accordion-content > table {
            width: 100%;
            border-spacing: 1px;
            border: 0;
            background-color: #fff;
        }

            .ui-accordion-content > table > tbody > tr > td {
                border: 1px solid #aaa;
            }

        .ui-accordion .ui-accordion-content {
            padding: 0;
            overflow: visible;
        }

        .ui-tooltip {
            position: absolute;
            top: 50px !important;
            left: 500px !important;
            font-size: 12px;
            max-height: 650px;
            overflow-y: auto;
        }

        .tabCountry, .tabTerritory {
            display: inline-block;
            width: 48%;
            height: 25px;
            float: left;
            font-family: inherit;
            font-weight: 700;
            color: #fff;
            padding: 5px 3px 0 3px;
            margin: 0;
            border: 0;
            box-shadow: none;
        }

        .tabCountry {
            background-color: #FFF;
            color: #898989;
        }

        .tabTerritory {
            cursor: pointer;
        }

        #lstRegion_chosen > ul, #lstWithoutExcludedRegion_chosen > ul, #lbSubtitling_chosen > ul,
        #lbLanguage_chosen > ul, #lstLTerritory_chosen > ul {
            min-height: 83px;
        }
    </style>

    <script>
        $(document).ready(function () {
            AssignChosenJQuery();
            InitializeCollapsiblePanels();
        });

        function InitializeCollapsiblePanels() {
            var headers = $('#accordion .accordion-header');
            var contentAreas = $('#accordion .ui-accordion-content').not('#divGeneral').hide();
            headers.click(function () {
                var panel = $(this).next();
                var isOpen = panel.is(':visible');
                panel[isOpen ? 'slideUp' : 'slideDown']().trigger(isOpen ? 'hide' : 'show');
                return false;
            });
        }

        function AssignChosenJQuery() {
            var maxSelectedOption = <%= this.MaxSelectedOption %>
            $('.Chosenlb').chosen({
                width: "95%",
                placeholder_text_multiple: "-- Please Select --",
                placeholder_text_single: "-- Please Select --"
            });
            $('.ChosenTitle').chosen();
            $("#lstRegion").chosen();
        }

        function triggerChoosen() {
            $(".Chosenlb").trigger("chosen:updated");
            $('.ChosenTitle').trigger("chosen:updated");
        }
    </script>

    <div class="title_block dotted_border clearfix">
        <h2 class="pull-left">Platformwise Report</h2>
        <div style="float: right; width: 35%">
            <div style="float: left">
                <asp:DropDownList ID="ddlReportFor" runat="server" AutoPostBack="true" CssClass="select"
                    OnSelectedIndexChanged="ddlReportFor_SelectedIndexChanged">
                    <asp:ListItem Text="Acquisition Deal" Value="A" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Syndication Deal" Value="S"></asp:ListItem>
                </asp:DropDownList>
            </div>
            <div style="float: right">
                Business Unit
            <asp:DropDownList ID="ddlBusinessUnit" runat="server" AutoPostBack="true" CssClass="select"
                OnSelectedIndexChanged="ddlBusinessUnit_SelectedIndexChanged">
            </asp:DropDownList>
                <asp:HiddenField ID="hdnIsCriteriaChange" runat="server" />
            </div>
        </div>
    </div>

    <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0">
    </asp:ScriptManager>

    <div id="divTab">
        <asp:ImageButton runat="server" ID="imgCriteriaOn" ImageUrl="~/images/Criteria.jpg" OnClientClick="return false" ImageAlign="AbsBottom" />
        <asp:ImageButton runat="server" ID="imgCriteria" ImageUrl="~/images/r_Criteria.jpg" Visible="false" ImageAlign="AbsBottom" OnClick="imgCriteria_Click" />
        <asp:ImageButton runat="server" ID="imgResultsOn" ImageUrl="~/images/Results.jpg" Visible="false" OnClientClick="return false" ImageAlign="AbsBottom" />
        <asp:ImageButton runat="server" ID="imgResults" ImageUrl="~/images/r_Results.jpg" Visible="true" ImageAlign="AbsBottom" OnClientClick="return ValidateTitle();" OnClick="imgResults_Click" />
    </div>

    <div id="accordion" class="ui-accordion ui-widget ui-helper-reset">
        <h3 class="accordion-header ui-accordion-header ui-helper-reset ui-state-default ui-accordion-icons ui-corner-all">
            <span class="ui-accordion-header-icon ui-icon ui-icon-triangle-1-e"></span>
            GENERAL
        </h3>
        <div class="ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom" id="divGeneral">
            <table>
                <tr style="height: 25px;">
                    <td class="pagingborder" style="text-align: center; width: 33%"><b>Title&nbsp;<span id="spTitleCount">(0)</span></b></td>
                    <td class="pagingborder" style="text-align: center; width: 34%"><b>Period</b></td>
                    <td class="pagingborder" style="text-align: center; width: 34%"><b>Additional</b></td>
                </tr>
                <tr>
                    <td style="text-align: center; width: 33%;">
                        <asp:UpdatePanel runat="server" ID="upTitle" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:LinkButton ID="lbSelectTitles" runat="server" OnClientClick="SetHiddenTitleCode();" CommandName="PD"
                                    OnClick="lbSelectTitles_Click" Style="font-weight: bold; text-decoration: underline">
                                                    Search Titles &nbsp;<img src="../images/icon-search.png" />
                                </asp:LinkButton>
                                <asp:HiddenField runat="server" ID="hdnTitleCodes" />
                                <br />
                                <br />
                                <asp:ListBox ID="lsMovie" runat="server" class="ChosenTitle" onClick="TitleChange();" Width="95%"></asp:ListBox>
                                <br />
                                <br />
                                Episode From
                                <asp:TextBox ID="txtEFrom" runat="server" CssClass="text numeric" Width="37px"></asp:TextBox>
                                To
                        <asp:TextBox ID="txtETo" runat="server" CssClass="text numeric" Width="37px"></asp:TextBox>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                    <td style="width: 33%;">
                        <asp:RadioButtonList ID="rblPeriodType" runat="server" RepeatDirection="Horizontal"
                            onClick="SelectPeriodType(this);">
                            <asp:ListItem Selected="True" Text="Minimum" Value="MI"></asp:ListItem>
                            <asp:ListItem Text="Flexi" Value="FL"></asp:ListItem>
                            <asp:ListItem Text="Fixed" Value="FI"></asp:ListItem>
                        </asp:RadioButtonList>
                        <br />
                        <table align="left" cellspacing="0" cellpadding="3" class="" id="tblMin" runat="server">
                            <tr>
                                <td>&nbsp;</td>
                                <td>DD</td>
                                <td>MM</td>
                                <td>YY</td>
                                <td>&nbsp;</td>
                                <td style="text-align: center;">Date</td>
                            </tr>
                            <tr>
                                <td class="">Start within
                                </td>
                                <td>
                                    <asp:TextBox ID="txtDaysWithin" runat="server" CssClass="text" Width="20px" onblur="CalculateDate();"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtMonths" runat="server" CssClass="text" Width="20px" onblur="CalculateDate();"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtYearWithin" runat="server" CssClass="text" Width="20px" onblur="CalculateDate();"></asp:TextBox>
                                </td>
                                <td>&nbsp;&nbsp;&nbsp;Start</td>
                                <td>
                                    <asp:TextBox ID="spStartDate" Width="77px" MaxLength="50" CssClass="text dateRange"
                                        runat="server" onkeypress="return false;" onkeydown="return false;"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td class="">For next
                                </td>
                                <td>
                                    <asp:TextBox ID="txtNextDays" runat="server" CssClass="text" Width="20px" onblur="CalculateDate();"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtNextmonth" runat="server" CssClass="text" Width="20px" onblur="CalculateDate();"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtYears" runat="server" CssClass="text" Width="20px" onblur="CalculateDate();"></asp:TextBox>
                                </td>
                                <td>&nbsp;&nbsp;&nbsp;End</td>
                                <td>
                                    <asp:TextBox ID="spEndDate" Width="77px" MaxLength="50" CssClass="text dateRange" runat="server"
                                        onkeypress="return false;" onkeydown="return false;"></asp:TextBox>
                                </td>
                            </tr>
                        </table>
                        <table cellspacing="0" cellpadding="3" id="tblFix" runat="server" style="display: none;">
                            <tr>
                                <td style="width: 25px;">&nbsp;</td>
                                <td align="left" style="width: 25px;">Available </td>
                                <td>From :</td>
                                <td>
                                    <asp:TextBox ID="txtfrom" AutoPostBack="true" Width="77px" MaxLength="50" CssClass="text dateRange" runat="server"
                                        onkeypress="return false;" onkeydown="return false;"></asp:TextBox>
                                    <a href="#" onclick="clearDate('txtfrom');">clear</a>
                                    <asp:HiddenField ID="hdnDateWatermarkFormat" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 25px;">&nbsp;</td>
                                <td style="width: 25px;">&nbsp;</td>
                                <td>To :</td>
                                <td>
                                    <asp:TextBox ID="txtto" AutoPostBack="true" Width="77px" MaxLength="50" CssClass="text dateRange"
                                        runat="server" onkeypress="return false;" onkeydown="return false;"></asp:TextBox>
                                    <a href="#" onclick="clearDate('txtto');">clear</a>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td width: 33%;">
                        <table class="mainReports">
                            <tr>
                                <td style="width: 35%;">
                                    <asp:CheckBox ID="chkIsOriginalLanguage" runat="server" Checked="true" Text="Title Language" />
                                </td>
                                <td class="" style="text-align: left">
                                    <asp:ListBox ID="lbTitleLang" runat="server" class="ChosenTitle" Width="100%"></asp:ListBox>
                                </td>
                            </tr>
                            <tr>
                                <td><b>Exclusivity</b></td>
                                <td class="" style="text-align: left">
                                    <asp:DropDownList ID="ddlExclusive" runat="server">
                                        <asp:ListItem Selected="True" Text="Both" Value="B"></asp:ListItem>
                                        <asp:ListItem Text="Exclusive" Value="E"></asp:ListItem>
                                        <asp:ListItem Text="Non Exclusive" Value="N"></asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td><b>Sub Licensing</b></td>
                                <td class="" style="text-align: left">
                                    <asp:ListBox ID="lbSubLicense" runat="server" class="ChosenTitle" Width="100%"></asp:ListBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <b>
                                        <asp:CheckBox ID="chkShowRemarks" runat="server" Text="Show Remarks" Visible="false" />
                                        <asp:CheckBox ID="chkRestRemarks" runat="server" Text="Restriction Remarks" />
                                        <asp:CheckBox ID="chkOtherRemarks" runat="server" Text="Other Remarks" />
                                    </b>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <b>
                                        <asp:CheckBox ID="chkIncludeSubDeal" runat="server" Text="Include Sub Deals" />
                                    </b>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>

        <h3 class="accordion-header ui-accordion-header ui-helper-reset ui-state-default ui-accordion-icons ui-corner-all">
            <span class="ui-accordion-header-icon ui-icon ui-icon-triangle-1-e"></span>
            REGION
        </h3>
        <div class="ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom">
            <table>
                <tr style="height: 25px;">
                    <td class="pagingborder" style="text-align: center;">
                        <b>
                            <span onclick="RegionTabSelect('T')" id="tabTerr">Territory</span>
                            <span id="tabCountry" onclick="RegionTabSelect('C')">Country&nbsp;<span id="spCountryCount"></span></span>
                            <asp:HiddenField ID="hdnRegionType" Value="T" runat="server" />
                        </b>
                    </td>
                    <td class="pagingborder" style="text-align: center;">
                        <b>Exclusion &nbsp;<span id="spExclusionCountryCount">(0)</span></b>
                    </td>
                    <td class="pagingborder" style="text-align: center;">
                        <b>
                            <asp:CheckBoxList ID="chkRegion" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                <asp:ListItem Text="Exact Match" Value="EM" onclick="MutExChkList(this);"></asp:ListItem>
                                <asp:ListItem Text="Must Have" Value="MH" onclick="MutExChkList(this);"></asp:ListItem>
                            </asp:CheckBoxList>
                            &nbsp;<span id="spMustExactHaveCountryCount">(0)</span>
                        </b>
                    </td>
                </tr>
                <tr>
                    <td class="" style="text-align: center; width: 33%;">
                        <table width="90%" align="center" cellpadding="0" cellspacing="0" class="mainReports" id="tbTerritory" style="height: 100px">
                            <tr>
                                <td>
                                    <asp:DropDownList ID="ddlTerritory" runat="server" class="Chosenlb"
                                        Height="25px" Width="95%">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div id="divCountries" runat="server" style="height: 40px; overflow-x: auto; display: none;">
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table id="tbCountry" width="90%" align="center" cellpadding="0" cellspacing="0"
                            class="mainReports" style="display: none; height: 100px;">
                            <tr>
                                <td>
                                    <asp:ListBox ID="lstLTerritory" runat="server" class="Chosenlb"
                                        Height="25px" Width="95%"></asp:ListBox>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td class="" style="text-align: center; width: 34%;">
                        <asp:ListBox ID="lstRegion" runat="server" class="Chosenlb" Height="140px" Width="95%"></asp:ListBox>
                    </td>
                    <td class="" style="text-align: center; width: 33%;">
                        <asp:ListBox ID="lstWithoutExcludedRegion" runat="server" class="Chosenlb" Height="140px" Width="95%"></asp:ListBox>
                    </td>
                    <asp:HiddenField runat="server" ID="hdnRegionCodes" Value="" />
                    <asp:HiddenField runat="server" ID="hdnExclusionRegionCode" Value="" />
                    <asp:HiddenField runat="server" ID="hdnMustHaveRegionCode" Value="" />
                </tr>
            </table>
        </div>
        <h3 class="accordion-header ui-accordion-header ui-helper-reset ui-state-default ui-accordion-icons ui-corner-all">
            <span class="ui-accordion-header-icon ui-icon ui-icon-triangle-1-e"></span>
            PLATFORM
        </h3>
        <div class="ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom">
            <table style="display:none">
                <tr style="height: 25px;">
                    <td class="pagingborder" style="text-align: center; width: 50%" colspan="2">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <b>
                                    <asp:Button ID="btnPlatformTab" Text="Platform" OnClick="btnPlatformTab_Click" runat="server" />
                                    <asp:Button ID="btnPlatformGroupTab" Text="Platform Group" OnClick="btnPlatformGroupTab_Click" runat="server" />
                                </b>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                    <td class="pagingborder" style="text-align: center; width: 50%" colspan="2">
                        <asp:UpdatePanel ID="upExact" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <b>
                                    <asp:CheckBoxList ID="chkExact" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow"
                                        OnSelectedIndexChanged="chkExact_SelectedIndexChanged" AutoPostBack="true">
                                        <asp:ListItem Text="Exact Match" Value="EM" onclick="MutExChkList(this);"></asp:ListItem>
                                        <asp:ListItem Text="Must Have" Value="MH" onclick="MutExChkList(this);"></asp:ListItem>
                                    </asp:CheckBoxList>
                                </b>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center; width: 50%; height: 250px">
                        <asp:UpdatePanel ID="upMainPlatform" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <div id="divPlatformFilter" runat="server">
                                    <asp:TextBox ID="txtPlatformSearch" runat="server" MaxLength="100"></asp:TextBox>
                                    <asp:Button ID="btnSearchPlatform" runat="server" CssClass="button" Text="Search"
                                        OnClientClick="return ValidateMandatoryField1();" OnClick="btnSearchPlatform_Click" />
                                    <asp:Button ID="btnShowAllPlatform" runat="server" CssClass="button" Text="Show All"
                                        OnClick="btnShowAllPlatform_Click" />
                                </div>
                                <div id="divPlatformGroup" style="display: none;" runat="server">
                                    <asp:DropDownList ID="ddlPlatformGroup" runat="server" class="Chosenlb" AutoPostBack="true"
                                        OnSelectedIndexChanged="ddlPlatformGroup_SelectedIndexChanged" />
                                </div>
                                <table width="90%" align="center" cellpadding="0" cellspacing="0" class="mainReports">
                                    <tr>
                                        <td>
                                            <div style="width: 98%; overflow-y: auto; height: 250px" id="divMainPlatform">
                                                <ucPTV:ucTab ID="uctabPTV" runat="server" />
                                                <asp:HiddenField ID="hdnIsMustHave" runat="server" />
                                                <asp:HiddenField ID="hdnPlatformMH" runat="server" />
                                                <asp:HiddenField ID="hdnPlatform" runat="server" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                    <td valign="top" colspan="2" style="text-align: center; width: 50%;">
                        <asp:UpdatePanel ID="upSelectedPlatform" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <div>
                                    <asp:TextBox ID="txtSelectedPlatformSearch" runat="server" MaxLength="100"></asp:TextBox>
                                    <asp:Button ID="btnSearchPlatform_Selected" runat="server" CssClass="button" Text="Search"
                                        OnClientClick="return ValidateMandatoryField2();" OnClick="btnSearchPlatform_Selected_Click" />
                                    <asp:Button ID="btnShowAllPlatform_Selected" runat="server" CssClass="button" Text="Show All"
                                        OnClick="btnShowAllPlatform_Selected_Click" />
                                </div>
                                <table width="90%" align="center" cellpadding="0" cellspacing="0" class="mainReports">
                                    <tr>
                                        <td>
                                            <div style="width: 98%; overflow-y: auto; height: 250px">
                                                <ucPTV:ucTab ID="uctabSelectedplt" runat="server" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="chkExact" EventName="SelectedIndexChanged" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </td>
                </tr>
            </table>
        </div>
        <h3 class="accordion-header ui-accordion-header ui-helper-reset ui-state-default ui-accordion-icons ui-corner-all">
            <span class="ui-accordion-header-icon ui-icon ui-icon-triangle-1-e"></span>
            LANGUAGE
        </h3>
        <div class="ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom">
            <table style="display:none">
                <tr style="height: 25px;">
                    <td class="pagingborder" style="text-align: center; width: 50%" colspan="2">
                        <span id="tabLanguageGropuID1" onclick="LanguageTabSelect('G')" style="display: none;">Language Group</span>
                        <span id="tabLanguageID1"><b>Subtitling Language <span id="spLanguageCount">(0)</span></b></span>
                        <asp:HiddenField ID="hdnLanguageType" Value="L" runat="server" />
                    </td>
                    <td class="pagingborder" style="text-align: center; width: 50%;" colspan="2">
                        <b>Dubbing Language <span id="spLanguageResult">(0)</span></b>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center; width: 50%;" colspan="2">
                        <table width="90%" align="center" cellpadding="0" cellspacing="0" class="mainReports">
                            <tr id="tblLanguageGroup" style="display: none;">
                                <td>
                                    <asp:DropDownList ID="ddlLanguageGroup" runat="server" class="Chosenlb"
                                        Height="25px" Width="95%">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr id="tblLanguage">
                                <td>
                                    <asp:ListBox ID="lbSubtitling" runat="server" class="Chosenlb" Height="25px" Width="95%"></asp:ListBox>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td style="text-align: center; width: 50%;" colspan="2">
                        <table width="90%" align="center" cellpadding="0" cellspacing="0" class="mainReports">
                            <tr>
                                <td>
                                    <asp:ListBox ID="lbDubbing" runat="server" class="Chosenlb"
                                        Height="140px" Width="95%"></asp:ListBox>
                                    <asp:HiddenField ID="hdnLanguageCodeExactMust" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>
                                        <asp:CheckBox ID="chkSameLanguage" runat="server" Checked="true"
                                            Text="Select same language for dubbing" />
                                    </b>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <div id="divResult">
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" BorderStyle="Solid" ShowParameterPrompts="false"
            Style="width: 100%;" Visible="false">
        </rsweb:ReportViewer>
    </div>

    <!-- Abhay
                <asp:UpdatePanel ID="UpTitlePopup" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class='popup' id="TitlePopup">
                            <div class='content'>
                                <img src="../images/fancy_close.png" alt='quit' class='X' id='Img1' onclick="ClosePopup()" />
                                <div>
                                    <asp:TextBox ID="txtSearch" runat="server" Width="340px" MaxLength="100" placeholder="Search by Title,Talent,Star Cast,Genre,Director"></asp:TextBox>
                                    <asp:Button ID="btnSearch_tit" runat="server" CssClass="button" Text="Search" OnClientClick="return ValidateMandatoryField();" OnClick="btnSearch_tit_Click" />
                                </div>
                                <div class="paging_ErrorPopup">
                                    <div id="divTotalRecord_ErrorPopup">
                                        Total record(s) found :
                                                <asp:Label ID="lblTotal_ErrorPopup" runat="server"></asp:Label>
                                    </div>
                                    <div id="divPaging_ErrorPopup">
                                        <asp:DataList ID="dtLst_ErrorPopup" runat="server" RepeatDirection="Horizontal"
                                            OnItemCommand="dtLst_ErrorPopup_ItemCommand" OnItemDataBound="dtLst_ErrorPopup_ItemDataBound">
                                            <ItemTemplate>
                                                <asp:Button ID="btnPager" CssClass="pagingbtn" runat="server"
                                                    Text='<%# ((UTOFrameWork.FrameworkClasses.AttribValue)Container.DataItem).Attrib %>'
                                                    CommandArgument='<%#  ((UTOFrameWork.FrameworkClasses.AttribValue)Container.DataItem).Val %>' />
                                            </ItemTemplate>
                                        </asp:DataList>
                                    </div>
                                </div>
                                <div id="divTitle">
                                    <asp:GridView ID='gvTitle' runat='server' CssClass='main' AllowSorting='True' HeaderStyle-CssClass='tableHd'
                                        CellPadding="3" AlternatingRowStyle-CssClass='rowBg' Width='100%' AutoGenerateColumns='False'
                                        DataKeyNames="IntCode" OnRowDataBound="gvTitle_RowDataBound">
                                        <Columns>
                                            <asp:TemplateField HeaderText="Select">
                                                <HeaderTemplate>
                                                    <asp:CheckBox runat="server" ID="chkSelectAll" onclick="SelectAllTitles()" />
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:CheckBox runat="server" ID="chkSelect" onclick="SelectTitles()" />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" CssClass="border" Width="5%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Title Name">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblIntCode" Text='<%#Eval("IntCode") %>' runat="server" Style="display: none"></asp:Label>
                                                    <asp:Label ID="lblTitle_Name" Text='<%#Eval("TitleName") %>' runat="server"></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" CssClass="border" Width="30%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Year of Release">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblRelease" Text='<%#Eval("yearOfProduction") %>' runat="server"></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" CssClass="border" Width="10%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Genres">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblGenere" runat="server" Text='<%# (Convert.ToString(Eval("Genere")).Length >=22 ? ((Convert.ToString(Eval("Genere"))).Substring(0,22)+ " ...") : Eval("Genere"))%>'
                                                        CssClass='<%#(Convert.ToString(Eval("Genere")).Length >=22 ? "checkbox":"")%>'
                                                        ToolTip='<%# (Convert.ToString(Eval("Genere")).Length >=22 ? Eval("Genere"): "") %>'></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" CssClass="border" Width="25%" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Talent">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblKeyStar" runat="server" Text='<%# (Convert.ToString(Eval("keyStarCast")).Length >=25 ? ((Convert.ToString(Eval("keyStarCast"))).Substring(0,25)+ " ...") : Eval("keyStarCast"))%>'
                                                        CssClass='<%#(Convert.ToString(Eval("keyStarCast")).Length >=25 ? "checkbox":"")%>'
                                                        ToolTip='<%# (Convert.ToString(Eval("keyStarCast")).Length >=25 ? Eval("keyStarCast"): "") %>'></asp:Label>
                                                    <asp:Label ID="lblKeyStar1" runat="server" Text='<%#Convert.ToString(Eval("keyStarCast"))%>'
                                                        Visible="false"></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" VerticalAlign="Top" CssClass="border" Width="30%" />
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                                <div id="divButtonPanel">
                                    <asp:Button ID="btnSaveTitle" runat="server" Text="Select Titles" CssClass="button"
                                        Style="cursor: pointer;" OnClick="btnSaveTitle_Click" />
                                    <input type="button" value="Close" class="button" style="cursor: pointer;" onclick="ClosePopup()" />
                                </div>
                            </div>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="lbSelectTitles" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="btnSearch_tit" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="rblPeriodType" EventName="SelectedIndexChanged" />
                    </Triggers>
                </asp:UpdatePanel>
                <asp:Panel ID="Panel1" runat="server" Width="150px" Style="max-height: 300px; display: none;" ScrollBars="Vertical"
                    BackColor="White" BorderColor="Black" BorderWidth="1px" BorderStyle="Solid">
                    <div id="divNames" style="margin-top: 15px;">
                    </div>
                    <asp:HiddenField ID="hdnNames" runat="server" />
                </asp:Panel>
                <AjaxToolkit:PopupControlExtender ID="PopupControlExtender1" runat="server" PopupControlID="Panel1"
                    Position="Right" TargetControlID="divCountries">
                </AjaxToolkit:PopupControlExtender>
                -->


    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequest);
        function endRequest(sender, args) {
            initlyExpander();
            CallOnLoad();
        }
    </script>
</asp:Content>

