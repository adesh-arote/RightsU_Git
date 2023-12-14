using Newtonsoft.Json;
using RightsU.BMS.Entities.HttpModel;
using RightsU.BMS.Entities.Master_Entities;
using RightsU.BMS.WebAPI.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace RightsU.BMS.WebAPI.Filters
{
    public class AssetsLogFilter : ActionFilterAttribute
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
                    if (actionExecutedContext.Request.Method.Method == "GET")
                    {
                        logObj.RequestContent = JsonConvert.SerializeObject(actionExecutedContext.ActionContext.ActionArguments);
                        logObj.IsSuccess = Convert.ToString(((RightsU.BMS.Entities.FrameworkClasses.GenericReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).IsSuccess);
                        logObj.TimeTaken = Convert.ToString(((RightsU.BMS.Entities.FrameworkClasses.GenericReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).TimeTaken);
                    }
                    else
                    {
                        logObj.RequestContent = JsonConvert.SerializeObject(actionExecutedContext.ActionContext.ActionArguments["Input"]);
                        logObj.IsSuccess = Convert.ToString(((RightsU.BMS.Entities.FrameworkClasses.PostReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).IsSuccess);
                        logObj.TimeTaken = Convert.ToString(((RightsU.BMS.Entities.FrameworkClasses.PostReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).TimeTaken);
                    }
                    
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

                    var logDetails = await UTOLogger.LogService(logObj, GlobalAuthKey);
                    HttpResponses logData = JsonConvert.DeserializeObject<HttpResponses>(logDetails);
                    if (logData.LGCode > 0)
                    {
                        actionExecutedContext.Response.Headers.Add("requestid", logObj.RequestId);
                        if (logObj.Method == "GET")
                        {
                            actionExecutedContext.Response.Headers.Add("message", ((RightsU.BMS.Entities.FrameworkClasses.GenericReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).Message);
                            actionExecutedContext.Response.Headers.Add("issuccess", ((RightsU.BMS.Entities.FrameworkClasses.GenericReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).IsSuccess.ToString());
                        }
                        else
                        {
                            actionExecutedContext.Response.Headers.Add("message", ((RightsU.BMS.Entities.FrameworkClasses.PostReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).Message);
                            actionExecutedContext.Response.Headers.Add("issuccess", ((RightsU.BMS.Entities.FrameworkClasses.PostReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).IsSuccess.ToString());
                        }                        
                    }
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