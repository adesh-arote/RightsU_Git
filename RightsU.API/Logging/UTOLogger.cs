﻿using Newtonsoft.Json;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;

namespace RightsU.API.Logging
{
    public class UTOLogger
    {
        public async static Task<string> LogService(UTOLogInput obj, string AuthKey)
        {
            int timeout = 3600;
            string result = "";

            try
            {
                string url = ConfigurationSettings.AppSettings["LogURL"];
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);

                try
                {
                    request.KeepAlive = false;
                    request.ProtocolVersion = HttpVersion.Version10;
                    request.ContentType = "application/Json";
                    request.Method = "POST";
                    request.Headers.Add("ContentType", "application/json");
                    request.Headers.Add("AuthKey", AuthKey);
                    request.Headers.Add("Service", "false");
                    if (obj.RequestContent == null)
                    {
                        obj.RequestContent = "";
                    }

                    using (var streamWriter = new StreamWriter(request.GetRequestStream()))
                    {
                        string logData = JsonConvert.SerializeObject(obj);
                        streamWriter.Write(logData);
                    }

                    var httpResponse = (HttpWebResponse)request.GetResponse();

                    using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                    {
                        result = streamReader.ReadToEnd();
                    }
                }
                catch (Exception ex)
                {
                    request.Abort();                    
                    LogService(JsonConvert.SerializeObject(obj));                    
                }
                if (result != "")
                {
                    //request posted successfully;	
                }                
            }
            catch(Exception ex)
            {
                LogService(JsonConvert.SerializeObject(obj));
            }
            return result;
        }

        public static void LogService(string content)
        {
            try
            {
                content = String.Format("============================================================{0}============================================================\n{1}", DateTime.Now.ToString("ddMMMyyyy HH:mm:ss"), content);

                string rootLogFolderPath = HttpContext.Current.Server.MapPath("~/ErrorLog//"); //ConfigurationSettings.AppSettings["LogFolderPath"];
                string FileName = rootLogFolderPath + "AssetsLog" + "_" + DateTime.Now.Date.ToString("dd-MMM-yyyy") + "_" + "Log.txt";
                if (!Directory.Exists(rootLogFolderPath))
                {
                    Directory.CreateDirectory(rootLogFolderPath);
                }
                FileStream fs = new FileStream(FileName, FileMode.OpenOrCreate, FileAccess.Write);
                StreamWriter sw = new StreamWriter(fs);
                sw.BaseStream.Seek(0, SeekOrigin.End);
                sw.WriteLine(content);
                sw.Flush();
                sw.Close();
            }
            catch (Exception ex)
            {
                //LogError("Not able to write to file - " + ex.InnerException);
            }
        }
    }
}