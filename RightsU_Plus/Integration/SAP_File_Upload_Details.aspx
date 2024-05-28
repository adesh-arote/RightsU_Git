<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SAP_File_Upload_Details.aspx.cs" Inherits="SAP_File_Upload_Details"  MasterPageFile="~/Home.Master" 
    UnobtrusiveValidationMode="None" %>

<%@ Register TagPrefix="UTO" Namespace="UTOFrameWork.FrameworkClasses" Assembly="RightsU_Plus" %>

<%--<!DOCTYPE html>
<html xmlns="">
<head id="Head1" runat="server">--%>
<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">
    <link href="../CSS/jquery-ui.css" rel="stylesheet" />
    <%--Start Commnon on Page--%>
   <%-- <link rel="stylesheet" type="text/css" href="../stylesheet/star_rights.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
    <link rel="stylesheet" type="text/css" href="../stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
    <script type="text/javascript" src="../Javascript/JQuery/jquery-1.11.1.min.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Javascript/JQuery/jquery-ui.min.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../JavaScript/jquery.expander.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Javascript/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Javascript/Master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>

    <link href="../CSS/Master_ASPX.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" rel="stylesheet" />
    <%--<link href="../Master/Stylesheet/star_rights.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" rel="stylesheet" />--%>
    <link href="../Master/Stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" rel="stylesheet" />
    <script src="../JS_Core/jquery-1.11.1.min.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script src="../JS_Core/jquery-ui.min.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script src="../JS_Core/jquery.expander.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script src="../Master/JS/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script src="../Master/JS/Master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
     <%--End Commnon on Page--%>
  <%--  <title></title>--%>

    <style type="text/css">
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

        .search-text
        {
            width: 90%;
            padding: 1px 5px 1px 5px;
        }
    </style>

    <script type="text/javascript">
        var overlay = $('<div id="overlay"></div>');
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
    </script>

<%--</head>
<body>
    <form id="form1" runat="server">--%>
        <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="updatePanelMain" runat="server">
            <ContentTemplate>
                <%--<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center" valign="top">
                    <tr>
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
                    </tr>
                    <tr>
                        <td>
                            <table width='100%' class="main" border='0' cellpadding='0' cellspacing='0' align='center'
                                valign='top'>
                                <tr>
                                    <td class="searchborder" style="text-align: center; width: 70%">
                                        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-text" placeholder="WBS Code, WBS Description, Short ID, Status, Sport Type"></asp:TextBox>
                                        <%--<input type="text" placeholder="Search..." class="search-text" required id="txtSearch">--%>
                                    <%--</td>
                                    <td class="searchborder" style="text-align: center; width: 30%">
                                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="button" />
                                        &nbsp;
                                        <asp:Button ID="btnShowAll" runat="server" Text="Show All" OnClick="btnShowAll_Click" CssClass="button" />
                                        &nbsp;
                                        <asp:Button ID="btnBackToList" runat="server" Text="Back To List" OnClick="btnBackToList_Click" CssClass="button" />
                                    </td>
                                </tr>
                                <tr height="25px">
                                    <td align="left" class="border" style="border-right-width: 0px; border-bottom-width: 0px;">Total record(s) found : 
                                        <asp:Label ID="lblTotal" runat="server" Text="0"></asp:Label>
                                    </td>
                                    <td align="right" class="border" style="border-left-width: 0px; border-bottom-width: 0px;">
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
                                    <td colspan="2">--%>
                <div class="title_block dotted_border clearfix">
                        <h2 class="pull-left"><asp:Label
                                        ID="lblHeader" runat="server"></asp:Label></h2>
                        
                    </div>
                    <div class="search_area">
                        <table class="table">
                            <tr>
                                <td class='normal' width="30%">
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="search-text" placeholder="WBS Code, WBS Description, Short ID, Status, Sport Type"></asp:TextBox></td>
                                <td class='normal'>
                                    <asp:Button ID="btnSearch" runat="server" CssClass="button" Text="Search" OnClick="btnSearch_Click" Width="60px" />&nbsp;
                            <asp:Button ID="btnShowAll" runat="server" CssClass="button" Text="Show All" OnClick="btnShowAll_Click" Width="60px" />&nbsp;
                                <asp:Button ID="btnBackToList" runat="server" Text="Back To List" OnClick="btnBackToList_Click" CssClass="button" />
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
                <div class="table-wrapper">
                                        <asp:GridView ID="gvSAP_WBS_Details_List" runat="server" CssClass='table table-bordered table-hover'  AutoGenerateColumns="false" Width="100%"
                                              AllowSorting='True' ShowHeader='True' DataKeyNames="Upload_Detail_Code" CellPadding="5" HorizontalAlign='center'
                                             AlternatingItemStyle-HorizontalAlign='center' OnRowCommand="gvSAP_WBS_Details_List_RowCommand" RowStyle-HorizontalAlign='center'>
                                            <Columns>
                                                <asp:TemplateField HeaderText="Row No." HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblSrNo" runat="server" Text='<%# Eval("Row_Num") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" CssClass="border" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Error Codes" HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <%--<asp:Label ID="lblError_Codes" runat="server" Text='<%# Eval("Error_Codes") %>'></asp:Label>--%>
                                                        <asp:LinkButton ID="lnkBtnError_Codes" runat="server" Text='<%# Eval("Error_Codes") %>'
                                                            CommandName="VIEW_ERROR" Visible='<%# Convert.ToString(Eval("Error_Codes")).Trim()!= "" ? true : false %>'
                                                            CommandArgument='<%#Container.DataItemIndex%>'></asp:LinkButton>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="WBS Code" HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblWBS_Code" runat="server" Text='<%# Eval("WBS_Code") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Center" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="WBS Description" HeaderStyle-Width="30%" ItemStyle-Width="20%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblWBS_Description" runat="server" Text='<%# Eval("WBS_Description") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Studio/Vendor" HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblStudio_Vendor" runat="server" Text='<%# Eval("Studio_Vendor") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Original/Dubbed" HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblOriginal_Dubbed" runat="server" Text='<%# Eval("Original_Dubbed") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Short ID" HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Short_ID") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Status" HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Sport Type" HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblSport_Type" runat="server" Text='<%# Eval("Sport_Type") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <%--<asp:TemplateField HeaderText="Action" HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <asp:Button ID="btnViewError" runat="server" Text="View Error" CssClass="button"
                                                            CommandName="VIEW_ERROR" Visible='<%# Convert.ToString(Eval("Error_Codes")).Trim()!= "" ? true : false %>'
                                                            CommandArgument='<%#Container.DataItemIndex%>'></asp:Button>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Center" />
                                                </asp:TemplateField>--%>
                                            </Columns>
                                        </asp:GridView>
                    </div>
                                   <%-- </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>--%>
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
                                        <ItemStyle HorizontalAlign="Left" CssClass="border" VerticalAlign="Top" />
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
  <%--  </form>
</body>
</html>--%>
    </asp:Content>
