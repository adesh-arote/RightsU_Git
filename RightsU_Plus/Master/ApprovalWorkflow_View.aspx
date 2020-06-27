<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" Inherits="SystemSetting_ApprovalWorkflow_View" CodeBehind="ApprovalWorkflow_View.aspx.cs" MasterPageFile="~/Home.Master" %>

<%@ Register TagPrefix="UTO" Namespace="UTOFrameWork.FrameworkClasses" Assembly="RightsU_Plus" %>

<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">

    <script type="text/javascript" src="JS/master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/common.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/AjaxUpdater.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/Ajax.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/HTTP.js?v=<%= ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <link rel="Stylesheet" href="stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />

     <script type="text/javascript" src="../JS_Core/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="../JS_Core/common.concat.js"></script>
    <link href="../CSS/Master_ASPX.css" rel="stylesheet" />

     <script type="text/javascript">
         $(document).ready(function () {
            // $("#ancFileName").attr('href', '../Help/index.html?IntCode=ApprovalWorkflow');
         });
            </script>
    <script type="text/javascript">
        var IntervalCode;
        function ReleaseLock() {
            IntervalCode = window.clearInterval(IntervalCode);
        }

        function RefreshTime(code) {
            var params = "action=RefreshRecordLock&className=Workflow&code=" + code;
            AjaxUpdater.Update('GET', '../Master/ProcessResponseRequest.aspx', getResponse, params);
        }

        function RefreshLock() {
            var str = location.search.match(/\RecNo\= *([^\&]+)/);
            if (str != null) {
                var recNo = str[1];
                setInterval("RefreshTime(" + recNo + ")", 15000);
            }
        }
        function getResponse() {
        }
        function ClearWFNChrMsg() {
            document.getElementById('lblCharMsgWrkflwName').value = '';
        }
        function ClearDescChrMsg() {
            document.getElementById('lblCharMsgDesc').value = '';
        }

        $(document).ready(function () {
            ReleaseLock();
        });
    </script>



    <AjaxToolkit:ToolkitScriptManager ID="smAppWfAddEdit" EnableScriptGlobalization="true" CombineScripts="false" runat="server" AsyncPostBackTimeout="0" />
    <asp:UpdatePanel ID="upAppWfAddEdit" runat="server" ChildrenAsTriggers="False" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:HiddenField ID="hdnId" runat="server" />
            <asp:HiddenField ID="hdnEditRecord" runat="server" />
              <div class="title_block dotted_border clearfix">
                    <h2 class="pull-left"><asp:Label ID="lblAddEdit" runat="server"></asp:Label>&nbsp;&nbsp</h2>
            </div> 
            <div class="search_area">                                   
                <table class="four_column table">                                  
                    <tr>
                        <td>Sr.No.</td>
                        <td><asp:Label ID="lblSrNo" runat="server" CssClass="text" Text="New"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Workflow Name</td>
                        <td><asp:Label ID="txtWrkflwName" runat="server" Width="500"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Description</td>
                        <td><asp:Label ID="txtDesc" runat="server" Width="800"></asp:Label>
                         <%--   <asp:TextBox ID="txtDesc" CssClass="text3" ReadOnly="true" runat="server" Width="800"></asp:TextBox>--%>
                        </td>
                    </tr>
                    <%--<tr>
                            <td class='searchborder'>Type
                            </td>
                            <td class='border'>
                                <asp:Label ID="lblType" runat="server" CssClass="text3"></asp:Label>
                            </td>
                        </tr>--%>
                    <tr>
                        <td>Business Unit</td>
                        <td>
                            <asp:Label ID="lblBusinessUnit" runat="server" CssClass="text3"></asp:Label>
                            <asp:Label ID="lblBusinessCode" Visible="false" runat="server" CssClass="text3"></asp:Label>
                        </td>
                    </tr>
                </table>
            </div>
            <div>&nbsp;</div>
            <div class="table-wrapper" id="up_container" runat="server">  
                <table>
                    <tr>                      
                        <td align="right"  id="tdFlatWorkflow" style="display: block;" runat="server">
                            <asp:GridView ID="gvWrkflwAddEdit" runat="server" AutoGenerateColumns="False" Width="100%"
                                CellPadding="0" CellSpacing="0" CssClass='table table-bordered table-hover' 
                                OnRowDataBound="gvWrkflwAddEdit_RowDataBound">
                                <Columns>
                                    <asp:TemplateField HeaderText="Level No.">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSrNo" runat="server" Text='<%#Bind("groupLevel") %>'></asp:Label>
                                        </ItemTemplate>

                                        <HeaderStyle Width="15%" />
                                        <ItemStyle HorizontalAlign="Center" />

                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Security Group">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSecGroup" runat="server" Text='<%# Bind("groupName")%>'></asp:Label>
                                            <asp:Label ID="lblHdnSecGrp" runat="server" Text='<%#Eval("objSecurityGroup.IntCode") %>' Visible="false"></asp:Label>
                                        </ItemTemplate>

                                        <HeaderStyle Width="20%" />
                                        <ItemStyle HorizontalAlign="Left" />

                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="User(s)">
                                        <ItemTemplate>
                                            <asp:Label ID="lblPrimaryUser" runat="server"></asp:Label>
                                        </ItemTemplate>

                                        <HeaderStyle Width="40%" />
                                        <ItemStyle HorizontalAlign="Left" />

                                    </asp:TemplateField>

                                </Columns>
                            </asp:GridView>
                        </td>
                        <td align="right" style="display: none;" id="tdBusinessUnitWorkflow" runat="server">
                            <asp:GridView ID="gvWorkflowBusinessUnit" AutoGenerateColumns="False" Width="100%" CellPadding="0" CellSpacing="0"
                                 CssClass='table table-bordered table-hover' OnRowDataBound="gvWorkflowBusinessUnit_RowDataBound" runat="server">
                                <Columns>
                                    <asp:TemplateField HeaderText="Business Name">
                                        <ItemTemplate>
                                            <table border="0" cellpadding="2" cellspacing="0" valign="top" width="100%">
                                                <tr>
                                                    <td align="left">
                                                        <b>
                                                            <asp:Label ID="lblBusinessUnitName" runat="server" Text='<%#Eval("BusinessUnitName") %>'></asp:Label></b>
                                                        <asp:Label ID="lblBusinessUnitCode" Visible="false" runat="server" Text='<%#Eval("IntCode") %>'></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="0">
                                                        <asp:GridView ID="gvWorkflowBusinessUnitRole" AutoGenerateColumns="False" Width="100%" CellPadding="0" CellSpacing="0"
                                                            CssClass='table table-bordered table-hover' OnRowDataBound="gvWorkflowBusinessUnitRole_RowDataBound"
                                                            runat="server">
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="Level No.">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblSrNo" runat="server" Text='<%#Bind("GroupLevel") %>'></asp:Label>
                                                                    </ItemTemplate>
                                                                    <HeaderStyle Width="15%" />
                                                                    <ItemStyle HorizontalAlign="Center" Width="15%" />
                                                                    <FooterStyle HorizontalAlign="Center" Width="15%" />
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="Security Role">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblISecGroup" runat="server" Text='<%#Eval("groupName") %>'></asp:Label>
                                                                        <asp:Label ID="lblSecGroupCode" Visible="false" runat="server" Text='<%#Eval("SecurityGroupCode")%>'></asp:Label>
                                                                    </ItemTemplate>
                                                                    <HeaderStyle Width="15%" />
                                                                    <ItemStyle Width="15%" HorizontalAlign="Left" />
                                                                    <FooterStyle Width="15%" HorizontalAlign="Left" />
                                                                </asp:TemplateField>
                                                                <asp:TemplateField HeaderText="User(s)">
                                                                    <ItemTemplate>
                                                                        <asp:Label ID="lblIUserName" runat="server"></asp:Label>
                                                                    </ItemTemplate>
                                                                    <HeaderStyle Width="30%" />
                                                                    <ItemStyle Width="30%" HorizontalAlign="Left" />
                                                                    <FooterStyle Width="30%" HorizontalAlign="Left" />
                                                                </asp:TemplateField>
                                                            </Columns>
                                                        </asp:GridView>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Left" />
                                        <HeaderStyle HorizontalAlign="Left" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table> 
              
            </div>
            <div>&nbsp;</div>
             <div class="bottom_action">
                    <ul>
                        <li><asp:Button ID="btnCancel" runat="server" CssClass="btn btn-primary" Text="Cancel" CausesValidation="false" OnClick="btnCancel_Click" /></li>
                    </ul>
                </div>
        </ContentTemplate>

    </asp:UpdatePanel>

   <%-- <script type="text/javascript">

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
