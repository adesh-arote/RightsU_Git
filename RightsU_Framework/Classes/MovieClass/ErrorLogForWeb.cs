using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.IO;
using System.Web.UI.HtmlControls;

/// <summary>
/// Summary description for ErrorLogForWeb
/// </summary>
public class ErrorLogForWeb
{
	public ErrorLogForWeb()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    #region --Methods--

    public static void ErrLogForWebService(Exception objEx)
    {
        try
        {
            string path = System.Configuration.ConfigurationManager.AppSettings["LogFilePath"].ToString();

            StreamWriter writer = new StreamWriter(path, true);
            if (File.Exists(path) == false)
            {
                writer = new StreamWriter(new FileStream(path, FileMode.Create, FileAccess.Write));
            }
            writer.WriteLine(">> " + objEx.StackTrace + " <<");
            writer.WriteLine("ErrMsg:" + objEx.Message + ", " + System.DateTime.Now);
            writer.Flush();
            writer.Close();
        }
        catch (Exception OpenEx)
        {
            // ErrLogForWebService(OpenEx);
        }
    }

    public static void LocalErrorLog(Exception objEx)
    {
        try
        {
            string path = System.Configuration.ConfigurationManager.AppSettings["LocalErrorPath"].ToString();

            StreamWriter writer = new StreamWriter(path, true);
            if (File.Exists(path) == false)
            {
                writer = new StreamWriter(new FileStream(path, FileMode.Create, FileAccess.Write));
            }
            writer.WriteLine(">> " + objEx.StackTrace + " <<");
            writer.WriteLine("ErrMsg:" + objEx.Message + ", " + System.DateTime.Now);
            writer.Flush();
            writer.Close();
        }
        catch (Exception OpenEx)
        {
           // LocalErrorLog(OpenEx);
        }
    }
    #endregion
}
