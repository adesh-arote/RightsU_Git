<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false"
    Inherits="SystemSetting_AssignWorkflowAddEdit" CodeBehind="AssignWorkflowAddEdit.aspx.cs" MasterPageFile="~/Home.Master" UnobtrusiveValidationMode="None" %>

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
    <%--<link rel="stylesheet" type="text/css" href="../jQuery/MultiSelect/jquery-ui.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />--%>

    <%--<script language="javascript" type="text/javascript" src="../JavaScript/Popup-dd-mm-yyyy.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>--%>
    
  <script type="text/javascript" src="../JS_Core/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="../JS_Core/common.concat.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.plugin.js"></script>
    <%--Date Picker
    <link rel="stylesheet" type="text/css" href="../stylesheet/jquery.dateentry.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
    
    <script type="text/javascript" src="../Javascript/jquery.dateentry.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
        Date Picker--%>
    <script type="text/javascript" src="../JS_Core/jquery.watermarkinput.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../JS_Core/watermark.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    

    <%--New Date Pick--%>
    <link rel="stylesheet" href="../CSS/jquery.datepick.css" />
    <link rel="stylesheet" href="../CSS/jquery-ui.css" />
    <link rel="stylesheet" href="../CSS/ui-start.datepick.css" />
    <script type="text/javascript" src="../JS_Core/jquery.datepick.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery.datepick.ext.js"></script>

    <%--New Date Pick--%>
     <script type="text/javascript">
         $(document).ready(function () {
            // $("#ancFileName").attr('href', '../Help/index.html?IntCode=AssignWorkflow');
         });
            </script>
    <style type="text/css">
        /*Datepick css start*/
        select, textarea {
            font-family: Arial,Helvetica,Sans-serif;
            font-size: 100%;
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
    </style>

    <script type="text/javascript">
        var dateWatermarkColor = '#999';
        var dateNormalkColor = '#000';
        var IntervalCode;

        $(document).ready(function () {
            debugger;
            AssignDateJQuery();
            ReleaseLock();
        });

        function AssignDateJQuery() {
            var dateWatermarkFormat = $('#<%=hdnDateWatermarkFormat.ClientID%>').val();
            var fromDate = $('#<%= txtEffStartDate.ClientID%>').val();

            if (fromDate == dateWatermarkFormat) {
                fromDate = "";
                $('#<%= txtEffStartDate.ClientID%>').val(fromDate);
            }

            $('.dateRange').datepick({
                dateFormat: 'dd/mm/yyyy', pickerClass: 'demo',
                autoSize: true,
                renderer: $.datepick.themeRollerRenderer,
                onSelect: customRange
            });

            function customRange(input) {
                if ($("#<%= txtEffStartDate.ClientID%>").val() != 'DD/MM/YYYY' && $("#<%= txtEffStartDate.ClientID%>").val() != '')
                    $("#<%= txtEffStartDate.ClientID%>").css('color', dateNormalkColor);
                else {
                    $("#<%= txtEffStartDate.ClientID%>").val(dateWatermarkFormat);
                    $("#<%= txtEffStartDate.ClientID%>").css('color', dateWatermarkColor);
                }
            }

            $('.dateRange').Watermark(dateWatermarkFormat);

            if (fromDate != "")
                $('#<%= txtEffStartDate.ClientID%>').val(fromDate)
        }

        function ReleaseLock() {
            IntervalCode = window.clearInterval(IntervalCode);
        }

        function RefreshTime(code) {
            //var params="action=RefreshRecordLock&className=WorkflowModule&code="+code;
            //AjaxUpdater.Update('GET', '../ProcessResponseRequest.aspx',getResponse,params);
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
            var val = $get('txtIdealPrcDays').value;

            if (val > 0)
                args.IsValid = true;
            else
                args.IsValid = false;
        }
        function CheckReminderDays(source, args) {
            var arrstr = source.id.slice(0, source.id.lastIndexOf('_') + 1);
            var val = $get(arrstr + 'txtReminder').value;

            if (val > 0)
                args.IsValid = true;
            else
                args.IsValid = false;
        }
        function ClearText(txtVal) {
            var txtVal = document.getElementById(txtVal);

            if (txtVal)
                txtVal.value = '';
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

            var ddlWorkflowName = $get('<%=ddlWorkflowName.ClientID%>');

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
    </script>


<AjaxToolkit:ToolkitScriptManager ID="smAssWfAddEdit" EnableScriptGlobalization="true"
    CombineScripts="false" runat="server" AsyncPostBackTimeout="0" />
       
        <div id="divMain" runat="server">
            <asp:UpdatePanel ID="upAssWfAddEdit" runat="server" ChildrenAsTriggers="false" UpdateMode="Conditional">
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
                                <td>
                                    <asp:DropDownList ID="ddlModuleName" runat="server" Width="200px" AutoPostBack="True"
                                        CssClass="select" OnSelectedIndexChanged="ddlModuleName_SelectedIndexChanged">
                                    </asp:DropDownList>
                                    <asp:Label ID="lblDisModuleName" runat="server"></asp:Label>
                                    &nbsp;<span style="color: #ff0000" id="spModuleName" runat="server">*</span>
                                    <asp:RequiredFieldValidator ID="rfvModuleName" runat="server" ControlToValidate="ddlModuleName"
                                        Display="None" ErrorMessage="Please select Module Name" SetFocusOnError="True"
                                        InitialValue="0">
                                    </asp:RequiredFieldValidator>
                                    <%--<AjaxToolkit:ValidatorCalloutExtender ID="vceModuleName" runat="server" Enabled="true"
                                        TargetControlID="rfvModuleName">
                                    </AjaxToolkit:ValidatorCalloutExtender>--%>
                                    <AjaxToolkit:ListSearchExtender ID="lSEModuleName" PromptPosition="Top" runat="server"
                                        PromptCssClass="ListSearchExtenderPrompt" TargetControlID="ddlModuleName"  PromptText="Type to search">
                                    </AjaxToolkit:ListSearchExtender>
                                </td>
                            </tr>
                            <tr>
                                <td>Business Unit</td>
                                <td>
                                    <asp:DropDownList ID="ddlBusinessUnit" runat="server" Width="200px" AutoPostBack="True"
                                        CssClass="select" OnSelectedIndexChanged="ddlBusinessUnit_SelectedIndexChanged">
                                    </asp:DropDownList>
                                    <asp:Label ID="Label1" runat="server"></asp:Label>
                                    &nbsp;<span style="color: #ff0000" id="Span1" runat="server">*</span>
                                    <asp:RequiredFieldValidator ID="rfvBusinessUnit" runat="server" ControlToValidate="ddlBusinessUnit"
                                        Display="None" ErrorMessage="Please select Business Unit" SetFocusOnError="True"
                                        InitialValue="0">
                                    </asp:RequiredFieldValidator>
                                  <%--  <AjaxToolkit:ValidatorCalloutExtender ID="vceBU" runat="server" Enabled="true"
                                        TargetControlID="rfvBusinessUnit">
                                    </AjaxToolkit:ValidatorCalloutExtender>--%>
                                    <%--<AjaxToolkit:ListSearchExtender ID="ListSearchExtender1" PromptPosition="Top" runat="server"
                                    PromptCssClass="ListSearchExtenderPrompt" TargetControlID="ddlModuleName">
                                </AjaxToolkit:ListSearchExtender>--%>
                                    <asp:Label ID="lblBusinessUnitNew" runat="server" Visible="false"></asp:Label>
                                    <asp:Label ID="lblBusinessCode" runat="server" Visible="false"></asp:Label>
                                </td>
                            </tr>
                            <tr id="trWrkflw" runat="server">
                                <td>
                                    <asp:Label ID="lblWrkflwName" runat="server"></asp:Label>
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlWorkflowName" runat="server" Width="200px" AutoPostBack="True" CssClass="select"
                                        OnSelectedIndexChanged="ddlWorkflowName_SelectedIndexChanged">
                                    </asp:DropDownList>
                                    <asp:Label ID="lblDisWrkflwName" runat="server"></asp:Label>
                                    &nbsp;<span style="color: #ff0000" id="spWrkflwName" runat="server">*</span>
                                    <asp:RequiredFieldValidator ID="rfvWorkflowName" runat="server" ControlToValidate="ddlWorkflowName"
                                        Display="None" ErrorMessage="Please select Workflow Name" SetFocusOnError="True"
                                        InitialValue="0">
                                    </asp:RequiredFieldValidator>
                                    <%--<AjaxToolkit:ValidatorCalloutExtender ID="vceWorkflowName" runat="server" Enabled="true"
                                        TargetControlID="rfvWorkflowName">
                                    </AjaxToolkit:ValidatorCalloutExtender>--%>
                                </td>
                            </tr>
                            <tr id="trWrkflwName" runat="server">
                                <td>New Workflow Name<%--<asp:Label ID="lblNewWrkflwName" runat="server"></asp:Label>--%></td>
                                <td>
                                    <asp:DropDownList ID="ddlNewWrkflwName" runat="server" AutoPostBack="True" Width="200px"
                                        CssClass="select" OnSelectedIndexChanged="ddlNewWrkflwName_SelectedIndexChanged">
                                    </asp:DropDownList>
                                    &nbsp;<span style="color: #ff0000">*</span>
                                    <asp:RequiredFieldValidator ID="rfvNewWorkflowName" runat="server" ControlToValidate="ddlNewWrkflwName"
                                        Display="None" ErrorMessage="Please select New Workflow Name" InitialValue="0"
                                        SetFocusOnError="True">
                                    </asp:RequiredFieldValidator>
                                  <%--  <AjaxToolkit:ValidatorCalloutExtender ID="vceNewWorkflowName" runat="server" Enabled="true"
                                        TargetControlID="rfvNewWorkflowName">
                                    </AjaxToolkit:ValidatorCalloutExtender>--%>
                                </td>
                            </tr>
                            <tr>
                                <td >Effective Start Date</td>
                                <td >
                                    <asp:HiddenField ID="hdnDateWatermarkFormat" runat="server" />
                                    <asp:TextBox ID="txtEffStartDate" Width="100px" runat="server" CssClass="text dateRange" MaxLength="10" onkeypress="return false;" onkeydown="return false;">
                                    </asp:TextBox>
                                    <%--<asp:TextBox ID="txtEffStartDate" runat="server" CssClass="text" Width="75px"></asp:TextBox>
                                &nbsp;<asp:ImageButton ID="imgCal" runat="server" ImageUrl="../Images/show-calendar.gif"
                                    CausesValidation="false" Style="cursor: hand" AlternateText="" align="absmiddle"
                                    border='0' />
                                &nbsp;<span style="color: #ff0000">*</span> &nbsp;
                                <asp:Label ID="imgClear" runat="server" Text="Clear" onclick="ClearText('txtEffStartDate')"
                                    align="absmiddle" border='0' alt='' Style="cursor: hand" CssClass="lblmandatory" />
                                <AjaxToolkit:CalendarExtender ID="ceEffStartDate" runat="server" TargetControlID="txtEffStartDate"
                                    Format="dd/MM/yyyy" PopupButtonID="imgCal">
                                </AjaxToolkit:CalendarExtender>
                                <asp:RequiredFieldValidator ID="rfvEffStartDate" runat="server" ControlToValidate="txtEffStartDate"
                                    ErrorMessage="Please select Effective Start Date" ForeColor="Red" SetFocusOnError="true"
                                    Display="None"></asp:RequiredFieldValidator>
                                <AjaxToolkit:ValidatorCalloutExtender ID="vceEffStartDate" runat="Server" HighlightCssClass="validatorCalloutHighlight"
                                    TargetControlID="rfvEffStartDate">
                                </AjaxToolkit:ValidatorCalloutExtender>--%>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div>&nbsp;</div>
                    <div id="up_container" runat="server">
                        <asp:GridView ID="gvAssignWrkFlw" runat="server" AutoGenerateColumns="False" Width="100%"
                            CellPadding="0" CellSpacing="0" CssClass='table table-bordered table-hover' OnRowDataBound="gvAssignWrkFlw_RowDataBound">
                            <Columns>
                                <asp:TemplateField HeaderText="Level">
                                    <ItemTemplate>
                                        <asp:Label ID="lblWrkflwIntCode" runat="server" Text='<%# Eval("objWorkFlowRole.IntCode") %>'
                                            Visible="false"></asp:Label>
                                        <asp:Label ID="lblGroupLevel" runat="server" Text='<%# Eval("objWorkFlowRole.groupLevel") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="15%" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Security Group">
                                    <ItemTemplate>
                                        <asp:Label ID="lblGroupCode" runat="server" Text='<%# Eval("objWorkFlowRole.objSecurityGroup.IntCode")%>'
                                            Visible="false"></asp:Label>
                                        <asp:Label ID="lblGroupName" runat="server" Text='<%# Eval("objWorkFlowRole.groupName")%>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="15%" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="User(s)">
                                    <ItemTemplate>
                                        <asp:Label ID="lblUserName" runat="server"></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle Width="50%" />
                                </asp:TemplateField>
                                <%-- <asp:TemplateField HeaderText="Reminder (Days)">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtReminder" runat="server" Text='<%# Eval("reminderDays","{0:#}")%>'
                                        CssClass="text" MaxLength="4" Width="25%" onpaste="return false;" ondrop="return false;"></asp:TextBox>
                                    &nbsp;<span style="color: #ff0000">*</span>
                                    <asp:RequiredFieldValidator ID="rfvReminder" runat="server" ControlToValidate="txtReminder"
                                        Display="None" ErrorMessage="Please enter Reminder (Days)" SetFocusOnError="True">
                                    </asp:RequiredFieldValidator>
                                    <AjaxToolkit:ValidatorCalloutExtender ID="vceReminder" runat="server" Enabled="true"
                                        TargetControlID="rfvReminder">
                                    </AjaxToolkit:ValidatorCalloutExtender>
                                    <asp:CustomValidator ID="cvReminderDays" runat="server" ClientValidationFunction="CheckReminderDays"
                                        ControlToValidate="txtReminder" Display="None" ErrorMessage="Reminder(Days) cannot be zero"
                                        SetFocusOnError="true" ValidateEmptyText="false">
                                    </asp:CustomValidator>
                                    <AjaxToolkit:ValidatorCalloutExtender ID="vceReminderDays" runat="server" Enabled="true"
                                        TargetControlID="cvReminderDays">
                                    </AjaxToolkit:ValidatorCalloutExtender>
                                </ItemTemplate>
                                <HeaderStyle Width="30%" />
                                <ItemStyle CssClass="border" HorizontalAlign="Center" />
                            </asp:TemplateField>--%>
                            </Columns>
                        </asp:GridView>
                        <asp:GridView ID="gvWorkflowBusinessUnit" AutoGenerateColumns="False" Width="100%" CellPadding="0" CellSpacing="0"
                            CssClass='table table-bordered table-hover' OnRowDataBound="gvWorkflowBusinessUnit_RowDataBound" runat="server">
                            <Columns>
                                <asp:TemplateField HeaderText="Business Name">
                                    <ItemTemplate>
                                        <table align="center" border="0" cellpadding="2" cellspacing="0" valign="top" width="100%">
                                            <tr>
                                                <td align="left">
                                                    <b>
                                                        <asp:Label ID="lblBusinessUnitName" runat="server" Text='<%#Eval("BusinessUnitName") %>'></asp:Label></b>
                                                    <%--<asp:Label ID="lblBusinessUnitCode" Visible="false" runat="server" Text='<%#Eval("BusinessUnitCode") %>'></asp:Label>--%>
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
                    </div>
                     <div class="bottom_action">
                       <ul>
                            <li><asp:Button ID="btnAssign" CssClass="btn btn-primary" runat="server" Text="Assign" OnClick="btnAssign_Click"/></li>
                            <li><asp:Button ID="btnCancel" runat="server" CssClass="btn btn-primary" Text="Cancel" CausesValidation="false"
                                    OnClick="btnCancel_Click" /></li>
                         </ul>
                    </div>     
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnAssign" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="gvAssignWrkFlw" EventName="RowCommand" />
                    <asp:AsyncPostBackTrigger ControlID="btnCancel" EventName="Click" />
                    <asp:AsyncPostBackTrigger ControlID="ddlWorkflowName" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="ddlNewWrkflwName" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="ddlModuleName" EventName="SelectedIndexChanged" />
                    <asp:AsyncPostBackTrigger ControlID="ddlBusinessUnit" EventName="SelectedIndexChanged" />
                </Triggers>
            </asp:UpdatePanel>
        </div>                
        <div id="divView" runat="server">
             <div class="title_block dotted_border clearfix">
                <h2 class="pull-left"><asp:Label ID="lblView" runat="server"></asp:Label></h2>
            </div>
            <div>&nbsp;</div>
             <div class="table-wrapper">              
                <asp:GridView ID="gvWrkflwModView" runat="server" AutoGenerateColumns="False" Width="100%"
                    CellPadding="5" CellSpacing="0" CssClass='table table-bordered table-hover' OnRowDataBound="gvWrkflwModView_RowDataBound">
                    <Columns>
                        <asp:TemplateField HeaderText="Workflow Name">
                            <ItemTemplate>
                                <asp:Label ID="lblWrkflwName" runat="server" Text='<%# Eval("objWorkflow.workflowName") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Business Unit">
                            <ItemTemplate>
                                <asp:Label ID="lblBusinessUnitCode" Visible="false" runat="server" Text='<%# Eval("objWorkflow.Business_Unit_Code") %>'></asp:Label>
                                <asp:Label ID="lblBusinessUnit" runat="server"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Effective Start Date">
                            <ItemTemplate>
                                <asp:Label ID="lblEffStartDate" runat="server" Text='<%# Bind("effStartDate") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="20%" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Effective End Date">
                            <ItemTemplate>
                                <asp:Label ID="lblSysEndDate" runat="server" Text='<%# Bind("sysEndDate") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle Width="20%" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
             <div class="bottom_action">
                <ul>
                    <li><asp:Button ID="btnBack" CssClass="btn btn-primary" runat="server" Text="Back" OnClick="btnBack_Click"
                    CausesValidation="False" /></li>
                </ul>
            </div>                  
        </div>
                

        <%--<script type="text/javascript">

            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequest);
            Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(initRequest);

            function initRequest(sender, args) {
                var pop = $find("mpeLoading");
                pop.show();
                $get('loadingPanel').focus();
            }

            function endRequest(sender, args) {
                AssignDateJQuery();
                var pop = $find("mpeLoading");
                pop.hide();
            }
        </script>--%>
</asp:Content>