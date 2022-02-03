using System;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http.Filters;
using System.Configuration;
using System.Net;
using System.IO;
using System.Security.Cryptography;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Web.Http;
using UTO_Notification.API.CustomFilter;
using System.Web;
using UTO_Notification.Entities;
using UTO_Notification.Controllers;
using System.Web.Hosting;

namespace UTO_Notification.API.AuthFilter
{
    public class AuthAttribute : ActionFilterAttribute, IAuthenticationFilter
    {
        public Task AuthenticateAsync(HttpAuthenticationContext context, CancellationToken cancellationToken)
        {
            UTOLog logObj = new UTOLog();
            logObj.ApplicationName = "Notification Engine";
            Boolean isSuccess = false; double TimeTaken;
            DateTime startTime;
            startTime = DateTime.Now;
            IEnumerable<string> requstAuthKey = context.Request.Headers.GetValues("AuthKey");
            var myListrequstAuthKey = requstAuthKey.ToList();
            IEnumerable<string> requstService = context.Request.Headers.GetValues("Service");
            var myListrequstService = requstService.ToList();
            string storedKeys = ConfigurationManager.AppSettings["storedKeys"].ToString();
            string[] sKeys;
            sKeys = storedKeys.Split(',');

            if (myListrequstAuthKey[0] == "")
            {
                var resp = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                {
                    ReasonPhrase = "Not Authenticated"
                };
                throw new HttpResponseException(resp);
            }
            else
            {
                if (myListrequstService[0] == "false")
                {
                    TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;

                    if (sKeys.Contains(myListrequstAuthKey[0].ToString()))
                    {
                        return Task.FromResult<object>(null);

                    }
                    else
                    {
                        var resp = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                        {
                            ReasonPhrase = "Not Authenticated"
                        };
                        throw new HttpResponseException(resp);
                    }
                }
                else
                {
                    //* write Log on collected server ip address *//
                    string ipAddress = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                    if (string.IsNullOrEmpty(ipAddress))
                    {
                        ipAddress = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
                    }
                    WriteLog.Log(ipAddress, "AuthenticateAsync :IPAddress ", ipAddress);

                    //*  return ip; *//

                    //string strHostName = "";
                    //strHostName = Dns.GetHostName();
                    //IPHostEntry ipEntry = Dns.GetHostEntry(strHostName);
                    //IPAddress[] addr = ipEntry.AddressList;
                    //string ipAddress = addr[addr.Length - 1].ToString();

                    //* Encrypted *//

                    string salt = ConfigurationManager.AppSettings["salt"].ToString();

                    byte[] bytesToBeEncrypted = Encoding.UTF8.GetBytes(salt);
                    byte[] passwordBytes = Encoding.UTF8.GetBytes(ipAddress);

                    byte[] bytesEncrypted = AES_Encrypt(bytesToBeEncrypted, passwordBytes);

                    string result = Convert.ToBase64String(bytesEncrypted);

                    if (result == myListrequstAuthKey[0].ToString() && sKeys.Contains(myListrequstAuthKey[0].ToString()))
                    {
                        return Task.FromResult<object>(null);

                    }
                    else
                    {
                        var resp = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                        {
                            ReasonPhrase = "Not Authenticated"
                        };
                        TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
                        Anuthorised(ipAddress, resp, TimeTaken);
                        throw new HttpResponseException(resp);
                    }
                }

            }
        }

