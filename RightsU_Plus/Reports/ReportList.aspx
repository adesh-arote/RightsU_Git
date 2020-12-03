<%@ Page Language="C#" AutoEventWireup="true" Inherits="Reports_ReportList"
    EnableEventValidation="false" CodeBehind="ReportList.aspx.cs" MasterPageFile="~/Home.Master" %>


<asp:Content ID="Content2" ContentPlaceHolderID="CphdBody" runat="Server">
    <link rel="stylesheet" href="../Master/stylesheet/AjaxControlToolkit.css?v=<%# ConfigurationManager.AppSettings["Version_No"] %>" />

    <script type="text/javascript" src="../Master/JS/master.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script dftype="text/javascript" src="../Master/JS/common.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/AjaxControlToolkit.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/AjaxUpdater.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/Ajax.js?v=<%# ConfigurationManager.AppSettings["Version_No"] %>"></script>
    <script type="text/javascript" src="../Master/JS/HTTP.js"></script>

    <script type="text/javascript" src="../JS_Core/jquery-1.11.1.min.js"></script>
    <script type="text/javascript" src="../JS_Core/jquery-ui.min.js"></script>
    <script type="text/javascript" src="../JS_Core/chosen.jquery.min.js"></script>

    <script type="text/javascript" src="../JS_Core/common.concat.js"></script>
    <link href="../CSS/Master_ASPX.css" rel="stylesheet" />

    <%--Start Chosen--%>

    <link href="../CSS/chosen.min.css" rel="stylesheet" />
    <%--End Chosen--%>

    <script type="text/javascript">
        $(document).ready(function () {
            AssignChosenJQuery();

        });

        function AssignChosenJQuery() {
            $('.Chosenlb').chosen({ width: "auto" });
        }
    </script>
    <style type="text/css">
        #gvReport td {
            height: 30px;
            cursor: default;
        }

        .tbSearch {
            margin-bottom: 25px;
            border-bottom: 1px dotted;
        }

            .tbSearch td {
                padding: 7px 2px 8px 5px;
            }

        #ddlBusinessUnit_Chosen {
            max-width: 48% !important;
            min-width: 48% !important;
        }

        #CphdBody_ddlBusinessUnit_chosen {
            width: 57% !important;
            max-width: 57% !important;
        }
        #CphdBody_ddlView_chosen{
             width: 80% !important;
            max-width: 80% !important;
        }
        .hnd{
            cursor: pointer !important;
        }
    </style>

    <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0">
    </asp:ScriptManager>
    <div class="title_block dotted_border clearfix">
        <h2 class="pull-left">
            <asp:Label runat="server" ID="lblTitle" Text="Query Report List"></asp:Label>
        </h2>
        <div class="right_nav pull-right">
            <ul>
                <li>
                    <asp:Button CssClass="btn btn-primary" ID="btnNew" runat="server" Text="New query" OnClick="btnNew_Click" /></li>
            </ul>
        </div>
    </div>

    <div class="search_area" id="trSearch">
        <table class="table">
            <tr>
                <td style="width: 280px">
                    <asp:DropDownList runat="server" CssClass="select Chosenlb" ID="ddlView" Width="80%"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlView_SelectedIndexChanged">
                    </asp:DropDownList>
                </td>
                <%--<td style="width: 7% !important;text-align:right;">
                    
                </td>--%>
                <td style="width: 383px;">
                    <b>Business Unit:</b>
                    <asp:DropDownList runat="server" CssClass="select Chosenlb" ID="ddlBusinessUnit" Width="57%"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlBusinessUnit_SelectedIndexChanged">
                    </asp:DropDownList>
                </td>
                <td>
                    <label class="checkbox-inline">
                        <asp:CheckBox runat="server" ID="chkTheatricalTerritory" />
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Theatrical Territory
                    </label>

                    <label class="checkbox-inline">
                        <asp:CheckBox runat="server" ID="chkExpired" />
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Expired Deals
                    </label>
                </td>
            </tr>
        </table>
    </div>
    <div class="paging_area clearfix">
    </div>
    <div class="table-wrapper">
        <asp:GridView ID="gvReport" runat="server" AutoGenerateColumns="False" CssClass='table table-bordered table-hover'
            DataKeyNames="IntCode" OnRowCommand="gvReport_RowCommand" OnRowDeleting="gvReport_RowDeleting" OnRowDataBound="gvReport_RowDataBound">
            <Columns>
                <asp:TemplateField HeaderText="Code" Visible="False">
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("IntCode") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Query" ItemStyle-Width="30%">
                    <ItemTemplate>
                        <asp:LinkButton ID="lbQuery" runat="server" Text='<%# Eval("QueryName") %>' CommandName="Query"
                            CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" CssClass="hnd"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Theatrical Territory" ItemStyle-Width="20%">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="lblTheatrical" Text='<%# Convert.ToString(Eval("Theatrical_Territory")) == "Y" ? "Yes" : "No"  %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Expired Deals" ItemStyle-Width="15%">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="lblExpired" Text='<%# Convert.ToString(Eval("Expired_Deals")) == "Y" ? "Yes" : "No" %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Created By" ItemStyle-Width="15%">
                    <ItemTemplate>
                        <asp:Label ID="lblCreatedBy" runat="server" Text='<%# Eval("InsertedBy") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Action" ItemStyle-Width="20%">
                    <ItemTemplate>
                        <asp:Button ID="btnDelete" runat="server" CssClass="button" CommandArgument='<%# Container.DataItemIndex %>'
                            CausesValidation="false" CommandName="Delete" Text="Delete" />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:HiddenField ID="hfIndex" runat="server" />
    </div>
</asp:Content>
