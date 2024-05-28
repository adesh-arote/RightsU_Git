using System;
using Newtonsoft.Json;
using System.Configuration;
using System.IO;
using System.Web.Hosting;

namespace UTO_Notification.API.CustomFilter
{
    public class WriteLog
    {

        public static void Log(string method, string strLog, Object obj = null)
        {
            try
            {
                if (ConfigurationManager.AppSettings["WRITEFILELOG"].ToString() == "Yes")
                {
                    StreamWriter log;
                    FileStream fileStream = null;
                    DirectoryInfo logDirInfo = null;
                    FileInfo logFileInfo;

                    var date = DateTime.Now;
                    string logFilePath = HostingEnvironment.MapPath("~/" + "/" + System.DateTime.Today.ToString("dd-MMM-yyyy") + "/");   //"D:\\TRAILogs\\";
                    logFilePath = logFilePath + "Log-" + date.Hour + "." + "txt";
                    logFileInfo = new FileInfo(logFilePath);
                    logDirInfo = new DirectoryInfo(logFileInfo.DirectoryName);
                    if (!logDirInfo.Exists) logDirInfo.Create();
                    if (!logFileInfo.Exists)
                    {
                        fileStream = logFileInfo.Create();
                    }
                    else
                    {
                        fileStream = new FileStream(logFilePath, FileMode.Append);
                    }
                    log = new StreamWriter(fileStream);

                    if (obj != null)
                    {
                        string output = JsonConvert.SerializeObject(obj);
                        strLog = strLog + output;
                    }


                    log.WriteLine(DateTime.Now.ToString() + " | " + method + " : " + strLog);
                    log.Close();
                }
            }
            catch (Exception ex)
            {

            }


        }
    }
}