        private void Anuthorised(string ipAddress, HttpResponseMessage resp, double TimeTaken)
        {
            UTOLog logObj = new UTOLog();
            logObj.RequestUri = System.Web.HttpContext.Current.Request.Url.AbsoluteUri;
            logObj.RequestMethod = System.Web.HttpContext.Current.Request.Url.AbsolutePath;
            logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy hh:mm:ss");
            logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy hh:mm:ss");
            logObj.ResponseContent = resp.ReasonPhrase;
            logObj.ResponseLength = Convert.ToString(resp.ReasonPhrase.Length);
            logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
            logObj.UserAgent = "Notification API";
            logObj.Method = System.Web.HttpContext.Current.Request.RequestType;
            logObj.ClientIpAddress = ipAddress; //(HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();
            logObj.IsSuccess = "False";
            logObj.TimeTaken = Convert.ToString(TimeTaken);
            logObj.HttpStatusCode = resp.StatusCode.ToString();
            logObj.HttpStatusDescription = resp.ReasonPhrase;
            HostingEnvironment.QueueBackgroundWorkItem(ctx => LogService(logObj, (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString()));
            // var result = new NotificationController().LogService(logObj);
        }


        private byte[] AES_Encrypt(byte[] bytesToBeEncrypted, byte[] passwordBytes)
        {
            byte[] encryptedBytes = null;
            byte[] saltBytes = new byte[] { 1, 2, 3, 4, 5, 6, 7, 8 };
            using (MemoryStream ms = new MemoryStream())
            {
                using (RijndaelManaged AES = new RijndaelManaged())
                {
                    AES.KeySize = 256;
                    AES.BlockSize = 128;

                    var key = new Rfc2898DeriveBytes(passwordBytes, saltBytes, 1000);
                    AES.Key = key.GetBytes(AES.KeySize / 8);
                    AES.IV = key.GetBytes(AES.BlockSize / 8);

                    AES.Mode = CipherMode.CBC;

                    using (var cs = new CryptoStream(ms, AES.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(bytesToBeEncrypted, 0, bytesToBeEncrypted.Length);
                        cs.Close();
                    }
                    encryptedBytes = ms.ToArray();
                }
            }

            return encryptedBytes;
        }

        public Task ChallengeAsync(HttpAuthenticationChallengeContext context, CancellationToken cancellationToken)
        {
            return Task.FromResult<object>(null);
        }

        public static void LogService(string content)
        {
            try
            {
                string rootLogFolderPath = ConfigurationSettings.AppSettings["LogFolderPath"];
                string FileName = rootLogFolderPath + "NotificationService" + "_" + DateTime.Now.Date.ToString("dd-MMM-yyyy") + "_" + "Log.txt";
                FileStream fs = new FileStream(FileName, FileMode.OpenOrCreate, FileAccess.Write);
                StreamWriter sw = new StreamWriter(fs);
                sw.BaseStream.Seek(0, SeekOrigin.End);
                sw.WriteLine(content);
                sw.Flush();
                sw.Close();
            }
            catch (Exception ex)
            {
                LogError("Not able to write to file - " + ex.InnerException);
            }
        }
        public static void LogService(UTOLog obj, string AuthKey)
        {
            int timeout = 3600;
            string result = "";
            string url = ConfigurationSettings.AppSettings["LogURL"];
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.KeepAlive = false;
            request.ProtocolVersion = HttpVersion.Version10;
            request.ContentType = "application/Json";
            request.Method = "POST";
            request.Headers.Add("ContentType", "application/json");
            request.Headers.Add("AuthKey", AuthKey);
            request.Headers.Add("Service", "True");
            if (obj.RequestContent == null)
            {
                obj.RequestContent = "";
            }
            using (var streamWriter = new StreamWriter(request.GetRequestStream()))
            {
                string json = "{" + "\"ApplicationName\": \"Notification Engine\"," +
                        "\"RequestId\": \"" + obj.RequestId + "\"," +
                        "\"User\": \"" + obj.UserId + "\"," +
                        "\"RequestUri\": \"" + obj.RequestUri + "\"," +
                        "\"RequestMethod\": \"" + obj.RequestMethod + "\"," +
                        "\"Method\": \"" + obj.Method + "\"," +
                        "\"IsSuccess\": \"" + obj.IsSuccess + "\"," +
                        "\"TimeTaken\": \"" + obj.TimeTaken + "\"," +
                        "\"RequestContent\": \"" + obj.RequestContent.Replace("\"", "'") + "\"," +
                        "\"RequestLength\": \"" + obj.RequestLength + "\"," +
                        "\"RequestDateTime\": \"" + obj.RequestDateTime + "\"," +
                        "\"ResponseContent\": \"" + obj.ResponseContent + "\"," +
                        "\"ResponseLength\": \"" + obj.ResponseLength + "\"," +
                        "\"ResponseDateTime\": \"" + obj.ResponseDateTime + "\"," +
                        "\"HttpStatusCode\": \"\"," +
                        "\"HttpStatusDescription\": \"\"," +
                        "\"AuthenticationKey\": \"\"," +
                        "\"UserAgent\": \"" + obj.UserAgent + "\"," +
                        "\"ServerName\": \"" + obj.ServerName + "\"," +
                        "\"ClientIpAddress\": \"" + obj.ClientIpAddress + "\""
                    + "}";
                streamWriter.Write(json);
            }
            var httpResponse = (HttpWebResponse)request.GetResponse();
            try
            {
                using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                {
                    result = streamReader.ReadToEnd();
                }
            }
            catch (Exception ex)
            {
                request.Abort();
                LogService("Not able to post to Log Service");
            }
            if (result != "")
            {
                //request posted successfully;	
            }

        }

        private static void LogError(string content)
        {
            UTOLog logObj = new UTOLog();
            logObj.RequestId = "0";
            logObj.UserId = "-1";
            logObj.RequestContent = "";
            logObj.RequestLength = "0";
            logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy hh:mm:ss");
            logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy hh:mm:ss");
            logObj.ResponseContent = content;
            logObj.ResponseLength = Convert.ToString(logObj.ResponseContent.Length);
            logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
            logObj.UserAgent = "Notification Service";
            logObj.Method = "Email";
            logObj.ClientIpAddress = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();
            logObj.IsSuccess = "false";
            // LogService(logObj);
            HostingEnvironment.QueueBackgroundWorkItem(ctx => LogService(logObj, (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString()));

        }
    }
}