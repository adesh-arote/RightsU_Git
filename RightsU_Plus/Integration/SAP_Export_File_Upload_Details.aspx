<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SAP_Export_File_Upload_Details.aspx.cs" Inherits="SAP_Export_File_Upload_Details" MasterPageFile="~/Home.Master" 
    UnobtrusiveValidationMode="None" %>

<%@ Register TagPrefix="UTO" Namespace="UTOFrameWork.FrameworkClasses" Assembly="RightsU_Plus" %>

<%--<!DOCTYPE html>
<html xmlns="">
<head id="Head1" runat="server">--%>
<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">
    <link href="../CSS/jquery-ui.css" rel="stylesheet" />
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
    <title></title>

    <style type="text/css">
        .search-text {
            width: 90%;
            padding: 1px 5px 1px 5px;
        }
    </style>

    <script type="text/javascript">

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
                    <%--<tr>
                        <td>
                            <table class="table">
                                <tr>
                                    <td class="searchborder" style="text-align: center; width: 70%">
                                        <asp:TextBox ID="txtSearch" runat="server" CssClass="search-text" placeholder="WBS Code, Error/Status Description"></asp:TextBox>--%>
                                        <%--<input type="text" placeholder="Search..." class="search-text" required id="txtSearch">--%>
                                    <%--</td>
                                    <td class="searchborder" style="text-align: center; width: 30%">
                                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" CssClass="button" />
                                        &nbsp;
                                        <asp:Button ID="btnShowAll" runat="server" Text="Show All" OnClick="btnShowAll_Click" CssClass="button" />
                                        &nbsp;
                                        <asp:Button ID="btnBackToList" runat="server" Text="Back To List" OnClick="btnBackToList_Click" CssClass="button" />
                                    </td>
                                </tr>--%>
                                <%--<tr height="25px">
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
                                </tr>--%>
                                <%--<tr>
                                    <td id="td_gv_Sap" runat="server" colspan="2" visible="false">--%>
                 <div class="title_block dotted_border clearfix">
                        <h2 class="pull-left"><asp:Label ID="lblHeader" runat="server"></asp:Label></h2>
                       </div>
                    <div class="search_area">
                        <table class="table">
                                <tr>
                                    <td class="normal" style="text-align: left">&nbsp;
                                       <asp:TextBox ID="txtSearch" runat="server" CssClass="search-text" placeholder="WBS Code, Error/Status Description"></asp:TextBox>
                                    </td>
                                    <td class="normal" style="text-align: center">
                                        <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" OnClientClick="return ValidateSearch();" CssClass="button" />
                                        &nbsp;
                                        <asp:Button ID="btnShowAll" runat="server" Text="Show All" OnClick="btnShowAll_Click" CssClass="button" />
                                         &nbsp;
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
                <div id="td_gv_Sap" runat="server" colspan="2" visible="false">
                                        <asp:GridView ID="gvSAP_Export_List" runat="server" AutoGenerateColumns="false" Width="100%"  AllowSorting='True'
                                             ShowHeader='True'  DataKeyNames="SAP_Export_Code,File_Code" CssClass='table table-bordered table-hover'
                                            CellPadding="5" HorizontalAlign='center' AlternatingItemStyle-HorizontalAlign='center'
                                            RowStyle-HorizontalAlign='center'>
                                            <Columns>
                                                <asp:TemplateField HeaderText="Sr No." HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblSrNo" runat="server" Text='<%#Container.DataItemIndex + 1 + ((PageNo - 1) * Convert.ToInt32(txtPageSize.Text)) %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" CssClass="border" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="WBS Code" HeaderStyle-Width="15%" ItemStyle-Width="15%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblWBS_Code" runat="server" Text='<%# Eval("WBS_Code") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Center" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Start Date" HeaderStyle-Width="15%" ItemStyle-Width="15%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblWBS_Start_Date" runat="server" Text='<%#(Eval("WBS_Start_Date") == null) ? "" : Convert.ToDateTime(Eval("WBS_Start_Date")).ToString("dd/MM/yyyy")%>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="End Date" HeaderStyle-Width="15%" ItemStyle-Width="15%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblWBS_End_Date" runat="server" Text='<%# (Eval("WBS_End_Date") == null) ? "" : Convert.ToDateTime(Eval("WBS_End_Date")).ToString("dd/MM/yyyy") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Error/Status Description" HeaderStyle-Width="60%" ItemStyle-Width="60%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblAcknowledgement_Status" runat="server" Text='<%# Eval("Acknowledgement_Status") %>' Visible="false"></asp:Label>
                                                        <asp:Label ID="lblStudio_Vendor" runat="server" Text='<%# Eval("Error_Details") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                </div>
                                   <%-- </td>
                                    <td colspan="2" id="td_gv_BV" runat="server" visible="false">--%>
                <div id="td_gv_BV" runat="server" visible="false">
                                        <asp:GridView ID="gvBV_Export_List" runat="server" AutoGenerateColumns="false" Width="100%" AllowSorting='True'
                                            CssClass='table table-bordered table-hover' ShowHeader='True'  DataKeyNames="BV_WBS_Code,File_Code"
                                            CellPadding="5" HorizontalAlign='center' AlternatingItemStyle-HorizontalAlign='center'
                                            RowStyle-HorizontalAlign='center'>
                                            <Columns>
                                                <asp:TemplateField HeaderText="Sr No." HeaderStyle-Width="10%" ItemStyle-Width="10%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblSrNo" runat="server" Text='<%#Container.DataItemIndex + 1 + ((PageNo - 1) * Convert.ToInt32(txtPageSize.Text)) %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" CssClass="border" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="WBS Code" HeaderStyle-Width="15%" ItemStyle-Width="15%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblWBS_Code" runat="server" Text='<%# Eval("WBS_Code") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Center" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="WBS Description" HeaderStyle-Width="15%" ItemStyle-Width="15%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblWBS_Description" runat="server" Text='<%# Eval("WBS_Description")%>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Short ID" HeaderStyle-Width="15%" ItemStyle-Width="15%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblShort_ID" runat="server" Text='<%# Eval("Short_ID") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Is Archive" HeaderStyle-Width="15%" ItemStyle-Width="15%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblIS_ARCHIVE" runat="server" Text='<%# (((string)DataBinder.Eval(Container.DataItem,"IS_ARCHIVE")) == "N") ? ("No") : ("Yes")%>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="WBS Description-ShortID-WBS Code" HeaderStyle-Width="60%" ItemStyle-Width="60%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblWBS_Description_Short_ID" runat="server" Text='<%# Eval("WBS_Description_Short_ID") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Response Status" HeaderStyle-Width="60%" ItemStyle-Width="60%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblResponse_Status" runat="server" Text='<%# Eval("Response_Status") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Response Type" HeaderStyle-Width="60%" ItemStyle-Width="60%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblResponse_Type" runat="server" Text='<%# Eval("Response_Type") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Error/Status Description" HeaderStyle-Width="60%" ItemStyle-Width="60%">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblStudio_Vendor" runat="server" Text='<%# Eval("Error_Details") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="border" HorizontalAlign="Left" />
                                                </asp:TemplateField>
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
   <%-- </form>
</body>
</html>--%>
    </asp:Content>