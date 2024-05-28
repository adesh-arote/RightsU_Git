<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Title_Avail_Language.aspx.cs" Inherits="RightsU_WebApp.Reports.Title_Avail_Language" MasterPageFile="~/Home.Master" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" 
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<%@ Register TagPrefix="UTO" Namespace="UTOFrameWork.FrameworkClasses" Assembly="RightsU_Plus" %>

<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">

    <link href="../CSS/common.css" rel="stylesheet" />
    <script src="../Master/JS/Master.js"></script>
    <script src="../Master/JS/common.js"></script>
    <script src="../Master/JS/AjaxControlToolkit.js"></script>
    <script src="../Master/JS/AjaxUpdater.js"></script>
    <script src="../Master/JS/multiSelection.js"></script>
    <script src="../Master/JS/multiple_listbox.js"></script>
    <link rel="Stylesheet" href="../Master/stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
    <link href="../CSS/jquery-ui.css" rel="stylesheet" />

    <script type="text/javascript" src="../JS_Core/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery-ui.min.js"></script>

    <script type="text/javascript" src="../JS_Core/common.concat.js"></script>

    <link href="../CSS/chosen.min.css" rel="stylesheet" />
    <script type="text/javascript" src="../JS_Core/chosen.jquery.min.js"></script>

    <script type="text/javascript" src="../JS_Core/jquery.expander.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.plugin.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.watermarkinput.js"></script>
    <script type="text/javascript" src="../JS_Core/watermark.js"></script>
    <link href="../CSS/Master_ASPX.css" rel="stylesheet" />
    <%--New Date Pick--%>
    <link rel="stylesheet" href="../CSS/jquery.datepick.css" />
    <link href="../CSS/jquery-ui.css" rel="stylesheet" />
    <link rel="stylesheet" href="../CSS/ui-start.datepick.css" />
    <script type="text/javascript" src="../JS_Core/jquery.datepick.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.datepick.ext.js"></script>
    <%--New Date Pick--%>

    <style type="text/css">
        /*Datepick css start*/
        select, textarea
        {
            font-family: Arial,Helvetica,Sans-serif;
            font-size: 100%;
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
            color: #000000 !important;
        }

        .chosen-container .chosen-results li.no-results
        {
            color: #000000 !important;
        }

        .chosen-container .chosen-results li.highlighted
        {
            color: #ffffff !important;
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
            width: 85%;
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
            width: 650px;
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
            width: 34%;
            min-width: 31%;
            height: 3%;
            color: #686868;
            font-size: 18px;
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

        #CphdBody_uctabPTV_trView table
        {
            width: 0 !important;
        }

        .popuptbl
        {
            width: 0 !important;
            padding: 1%;
            /* display: block; */
        }
    </style>
    <%-- CSS for Reportviewer based on Browser START --%>
    <style type="text/css">
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
            height: 600px !Important;
            width: 100%;
        }

            .reportViewer table
            {
                width: initial;
            }
    </style>

    <script type="text/javascript">

        var dateWatermarkFormat = "DD/MM/YYYY";
        var dateWatermarkColor = '#999';
        var dateNormalkColor = '#000';
        /*Start Code for Popup*/
        var overlay = $('<div id="overlay" class="overlay_common"></div>');
        function ClosePopup() {
            debugger
            $('#PlatformPopup').hide();
            overlay.appendTo(document.body).remove();

            return false;
        }
        function OpenPopup() {
            debugger
            overlay.show();
            overlay.appendTo(document.body);
            $('#PlatformPopup').show("fast");
            return false;
        }

        //Start choosen
        $(document).ready(function () {
            AssignChosenJQuery();

            //AssignDateJQuery();
        });

        function AssignDateJQuery() {
            debugger
            var dateWatermarkFormat = $('#<%=hdnDateWatermarkFormat.ClientID %>').val();
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

            $('.dateRange').datepick({
                onSelect: customRange, dateFormat: 'dd/mm/yyyy', pickerClass: 'demo',
                autoSize: true,
                renderer: $.datepick.themeRollerRenderer
            });
            function customRange(dates) {
                debugger
                if (this.id == '<%=txtfrom.ClientID %>') {
                    if ($('#<%=txtfrom.ClientID %>').val() != 'DD/MM/YYYY' && $('#<%=txtfrom.ClientID %>').val() != '') {
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
            $('#<%= txtfrom.ClientID %>').datepick('option', 'minDate', $.datepick.today());
            $('#<%= txtto.ClientID %>').datepick('option', 'minDate', $.datepick.today());
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
            debugger
            var maxSelectedOption = <%= this.MaxSelectedOption %>
        $('.Chosenlb').chosen('Select Title');
            //  $('.ChosenTitle').chosen('Select Title');
            $('.ChosenTitle').chosen({ max_selected_options: maxSelectedOption });
        }

        function triggerChoosen() {
            debugger
            $(".Chosenlb").trigger("chosen:updated");
            $('.ChosenTitle').trigger("chosen:updated");
        }

        function Assign_Css() {
            $("#<%=ReportViewer1.ClientID %> table").each(function (i, item) {
                $(item).css('display', 'inline-block');
            });
            $("#<%=ReportViewer1.ClientID %> table.aspNetDisabled").each(function (i, item) {
                $(item).css('display', 'none');
            });
        }

        function ValidateTitle() {
            debugger
            var lsMovie = document.getElementById("<%=lsMovie.ClientID %>");
            if ($('#<%=lsMovie.ClientID %>.ChosenTitle')[0].value == '') {
                AlertModalPopup(lsMovie, 'Please select atleast one title.');
                return false;
            }

            if (!$('#<%=chkIsOriginalLanguage.ClientID %>')[0].checked && $("[id*=<%=chkDubbingSubtitling.ClientID %>] input:checked").length == 0) {
                AlertModalPopup(lsMovie, 'Please select atleast one language type.');
                return false;
            }

            if ($('#<%=txtfrom.ClientID %>').val() == 'DD/MM/YYYY' || $('#<%=txtfrom.ClientID %>').val() == '') {
                AlertModalPopup(lsMovie, 'Please select Available from date.');
                return false;
            }
            return true;
        }

        function sliceOption() {
            debugger
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
            triggerChoosen();
        }
        $(document).ready(function () {
            if ($('#<%=rblDateCriteria.ClientID %> input:checked').val() == 'FL')
                document.getElementById('tdAddYear').style.display = '';
            else {
                document.getElementById('tdAddYear').style.display = 'none';
                document.getElementById('<%=chkAddYear.ClientID %>').checked = false;
            }

            $('#<%=rblDateCriteria.ClientID %>').change(function () {
                //debugger
                if ($('#<%=rblDateCriteria.ClientID %> input:checked').val() == 'FL')
                    document.getElementById('tdAddYear').style.display = '';
                else
                    document.getElementById('tdAddYear').style.display = 'none';
                document.getElementById('<%=chkAddYear.ClientID %>').checked = false;
            });

            $('#<%=chkAddYear.ClientID %>').change(function () {
                // debugger
                var txtto = $get('<%=txtto.ClientID %>');
                if ($(this).is(":checked")) {
                    var txtfrom = $get('<%=txtfrom.ClientID %>');

                     var rightSD = new Date(MakeDateFormate(txtfrom.value));
                     var newDate = CalculateEndDate(rightSD, 1, 0);
                     txtto.value = newDate;
                 }
                 else
                     txtto.value = '';
            });

            Assign_Css();
            InitializeDate();
        });

         function sliceLanguageOption() {
             debugger
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
            triggerChoosen();
        }
        function ValidateMandatoryField() {
            if (!checkblank(document.getElementById('<%=txtSearch.ClientID %>').value)) {
                AlertModalPopup(document.getElementById('<%=btnSearch_plt.ClientID %>'), 'Please enter Platform / Rights');
                return false;
            }
            // return true;
        }

        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(CheckBeforeSave);

        function CheckBeforeSave() {
            InitializeDate();

            if ($('#<%=rblDateCriteria.ClientID %> input:checked').val() == 'FL')
                document.getElementById('tdAddYear').style.display = '';
            else {
                document.getElementById('tdAddYear').style.display = 'none';
                document.getElementById('<%=chkAddYear.ClientID %>').checked = false;
            }
            $('#<%=rblDateCriteria.ClientID %>').change(function () {
                //debugger
                if ($('#<%=rblDateCriteria.ClientID %> input:checked').val() == 'FL')
                    document.getElementById('tdAddYear').style.display = '';
                else
                    document.getElementById('tdAddYear').style.display = 'none';
                document.getElementById('<%=chkAddYear.ClientID %>').checked = false;
            });

            $('#<%=chkAddYear.ClientID %>').change(function () {
                // debugger
                var txtto = $get('<%=txtto.ClientID %>');
                 if ($(this).is(":checked")) {
                     var txtfrom = $get('<%=txtfrom.ClientID %>');

                    var rightSD = new Date(MakeDateFormate(txtfrom.value));
                    var newDate = CalculateEndDate(rightSD, 1, 0);
                    txtto.value = newDate;
                }
                else
                    txtto.value = '';
             });
            Assign_Css();
         
        }

        function InitializeDate() {
         
            var StartDate = $('#<%=txtfrom.ClientID %>').val();

            if (StartDate != '') {
                $('#<%=txtfrom.ClientID %>').datepick('option', 'minDate', StartDate);
                $('#<%=txtto.ClientID %>').datepick('option', 'minDate', StartDate);
            }   
            else {
                $('#<%=txtfrom.ClientID %>').datepick('option', 'minDate', $.datepick.today());
                $('#<%=txtto.ClientID %>').datepick('option', 'minDate', $.datepick.today());
            }
        }


        function CalculateEndDate(startDate, year, month) {
            debugger
            var yearToMonth = 12 * year;
            month = month + yearToMonth;
            startDate.setMonth(startDate.getMonth() + month);
            startDate.setDate(startDate.getDate() - 1);
            var newDateStr = ConvertDateToCurrentFormat(startDate);
            return newDateStr;
        }

        function ConvertDateToCurrentFormat(objDate) {
            debugger
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


    </script>

    <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0">
    </asp:ScriptManager>
    <div class="top_area">    
        <h2 class="pull-left">Title Availability </h2>
        <div class="right_nav pull-right">
            <ul>
                <li>
                    <b>Business Unit</b>
                    <asp:DropDownList ID="ddlBusinessUnit" runat="server" AutoPostBack="true" CssClass="select" OnSelectedIndexChanged="ddlBusinessUnit_SelectedIndexChanged"></asp:DropDownList>
                </li>
            </ul>
        </div>
    </div>
    <asp:UpdatePanel ID="upGridView" runat="server" ChildrenAsTriggers="true">
        <ContentTemplate>
            <div class="search_area" id="trSearch">
                <table class="table">
                    <tr>
                        <td style="width: 12%;"><b>Title</b></td>
                        <td style="width: 38%;">
                            <asp:ListBox ID="lsMovie" class="ChosenTitle" runat="server" Width="90%" SelectionMode="Multiple"></asp:ListBox></td>
                        <td style="width: 12%;"><b>Region</b></td>
                        <td style="width: 38%;" colspan="2">
                            <asp:ListBox ID="lstLTerritory" class="Chosenlb" runat="server" Width="90%" Height="25px" SelectionMode="Multiple"></asp:ListBox></td>
                    </tr>
                    <tr>
                        <td><b>Platform</b></td>
                        <td>
                            <asp:LinkButton ID="lnkbtnPltform" runat="server" OnClick="lnkbtnPltform_Click" CommandName="PD"
                                Text="Select Platforms" Style="float: left;"></asp:LinkButton>
                            <asp:HiddenField ID="hdnPlatform" runat="server" Visible="false" />
                        </td>
                        <td></td>
                        <td colspan="2">
                            <table style="width: 70%;">
                                <tr>
                                    <td>
                                        <asp:CheckBox ID="chkIsOriginalLanguage" Text="Title Language" runat="server" Checked="true" />
                                    </td>
                                    <td>
                                        <asp:CheckBoxList ID="chkDubbingSubtitling" runat="server" RepeatDirection="Horizontal">
                                            <asp:ListItem Text="Subtitling" Value="S" />
                                            <asp:ListItem Text="Dubbing" Value="D" />
                                        </asp:CheckBoxList>
                                    </td>

                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Report On</b></td>
                        <td>
                            <asp:RadioButtonList ID="rdlNode" runat="server" Style="width: 56%;" RepeatDirection="Horizontal">
                                <asp:ListItem Text="Parent Node" Value="P" />
                                <asp:ListItem Text="Child Node" Value="C" Selected="True" />
                            </asp:RadioButtonList>
                        </td>
                        <td><b>Language</b></td>
                        <td colspan="2">
                            <asp:ListBox ID="lbLanguage" class="Chosenlb" runat="server" Width="90%" Height="25px" SelectionMode="Multiple"></asp:ListBox>
                        </td>
                    </tr>
                    <tr style="line-height: 30px;">
                        <td></td>
                        <td>
                            <div class="" style="width: 400px; display: inline-block;">
                                <div style="width: 240px; float: left">
                                    <asp:RadioButtonList runat="server" ID="rblDateCriteria" RepeatDirection="Horizontal">
                                        <asp:ListItem Selected="True" Text="Flexi Date" Value="FL"></asp:ListItem>
                                        <asp:ListItem Text="Fixed Date" Value="FI"></asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                                <div id="tdAddYear" style="display: inline-block;">
                                    <asp:CheckBox ID="chkAddYear" Text="Add 1 Year" runat="server" />
                                </div>
                            </div>
                        </td>
                        <td></td>
                        <td colspan="2">
                            <asp:RadioButtonList ID="rdbGroupBy" runat="server" RepeatDirection="Horizontal" Style="width: 60%;">
                                <asp:ListItem Text="Language wise" Value="L" Selected="True" />
                                <asp:ListItem Text="Country wise" Value="C" />
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                    <tr>
                        <td><b>Available </b></td>
                        <td>
                            <table>
                                <tr>
                                    <td>From:
                                        <asp:TextBox ID="txtfrom" Width="90px" MaxLength="50" placeholder="DD/MM/YYYY" CssClass="text dateRange" runat="server" onkeypress="return false;" onkeydown="return false;"></asp:TextBox>
                                        <a href="#" onclick="clearDate('txtfrom');">clear</a>
                                        <asp:HiddenField ID="hdnDateWatermarkFormat" runat="server" />
                                    </td>
                                    <td>To:
                                        <asp:TextBox ID="txtto" Width="90px" MaxLength="50" placeholder="DD/MM/YYYY" CssClass="text dateRange" runat="server" onkeypress="return false;" onkeydown="return false;"></asp:TextBox>
                                        <a href="#" onclick="clearDate('txtto');">clear</a>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td></td>
                        <td>
                            <asp:CheckBox ID="chkShowRemarks" Text="Show Remarks" runat="server" /></td>
                        <td>
                            <asp:Button ID="btnSearch" OnClick="btnSearch_Click" runat="server" CssClass="button"
                                ValidationGroup="SEARCH" Text="Search" Width="60px" OnClientClick="return ValidateTitle();" />
                            <asp:Button ID="btnback" Width="60px" Visible="false" runat="server" OnClick="btnback_Click" CssClass="btn btn-primary"
                                Text="Back" /></td>
                    </tr>
                </table>
            </div>
            <asp:UpdatePanel ID="UpPlatformPopup" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class='popup' id="PlatformPopup">
                        <div class='content'>
                            <img src="../images/fancy_close.png" alt='quit' class='X' id='Img1' onclick="ClosePopup()" />
                            <div class="popupHeading" style="float: left;">
                                Platform / Rights
                            </div>
                            <div style="float: right;">
                                <asp:TextBox ID="txtSearch" runat="server" MaxLength="100"></asp:TextBox>
                                <asp:Button ID="btnSearch_plt" runat="server" CssClass="button" Text="Search" OnClientClick="return ValidateMandatoryField();" OnClick="btnSearch_plt_Click" />
                                <asp:Button ID="btnShowAll_plt" runat="server" CssClass="button" Text="Show All" OnClick="btnShowAll_plt_Click" />
                            </div>
                            <div id="divPlatform">
                                <ucPTV:ucTab ID="uctabPTV" runat="server" class="popuptbl" />
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
                    <asp:AsyncPostBackTrigger ControlID="btnSearch_plt" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnSearch" />
            <asp:AsyncPostBackTrigger ControlID="btnback" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>


    <div>
        <rsweb:ReportViewer ID="ReportViewer1" runat="server" ShowParameterPrompts="false"
            Visible="false" Style="width: 100%;" CssClass="reportViewer">
        </rsweb:ReportViewer>
    </div>

</asp:Content>
