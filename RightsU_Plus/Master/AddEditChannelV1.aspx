<%@ Page Language="C#" AutoEventWireup="true" Inherits="Master_AddEditChannelV1" CodeBehind="AddEditChannelV1.aspx.cs" MasterPageFile="~/Home.Master" UnobtrusiveValidationMode="None" %>

<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">

    <script type="text/javascript" src="JS/master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/common.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/AjaxUpdater.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="JS/Ajax.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="../JS_Core/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="../JS_Core/common.concat.js"></script>
    <link rel="Stylesheet" href="stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
    <link href="../CSS/Master_ASPX.css" rel="stylesheet" />
    <style type="text/css">
        DIV.AutoDealType {
            vertical-align: top;
            overflow: auto;
            width: 100%;
            height: 100px;
        }
    </style>

    <script type="text/javascript">

        function CheckForhr(txthr, msg) {

            var hr = txthr.value;
            if (hr <= 23)
                return true;
            else {
                AlertModalPopup(txthr, msg);
                return false;
            }

        }

        function CheckForMin(txtmin, msg) {

            var hr = txtmin.value;
            if (hr <= 59)
                return true;
            else {
                AlertModalPopup(txtmin, msg);
                return false;
            }

        }

        function sethidrange(txt) {
            document.getElementById("<%= txtHidRangeFromprefix.ClientID %>").value = txt.value;
                    document.getElementById("<%= txtHidRangeToPrefix.ClientID %>").value = txt.value;
                }

                function CheckForHidDigit(txt) {
                    var allowZero = true;

                    if (event.keyCode > 47 && event.keyCode < 58) {
                        if ((txt.value == '') && (event.keyCode == 48) && !allowZero) {
                            event.returnValue = false;
                        }
                        else {
                            var txthidPrefix = document.getElementById("<%= txthidPrefix.ClientID %>");
                            var txthiddigit = document.getElementById("<%= txthiddigit.ClientID %>");
                            var range = txthiddigit.value;
                            if (range == "" || txthidPrefix.value == "") {
                                AlertModalPopup(txthiddigit, "Please enter valid HouseId Prefix and HouseId Digit");
                                event.returnValue = false;
                            }
                            else {
                                var result = txt.value.length;
                                if (parseFloat(result) < parseFloat(range))
                                    event.returnValue = true;
                                else
                                    event.returnValue = false;
                            }
                        }
                    }
                    else
                        event.returnValue = false;

                }

                function CheckForHidDigitonBlurr(txt) {
                    var txthidrangefrom = document.getElementById("<%= txthidrangefrom.ClientID %>");
                    var txthidrangeto = document.getElementById("<%= txthidrangeto.ClientID %>");

                    if (txthidrangefrom.id == txt.id) {
                        if (txthidrangeto.value != "") {
                            if (parseFloat(txthidrangefrom.value) > parseFloat(txthidrangeto.value))
                                AlertModalPopup(txt, 'HouseId From Range should be less than HouseId To Range');
                            else
                                validateLength(txt);
                        }

                    }
                    else if (txthidrangeto.id == txt.id) {
                        if (txthidrangefrom.value != "") {
                            if (parseFloat(txthidrangefrom.value) > parseFloat(txthidrangeto.value))
                                AlertModalPopup(txt, 'HouseId From Range should be less than HouseId To Range');
                            else
                                validateLength(txt);
                        }
                        else
                            AlertModalPopup(txthidrangefrom, 'Please enter HouseId From Range');
                    }

                }

                function validateLength(txt) {
                    var txthidrangefrom = document.getElementById("<%= txthidrangefrom.ClientID %>");
                    var txthidrangeto = document.getElementById("<%= txthidrangeto.ClientID %>");
                    var msgappend = "";
                    if (txthidrangefrom.id == txt.id) {
                        msgappend = "From"

                    }
                    else if (txthidrangeto.id == txt.id) {
                        msgappend = "To";
                    }

                    var txthiddigit = document.getElementById("<%= txthiddigit.ClientID %>");
                    var range = txthiddigit.value;
                    var result = txt.value.length;
                    if (parseFloat(result) != parseFloat(range))
                        AlertModalPopup(txt, 'HouseId digit and no of digits in HouseId Range ' + msgappend + ' should be same');
                }

                function checkChannelReferenceForOwnandOthers(rdoEEntityType, lblChannelReferenceForOwn, lblChannelReferenceForOthers) {

                    var oldValue = "";
                    var radiolength = rdoEEntityType.length;
                    var hdnEntityType = document.getElementById('<%= hdnEntityType.ClientID %>');
                oldValue = hdnEntityType.value;
                var arrayOfRadioBoxes = rdoEEntityType;
                var entityType = "";
                for (var i = 0; i < radiolength; i++) {

                    if (arrayOfRadioBoxes[i].checked)
                        entityType = arrayOfRadioBoxes[i];
                }

                if (oldValue == "O") {
                    var strOwnReferCount = parseInt(lblChannelReferenceForOwn, 10);

                    if (strOwnReferCount > 0) {
                        AlertModalPopup(null, "Entity Type can not be edited because Channel Reference exists.");
                        SetCheckedValue(rdoEEntityType, oldValue);
                    }

                }
                else if (oldValue == "C") {
                    var strOthersReferCount = parseInt(lblChannelReferenceForOthers, 10);

                    if (strOthersReferCount > 0) {
                        AlertModalPopup(null, "Entity Type can not be edited because Channel Reference exists.");
                        SetCheckedValue(rdoEEntityType, oldValue);
                    }

                }
                else
                    SetCheckedValue(rdoEEntityType, oldValue);
            }

            function SetCheckedValue(radioObj, oldValue) {
                if (!radioObj)
                    return;
                var radiolength = radioObj.length;
                var arrayOfRadioBoxes = radioObj;

                for (var j = 0; j < radiolength; j++) {
                    arrayOfRadioBoxes[j].checked = false;
                    if (arrayOfRadioBoxes[j] == oldValue)
                        arrayOfRadioBoxes[j].checked = true;
                }
            }

            function check() {
                var txtofstimerunhr = document.getElementById("<%= txtofstimerunhr.ClientID %>");
                var txtofstimeschr = document.getElementById("<%= txtofstimeschr.ClientID %>");
                var txtofstimerunmin = document.getElementById("<%= txtofstimerunmin.ClientID %>");
                var txtofstimescmin = document.getElementById("<%= txtofstimescmin.ClientID %>");


                if (CheckForhr(txtofstimeschr, 'Invalid entry for Offset Time Schedule Hrs.')) {
                    if (CheckForMin(txtofstimescmin, 'Invalid entry for Offset Time Schedule Min.')) {
                        if (CheckForhr(txtofstimerunhr, 'Invalid entry for Offset Time AsRun Hrs.')) {

                            if (CheckForhr(txtofstimerunmin, 'Invalid entry for Offset Time AsRun Min.'))
                                return true;
                            else return false;
                        }
                        else return false;
                    }
                    else return false;

                }
                else return false;

            }
            function checkForsave() {
                //debugger;
                $('.required').removeClass('required');
                var returnVal = RequiredFieldValidation();
                return returnVal;
            }

            function RequiredFieldValidation() {
                debugger;
                var returnVal = true;
                var txtFChannelName = $("#" + "<%=txtFChannelName.ClientID%>").val();
            //var ddlChannelId = $("select[ID=#"+<%=ddlChannelId.ClientID%>+"] option:selected").val();
            var ddlChannelId = $("#" + "<%=ddlChannelId.ClientID%>").val();
            var ddlFGenresCode = $("#" + "<%=ddlFGenresCode.ClientID%>").val();
            var ddlFEntityCode = $("#" + "<%=ddlFEntityCode.ClientID%>").val();
            var txtschfpath = $("#" + "<%=txtschfpath.ClientID%>").val();
            var txtschfpathpkg = $("#" + "<%=txtschfpathpkg.ClientID%>").val();
            var txtBvchcode = $("#" + "<%=txtBvchcode.ClientID%>").val();
            var txtofstimeschr = $("#" + "<%=txtofstimeschr.ClientID%>").val();
            var txtofstimescmin = $("#" + "<%=txtofstimescmin.ClientID%>").val();
            var txtofstimerunhr = $("#" + "<%=txtofstimerunhr.ClientID%>").val();
            var txtofstimerunmin = $("#" + "<%=txtofstimerunmin.ClientID%>").val();

            if (txtFChannelName == null || txtFChannelName == "") {
                $("#" + "<%=txtFChannelName.ClientID%>").attr('required', true);
                returnVal = false;
            }
            if (ddlChannelId == 0) {
                $("#" + "<%=ddlChannelId.ClientID%>").addClass('required');
                returnVal = false;
            }
            if (ddlFGenresCode == 0) {
                $("#" + "<%=ddlFGenresCode.ClientID%>").addClass('required');
                returnVal = false;
            }
            if (ddlFEntityCode == 0) {
                $("#" + "<%=ddlFEntityCode.ClientID%>").addClass('required');
                returnVal = false;
            }
            // if (ddlFGenresList == 0) {
            //$('#ddlDeal_Tag').attr('required', true)
            //     $('#ddlFGenresCode').addClass("required");
            //     returnVal = false;
            // }

            if (txtschfpath == null || txtschfpath == "") {
                $("#" + "<%=txtschfpath.ClientID%>").attr('required', true);
                returnVal = false;
            }

            if (txtschfpathpkg == null || txtschfpathpkg == "") {
                $("#" + "<%=txtschfpathpkg.ClientID%>").attr('required', true);
                returnVal = false;
            }

            if (txtBvchcode == null || txtBvchcode == "") {
                $("#" + "<%=txtBvchcode.ClientID%>").attr('required', true);
                returnVal = false;
            }

            if (txtofstimeschr == null || txtofstimeschr == "") {
                $("#" + "<%=txtofstimeschr.ClientID%>").attr('required', true);
                returnVal = false;
            }
            if (txtofstimescmin == null || txtofstimescmin == "") {
                $("#" + "<%=txtofstimescmin.ClientID%>").attr('required', true);
                returnVal = false;
            }
            if (txtofstimerunhr == null || txtofstimerunhr == "") {
                $("#" + "<%=txtofstimerunhr.ClientID%>").attr('required', true);
                returnVal = false;
            }
            if (txtofstimerunmin == null || txtofstimerunmin == "") {
                $("#" + "<%=txtofstimerunmin.ClientID%>").attr('required', true);
                returnVal = false;
            }
            //Radio Button Validation
            var Chklstcount = $("input[type=radio][name*='rdoFEntityType']").length;
            var chkCount = 0;
            for (var i = 0; i < Chklstcount; i++) {

                var rdoFEntityType = $("#" + "<%=rdoFEntityType.ClientID%>" + "_" + i);
                if (rdoFEntityType[0].checked == true)
                    chkCount = chkCount + 1;
            }
            if (chkCount == 0) {
                $('.divCheckbox').attr('required', true);
                return false;
            }
            //Radio Button Validation End

            return returnVal;
            }

        $(document).ready(function () {
            
            $("#" + "<%=ddlChannelId.ClientID%>").change(function () {
                if ($("#" + "<%=ddlChannelId.ClientID%>").val() > 0) {

                    $("#" + "<%=ddlChannelId.ClientID%>").removeClass('required');
                }
            });
            $("#" + "<%=ddlFGenresCode.ClientID%>").change(function () {
                if ($("#" + "<%=ddlFGenresCode.ClientID%>").val() > 0) {

                     $("#" + "<%=ddlFGenresCode.ClientID%>").removeClass('required');
                }
            });
            $("#" + "<%=ddlFEntityCode.ClientID%>").change(function () {
                if ($("#" + "<%=ddlFEntityCode.ClientID%>").val() > 0) {

                     $("#" + "<%=ddlFEntityCode.ClientID%>").removeClass('required');
                }
             });


        });

        function Cancelvalidation()
        {
            $(".text").attr('required', false);
            $("#" + "<%=ddlFEntityCode.ClientID%>").removeClass('required');
            $("#" + "<%=ddlFGenresCode.ClientID%>").removeClass('required');
            $("#" + "<%=ddlChannelId.ClientID%>").removeClass('required');
        }
    </script>


    <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="upMain" runat="server" ChildrenAsTriggers="true">
        <ContentTemplate>
            <div class="title_block dotted_border clearfix">
                <h2 class="pull-left">
                    <asp:Label ID="lblAddEdit" runat="server"></asp:Label></h2>
            </div>
            <div class="table-wrapper">
                <table class="table table-bordered table-hover">
                    <%--<tr>
                        <td colspan="2" align="left">
                            &nbsp;<asp:Label ID="lblMdt" runat="server" CssClass="lblmandatory" Text="(*) Mandatory Field"></asp:Label>
                        </td>
                    </tr>--%>
                    <tr>
                        <td style="width: 30%;">Channel Name</td>
                        <td style="width: 70%;">
                            <asp:TextBox ID="txtFChannelName" runat="server" CssClass="text" MaxLength="100"
                                Width="40%"></asp:TextBox>

                        </td>
                    </tr>

                    <tr>
                        <td>Channel Beam</td>
                        <td>
                            <asp:DropDownList ID="ddlChannelId" runat="server" Style="width: 290px;" CssClass="form_input chosen-select">
                                <asp:ListItem Text="--Please Select--" Selected="True" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Colors India" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Colors UK" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Colors US" Value="3"></asp:ListItem>
                                <asp:ListItem Text="Colors MENA" Value="4"></asp:ListItem>
                                <asp:ListItem Text="Colors HD" Value="5"></asp:ListItem>
                            </asp:DropDownList>

                        </td>
                    </tr>

                    <tr>
                        <td>Genres</td>
                        <td>
                            <asp:DropDownList ID="ddlFGenresCode" runat="server" CssClass="form_input chosen-select" Style="width: 290px;">
                            </asp:DropDownList>

                        </td>
                    </tr>

                    <tr>
                        <td>Entity Type
                        </td>
                        <td>
                            <div id="CheckBoxDiv" class="divCheckbox">
                                <asp:RadioButtonList ID="rdoFEntityType" runat="server" RepeatDirection="Horizontal" AutoPostBack="True" OnSelectedIndexChanged="rdoFEntityType_SelectedIndexChanged">
                                    <asp:ListItem Text="Own" Value="O">
                                    </asp:ListItem>
                                    <asp:ListItem Text="Others" Value="C" Selected="True">
                                    </asp:ListItem>
                                </asp:RadioButtonList>
                                <asp:Label ID="lblChannelReferenceForOwn" runat="server" Style="display: none"></asp:Label>
                                <asp:Label ID="lblChannelReferenceForOthers" runat="server" Style="display: none"></asp:Label>
                                <%--<span class='lblmandatory'>*</span>--%>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td>Entity / Broadcaster
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlFEntityCode" runat="server" Style="width: 290px;" CssClass="form_input chosen-select">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <!-- new fields -->

                    <tr>
                        <td>Schedule Source FilePath
                        </td>
                        <td>
                            <asp:TextBox ID="txtschfpath" CssClass="text" runat="server" MaxLength="500" Width="40%"></asp:TextBox>
                         
                                    
                        </td>
                    </tr>

                    <tr>
                        <td>Schedule Source FilePath SSIS Package
                        </td>
                        <td>
                            <asp:TextBox ID="txtschfpathpkg" CssClass="text" runat="server" MaxLength="500" Width="40%"></asp:TextBox>
                          
                                    
                        </td>
                    </tr>

                    <tr>
                        <td>Broadview Channel Code
                        </td>
                        <td>
                            <asp:TextBox ID="txtBvchcode" CssClass="text" runat="server" MaxLength="4" Width="40%"
                                OnCopy="return false;" OnPaste="return false;" OnDrag="return false;" OnDrop="return false;"
                                onkeypress="allowOnlyNumber(this,true);"></asp:TextBox>
                         
                                    
                        </td>
                    </tr>

                    <tr style="display: none">
                        <td>HouseID Prefix
                        </td>
                        <td>
                            <asp:TextBox ID="txthidPrefix" CssClass="text" runat="server" MaxLength="50" Width="40%"
                                onkeypress="AllowCharacterOnly();" OnChange="sethidrange(this)"></asp:TextBox>
                            <span class='lblmandatory'>*</span>
                        </td>
                    </tr>

                    <tr style="display: none">
                        <td>HouseID Digit After Prefix
                        </td>
                        <td>
                            <asp:TextBox ID="txthiddigit" CssClass="text" runat="server" MaxLength="20" Width="40%"
                                OnCopy="return false;" OnPaste="return false;" OnDrag="return false;" OnDrop="return false;" Text="1"
                                onkeypress="allowOnlyNumber(this,true);"></asp:TextBox>
                            <span class='lblmandatory'>*</span>
                        </td>
                    </tr>

                    <tr style="display: none">
                        <td>HouseID Range From
                        </td>
                        <td>
                            <asp:TextBox ID="txtHidRangeFromprefix" CssClass="text" runat="server"
                                OnCopy="return false;" OnPaste="return false;" OnDrag="return false;" OnDrop="return false;"
                                MaxLength="50" Width="5%"></asp:TextBox>
                            <asp:TextBox ID="txthidrangefrom" CssClass="text" runat="server" MaxLength="50" Width="35%"
                                OnCopy="return false;" OnPaste="return false;" OnDrag="return false;" OnDrop="return false;"
                                onkeypress="CheckForHidDigit(this)" OnChange="CheckForHidDigitonBlurr(this)" Text="0"></asp:TextBox>
                            <span class='lblmandatory'>*</span>
                        </td>
                    </tr>

                    <tr style="display: none">
                        <td>HouseID Range To
                        </td>
                        <td>
                            <asp:TextBox ID="txtHidRangeToPrefix" CssClass="text" runat="server"
                                OnCopy="return false;" OnPaste="return false;" OnDrag="return false;" OnDrop="return false;"
                                MaxLength="50" Width="5%"></asp:TextBox>
                            <asp:TextBox ID="txthidrangeto" CssClass="text" runat="server" MaxLength="50" Width="35%"
                                OnCopy="return false;" OnPaste="return false;" OnDrag="return false;" OnDrop="return false;"
                                onkeypress="CheckForHidDigit(this)" OnChange="CheckForHidDigitonBlurr(this)" Text="0"></asp:TextBox>
                            <span class='lblmandatory'>*</span>
                        </td>
                    </tr>

                    <tr>
                        <td>Offset Time Schedule
                        </td>
                        <td>
                            <asp:TextBox ID="txtofstimeschr" runat="server" CssClass="text" MaxLength="2" Width="35"
                                OnCopy="return false;" OnPaste="return false;" OnDrag="return false;" OnDrop="return false;"
                                onkeypress="allowOnlyNumber(this,true);" onkeyup="CheckForhr(this,'Invalid entry for Offset Time Schedule Hrs.')" /> hrs.
                           <%-- <asp:RequiredFieldValidator ID="rfvtxtofstimeschr" runat="server" ValidationGroup="save" ControlToValidate="txtofstimeschr"
                                Display="None" SetFocusOnError="true" ErrorMessage="Please enter Offset Time Schedule Hrs."></asp:RequiredFieldValidator>
                            <AjaxToolkit:ValidatorCalloutExtender ID="vcetxtofstimeschr" runat="server" TargetControlID="rfvtxtofstimeschr">
                            </AjaxToolkit:ValidatorCalloutExtender>
                            &nbsp; : &nbsp;--%>
                            <asp:TextBox ID="txtofstimescmin" runat="server" CssClass="text" MaxLength="2" Width="35"
                                OnCopy="return false;" OnPaste="return false;" OnDrag="return false;" OnDrop="return false;"
                                onkeypress="allowOnlyNumber(this,true);" onkeyup="CheckForMin(this,'Invalid entry for Offset Time Schedule Min.')" /> min.
                           <%-- <asp:RequiredFieldValidator ID="rfvtxtofstimescmin" runat="server" ValidationGroup="save" ControlToValidate="txtofstimescmin"
                                Display="None" SetFocusOnError="true" ErrorMessage="Please enter Offset Time Schedule Min."></asp:RequiredFieldValidator>
                            <AjaxToolkit:ValidatorCalloutExtender ID="vcetxtofstimescmin" runat="server" TargetControlID="rfvtxtofstimescmin">
                            </AjaxToolkit:ValidatorCalloutExtender>
                            <span class='lblmandatory'>*</span>--%>
                                    
                        </td>
                    </tr>

                    <tr>
                        <td>Offset Time AsRun
                        </td>
                        <td>
                            <asp:TextBox ID="txtofstimerunhr" runat="server" CssClass="text" MaxLength="2" Width="35"
                                OnCopy="return false;" OnPaste="return false;" OnDrag="return false;" OnDrop="return false;"
                                onkeypress="allowOnlyNumber(this,true);" onkeyup="CheckForhr(this,'Invalid entry for Offset Time AsRun Hrs.')" /> hrs.
                          <%--  <asp:RequiredFieldValidator ID="rfvtxtofstimerunhr" runat="server" ValidationGroup="save" ControlToValidate="txtofstimerunhr"
                                Display="None" SetFocusOnError="true" ErrorMessage="Please enter Offset Time AsRun Hrs."></asp:RequiredFieldValidator>
                            <AjaxToolkit:ValidatorCalloutExtender ID="vcetxtofstimerunhr" runat="server" TargetControlID="rfvtxtofstimerunhr">
                            </AjaxToolkit:ValidatorCalloutExtender>
                            &nbsp; : &nbsp;--%>
                            <asp:TextBox ID="txtofstimerunmin" runat="server" CssClass="text" MaxLength="2" Width="35"
                                OnCopy="return false;" OnPaste="return false;" OnDrag="return false;" OnDrop="return false;"
                                onkeypress="allowOnlyNumber(this,true);" onkeyup="CheckForMin(this,'Invalid entry for Offset Time AsRun Min.')" /> min.
                           <%-- <asp:RequiredFieldValidator ID="rfvtxtofstimerunmin" runat="server" ValidationGroup="save" ControlToValidate="txtofstimerunmin"
                                Display="None" SetFocusOnError="true" ErrorMessage="Please enter Offset Time AsRun Min."></asp:RequiredFieldValidator>
                            <AjaxToolkit:ValidatorCalloutExtender ID="vcetxtofstimerunmin" runat="server" TargetControlID="rfvtxtofstimerunmin">
                            </AjaxToolkit:ValidatorCalloutExtender>
                            <span class='lblmandatory'>*</span>--%>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="bottom_action">
                <ul>
                    <li>
                        <asp:Button ID="btnSave" runat="server" Text="Save" OnClientClick="return checkForsave();" CssClass="btn btn-primary" OnClick="btnSave_Click" /></li>
                    <li>
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-primary" CausesValidation="false"
                            OnClick="btnCancel_Click" OnClientClick="return Cancelvalidation();"/></li>
                </ul>
            </div>
            <asp:HiddenField ID="hdnIntCode" runat="server" />
            <asp:HiddenField ID="hdnEntityType" runat="server" />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
