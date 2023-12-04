using Newtonsoft.Json;
using RightsU.Audit.Entities.HttpModel;
using RightsU.Audit.Entities.InputEntities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Hosting;
using System.Web.Http.Filters;

namespace RightsU.Audit.WebAPI.Filters
{
    public class LogFilter : ActionFilterAttribute
    {
        public override void OnActionExecuted(HttpActionExecutedContext actionExecutedContext)
        {
            UTOLogInput logObj = new UTOLogInput();

            try
            {
                logObj.ApplicationName = "AuditLog";
                logObj.RequestId = Guid.NewGuid().ToString();
                logObj.RequestUri = actionExecutedContext.Request.RequestUri.AbsoluteUri;
                logObj.RequestMethod = actionExecutedContext.Request.RequestUri.AbsolutePath;
                if (actionExecutedContext.Request.Method.Method == "GET")
                {
                    logObj.RequestContent = JsonConvert.SerializeObject(actionExecutedContext.ActionContext.ActionArguments);
                    logObj.IsSuccess = Convert.ToString(((RightsU.Audit.Entities.FrameworkClasses.GetReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).IsSuccess);
                    logObj.TimeTaken = Convert.ToString(((RightsU.Audit.Entities.FrameworkClasses.GetReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).TimeTaken);                    
                }
                else
                {
                    logObj.RequestContent = JsonConvert.SerializeObject(actionExecutedContext.ActionContext.ActionArguments["Input"]);
                    logObj.IsSuccess = Convert.ToString(((RightsU.Audit.Entities.FrameworkClasses.PostReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).IsSuccess);
                    logObj.TimeTaken = Convert.ToString(((RightsU.Audit.Entities.FrameworkClasses.PostReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).TimeTaken);
                }

                logObj.RequestLength = Convert.ToString(logObj.RequestContent.ToString().Length);
                logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                logObj.ResponseContent = JsonConvert.SerializeObject(((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value);
                logObj.ResponseLength = Convert.ToString(logObj.ResponseContent.Length);
                logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
                logObj.UserAgent = "AutidLog API";
                logObj.Method = actionExecutedContext.Request.Method.Method;
                logObj.ClientIpAddress = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();

                logObj.HttpStatusCode = Convert.ToString(actionExecutedContext.Response.StatusCode.GetHashCode());

                string GlobalAuthKey = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString();
                logObj.AuthenticationKey = GlobalAuthKey;

                var logDetails = LogService(logObj, GlobalAuthKey);
                HttpResponses logData = JsonConvert.DeserializeObject<HttpResponses>(logDetails);
                if (logData.LGCode > 0)
                {
                    actionExecutedContext.Response.Headers.Add("requestid", logObj.RequestId);
                    if (logObj.Method == "GET")
                    {
                        actionExecutedContext.Response.Headers.Add("message", ((RightsU.Audit.Entities.FrameworkClasses.GetReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).Message);
                        actionExecutedContext.Response.Headers.Add("issuccess", ((RightsU.Audit.Entities.FrameworkClasses.GetReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).IsSuccess.ToString());
                    }
                    else
                    {
                        actionExecutedContext.Response.Headers.Add("message", ((RightsU.Audit.Entities.FrameworkClasses.PostReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).Message);
                        actionExecutedContext.Response.Headers.Add("issuccess", ((RightsU.Audit.Entities.FrameworkClasses.PostReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).IsSuccess.ToString());
                    }
                    

                }
            }
            catch (Exception ex)
            {

                //throw;
            }
        }

        public static string LogService(UTOLogInput obj, string AuthKey)
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
            request.Headers.Add("Service", "False");
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
                //LogService("Not able to post to Log Service");
            }
            if (result != "")
            {
                //request posted successfully;	
            }
            return result;
        }
    }
}