<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" Inherits="SystemSetting_AssignWorkflow" CodeBehind="AssignWorkflow.aspx.cs" MasterPageFile="~/Home.Master" %>

<%@ Register TagPrefix="UTO" Namespace="UTOFrameWork.FrameworkClasses" Assembly="RightsU_Plus" %>

<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">

    <script type="text/javascript" src="JS/master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/common.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/AjaxUpdater.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/Ajax.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/HTTP.js?v=<%= ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <link rel="Stylesheet" href="stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
    <link href="../CSS/Master_ASPX.css" rel="stylesheet" />

    <script type="text/javascript" src="../JS_Core/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="../JS_Core/common.concat.js"></script>
     <script type="text/javascript">       
         $(document).ready(function () {
            // $("#ancFileName").attr('href', '../Help/index.html?IntCode=AssignWorkflow');
         });
            </script>

    <AjaxToolkit:ToolkitScriptManager ID="smAssWorkflow" EnableScriptGlobalization="true" CombineScripts="false" runat="server" AsyncPostBackTimeout="0" />
    <asp:UpdatePanel ID="upAppWorkflow" runat="server" ChildrenAsTriggers="False" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="title_block dotted_border clearfix">
                <h2 class="pull-left">Assign/Upgrade Workflow</h2>
                <div class="right_nav pull-right">
                    <ul>
                        <li>
                            <asp:Button ID="btnAssign" runat="server" CssClass="btn btn-primary" Text="Assign" OnClick="btnAssign_Click" /></li>
                    </ul>
                </div>
            </div>
            <%--<div class="search_area">
                <table class="table">
                    <tr>
                        <td></td>
                    </tr>
                </table>
            </div>--%>
            <div id="up_container" runat="server">
                <asp:HiddenField ID="hdnId" runat="server" />
                <asp:HiddenField ID="hdnEditRecord" runat="server" />
                <div class="paging_area clearfix">
                    <div class="divBlock">
                        <div>
                            <span class="pull-left">Total Records:
                                <asp:Label ID="lblTotal" runat="server" Text="0"></asp:Label>
                            </span>
                        </div>
                        <div>
                            <asp:DataList ID="dtLst" runat="server" RepeatDirection="horizontal" OnItemCommand="dtLst_ItemCommand" OnItemDataBound="dtLst_ItemDataBound">
                                <ItemTemplate>
                                    <asp:Button ID="btnPager" CssClass="pagingbtn" Text='<%#  ((AttribValue)Container.DataItem).Attrib %>' CommandArgument='<%#((AttribValue)Container.DataItem).Val %>' runat="server" />
                                </ItemTemplate>
                            </asp:DataList>
                            <a class="menu" href="#"></a>
                        </div>
                        <div>
                            <span class="pull-right"><%--Page Size: --%>
                                <a class="menu" href="#"></a>
                                <asp:PlaceHolder ID="phPage" runat="server"></asp:PlaceHolder>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="table-wrapper">
                    <asp:GridView ID="gvAssWorkflow" runat="server" AutoGenerateColumns="False"
                        DataKeyNames="IntCode,lastUpdatedTime,moduleCode" Width="100%" CellPadding="0" CellSpacing="0"
                        CssClass='table table-bordered table-hover' OnRowCommand="gvAssWorkflow_RowCommand" OnRowDeleting="gvAssWorkflow_RowDeleting" OnRowEditing="gvAssWorkflow_RowEditing"
                        OnRowDataBound="gvAssWorkflow_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText="Module Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblModName" runat="server" Text='<%# (Convert.ToString(Eval("objSysModule.moduleName")).Length >=35 ? ((Convert.ToString(Eval("objSysModule.moduleName"))).Substring(0,35)+ " ...") : Eval("objSysModule.moduleName"))%>' CssClass='<%#(Convert.ToString(Eval("objSysModule.moduleName")).Length >=35 ? "checkbox":"")%>' ToolTip='<%# (Convert.ToString(Eval("objSysModule.moduleName")).Length >=35 ? Eval("objSysModule.moduleName"): "") %>'>
                                    </asp:Label>
                                </ItemTemplate>
                                <HeaderStyle Width="20%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Workflow Name">
                                <ItemTemplate>
                                    <asp:Label ID="lblWorkflowName" runat="server" Text='<%# (Convert.ToString(Eval("objWorkflow.workflowName")).Length >=35 ? ((Convert.ToString(Eval("objWorkflow.workflowName"))).Substring(0,35)+ " ...") : Eval("objWorkflow.workflowName"))%>' CssClass='<%#(Convert.ToString(Eval("objWorkflow.workflowName")).Length >=35 ? "checkbox":"")%>' ToolTip='<%# (Convert.ToString(Eval("objWorkflow.workflowName")).Length >=35 ? Eval("objWorkflow.workflowName"): "") %>'>
                                    </asp:Label>
                                </ItemTemplate>
                                <HeaderStyle Width="15%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Content Category">
                                <ItemTemplate>
                                    <asp:Label ID="lblBusinessUnitCode" Visible="false" runat="server" Text='<%#Eval("objWorkflow.Business_Unit_Code")%>'>
                                    </asp:Label>
                                    <asp:Label ID="lblBusinessUnit" runat="server">
                                    </asp:Label>
                                </ItemTemplate>
                                <HeaderStyle Width="15%" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Effective Start Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblDesc" runat="server" Text='<%# Bind("effStartDate") %>'>
                                    </asp:Label>
                                </ItemTemplate>
                                <HeaderStyle Width="15%" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <asp:Label ID="lblStatus" runat="server">
                                    </asp:Label>
                                </ItemTemplate>
                                <HeaderStyle Width="15%" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Action">
                                <ItemTemplate>
                                    <asp:Button ID="btnEdit" runat="server" CssClass='btn btn-primary' CausesValidation="false" Visible="false" CommandName="Edit" Text="Edit" Width="50px" />
                                    <asp:Button ID="btnDelete" runat="server" CssClass='btn btn-primary' CausesValidation="False" CommandName="Delete" Text="Delete" Width="50px" Visible="false" />
                                    <asp:Button ID="btnUpgrade" runat="server" CssClass='btn btn-primary' CausesValidation="false" CommandName="Upgrade" Text="Upgrade" Width="65px" CommandArgument='<%# Container.DataItemIndex %>' />
                                    <asp:Button ID="btnViewHis" runat="server" CssClass='btn btn-primary' CausesValidation="False" CommandName="ViewHis" Text="View History" Width="90px" CommandArgument='<%# Container.DataItemIndex %>' />
                                    <asp:Button ID="btnView" runat="server" CssClass='btn btn-primary' CausesValidation="False" CommandName="View" Text="View" CommandArgument='<%# Container.DataItemIndex %>' />
                                </ItemTemplate>
                                <HeaderStyle Width="20%" />
                                <ItemStyle HorizontalAlign="Center" />
                                <FooterStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnAssign" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="gvAssWorkflow" EventName="RowCommand" />
            <asp:AsyncPostBackTrigger ControlID="dtLst" EventName="ItemCommand" />
        </Triggers>
    </asp:UpdatePanel>

    <%--<script type="text/javascript">

        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequest);
        Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(initRequest);

        function initRequest(sender, args) {
            var pop = $find("mpeLoading");
            pop.show();
            $get('loadingPanel').focus();
        }

        function endRequest(sender, args) {
            var pop = $find("mpeLoading");
            pop.hide();
        }
    </script>--%>

</asp:Content>
