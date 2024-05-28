<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=14.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>

<html>
<head runat="server">
    <meta name="viewport" content="width=device-width" />
    <title></title>
    <script runat="server">
        void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindReport();
            }
        }

        private void BindReport()
        {
            ReportCredential();
            ReportViewer1.ServerReport.ReportPath = string.Empty;
            if (ReportViewer1.ServerReport.ReportPath == "")
            {
                UTOFrameWork.FrameworkClasses.ReportSetting objRS = new UTOFrameWork.FrameworkClasses.ReportSetting();
                ReportViewer1.ServerReport.ReportPath = objRS.GetReport(ViewBag.ReportName);
            }

            if (TempData["ReportParameter"] != null)
            {
                ReportParameter[] parm = (ReportParameter[])TempData["ReportParameter"];
                ReportViewer1.ServerReport.SetParameters(parm);
            }
            ReportViewer1.ServerReport.Refresh();
        }

        public void ReportCredential()
        {
            string IsCredentialRequired = ConfigurationManager.AppSettings["IsCredentialRequired"];

            if (IsCredentialRequired.ToUpper() == "TRUE")
            {
                string CredentialPassWord = ConfigurationManager.AppSettings["CredentialsUserPassWord"];
                string CredentialUser = ConfigurationManager.AppSettings["CredentialsUserName"];
                string CredentialdomainName = ConfigurationManager.AppSettings["CredentialdomainName"];
                ReportViewer1.ServerReport.ReportServerCredentials = new ReportServerCredentials(CredentialUser,CredentialPassWord,CredentialdomainName);
            }

            ReportViewer1.Visible = true;
            ReportViewer1.ServerReport.Refresh();
            ReportViewer1.ProcessingMode = ProcessingMode.Remote;

            if (ReportViewer1.ServerReport.ReportServerUrl.OriginalString == "http://localhost/reportserver")
                ReportViewer1.ServerReport.ReportServerUrl = new Uri(ConfigurationManager.AppSettings["ReportingServer"]);
        }

    </script>
    <script>
        $(document).ready(function () {

            $('#ReportFrameReportViewer1').load(function () {
                $(this).contents().find('frame#report').each(function () {
                    $(this.contentDocument).find('#oReportDiv').each(function () {
                        $(this).css('overflow', 'initial');
                    });
                });
            });
            $('#divResult').css({ 'border': '2px solid black' });
        });

    </script>
    <style>
        #ReportViewer1 {
            height: 523px !important;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="0">
            </asp:ScriptManager>
            <div>
                <rsweb:ReportViewer ID="ReportViewer1" ShowParameterPrompts="false" runat="server"
                    Width="100%" Visible="false" CssClass="reportViewer">
                </rsweb:ReportViewer>
            </div>
        </div>
    </form>
</body>
</html>
