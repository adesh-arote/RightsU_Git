<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SAP_File_Upload.aspx.cs" Inherits="SAP_File_Upload" MasterPageFile="~/Home.Master" 
    UnobtrusiveValidationMode="None" %>

<%@ Register TagPrefix="UTO" Namespace="UTOFrameWork.FrameworkClasses" Assembly="RightsU_Plus" %>
<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">    <link href="../jQuery/MultiSelect/jquery-ui.css?v=2" rel="stylesheet" />
   <%--Start Commnon on Page--%>
     <link href="../CSS/Master_ASPX.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" rel="stylesheet" />
    <%--<link href="../Master/Stylesheet/star_rights.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" rel="stylesheet" />--%>
    <link href="../Master/Stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" rel="stylesheet" />
    <script src="../JS_Core/jquery-1.11.1.min.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script src="../JS_Core/jquery-ui.min.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script src="../JS_Core/jquery.expander.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script src="../Master/JS/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script src="../Master/JS/Master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <%--End Commnon on Page--%>

    <%--New Date Pick--%>
    <script src="../JS_Core/jquery.plugin.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <link href="../CSS/ui.datepick.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" rel="stylesheet" />
    <link href="../CSS/jquery-ui.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" rel="stylesheet" />
    <link href="../CSS/ui-start.datepick.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" rel="stylesheet" />
    <script src="../JS_Core/jquery.datepick.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script src="../JS_Core/jquery.datepick.ext.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script src="../JS_Core/jquery.watermarkinput.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
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

        .datepick-popup
        {
            z-index: 9001;
        }
        /*Datepick css end*/

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

        .popup
        {
            width: 100%;
            margin: auto;
            top: 10%;
            display: none;
            position: fixed;
            z-index: 8001;
        }

        .popupHeading
        {
            color: #686868;
            width: 90%;
            height: 30px;
            font-size: 20px;
            font-family: sans-serif;
            text-shadow: 1px 1px 1px #E0E0E0;
        }

        #divErrorPopupRecord
        {
            overflow: auto;
            height: 120px;
            width: 100%;
        }

        .content
        {
            width: 800px;
            height: 180px;
            margin: auto;
            background: #f3f3f3;
            position: relative;
            padding: 10px;
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
    </style>

    <script type="text/javascript">
        var overlay = $('<div id="overlay"></div>');
        var dateWatermarkFormat = "DD/MM/YYYY";
        var dateWatermarkColor = '#999';
        var dateNormalkColor = '#000';
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

        function ValidatePaging(txtId) {
            var pageSize = $('#' + txtId).val();
            if (pageSize == "") {
                AlertModalPopup(null, "Please select pagesize.")
                return false;
            }
            var size = parseInt(pageSize);

            if (isNaN(size)) {
                AlertModalPopup(null, "Please enter valid number")
                return false;
            }

            if (size <= 0) {
                AlertModalPopup(null, "Pagesize must be greater than 0.")
                return false;
            }
        }

        function ValidateSearch() {
            var dateFrom = $('#txtto').val().trim();
            var dateTo = $('#txtfrom').val().trim();
            var fileName = $('#txtFile_Name').val().trim();
            var dateWatermarkFormat = $('#hdnDateWatermarkFormat').val();

            if (dateFrom == dateWatermarkFormat)
                dateFrom = "";

            if (dateTo == dateWatermarkFormat)
                dateTo = "";

            if (dateFrom == "" && dateTo == "" && fileName == "") {
                AlertModalPopup(null, "Please select search criteria.")
                return false;
            }

            return true;
        }

        $(document).ready(function () {
            AssignDateJQuery();
        });

        function AssignDateJQuery() {
            var dateWatermarkFormat = $('#hdnDateWatermarkFormat').val();
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

            //$('.milestoneDateRange').dateEntry({dateFormat: 'dmy/' });
            //$('.milestoneDateRange').Watermark(dateWatermarkFormat);

            if (fromDate != "")
                $('#txtfrom').val(fromDate)

            if (toDate != "")
                $('#txtto').val(toDate)
        }
    </script>

        <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="updatePanelMain" runat="server">
            <ContentTemplate>
                <%--<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center" valign="top">--%>
                   <%-- <tr>
                        <td class='normal1'>
                            <table width='100%' border='0' class="main" cellpadding='0' cellspacing='0' align='center'
                                valign='top'>
                                <tr>
                                    <td align="left" class='head'>&nbsp;&nbsp;<img align="absmiddle" alt='' border='0' src='../Images/red.gif'>&nbsp;&nbsp;<asp:Label
                                        ID="lblHeader" runat="server"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>--%>
                <div class="title_block dotted_border clearfix">
                        <h2 class="pull-left"><asp:Label ID="lblHeader" runat="server"></asp:Label></h2>
                    </div>
                    <div class="search_area">
                        <table class="table">
                            <tr>
                                    <td  style="text-align: left">&nbsp;<b>Upload Date</b> : 
                                        <asp:TextBox ID="txtfrom" Width="78px" MaxLength="50" CssClass="text dateRange" runat="server" ondrop="return false;" onkeypress="return false;" onkeydown="return false;"></asp:TextBox>&nbsp;
                                        To&nbsp;<asp:TextBox ID="txtto" Width="78px" MaxLength="50" CssClass="text dateRange" runat="server" ondrop="return false;" onkeypress="return false;" onkeydown="return false;"></asp:TextBox>
                                        <asp:HiddenField ID="hdnDateWatermarkFormat" runat="server" />
                                    </td>
                                    <td style="text-align: left">&nbsp;<b>File Name</b> : 
                                        <asp:TextBox ID="txtFile_Name" runat="server" CssClass="text"></asp:TextBox>
                                    </td>
                                    <td style="text-align: center">
                                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" OnClientClick="return ValidateSearch();" CssClass="button" />
                                        &nbsp;
                                        <asp:Button ID="btnShowAll" runat="server" Text="Show All" OnClick="btnShowAll_Click" CssClass="button" />
                                    </td>
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
                                    </ItemTemplate>
                                </asp:DataList>
                            </div>
                            <div>
                                <span class="pull-right">Page Size: 
                            <asp:TextBox ID="txtPageSize" runat="server" CssClass="text" MaxLength="2"  onclick="return CheckAddEdit(this)"
                                ValidationGroup="ValidateSeacrh" align="Right" Width="34px" AutoPostBack="true" OnTextChanged="txtPageSize_TextChanged"></asp:TextBox>
                                    <span class='lblmandatory'>*</span>
                                    <AjaxToolkit:FilteredTextBoxExtender ID="fteSRecordPerPage" runat="server" TargetControlID="txtPageSize"
                                        FilterType="Numbers"></AjaxToolkit:FilteredTextBoxExtender>
                                </span>
                            </div>
                        </div>
                    </div>
                
                               <%-- <tr height="25px">
                                    <td align="left" class="border" style="border-right-width: 0px; border-bottom-width: 0px;">Total record(s) found : 
                                        <asp:Label ID="lblTotal" runat="server" Text="0"></asp:Label>
                                    </td>
                                    <td align="right" colspan="2" class="border" style="border-left-width: 0px; border-bottom-width: 0px;">
                                        <table>
                                            <tr>
                                                <td>Page Size
                                                    <asp:TextBox ID="txtPageSize" runat="server" Width="35px" onKeyPress="return checkNumbers(this, true, 3, 0);"> </asp:TextBox>
                                                    <asp:Button ID="btnApply" CssClass="button" runat="server" OnClick="btnApply_Click" Text="Apply" OnClientClick="return ValidatePaging('txtPageSize');" />
                                                </td>
                                                <td>
                                                    <asp:DataList ID="dtLst" runat="server" RepeatDirection="Horizontal" OnItemCommand="dtLst_ItemCommand"
                                                        OnItemDataBound="dtLst_ItemDataBound" ItemStyle-CssClass="white">
                                                        <ItemTemplate>
                                                            <asp:Button ID="btnPager" CssClass="pagingbtn" Text='<%#  ((UTOFrameWork.FrameworkClasses.AttribValue)Container.DataItem).Attrib %>'
                                                                CommandArgument='<%#  ((UTOFrameWork.FrameworkClasses.AttribValue)Container.DataItem).Val %>' runat="server" />
                                                        </ItemTemplate>
                                                    </asp:DataList>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">--%>
                <div class="table-wrapper">
                                        <asp:GridView ID="gvSAP_WBS_List" runat="server" AutoGenerateColumns="false" Width="100%" CssClass='table table-bordered table-hover' AllowSorting='True'
                                             ShowHeader='True'  DataKeyNames="File_Code,Is_Error"
                                            CellPadding="5" HorizontalAlign='center' AlternatingItemStyle-HorizontalAlign='center' OnRowCommand="gvSAP_WBS_List_RowCommand"
                                            RowStyle-HorizontalAlign='center'>
                                            <Columns>
                                                <asp:TemplateField HeaderText="Sr. No." HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblSrNo" runat="server" Text='<%#Container.DataItemIndex + 1 + ((PageNo - 1) * Convert.ToInt32(txtPageSize.Text)) %>'></asp:Label>.
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" CssClass="border" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="File Name" HeaderStyle-Width="50%" ItemStyle-Width="50%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblFileName" runat="server" Text='<%# Eval("File_Name") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Upload Date" HeaderStyle-Width="30%" ItemStyle-Width="30%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblUploadDate" runat="server" Text='<%# (Eval("Upload_Date") == null) ? "" : Convert.ToDateTime(Eval("Upload_Date")).ToString("dd/MM/yyyy hh:mm:ss tt") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" CssClass="border" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Action" HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <asp:Button ID="btnError" Text="Details" runat="server" CssClass="button" CommandName="VIEW_DETAILS"
                                                            CommandArgument='<%#Container.DataItemIndex%>' CausesValidation="false" />
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" CssClass="border" />
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
            </ContentTemplate>
        </asp:UpdatePanel>

        <div class='popup' id="ErrorPopup">
            <div class="content">
                <asp:UpdatePanel ID="upErrorPopup" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <img src="../images/fancy_close.png" alt='quit' class='X' onclick="ClosePopup('ErrorPopup')" />
                        <div class="popupHeading">
                            <asp:Label ID="lblPopupHead" runat="server" Text="Error Details"></asp:Label>
                        </div>
                        <div id="divErrorPopupRecord">
                            <asp:GridView ID="gvErrorPopup" runat='server' CssClass='main'
                                CellPadding="3" HeaderStyle-CssClass='tableHd' ShowHeader='True' AlternatingRowStyle-CssClass='rowBg'
                                HorizontalAlign='center' AlternatingItemStyle-HorizontalAlign='center' RowStyle-HorizontalAlign='center'
                                Width='100%' AutoGenerateColumns="false">
                                <Columns>
                                    <asp:TemplateField HeaderText="Sr. No." HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSrNo" runat="server" Text='<%#Container.DataItemIndex+1 %>'></asp:Label>.
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Right" CssClass="border" VerticalAlign="Top" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Error Code" HeaderStyle-Width="15%" ItemStyle-Width="15%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblError_Code" runat="server" Text='<%# Eval("Error_Code") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle Width="10%" CssClass="border" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Error_Description" HeaderStyle-Width="75%" ItemStyle-Width="75%">
                                        <ItemTemplate>
                                            <asp:Label ID="lblError_Description" runat="server" Text='<%# Eval("Error_Description") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Left" CssClass="border" VerticalAlign="Top"/>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                        <div class="footerRow">
                            <input type="button" class="button" value="Cancel" onclick="ClosePopup('ErrorPopup')" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </form>
</asp:Content>