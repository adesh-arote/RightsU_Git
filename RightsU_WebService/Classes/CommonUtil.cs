using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using RightsU_BLL;
using RightsU_Entities;


public class CommonUtil
{
  
    #region --- Write Log File ---
    /*
     * Pass errorFileName with extention e.g. errorLog.txt
     */
    public static void WriteErrorLog(string ex, string errorFileName)
    {
        string fullfileName = System.Web.HttpContext.Current.Server.MapPath("~/" + errorFileName);
        string writeErrLog = System.Configuration.ConfigurationManager.AppSettings["WriteErrLog"];
        if (writeErrLog == "Y")
        {
            try
            {
                StreamWriter w = File.AppendText(fullfileName);
                Log(ex, w);
                w.Close();
            }
            catch (Exception e)
            {
                Console.Out.WriteLine("Error writing error log");
                Console.Out.WriteLine(e.Message);
            }
        }
    }
    public static void Log(String logMessage, StreamWriter w)
    {
        try
        {
            w.WriteLine("{0} {1}", DateTime.Now.ToLongDateString(), DateTime.Now.ToLongTimeString());
            //w.WriteLine("  :");
            w.WriteLine("  :{0}", logMessage);
            w.WriteLine("-------------------------------");
            w.Flush();
        }
        catch (Exception e)
        {
            Console.Out.WriteLine("Error writing log");
            Console.Out.WriteLine(e.Message);
        }
    }
    #endregion
}
