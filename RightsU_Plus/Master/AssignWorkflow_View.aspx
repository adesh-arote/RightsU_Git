<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false"
    Inherits="SystemSetting_AssignWorkflow_View" CodeBehind="AssignWorkflow_View.aspx.cs" MasterPageFile="~/Home.Master" %>


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
    <script type="text/javascript">
        var IntervalCode;
        function ReleaseLock() {
            IntervalCode = window.clearInterval(IntervalCode);
        }

        function RefreshTime(code) {
            //            var params="action=RefreshRecordLock&className=WorkflowModule&code="+code;
            //            AjaxUpdater.Update('GET', '../ProcessResponseRequest.aspx',getResponse,params);
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
        function ValidateDays(val) {
            if (event.keyCode > 47 && event.keyCode < 58) {
                if ((val.value == '') && (event.keyCode == 48))
                    event.returnValue = false;
                else
                    event.returnValue = true;
            }
            else
                event.returnValue = false;
        }
        function CheckIdealProDays(source, args) {
            //var val=document.getElementById('txtIdealPrcDays').value; 
            var val = $get('txtIdealPrcDays').value;
            if (val > 0) {
                args.IsValid = true;
            }
            else {
                args.IsValid = false;
            }
        }
        function CheckReminderDays(source, args) {
            var arrstr = source.id.slice(0, source.id.lastIndexOf('_') + 1);
            var val = $get(arrstr + 'txtReminder').value;
            if (val > 0) {
                args.IsValid = true;
            }
            else {
                args.IsValid = false;
            }
        }
        function ClearText(txtVal) {
            var txtVal = document.getElementById(txtVal);
            if (txtVal) {
                txtVal.value = '';
            }
        }
        function CheckWorkFlow(source, args) {
            //            var ddlModuleName=$get('ddlModuleName');            
            //            if(ddlModuleName.selectedIndex == 0)
            //            {
            //                AlertModalPopup(ddlModuleName,"Please select Module Name first");
            //                return false;
            //            }
            //            else
            //            {
            //                return true;
            //            }

            //var ddlModuleName=$get('ddlModuleName');
            alert('Hello');
            var ddlWorkflowName = $get('ddlWorkflowName');
            if (ddlWorkflowName.selectedIndex == 0) {
                source.errormessage = "Please select Workflow Name";
                ddlWorkflowName.focus();
                args.IsValid = false;
            }
            else {
                args.IsValid = false;
            }

        }



        //        function CheckWorkFlow(source,args)
        //        {            
        //            var ddlWorkflowName=$get('ddlWorkflowName');            
        //            if(ddlWorkflowName.options[ddlWorkflowName.selectedIndex].value != '0')
        //            {
        //                var workFlowCode = ddlWorkflowName.options[ddlWorkflowName.selectedIndex].value;
        //                var params="action=CHECKWORKFLOWFORAPPROVE&workFlowCode="+workFlowCode+"";
        //                var str= AjaxUpdater.Update('GET', '../ProcessResponseRequest.aspx',getResponse,params);        
        //                if(Ajax.request.responseText=="")
        //                {   
        //                     args.IsValid = true;
        //                }
        //                else
        //                {                    
        //                    source.errormessage = "Tentative Date of Release should be greater than Deal signed date ("+Ajax.request.responseText+")";               
        //                    args.IsValid = false;
        //                }
        //            }
        //            else
        //            {
        //                args.IsValid = true;   
        //            }            
        //        }  

        $(document).ready(function () {
            ReleaseLock();
        });
    </script>


    <AjaxToolkit:ToolkitScriptManager ID="smAssWfAddEdit" EnableScriptGlobalization="true"
        CombineScripts="false" runat="server" AsyncPostBackTimeout="0" />       
        <div id="divMain" runat="server">
            <asp:UpdatePanel ID="upAssWfAddEdit" runat="server" ChildrenAsTriggers="False" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:HiddenField ID="hdnId" runat="server" />
                    <asp:HiddenField ID="hdnEditRecord" runat="server" />
                     <div class="title_block dotted_border clearfix">
                        <h2 class="pull-left"><asp:Label ID="lblOpType" runat="server"></asp:Label></h2>
                    </div>     
                    <div class="search_area">                                   
                        <table class="four_column table">                                     
                            <tr>
                                <td style="width:25%;">Module Name</td>
                                <td><asp:Label ID="lblDisModuleName" runat="server"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>Workflow Name</td>
                                <td><asp:Label ID="lblWrkflwName" runat="server"></asp:Label>&nbsp;</td>
                            </tr>
                            <%--<tr>
                                <td class='searchborder'>Ideal Process Days
                                </td>
                                <td class='border'>
                                    <asp:Label ID="lblIdealPrcDays" runat="server"></asp:Label>

                                </td>
                            </tr>--%>
                            <%--<tr>
                                <td class='searchborder'>Type
                                </td>
                                <td class='border'>
                                    <asp:Label ID="lblType" runat="server"></asp:Label>

                                </td>
                            </tr>--%>
                            <tr>
                                <td>Business Unit</td>
                                <td><asp:Label ID="lblBusinessUnit" runat="server"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>Effective Start Date</td>
                                <td><asp:Label ID="lblEffStartDate" runat="server"></asp:Label></td>
                            </tr>
                        </table>
                     </div> 
                     <div>&nbsp;</div>
                    <div class="table-wrapper">    
                        <%-- <td>--%>
                        <%-- <div id="up_container" runat="server">--%>
                        <asp:GridView ID="gvAssignWrkFlw" runat="server" AutoGenerateColumns="False" Width="100%"
                            CellPadding="0" CellSpacing="0" CssClass='table table-bordered table-hover' OnRowDataBound="gvAssignWrkFlw_RowDataBound" >
                            <Columns>
                                <asp:TemplateField HeaderText="Level">
                                    <ItemTemplate>
                                        <asp:Label ID="lblWrkflwIntCode" runat="server" Text='<%# Eval("objWorkFlowRole.IntCode") %>'
                                            Visible="false"></asp:Label>
                                        <asp:Label ID="lblGroupLevel" runat="server" Text='<%# Eval("objWorkFlowRole.groupLevel") %>'></asp:Label>
                                        <%--<asp:Label ID="lblBusinessUnitCode" runat="server" Text='<%# Eval("Business_Unit_Code") %>'></asp:Label>--%>
                                                            
                                    </ItemTemplate>
                                    <HeaderStyle Width="15%" />
                                    <ItemStyle  HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Security Group">
                                    <ItemTemplate>
                                        <asp:Label ID="lblGroupCode" runat="server" Text='<%# Eval("objWorkFlowRole.objSecurityGroup.IntCode")%>'
                                            Visible="false"></asp:Label>
                                        <asp:Label ID="lblGroupName" runat="server" Text='<%# Eval("objWorkFlowRole.groupName")%>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="20%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="User(s)">
                                    <ItemTemplate>
                                        <asp:Label ID="lblUserName" runat="server" ></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="50%" />
                                </asp:TemplateField>
                                <%--<asp:TemplateField HeaderText="Reminder(Days)">
                                    <ItemTemplate>

                                        <asp:Label ID="lblReminder" runat="server" Text='<%#  Eval("reminderDays","{0:#}")%>'></asp:Label>

                                    </ItemTemplate>
                                    <HeaderStyle Width="30%" />
                                    <ItemStyle CssClass="border" HorizontalAlign="Center" />
                                </asp:TemplateField>--%>
                            </Columns>
                        </asp:GridView>
                        <%-- </div>--%>
                        <%--</td>
                <td>--%>
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
                                                    <asp:Label ID="lblBusinessUnitCode" Visible="false" runat="server" Text='<%#Eval("BusinessUnitCode") %>'></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="0">
                                                    <asp:GridView ID="gvWorkflowBusinessUnitRole" CssClass='table table-bordered table-hover' AutoGenerateColumns="False" Width="100%" CellPadding="0" CellSpacing="0"
                                                        OnRowDataBound="gvWorkflowBusinessUnitRole_RowDataBound" runat="server">
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
                                                                    <asp:Label ID="lblISecGroup" runat="server" Text='<%#Eval("objSecurityGroup.securitygroupname") %>'></asp:Label>
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
                        <%-- </td>--%>
                     </div>      
                     <div class="bottom_action">
                           <ul>
                                <li><asp:Button ID="btnCancel" runat="server" CssClass="btn btn-primary" Text="Cancel" CausesValidation="false"
                                    OnClick="btnCancel_Click" /></li>
                         </ul>
                    </div>   
                            
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnCancel" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>
        </div>               
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
