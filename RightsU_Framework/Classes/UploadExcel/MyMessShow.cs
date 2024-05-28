using System;
using System.Web.UI.WebControls;
using UTOFrameWork.FrameworkClasses;

/// <summary>
/// Summary description for MyMessShow
/// </summary>
public class MyMessShow
{
	public MyMessShow()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    public void CreateMessageAlert(System.Web.UI.Page senderPage, string alertMsg, string alertKey)
    {
        string strScript = "<script language=JavaScript>alert('" + alertMsg + "')</script>";
        if (!(senderPage.IsStartupScriptRegistered(alertKey)))
        {
            senderPage.RegisterStartupScript(alertKey, strScript);
        }
    }
    public System.Text.StringBuilder hideBtn(System.Web.UI.Control btn, System.Web.UI.Page senderPage)
    {
        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        sb.Append("if (typeof(Page_ClientValidate) == 'function') { ");
        sb.Append("if (Page_ClientValidate() == false) { return false; }} ");
        sb.Append("this.value = 'Please wait...';");
        sb.Append("this.disabled = true; return false; ");
        sb.Append(senderPage.GetPostBackEventReference(btn));
        sb.Append(";");

        return sb;
    }
}
