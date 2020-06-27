using System;

namespace UTOFrameWork.FrameworkClasses {
    /// <summary>
    /// Summary description for MyMessageShow.
    /// </summary>
    public class MessageShow {

        public static void CreateMessageAlert(System.Web.UI.Page senderPage, string alertMsg, string alertKey)
        {
            alertMsg = alertMsg.Replace("'", "\'");
            string strScript = "<script language=JavaScript>alert(\"" + alertMsg + "\")</script>";
            if (!senderPage.ClientScript.IsStartupScriptRegistered(alertKey))
            {
                senderPage.ClientScript.RegisterStartupScript(senderPage.GetType(), alertKey, strScript);
            }
        }

        public static void AlertNadRedirect(System.Web.UI.Page senderPage, string alertMsg, string alertKey, string strURL)
        {
            alertMsg = alertMsg.Replace("'", "\'");
            string strScript = "<script language=JavaScript>function AlertNadRedirect(){ alert(\"" + alertMsg + "\");"
                + " window.location = '" + strURL + "';} AlertNadRedirect();</script>";
            if (!senderPage.ClientScript.IsStartupScriptRegistered(alertKey))
            {
                senderPage.ClientScript.RegisterStartupScript(senderPage.GetType(), alertKey, strScript);
            }
        }

        public System.Text.StringBuilder hideBtn(System.Web.UI.Control btn, System.Web.UI.Page senderPage)
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append("if (typeof(Page_ClientValidate) == 'function') { ");
            sb.Append("if (Page_ClientValidate() == false) { return false; }} ");
            sb.Append("this.value = 'Please wait...';");
            sb.Append("this.disabled = true; return false; ");
            sb.Append(senderPage.ClientScript.GetPostBackEventReference(btn, ""));
            sb.Append(";");

            return sb;
        }

    }
}
