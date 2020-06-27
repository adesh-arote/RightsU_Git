<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BVTitleMapping_Schedule.aspx.cs" Inherits="BVTitleMapping_Schedule" MasterPageFile="~/Home.Master" 
     UnobtrusiveValidationMode="None" %>

<%@ Register TagPrefix="UTO" Namespace="UTOFrameWork.FrameworkClasses" Assembly="RightsU_Plus" %>


<%--<!DOCTYPE html>
<html xmlns="">
<head id="Head1" runat="server">
    <title></title>--%>
<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">

    <script src="../JS_Core/autoNumeric-1.8.1.js"></script>
    <link href="../CSS/jquery-ui.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" rel="stylesheet" />
    <link href="../CSS/Master_ASPX.css" rel="stylesheet" />

    <script type="text/javascript" src="../JS_Core/jquery.expander.js"></script>

    <script type="text/javascript" src="../Master/JS/master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="../Master/JS/common.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script src="../JS_Core/jquery.watermarkinput.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="../Master/JS/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script src="../JS_Core/watermark.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="../Master/JS/AjaxUpdater.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script src="../JS_Core/jquery.plugin.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="../Master/JS/Ajax.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../JS_Core/jquery-1.11.1.min.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="../JS_Core/common.concat.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>

    <script type="text/javascript" src="../JS_Core/jquery.expander.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../JS_Core/jquery-ui.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <link rel="Stylesheet" href="../Master/Stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />
    <script src="../JS_Core/chosen.jquery.min.js"></script>
    <script type="text/javascript" src="../JS_Core/autoNumeric-1.8.1.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <style type="text/css">
        th.th2 {
            border-right: #0976C9 1px solid;
            font-weight: bold;
            font-size: 12px;
            color: #ffffff;
            position: relative;
            background-color: #0976C9;
            text-align: center;
            z-index: 10;
        }

        .completionList {
            border: solid 1px #444444;
            margin: 1px;
            padding: 2px; /*height: 150px;*/
            overflow: auto;
        }

        /*Popup*/
        #overlay {
            position: fixed;
            border: 15px solid #ccc;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: #000;
            filter: alpha(opacity=70);
            -moz-opacity: 0.7;
            -khtml-opacity: 0.7;
            opacity: 0.7;
            z-index: 100;
            display: none;
        }

        .popup {
            width: 83%;
            margin: auto;
            top: 10%;
            display: none;
            position: fixed;
            z-index: 1001;
        }

        .popupHeading {
            color: #686868;
            width: 95%;
            min-width: 95%;
            height: 30px;
            font-size: 20px;
            font-family: sans-serif;
            text-shadow: 1px 1px 1px #E0E0E0;
        }

        .content_RunErrorPopup {
            height: 435px !important;
        }

        .content {
            width: 600px;
            height: 700px;
            margin: auto;
            background: #f3f3f3;
            position: relative;
            z-index: 103;
            padding: 10px;
            border-radius: 5px; /*box-shadow: 0 2px 5px #000;*/
            box-shadow: 5px 5px 5px #888888;
            font-family: Arial,Helvetica,sans-serif;
            font-size: 12px;
        }

            .content .x {
                float: right;
                height: 35px;
                left: 22px;
                position: relative;
                top: -25px;
                width: 34px;
            }

                .content .x:hover {
                    cursor: pointer;
                }


        #RunErrorPopupContent {
            overflow: auto;
            height: 400px;
            width: 100%;
        }
        .ui-autocomplete {
            max-height:200px;
            overflow-y: auto;
            /* prevent horizontal scrollbar */
            overflow-x: auto;
            /* add padding to account for vertical scrollbar */
            /*padding-right: 20px;*/
           width:200px;
    }
    </style>

    <script type="text/javascript">

        var overlay = $('<div id="overlay"></div>');

        $(document).ready(function () {
            InitializeChosen();
        });

        function InitializeChosen() {
            $('.chosenDrop').chosen('Select Title');
        }

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

        function ExecuteSynchronously(url, method, args) {
            var executor = new Sys.Net.XMLHttpSyncExecutor();
            var request = new Sys.Net.WebRequest();            				             // Instantiate a WebRequest. 

            request.set_url(url + '/' + method);                                         // Set the request URL.
            request.set_httpVerb('POST');            					                 // Set the request verb. 
            request.get_headers()['Content-Type'] = 'application/json; charset=utf-8';   // Set request header. 
            request.set_executor(executor);            					                 // Set the executor. 
            request.set_body(Sys.Serialization.JavaScriptSerializer.serialize(args));    // Serialize arguments into JSON string. 

            request.invoke();															 // Execute the request.

            if (executor.get_responseAvailable()) {
                return (executor.get_object());
            }

            return (false);
        }

        function changeColor(CheckBoxObj, altYN) {
            if (CheckBoxObj.checked == true) {
                CheckBoxObj.parentNode.parentNode.parentNode.style.backgroundColor = "#f5f5f5";
            }
            else {
                    CheckBoxObj.parentNode.parentNode.parentNode.style.backgroundColor = "#FFF";
            }
        }
        function validateSearch() {
            var lbBVTitleSearch = $get("<%=lbBVTitleSearch.ClientID %>");

            if (lbBVTitleSearch.selectedOptions.length == "") {
                AlertModalPopup('lbBVTitleSearch', 'Please enter search criteria');
                return false;
            }
            else
                return true;
        }

        function ValidateOnFinalSave(source, args) {
            debugger;
            var lbBVTitleSearch = document.getElementById("<%= lbBVTitleSearch.ClientID %>");
            var tmpGvWOAssignment = document.getElementById("<%=gvTitleMapping.ClientID%>");
            var counter = 0;
            var hdnIntCode = document.getElementById("<%= hdnIntCode.ClientID%>");

            if (hdnIntCode.value == '')
                AlertModalPopup(lbBVTitleSearch, "Please select atleast one CheckBox");

            var arrstr = tmpGvWOAssignment.id + "_ctl";

            for (var i = 0; i < gvTitleMapping.rows.length-1; i++) {
                var c = i
                debugger;
                var txtDealTitles = document.getElementById("<%=gvTitleMapping.ClientID%>_txtDealTitles_" + c);
                var lblDealTitleCode = document.getElementById("<%=gvTitleMapping.ClientID%>_txtTitleCode_" + c);
                var chkTitle = document.getElementById("<%=gvTitleMapping.ClientID%>_chkCheckAll_"+ c);
                var lblEpisodeNo = document.getElementById("<%=gvTitleMapping.ClientID%>_lblEpisodeNo_"+ c );
                var lblBVTitleName = document.getElementById("<%=gvTitleMapping.ClientID%>_lblBVTitleName_" + c );
                var chk = document.getElementById("<%=gvTitleMapping.ClientID%>_chkIgnore_" +  c );

                if (chk.checked == true && chkTitle.checked == true) {
                    counter++;
                }

                if (chk.checked == false) {
                    if (chkTitle) {
                        if (chkTitle.checked == true) {
                            counter++;
                            if (txtDealTitles.value.trim() != '' && (ddlDealTitle.value == "0" || ddlDealTitle.value.trim() == "")) {
                                AlertModalPopup(ddlDealTitle, "Please Enter valid Deal title");
                                args.IsValid = false;
                                return;
                            }
                            else if (!chk.checked && ($(lblDealTitleCode).val() == '' || $(lblDealTitleCode).val() == '0')) {
                                AlertModalPopup(ddlDealTitle, "Please select either Ignore or Deal title to Map");
                                args.IsValid = false;
                                return;
                            }
                        }
                    }
                }
            }

            if (counter == 0) {
                AlertModalPopup(lbBVTitleSearch, "Please select atleast one CheckBox");
                args.IsValid = false;
            }

            if ((tmpGvWOAssignment.rows.length - 1) == 0) {
                AlertModalPopup(lbBVTitleSearch, "No Records have been affected");
                args.IsValid = false;
                return;
            }
        }

        function ValidateOnPageChange(source, args) {
            debugger;

            var tmpGvWOAssignment = document.getElementById("<%=gvTitleMapping.ClientID%>");
            var counter = 0;
            var hdnIntCode = document.getElementById("<%= hdnIntCode.ClientID %>");
            var arrstr = tmpGvWOAssignment.id + "_ctl";
            for (var i = 0; i < tmpGvWOAssignment.rows.length-1; i++) {
                    var c = i;
                    var txtDealTitles = document.getElementById("<%=gvTitleMapping.ClientID%>_txtDealTitles_" + c);
                    var ddlDealTitle = document.getElementById("<%=gvTitleMapping.ClientID%>_txtTitleCode_" + c);
                var chkTitle = document.getElementById("<%=gvTitleMapping.ClientID%>_chkCheckAll_" + c );
                var lblEpisodeNo = document.getElementById("<%=gvTitleMapping.ClientID%>_lblEpisodeNo_"+  c );
                var lblBVTitleName = document.getElementById("<%=gvTitleMapping.ClientID%>_lblBVTitleName_"  + c );
                var chk = document.getElementById("<%=gvTitleMapping.ClientID%>_chkIgnore_" + c );


                if (chkTitle) {
                    if (chkTitle.checked == true) {
                        if (chkTitle.checked == true) {
                            counter++;
                            if (txtDealTitles.value.trim() != '' && (ddlDealTitle.value == "0" || ddlDealTitle.value.trim() == ""))
                            {
                                AlertModalPopup(ddlDealTitle, "Please Enter valid Deal title");
                                args.IsValid = false;
                                return;
                            }
                            else if ((ddlDealTitle.value == "0" || ddlDealTitle.value.trim() == "") && chk.checked == false) {
                                AlertModalPopup(ddlDealTitle, "Please select either Ignore or Deal title to Map");
                                args.IsValid = false;
                                return;
                            }
                        }
                    }
                }
            }

            if ((tmpGvWOAssignment.rows.length - 1) == 0) {
                AlertModalPopup(lbBVTitleSearch, "No Records have been affected");
                args.IsValid = false;
                return;
            }
        }

        function validateCheckedRecords(source, args) {
            var hdnIntCode = document.getElementById("<%= hdnIntCode.ClientID %>");
        }
        function selectAllValue(id) {
            debugger;
            var headerChkBox = id;
            var hdnIntCode = document.getElementById("<%= hdnIntCode.ClientID %>");
            var gvTitleMapping = document.getElementById("<%= gvTitleMapping.ClientID %>");
            var altYN = 'Y';
            var arrstr = gvTitleMapping.id + "_ctl";
            for (var i = 0; i < gvTitleMapping.rows.length-1; i++) {
                var rowNum = i;
                var checkBox = document.getElementById("<%=gvTitleMapping.ClientID%>_chkCheckAll_" + rowNum);
                var lblIntCode = document.getElementById("<%=gvTitleMapping.ClientID%>_lblIntCode_" + rowNum);
                var IntCode = lblIntCode.innerHTML;
                checkBox.checked = headerChkBox.checked;

                if (checkBox.checked) {
                    hdnIntCode.value.replace('!' + IntCode + '~', '');
                    hdnIntCode.value = hdnIntCode.value + '!' + IntCode + '~';
                }
                else {
                    hdnIntCode.value = hdnIntCode.value.replace('!' + IntCode + '~', '');
                }

                changeColor(checkBox, altYN);

                if (altYN == 'Y')
                    altYN = 'N'
                else
                    altYN = 'Y'
            }



        }
        function selectCurrent(chkBox) {
            debugger;
            var chkBoxID = chkBox.id;
            var chkIgnore = document.getElementById(chkBoxID.replace('chkCheckAll', 'chkIgnore'));
            var txtDealTitles = document.getElementById(chkBoxID.replace('chkCheckAll', 'txtDealTitles'));
            var txtEpisodeNo = document.getElementById(chkBoxID.replace('chkCheckAll', 'txtEpisodeNo'));

            if ($(chkBox).prop("checked")) {
                $(txtDealTitles).removeAttr("disabled");
            }
            else {
                $(txtDealTitles).val('');
                $(txtEpisodeNo).val('');

                $(chkIgnore).prop('checked', false);
                $(txtDealTitles).attr("disabled", "disabled");
                $(txtEpisodeNo).attr("disabled", "disabled");
            }
        }
        function IntCodeInHdnField(idchk, IntCode) {
            debugger;
            var chkBox = document.getElementById(idchk);
            var hdnIntCode = document.getElementById("<%= hdnIntCode.ClientID %>");
            var txtDealTitles = document.getElementById(idchk.replace('chkCheckAll', 'txtDealTitles'));

            if (chkBox.checked) {
                hdnIntCode.value = hdnIntCode.value.replace('!' + IntCode + '~', '');
                hdnIntCode.value = hdnIntCode.value + '!' + IntCode + '~';
                $(txtDealTitles).removeAttr("disabled");
            }
            else {
                $(txtDealTitles).attr("disabled", "disabled");
                hdnIntCode.value = hdnIntCode.value.replace('!' + IntCode + '~', '');
            }
        }

        function CheckUnCheckIngnoreChk(chkClientID, gvTitleMapping, RowIndex) {
            debugger;
            var gvTitleMapping = document.getElementById(gvTitleMapping); //Find the GridView
            var chkMain = document.getElementById(chkClientID);
            var arrstr = gvTitleMapping.id + "_ctl";
            var counter = 0;
            for (var i = 0; i < gvTitleMapping.rows.length-1; i++) {
                var rowNum = i;
                var chk = document.getElementById("<%=gvTitleMapping.ClientID%>_chkIgnore_"+ rowNum );
                var chkCheckAll = document.getElementById("<%=gvTitleMapping.ClientID%>_chkCheckAll_" + rowNum );
                var txtDealTitles = document.getElementById("<%=gvTitleMapping.ClientID%>_txtDealTitles_" + rowNum);
                if (chkCheckAll.checked)
                if (chk.checked) {
                    counter++;
                    txtDealTitles.value = '';
                    txtDealTitles.disabled = true;
                }
                else {
                    txtDealTitles.disabled = false;
                }
            }
        }

        function GetEpisodeNo(obj) {
            debugger;
            var Method = "/GetDealTitlesForSchedule";
            var gvid = obj.id;
            var txtEpisodeNo = document.getElementById(gvid.replace('txtDealTitles', 'txtEpisodeNo'));
            var txtTitleCode = document.getElementById(gvid.replace('txtDealTitles', 'txtTitleCode'));
            if (obj.val == "") {
                $(txtTitleCode).val('');
            }

            $("*[id$=gvTitleMapping] input[id$=" + obj.id + "]").autocomplete({

                source: function (request, response) {

                    var param = { keyword: obj.value};
                    $.ajax({
                        url: '<%=ResolveUrl("~/Web_Service")%>' + Method,
                        data: JSON.stringify(param),
                        dataType: "json",
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        dataFilter: function (data) { return data; },
                        success: function (data) {
                            $(txtTitleCode).val('');
                            if (data.length == 0) {
                                data[0] = 'Result Not Found~0';
                                response($.map(data, function (v, i) {
                                    return {
                                        label: v.split('~')[0],
                                        val: v.split('~')[1]
                                    }
                                }))
                            }
                            else {
                                response($.map(data, function (v, i) {

                                    return {
                                        label: v.split('~')[0],
                                        val: v.split('~')[1]
                                    }

                                }))
                            }
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {

                            alert("Error" + textStatus);
                        }
                    });
                },
                select: function (event, ui) {
                    
                    var test = ui.item.val;

                    //if (test[0] > 0)
                    //    document.getElementById(hdnVal).innerHTML = test[0];

                    if (test.length == 3 && test[1] == test[2]) {
                        $(txtEpisodeNo).val(test[1]);
                        $(txtEpisodeNo).attr("disabled", "disabled");
                    }
                    else {
                        $(txtEpisodeNo).val('');
                        $(txtEpisodeNo).removeAttr("disabled");
                    }

                    //if (test[1] != null)
                    //    $(lblEpisodeStart).val(test[1]);
                    //else
                    //    $(lblEpisodeStart).val('0');

                    //if (test[2] != null)
                    //    $(lblEpisodeEnd).val(test[2]);
                    //else
                    //    $(lblEpisodeEnd).val('0');

                    $(txtTitleCode).val(ui.item.val);
                    //alert(hdnVal + ''  + ui.item.val);
                    if (ui.item.val == '0') {

                        return false;
                    }
                    else
                        return true;
                },
                minLength: 2
            });
        }

    </script>
        <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="updatePanelouter" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                    <div class="title_block dotted_border clearfix">
                        <h2 class="pull-left">BV Title Mapping </h2>
                        <div class="right_nav pull-right">
                            <ul>
                                <li>
                                    <%--<asp:Button ID="btnAdd" runat="server" CssClass="btn btn-primary" Text="Add" OnClick="btnAdd_Click"
                                        Width="50px" />--%>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="search_area">
                        <table class="table">
                            <tr>
                                <td class='normal' width="30%">&nbsp;&nbsp;BV Title:
                            <asp:ListBox runat="server" ID="lbBVTitleSearch" class="chosenDrop" multiple="true" Width="400px"
                                            SelectionMode="Multiple"></asp:ListBox>
                                        <asp:HiddenField ID="hdnBvTitle" runat="server" /></td>
                                <td class='normal'>
                                    <asp:Button ID="btnSearch" runat="server" CssClass="button" Text="Search" OnClick="btnSearch_Click" Width="60px" />&nbsp;
                            <asp:Button ID="btnShowAll" runat="server" CssClass="button" Text="Show All" OnClick="btnShowAll_Click" Width="60px" /></td>
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
                                            CommandArgument='<%#  ((UTOFrameWork.FrameworkClasses.AttribValue)Container.DataItem).Val %>' runat="server"  ValidationGroup="MAP1" />
                                        <asp:TextBox runat="server" ID="txtDummy1" TabIndex="-1" Style="display: none"></asp:TextBox>
                                                <asp:CustomValidator runat="server" ID="cvValidateSavePageChange" ClientValidationFunction="ValidateOnPageChange"
                                                    ValidationGroup="MAP1" EnableClientScript="true" ControlToValidate="txtDummy1"
                                                    Display="None" SetFocusOnError="false" ValidateEmptyText="true"></asp:CustomValidator>
                                    </ItemTemplate>
                                </asp:DataList>
                            </div>
                            
                        </div>
                    </div>
                   
                <div class="table-wrapper">
                            <asp:GridView ID="gvTitleMapping" runat="server" Width="100%" CellPadding="3" CellSpacing="0"
                                AutoGenerateColumns="false" ShowHeader="true" CssClass='table table-bordered table-hover'
                                 DataKeyNames="IntCode" OnRowDataBound="gvTitleMapping_RowDataBound">
                                <Columns>
                                    <asp:TemplateField HeaderText="CheckAll" ShowHeader="true">
                                        <HeaderTemplate>
                                            <asp:Label ID="lblCheckAll" runat="server" Text="Check All"></asp:Label>
                                            <input id="chkAll" type="checkbox" runat="server" onclick="javascript: selectAllValue(this)" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <input id="chkCheckAll" type="checkbox" runat="server" onclick="javascript: selectCurrent(this)" />
                                            <asp:Label ID="lblIntCode" Text='<%#Eval("IntCode") %>' runat="server" Style="display: none"></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="border" Width="10%" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Program Episode ID" HeaderStyle-Width="12%" ShowHeader="true">
                                        <ItemTemplate>
                                            <asp:Label ID="lblProgram_Episode_ID" runat="server" Text='<%# Eval("Program_Episode_ID") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="border" Width="12%" HorizontalAlign="Right" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="BV Title Name" HeaderStyle-Width="30%" ShowHeader="true">
                                        <ItemTemplate>
                                            <asp:Label ID="lblBVTitleName" runat="server" Text='<%# Eval("BVTitle") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="border" Width="30%" HorizontalAlign="left" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Episode No." HeaderStyle-Width="10%" ShowHeader="true">
                                        <ItemTemplate>
                                            <asp:Label ID="lblEpisodeNo" runat="server" Text='<%# Eval("EpisodeNumbers") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="border" Width="10%" HorizontalAlign="Right" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Ignore" HeaderStyle-Width="5%" ShowHeader="true" >
                                        <ItemTemplate>
                                            <input id="chkIgnore" type="checkbox" runat="server" />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="border" Width="5%" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <%--<asp:TemplateField HeaderText="Program_Version_ID" HeaderStyle-Width="20%" ShowHeader="true">
                                        <ItemTemplate>
                                            <asp:Label ID="lblProgram_Version_ID" runat="server" Text='<%# Eval("Program_Version_ID") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="border" Width="20%" HorizontalAlign="left" />
                                    </asp:TemplateField>--%>
                                    <asp:TemplateField HeaderText="Map To Deal Title:" HeaderStyle-Width="30%" ShowHeader="true">
                                        <ItemTemplate>
                                            <%--<AjaxToolkit:ListSearchExtender ID="lsextddlUsers" TargetControlID="ddlDealTitle"
                                                runat="server" PromptCssClass="ListSearchExtenderPrompt" PromptText="Type to search"
                                                QueryPattern="StartsWith" PromptPosition="Top">
                                            </AjaxToolkit:ListSearchExtender>--%>

                                            <%--<asp:DropDownList ID="ddlDealTitle" runat="server" CssClass="chosenDrop">
                                            </asp:DropDownList>--%>

                                            <asp:TextBox ID="txtDealTitles" runat="server" disabled="disabled" Width="250px" onkeypress="GetEpisodeNo(this)" onblur="GetEpisodeNo(this)"></asp:TextBox>
                                            <asp:TextBox ID="txtDummy2" runat="server" Style="display: none"></asp:TextBox>
                                            <asp:TextBox ID="txtTitleCode" runat="server" Style="display: none;"></asp:TextBox>
                                            <%--<asp:CustomValidator runat="server" ID="cvValidateTitleEpisodeRange" ClientValidationFunction="ValidateBVEpiWithTitleEpiRange"
                                                EnableClientScript="true" ControlToValidate="ddlDealTitle" Display="None" SetFocusOnError="false"
                                                ErrorMessage="BV Title episode no does not fall into episode range of deal title"></asp:CustomValidator>--%>
                                            <%--<AjaxToolkit:ValidatorCalloutExtender ID="vceValidateTitleEpisodeRange" runat="server"
                                                TargetControlID="cvValidateTitleEpisodeRange">
                                            </AjaxToolkit:ValidatorCalloutExtender>--%>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="border" Width="30%" HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                    </div>
                        
                <div class="bottom_action">
                <ul>
                    <li>
                            <asp:Button ID="btnMap" runat="server" Text="  MAP " OnClick="btnMap_Click" CssClass="button"
                                ValidationGroup="MAP1" />
                        </li>
                    <li>
                            <asp:Button ID="btnCancel" runat="server" Text="  Cancel " CssClass="button" CausesValidation="false"
                                OnClick="btnCancel_Click" />
                        </li>
                    </ul>
                    </div>
                      
                <asp:TextBox runat="server" ID="txtDummy" TabIndex="-1" Style="display: none"></asp:TextBox>
                <asp:CustomValidator runat="server" ID="cvValidateSave" ClientValidationFunction="ValidateOnFinalSave"
                    ValidationGroup="MAP" EnableClientScript="true" ControlToValidate="txtDummy"
                    Display="None" SetFocusOnError="false" ValidateEmptyText="true"></asp:CustomValidator>

                <asp:HiddenField runat="server" ID="hdnSearch" />
                <asp:HiddenField runat="server" ID="hdnIntCode" />
                <asp:HiddenField runat="server" ID="hdnExternalTitleData" />

                <div class='popup' id="MappingErrorPopup">
                    <div class='content'>
                        <img src="../images/fancy_close.png" alt='quit' class='x' id='x' onclick="ClosePopup('MappingErrorPopup')" />
                        <div class="popupHeading">
                            <asp:Label ID="lblPopupHead" runat="server" Text="Episodes not found for the following titles :"></asp:Label>
                        </div>
                        <div id="MappingErrorPopupContent">
                            <asp:GridView ID="gvMappingException" runat="server" AutoGenerateColumns="false" CssClass="tblBorder"
                                Width="100%" AlternatingRowStyle-CssClass="rowBg" CellPadding="3" HeaderStyle-CssClass="tableHd">
                                <Columns>
                                    <asp:TemplateField HeaderText="Title">
                                        <ItemTemplate>
                                            <asp:Label ID="lblITitle" runat="server" Text='<%# Eval("TitleName") %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" CssClass="border" Width="15%" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Episode No">
                                        <ItemTemplate>
                                            <asp:Label ID="lblIEpisode" runat="server" Text='<%# Eval("EpisodeNo") %> '></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" CssClass="border" Width="15%" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    <script type="text/javascript">
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
        function EndRequestHandler(sender, args) {
            InitializeChosen();
        }
    </script>
    </asp:Content>