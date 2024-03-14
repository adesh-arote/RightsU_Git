using Newtonsoft.Json;
using RightsU.API.Entities.HttpModel;
using RightsU.API.Entities;
using RightsU.API.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace RightsU.API.Filters
{
    public class SysLogFilter : ActionFilterAttribute
    {
        private const string _requestId = "";

        public override Task OnActionExecutingAsync(HttpActionContext actionContext, CancellationToken cancellationToken)
        {
            if (HttpContext.Current.Request.Headers["LogRequestId"] == null)
            {

                HttpContext.Current.Request.Headers.Add("LogRequestId", Guid.NewGuid().ToString());
                HttpContext.Current.Request.Headers.Add("ApiName", actionContext.ActionDescriptor.ActionName);
            }

            return base.OnActionExecutingAsync(actionContext, cancellationToken);
        }
        public override async Task OnActionExecutedAsync(HttpActionExecutedContext actionExecutedContext, CancellationToken cancellationToken)
        {
            UTOLogInput logObj = new UTOLogInput();

            if (actionExecutedContext.Response != null)
            {
                try
                {
                    logObj.ApplicationName = "Assets";
                    logObj.RequestId = HttpContext.Current.Request.Headers["LogRequestId"]; //Guid.NewGuid().ToString();
                    logObj.RequestUri = actionExecutedContext.Request.RequestUri.AbsoluteUri;
                    logObj.RequestMethod = actionExecutedContext.Request.RequestUri.AbsolutePath;
                    logObj.RequestContent = JsonConvert.SerializeObject(actionExecutedContext.ActionContext.ActionArguments);

                    ////if (actionExecutedContext.Request.Method.Method == "GET")
                    ////{
                    ////    logObj.RequestContent = JsonConvert.SerializeObject(actionExecutedContext.ActionContext.ActionArguments);                        
                    ////}
                    ////else
                    ////{
                    ////    logObj.RequestContent = JsonConvert.SerializeObject(actionExecutedContext.ActionContext.ActionArguments["Input"]);                        
                    ////}

                    //logObj.IsSuccess = Convert.ToString(((RightsU.API.Entities.FrameworkClasses.GenericReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).IsSuccess);
                    //logObj.TimeTaken = Convert.ToString(((RightsU.API.Entities.FrameworkClasses.GenericReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).TimeTaken);
                    logObj.IsSuccess = ((string[])actionExecutedContext.Response.Headers.Where(x => x.Key == "request_completion").Select(x => x.Value).FirstOrDefault())[0];
                    logObj.TimeTaken = ((string[])actionExecutedContext.Response.Headers.Where(x => x.Key == "timetaken").Select(x => x.Value).FirstOrDefault())[0];

                    logObj.RequestLength = Convert.ToString(logObj.RequestContent.ToString().Length);
                    logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseContent = JsonConvert.SerializeObject(((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value);
                    logObj.ResponseLength = Convert.ToString(logObj.ResponseContent.Length);
                    logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
                    logObj.UserAgent = "Asset API";
                    logObj.Method = actionExecutedContext.Request.Method.Method;
                    logObj.ClientIpAddress = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();

                    logObj.HttpStatusCode = Convert.ToString(actionExecutedContext.Response.StatusCode.GetHashCode());

                    string GlobalAuthKey = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString();
                    logObj.AuthenticationKey = GlobalAuthKey;

                    actionExecutedContext.Response.Headers.Add("requestid", logObj.RequestId);
                    actionExecutedContext.Response.Headers.Remove("timetaken");

                    //actionExecutedContext.Response.Headers.Add("message", ((RightsU.API.Entities.FrameworkClasses.GenericReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).Message);
                    //actionExecutedContext.Response.Headers.Add("issuccess", ((RightsU.API.Entities.FrameworkClasses.GenericReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).IsSuccess.ToString());

                    var logDetails = await UTOLogger.LogService(logObj, GlobalAuthKey);
                    HttpResponses logData = JsonConvert.DeserializeObject<HttpResponses>(logDetails);    
                }
                catch (Exception ex)
                {
                    //throw;
                }
            }
            //return base.OnActionExecutedAsync(actionExecutedContext, cancellationToken);
        }
    }
}