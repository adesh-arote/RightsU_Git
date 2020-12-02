<%@ Page Language="C#" AutoEventWireup="true" EnableEventValidation="false" Inherits="SystemSetting_ApprovalWorkflowAddEdit" CodeBehind="ApprovalWorkflowAddEdit.aspx.cs" MasterPageFile="~/Home.Master" UnobtrusiveValidationMode="None" %>


<%@ Register TagPrefix="UTO" Namespace="UTOFrameWork.FrameworkClasses" Assembly="RightsU_Plus" %>

<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">


    <script type="text/javascript" src="JS/master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/common.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/AjaxUpdater.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/Ajax.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/HTTP.js?v=<%= ConfigurationManager.AppSettings["Version_No"] %>"></script>

      <script type="text/javascript" src="../JS_Core/jquery-1.11.1.min.js"></script>
   
    <script type="text/javascript" src="../JS_Core/common.concat.js"></script>

    <link rel="Stylesheet" href="stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
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
            document.getElementById('<%= lblCharMsgWrkflwName.ClientID %>').value = '';
        }
        function ClearDescChrMsg() {
            document.getElementById('<%= lblCharMsgDesc.ClientID %>').value = '';
        }
        function OnSave() {
           // alert("c");
            // debugger;
            debugger;
            if (checkValidation("Save")) {
                var hfEditRecord = document.getElementById('<%= hdnEditRecord.ClientID %>');
                var hfVal;
                if (typeof hfEditRecord == "object") {
                    hfVal = hfEditRecord.value;
                }
                else {
                    if (typeof hfEditRecord == "string") {
                        hfVal = hfEditRecord;
                    }
                }

                var index = hfVal.indexOf('#');
                var focusOn = "";
                var canEdit = "";
                if (index != -1) {
                    var field_Array = hfVal.split("#");
                    canEdit = field_Array[0];
                    focusOn = field_Array[1];
                    if (canEdit == 0) {
                        if (focusOn != null) {
                            AlertModalPopup(focusOn, "Please complete Add /Edit operation first")
                            return false;
                        }
                        else {
                            AlertModalPopup(null, "Please complete Add /Edit operation first")
                            return false;
                        }
                    }

                }
                else {
                    if (hfEditRecord.value == "0") {
                        AlertModalPopup(null, "Please complete Add /Edit operation first")
                        return false;
                    }

                }
                return true;

                //Final
               // return true;
            }
            else
                return false;
        }

        function checkValidation(VGroup) {
            debugger;
            for (var i = 0; i < Page_Validators.length; i++) {
                if (Page_Validators[i].validationGroup == VGroup) {
                    ValidatorEnable(Page_Validators[i], Page_Validators[i].enabled);

                    if (!Page_Validators[i].isvalid) {
                        Page_Validators[i].IsValid = false;
                        return false;
                    }
                }
            }

            return true;
        }

        $(document).ready(function () {
            ReleaseLock();
            $("#" + "<%=ddlBusinessUnit.ClientID%>").change(function () {
                if ($("#" + "<%=ddlBusinessUnit.ClientID%>").val() > 0)
                {

                    $("#" + "<%=ddlBusinessUnit.ClientID%>").removeClass('required');
                }
            });

        });
        function checkForsave(ObjectType) {
            debugger;
            $('.required').removeClass('required');
            var returnVal = RequiredFieldValidation(ObjectType);
           // return returnVal;

            if (returnVal) {
                var hfEditRecord = document.getElementById('<%= hdnEditRecord.ClientID %>');
                  var hfVal;
                  if (typeof hfEditRecord == "object") {
                      hfVal = hfEditRecord.value;
                  }
                  else {
                      if (typeof hfEditRecord == "string") {
                          hfVal = hfEditRecord;
                      }
                  }

                  var index = hfVal.indexOf('#');
                  var focusOn = "";
                  var canEdit = "";
                  if (index != -1) {
                      var field_Array = hfVal.split("#");
                      canEdit = field_Array[0];
                      focusOn = field_Array[1];
                      if (canEdit == 0) {
                          if (focusOn != null) {
                              AlertModalPopup(focusOn, "Please complete Add /Edit operation first")
                              return false;
                          }
                          else {
                              AlertModalPopup(null, "Please complete Add /Edit operation first")
                              return false;
                          }
                      }

                  }
                  else {
                      if (hfEditRecord.value == "0") {
                          AlertModalPopup(null, "Please complete Add /Edit operation first")
                          return false;
                      }

                  }
                  return true;

                  //Final
                  // return true;
              }
              else
                  return false;
        }
        function RequiredFieldValidation() {
            debugger;
            var returnVal = true;
            var txtWrkflwName = $("#" + "<%=txtWrkflwName.ClientID%>").val();
            var txtDesc = $("#" + "<%=txtDesc.ClientID%>").val();
            var ddlBusinessUnit = $("#" + "<%=ddlBusinessUnit.ClientID%>").val();

            if (txtWrkflwName == null || txtWrkflwName == "") {
                $("#" + "<%=txtWrkflwName.ClientID%>").attr('required', true);
                   returnVal = false;
               }

            if (txtDesc == null || txtDesc == "") {
                $("#" + "<%=txtDesc.ClientID%>").attr('required', true);
                returnVal = false;
                }
            if (ddlBusinessUnit == 0) {
                $("#" + "<%=ddlBusinessUnit.ClientID%>").addClass('required');
                returnVal = false;
                }
               return returnVal;
        }

        function checkForcancel() {
            $(".text").attr('required', false);
            $("#" + "<%=ddlBusinessUnit.ClientID%>").removeClass('required');

        }

        //function Validateddl(ddl)
        //{
        //    debugger
        //    if (ddl.val() > 0)
        //    {
        //        ddl.removeClass('required');
        //    }
        //}
    </script>

        <AjaxToolkit:ToolkitScriptManager ID="smAppWfAddEdit" EnableScriptGlobalization="true" CombineScripts="false" runat="server" AsyncPostBackTimeout="0" />
        <asp:HiddenField ID="hdnId" runat="server" />    
        <div class="title_block dotted_border clearfix">
            <h2 class="pull-left"><asp:Label ID="lblAddEdit" runat="server"></asp:Label> </h2>                
        </div>
        <asp:UpdatePanel ID="upWorkdlowType" runat="server">
            <ContentTemplate>
                <div class="search_area">
                    <table class="table">
                       <%-- <tr>
                            <td colspan="2">&nbsp;<asp:Label ID="lblMdt" runat="server" CssClass="lblmandatory" Text="(*) Mandatory Field"></asp:Label>
                            </td>
                        </tr>--%>
                        <tr>
                            <td style="width:25%;">Sr.No.</td>
                            <td><asp:Label ID="lblSrNo" runat="server" CssClass="text" Text="New"></asp:Label></td>
                        </tr>
                        <tr>
                            <td>Workflow Name</td>
                            <td>
                                <asp:TextBox ID="txtWrkflwName" runat="server" CssClass="text" MaxLength="100" Width="50%" ondrop="return false;"></asp:TextBox>&nbsp; <%--<span style="color: #ff0000">*</span>&nbsp;--%>
                            <asp:Label ID="lblCharMsgWrkflwName" runat="server" CssClass="lblChar" Style="display: none"></asp:Label>
                             
                            </td>
                        </tr>
                        <tr>
                            <td>Description</td>
                            <td>
                                <asp:TextBox ID="txtDesc" runat="server" CssClass="text" MaxLength="250" Width="50%" ondrop="return false;"></asp:TextBox>&nbsp;<%-- <span style="color: #ff0000">*</span>&nbsp;--%>
                            <asp:Label ID="lblCharMsgDesc" runat="server" CssClass="lblChar" Style="display: none"></asp:Label>
                       
                            </td>
                        </tr>
                        <tr>
                            <td>Content Category</td>
                            <td >
                                <asp:DropDownList ID="ddlBusinessUnit" CssClass="select" runat="server" ></asp:DropDownList> &nbsp;<%-- <span style="color: #ff0000">*</span>&nbsp;--%>
     
                            </td>
                        </tr>
                    </table>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnAdd" EventName="Click" />
                <%--<asp:AsyncPostBackTrigger ControlID="gvWorkflowBusinessUnit" EventName="RowCommand" />--%>
                <asp:AsyncPostBackTrigger ControlID="gvWrkflwAddEdit" EventName="RowCommand" />
                <%-- <asp:AsyncPostBackTrigger ControlID="gvWrkflwAddEdit" EventName="RowDataBound" />--%>
            </Triggers>
        </asp:UpdatePanel>
           
        <asp:UpdatePanel ID="upAppWfAddEdit" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div id="tdFlatWorkflow" style="display: block;" runat="server">
                    <asp:HiddenField ID="hdnEditRecord" runat="server" />
                    <div class="paging_area clearfix">
                        <div class="divBlock">
                            <div>
                                <span class="pull-right"><asp:Button ID="btnAdd" style="float:right; margin: 0px 12px;" runat="server"  CssClass="btn btn-primary" Text="Add" OnClick="btnAdd_Click" OnClientClick="return RequiredFieldValidation();"/></span>
                            </div>
                        </div>
                    </div>
                    <div class="table-wrapper">              
                        <asp:GridView ID="gvWrkflwAddEdit" runat="server" AutoGenerateColumns="False" Width="100%" CellPadding="0" CellSpacing="0" CssClass='table table-bordered table-hover' OnRowCommand="gvWrkflwAddEdit_RowCommand" OnRowDataBound="gvWrkflwAddEdit_RowDataBound" OnRowDeleting="gvWrkflwAddEdit_RowDeleting" OnRowEditing="gvWrkflwAddEdit_RowEditing" OnRowCancelingEdit="gvWrkflwAddEdit_RowCancelingEdit" OnRowUpdating="gvWrkflwAddEdit_RowUpdating">
                                <Columns>
                                    <asp:TemplateField HeaderText="Level No.">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSrNo" runat="server" Text='<%#Bind("groupLevel") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Label ID="lblESrNo" runat="server" Text='<%#Bind("groupLevel") %>'></asp:Label>
                                        </EditItemTemplate>
                                        <FooterTemplate>
                                            <asp:Label ID="lblFSrNo" runat="server" Text="New"></asp:Label>
                                        </FooterTemplate>
                                        <HeaderStyle Width="15%" />
                                        <ItemStyle CssClass="border" HorizontalAlign="Center" />
                                        <FooterStyle CssClass="border" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Security Group">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSecGroup" runat="server" Text='<%# Bind("groupName")%>'></asp:Label>
                                            <%--<asp:Label ID="lblBusinessUnitCOde" runat="server" Text='<%# Bind("Business_Unit_Code")%>'></asp:Label>--%>
                                            <asp:Label ID="lblHdnSecGrp" runat="server" Text='<%#Eval("objSecurityGroup.IntCode") %>' Visible="false"></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Label ID="lblHdnESecGrp" runat="server" Text='<%#Eval("objSecurityGroup.IntCode") %>' Visible="false"></asp:Label>
                                            <asp:DropDownList ID="ddlESecGroup" runat="server" OnSelectedIndexChanged="ddlESecGroup_SelectedIndexChanged" AutoPostBack="True" CssClass="select">
                                            </asp:DropDownList>
                                            &nbsp;<span style="color: #ff0000">*</span>
                                            <asp:RequiredFieldValidator ID="rfvESecGroup" runat="server" ControlToValidate="ddlESecGroup" ErrorMessage="Please select Security Group" ForeColor="RED" SetFocusOnError="true" InitialValue="0" Display="None">
                                            </asp:RequiredFieldValidator>
                                            <%--<AjaxToolkit:ValidatorCalloutExtender ID="vceESecGroup" runat="Server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="rfvESecGroup">
                                            </AjaxToolkit:ValidatorCalloutExtender>--%>
                                            <AjaxToolkit:ListSearchExtender ID="lSEESecGroup" PromptPosition="Top" runat="server" PromptCssClass="ListSearchExtenderPrompt" TargetControlID="ddlESecGroup"  PromptText="Type to search">
                                            </AjaxToolkit:ListSearchExtender>
                                        </EditItemTemplate>
                                        <FooterTemplate>
                                            <asp:DropDownList ID="ddlFSecGroup" runat="server" OnSelectedIndexChanged="ddlFSecGroup_SelectedIndexChanged" AutoPostBack="True" CssClass="select">
                                            </asp:DropDownList>
                                            &nbsp;<span style="color: #ff0000">*</span>
                                            <asp:RequiredFieldValidator ID="rfvFSecGroup" runat="server" ControlToValidate="ddlFSecGroup" ErrorMessage="Please select Security Group" ForeColor="RED" SetFocusOnError="true" InitialValue="0" Display="None">
                                            </asp:RequiredFieldValidator>
                                           <%-- <AjaxToolkit:ValidatorCalloutExtender ID="vceFSecGroup" runat="Server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="rfvFSecGroup">
                                            </AjaxToolkit:ValidatorCalloutExtender>--%>
                                            <AjaxToolkit:ListSearchExtender ID="lSEFSecGroup" PromptPosition="Top" runat="server" PromptCssClass="ListSearchExtenderPrompt" TargetControlID="ddlFSecGroup"  PromptText="Type to search">
                                            </AjaxToolkit:ListSearchExtender>
                                        </FooterTemplate>
                                        <HeaderStyle Width="30%" />
                                        <ItemStyle  HorizontalAlign="Left" />
                                        <FooterStyle  HorizontalAlign="Left" />
                                    </asp:TemplateField>
                                    <%--<asp:TemplateField HeaderText="User(s)">
                                        <ItemTemplate>
                                            <asp:Label ID="lblPrimaryUser" runat="server" Text='<%# Bind("objPrimaryUser.userName")%>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:UpdatePanel ID="upEDropDown" runat="server">
                                                <ContentTemplate>
                                                    <asp:DropDownList ID="ddlEPrimaryUser" runat="server" CssClass="select">
                                                    </asp:DropDownList>
                                                    &nbsp;<span style="color: #ff0000">*</span>
                                                    <asp:RequiredFieldValidator ID="rfvEPrimaryUser" runat="server" ControlToValidate="ddlEPrimaryUser" ErrorMessage="Please select Primary User" ForeColor="RED" SetFocusOnError="true" InitialValue="0" Display="None">
                                                    </asp:RequiredFieldValidator>
                                                    <AjaxToolkit:ValidatorCalloutExtender ID="vceEPrimaryUser" runat="Server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="rfvEPrimaryUser">
                                                    </AjaxToolkit:ValidatorCalloutExtender>
                                                    <AjaxToolkit:ListSearchExtender ID="lSEEPrimaryUser" PromptPosition="Top" runat="server" PromptCssClass="ListSearchExtenderPrompt" TargetControlID="ddlEPrimaryUser">
                                                    </AjaxToolkit:ListSearchExtender>
                                                </ContentTemplate>
                                                <Triggers>
                                                    <asp:AsyncPostBackTrigger ControlID="ddlESecGroup" EventName="SelectedIndexChanged" />
                                                </Triggers>
                                            </asp:UpdatePanel>
                                        </EditItemTemplate>
                                        <FooterTemplate>
                                            <asp:UpdatePanel ID="upFDropDown" runat="server">
                                                <ContentTemplate>
                                                    <asp:DropDownList ID="ddlFPrimaryUser" runat="server" CssClass="select">
                                                    </asp:DropDownList>
                                                    &nbsp;<span style="color: #ff0000">*</span>
                                                    <asp:RequiredFieldValidator ID="rfvFPrimaryUser" runat="server" ControlToValidate="ddlFPrimaryUser" ErrorMessage="Please select Primary User" ForeColor="RED" SetFocusOnError="true" InitialValue="0" Display="None">
                                                    </asp:RequiredFieldValidator>
                                                    <AjaxToolkit:ValidatorCalloutExtender ID="vceFPrimaryUser" runat="Server" HighlightCssClass="validatorCalloutHighlight" TargetControlID="rfvFPrimaryUser">
                                                    </AjaxToolkit:ValidatorCalloutExtender>
                                                    <AjaxToolkit:ListSearchExtender ID="lSEFPrimaryUser" PromptPosition="Top" runat="server" PromptCssClass="ListSearchExtenderPrompt" TargetControlID="ddlFPrimaryUser">
                                                    </AjaxToolkit:ListSearchExtender>
                                                </ContentTemplate>
                                                <Triggers>
                                                    <asp:AsyncPostBackTrigger ControlID="ddlFSecGroup" EventName="SelectedIndexChanged" />
                                                </Triggers>
                                            </asp:UpdatePanel>
                                        </FooterTemplate>
                                        <HeaderStyle Width="30%" />
                                        <ItemStyle CssClass="border" />
                                        <FooterStyle CssClass="border" />
                                    </asp:TemplateField>--%>
                                    <asp:TemplateField HeaderText="User(s)">
                                        <ItemTemplate>
                                            <asp:Label ID="lblIUserName" runat="server"></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Label ID="lblEUserName" runat="server"></asp:Label>
                                        </EditItemTemplate>
                                        <FooterTemplate>
                                            <asp:Label ID="lblFUserName" runat="server"></asp:Label>
                                        </FooterTemplate>
                                        <HeaderStyle Width="30%" />
                                        <ItemStyle Width="30%" HorizontalAlign="Left" />
                                        <FooterStyle Width="30%" HorizontalAlign="Left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Action">
                                        <ItemTemplate>
                                            <asp:Button ID="btnEdit" runat="server" CssClass='button' CausesValidation="false" CommandName="Edit" Text="Edit" Width="60px" />
                                            <asp:Button ID="btnDelete" runat="server" CssClass='button' CausesValidation="False" CommandName="Delete" Text="Delete" Width="60px" />
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Button ID="btnUpdate" runat="server" CssClass='button' Text="Update" CommandName="Update" Width="60px" />
                                            <asp:Button ID="btnCancel" runat="server" CausesValidation="False" CommandName="Cancel" CssClass='button' Text="Cancel" Width="60px" />
                                        </EditItemTemplate>
                                        <FooterTemplate>
                                            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass='button' CommandName="Save" Width="60px" />
                                            <asp:Button ID="btnFCancel" runat="server" CausesValidation="False" CssClass="button" Text="Cancel" CommandName="Cancel" Width="60px" />
                                        </FooterTemplate>
                                        <HeaderStyle Width="25%" />
                                        <ItemStyle  HorizontalAlign="Center" />
                                        <FooterStyle  HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="ddlBusinessUnit" EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="btnSave" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>
        <%--  align="right" class="normal" style="display: none;" id="tdBusinessUnitWorkflow" runat="server" --%>
        <asp:UpdatePanel ID="upWorkflowBusinessUnit" runat="server"  UpdateMode="Conditional">
            <ContentTemplate>
                <asp:HiddenField ID="hdnEditRecordBU" runat="server" />
                <div class="table-wrapper" style="display: none;" id="tdBusinessUnitWorkflow" runat="server">
                <asp:GridView ID="gvWorkflowBusinessUnit" AutoGenerateColumns="False" Width="100%" CellPadding="0" CellSpacing="0"
                    CssClass='table table-bordered table-hover' OnRowCommand="gvWorkflowBusinessUnit_RowCommand" OnRowDataBound="gvWorkflowBusinessUnit_RowDataBound" runat="server">
                    <Columns>
                        <asp:TemplateField HeaderText="Business Name">
                            <ItemTemplate>
                                <table align="center" border="0" cellpadding="2" cellspacing="0" valign="top" width="100%">
                                    <tr>
                                        <td align="left">
                                            <asp:Label ID="lblBusinessUnitName" runat="server" Text='<%#Eval("BusinessUnitName") %>'></asp:Label>
                                            <asp:Label ID="lblBusinessUnitCode" Visible="false" runat="server" Text='<%#Eval("IntCode") %>'></asp:Label>
                                        </td>
                                        <td align="right">
                                            <asp:Button ID="btnBusinessUnitAdd" CssClass="btn btn-primary" runat="server" CommandArgument='<%#Eval("IntCode")%>' Text="Add" CommandName="AddBusinessUnit" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:GridView ID="gvWorkflowBusinessUnitRole" AutoGenerateColumns="False" Width="100%" CellPadding="0" CellSpacing="0"
                                                CssClass="table table-bordered table-hover" OnRowCommand="gvWorkflowBusinessUnitRole_RowCommand" OnRowDataBound="gvWorkflowBusinessUnitRole_RowDataBound"
                                                OnRowEditing="gvWorkflowBusinessUnitRole_RowEditing" OnRowCancelingEdit="gvWorkflowBusinessUnitRole_RowCancelingEdit"
                                                OnRowUpdating="gvWorkflowBusinessUnitRole_RowUpdating" OnRowDeleting="gvWorkflowBusinessUnitRole_OnRowDeleting"
                                                runat="server">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Level No.">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblSrNo" runat="server" Text='<%#Bind("GroupLevel") %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:Label ID="lblESrNo" runat="server" Text='<%#Bind("GroupLevel") %>'></asp:Label>
                                                        </EditItemTemplate>
                                                        <FooterTemplate>
                                                            <asp:Label ID="lblFSrNo" runat="server" Text="New"></asp:Label>
                                                        </FooterTemplate>
                                                        <HeaderStyle Width="15%" />
                                                        <ItemStyle HorizontalAlign="Center" Width="15%" />
                                                        <FooterStyle HorizontalAlign="Center" Width="15%" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Security Role">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblISecGroup" runat="server" Text='<%#Eval("groupName") %>'></asp:Label>
                                                            <asp:Label ID="lblSecGroupCode" Visible="false" runat="server" Text='<%#Eval("SecurityGroupCode")%>'></asp:Label>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            <asp:DropDownList ID="ddlFSecGroup" runat="server" OnSelectedIndexChanged="ddlFSecGroupBU_SelectedIndexChanged"
                                                                AutoPostBack="True" CssClass="select" onchange="Validateddl(this)">
                                                            </asp:DropDownList>
                                                            &nbsp;<span style="color: #ff0000">*</span>
                                                            <asp:RequiredFieldValidator ID="rfvFSecGroup" runat="server" ControlToValidate="ddlFSecGroup"
                                                                ErrorMessage="Please select Security Group" SetFocusOnError="true" InitialValue="0"
                                                                Display="None">
                                                            </asp:RequiredFieldValidator>
                                                            <AjaxToolkit:ValidatorCalloutExtender ID="vceFSecGroup" runat="Server" TargetControlID="rfvFSecGroup">
                                                            </AjaxToolkit:ValidatorCalloutExtender>
                                                            <AjaxToolkit:ListSearchExtender ID="lSEFSecGroup" PromptPosition="Top" runat="server"
                                                                PromptCssClass="ListSearchExtenderPrompt" TargetControlID="ddlFSecGroup">
                                                            </AjaxToolkit:ListSearchExtender>
                                                        </FooterTemplate>
                                                        <EditItemTemplate>
                                                            <asp:Label ID="lblHdnESecGrp" runat="server" Text='<%#Eval("objSecurityGroup.IntCode") %>'
                                                                Visible="false"></asp:Label>
                                                            <asp:DropDownList ID="ddlESecGroup" runat="server" OnSelectedIndexChanged="ddlESecGroupBU_SelectedIndexChanged"
                                                                AutoPostBack="True" CssClass="select" onchange="Validateddl(this)">
                                                            </asp:DropDownList>
                                                            &nbsp;<span style="color: #ff0000">*</span>
                                                            <asp:RequiredFieldValidator ID="rfvESecGroup" runat="server" ControlToValidate="ddlESecGroup"
                                                                ErrorMessage="Please select Security Group" ForeColor="RED" SetFocusOnError="true"
                                                                InitialValue="0" Display="None">
                                                            </asp:RequiredFieldValidator>
                                                            <AjaxToolkit:ValidatorCalloutExtender ID="vceESecGroup" runat="Server" HighlightCssClass="validatorCalloutHighlight"
                                                                TargetControlID="rfvESecGroup">
                                                            </AjaxToolkit:ValidatorCalloutExtender>
                                                            <AjaxToolkit:ListSearchExtender ID="lSEESecGroup" PromptPosition="Top" runat="server"
                                                                PromptCssClass="ListSearchExtenderPrompt" TargetControlID="ddlESecGroup">
                                                            </AjaxToolkit:ListSearchExtender>
                                                        </EditItemTemplate>
                                                        <HeaderStyle Width="15%" />
                                                        <ItemStyle Width="15%" HorizontalAlign="Left" />
                                                        <FooterStyle Width="15%" HorizontalAlign="Left" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="User(s)">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblIUserName" runat="server"></asp:Label>
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:Label ID="lblEUserName" runat="server"></asp:Label>
                                                        </EditItemTemplate>
                                                        <FooterTemplate>
                                                            <asp:Label ID="lblFUserName" runat="server"></asp:Label>
                                                        </FooterTemplate>
                                                        <HeaderStyle Width="30%" />
                                                        <ItemStyle Width="30%" HorizontalAlign="Left" />
                                                        <FooterStyle Width="30%" HorizontalAlign="Left" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Action">
                                                        <ItemTemplate>
                                                            <asp:Button ID="btnEdit" runat="server" CssClass='button' CausesValidation="false"
                                                                CommandName="Edit" CommandArgument='<%#Eval("BusinessUnitCode")%>' Text="Edit" Width="60px" />
                                                            <asp:Button ID="btnDelete" runat="server" CssClass='button' CausesValidation="False"
                                                                CommandName="Delete" CommandArgument='<%#Eval("BusinessUnitCode")%>' Text="Delete" Width="60px" />
                                                        </ItemTemplate>
                                                        <EditItemTemplate>
                                                            <asp:Button ID="btnUpdate" runat="server" CssClass='button' Text="Update" CommandName="Update"
                                                                Width="60px" />
                                                            <asp:Button ID="btnCancel" runat="server" CausesValidation="False" CommandName="Cancel"
                                                                Text="Cancel" CssClass='button' Width="60px" />
                                                        </EditItemTemplate>
                                                        <FooterTemplate>
                                                            <asp:Button ID="btnSave" runat="server" Text="Save" CssClass='button' CommandName="Save"
                                                                Width="60px" />
                                                            <asp:Button ID="btnFCancel" runat="server" CausesValidation="False" CssClass="button"
                                                                Text="Cancel" CommandName="Cancel" Width="60px" />
                                                        </FooterTemplate>
                                                        <HeaderStyle Width="25%" />
                                                        <ItemStyle  HorizontalAlign="Center" Width="25%" />
                                                        <FooterStyle  HorizontalAlign="Center" Width="25%" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                </table>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:HiddenField ID="hdnWorkFlowBURow" runat="server" Value="0" />
                <asp:HiddenField ID="hdnBusinessUnitCode" runat="server" Value="0" />
                </div>
            </ContentTemplate>
            <Triggers>
                <%--<asp:AsyncPostBackTrigger ControlID="rdoType" EventName="SelectedIndexChanged" />--%>
                <asp:AsyncPostBackTrigger ControlID="btnSave" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>
         
         <div class="bottom_action" style="margin: 6px 0px;">
           <ul>
                <li><asp:Button ID="btnSave"  OnClientClick="return checkForsave();"  CssClass="btn btn-primary" runat="server" Text="Save" OnClick="btnSave_Click" /></li>
                <li><asp:Button ID="btnCancel" runat="server" CssClass="btn btn-primary" Text="Cancel" CausesValidation="false" OnClick="btnCancel_Click" OnClientClick="return checkForcancel();" /></li>          
            </ul>
        </div>   
<%--OnClientClick="return OnSave()"--%>  

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
