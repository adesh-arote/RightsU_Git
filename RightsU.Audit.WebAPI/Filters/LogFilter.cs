using Newtonsoft.Json;
using RightsU.Audit.Entities.HttpModel;
using RightsU.Audit.Entities.InputEntities;
using RightsU.Audit.WebAPI.Logging;
using RightsU.Audit.WebAPI.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Hosting;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

namespace RightsU.Audit.WebAPI.Filters
{
    public class LogFilter : ActionFilterAttribute
    {
        private const string _requestId = "";

        public override Task OnActionExecutingAsync(HttpActionContext actionContext, CancellationToken cancellationToken)
        {
            if (HttpContext.Current.Request.Headers["LogRequestId"] == null)
            {

                HttpContext.Current.Request.Headers.Add("LogRequestId", Guid.NewGuid().ToString());
            }

            return base.OnActionExecutingAsync(actionContext, cancellationToken);
        }
        //public override void OnActionExecuting(HttpActionContext actionContext)
        //{
        //    //RequestContext context = null;
        //    if (HttpContext.Current.Request.Headers["LogRequestId"] != null)
        //    {

        //        //context = JsonConvert.DeserializeObject<string>(HttpContext.Current.Request.Headers["LogRequestId"]);
        //    }
        //    else
        //    {
        //        //context = new RequestContext();
        //        //context.RequestID= Guid.NewGuid().ToString();
        //        HttpContext.Current.Request.Headers.Add("LogRequestId", Guid.NewGuid().ToString());
        //    }

        //    //HttpContext.Current.Request.Headers.Add("LogRequestId", JsonConvert.SerializeObject(context));

        //}

        public override async Task OnActionExecutedAsync(HttpActionExecutedContext actionExecutedContext, CancellationToken cancellationToken)
        {
            UTOLogInput logObj = new UTOLogInput();

            if (actionExecutedContext.Response != null)
            {
                try
                {
                    logObj.ApplicationName = "AuditLog";
                    logObj.RequestId = HttpContext.Current.Request.Headers["LogRequestId"]; //Guid.NewGuid().ToString();
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

                    var logDetails = await UTOLogger.LogService(logObj, GlobalAuthKey);
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
            //return base.OnActionExecutedAsync(actionExecutedContext, cancellationToken);
        }

        //public override void OnActionExecuted(HttpActionExecutedContext actionExecutedContext)
        //{
        //    UTOLogInput logObj = new UTOLogInput();

        //    try
        //    {
        //        logObj.ApplicationName = "AuditLog";
        //        logObj.RequestId = HttpContext.Current.Request.Headers["LogRequestId"]; //Guid.NewGuid().ToString();
        //        logObj.RequestUri = actionExecutedContext.Request.RequestUri.AbsoluteUri;
        //        logObj.RequestMethod = actionExecutedContext.Request.RequestUri.AbsolutePath;
        //        if (actionExecutedContext.Request.Method.Method == "GET")
        //        {
        //            logObj.RequestContent = JsonConvert.SerializeObject(actionExecutedContext.ActionContext.ActionArguments);
        //            logObj.IsSuccess = Convert.ToString(((RightsU.Audit.Entities.FrameworkClasses.GetReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).IsSuccess);
        //            logObj.TimeTaken = Convert.ToString(((RightsU.Audit.Entities.FrameworkClasses.GetReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).TimeTaken);
        //        }
        //        else
        //        {
        //            logObj.RequestContent = JsonConvert.SerializeObject(actionExecutedContext.ActionContext.ActionArguments["Input"]);
        //            logObj.IsSuccess = Convert.ToString(((RightsU.Audit.Entities.FrameworkClasses.PostReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).IsSuccess);
        //            logObj.TimeTaken = Convert.ToString(((RightsU.Audit.Entities.FrameworkClasses.PostReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).TimeTaken);
        //        }

        //        logObj.RequestLength = Convert.ToString(logObj.RequestContent.ToString().Length);
        //        logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
        //        logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
        //        logObj.ResponseContent = JsonConvert.SerializeObject(((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value);
        //        logObj.ResponseLength = Convert.ToString(logObj.ResponseContent.Length);
        //        logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
        //        logObj.UserAgent = "AutidLog API";
        //        logObj.Method = actionExecutedContext.Request.Method.Method;
        //        logObj.ClientIpAddress = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();

        //        logObj.HttpStatusCode = Convert.ToString(actionExecutedContext.Response.StatusCode.GetHashCode());

        //        string GlobalAuthKey = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString();
        //        logObj.AuthenticationKey = GlobalAuthKey;

        //        var logDetails = LogService(logObj, GlobalAuthKey);
        //        HttpResponses logData = JsonConvert.DeserializeObject<HttpResponses>(logDetails);
        //        if (logData.LGCode > 0)
        //        {
        //            actionExecutedContext.Response.Headers.Add("requestid", logObj.RequestId);
        //            if (logObj.Method == "GET")
        //            {
        //                actionExecutedContext.Response.Headers.Add("message", ((RightsU.Audit.Entities.FrameworkClasses.GetReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).Message);
        //                actionExecutedContext.Response.Headers.Add("issuccess", ((RightsU.Audit.Entities.FrameworkClasses.GetReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).IsSuccess.ToString());
        //            }
        //            else
        //            {
        //                actionExecutedContext.Response.Headers.Add("message", ((RightsU.Audit.Entities.FrameworkClasses.PostReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).Message);
        //                actionExecutedContext.Response.Headers.Add("issuccess", ((RightsU.Audit.Entities.FrameworkClasses.PostReturn)((System.Net.Http.ObjectContent)actionExecutedContext.Response.Content).Value).IsSuccess.ToString());
        //            }


        //        }
        //    }
        //    catch (Exception ex)
        //    {

        //        //throw;
        //    }
        //}

    }
}