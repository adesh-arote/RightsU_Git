using Newtonsoft.Json;
using RightsU.Audit.Entities.HttpModel;
using RightsU.Audit.Entities.InputEntities;
using RightsU.Audit.WebAPI.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http.Filters;

namespace RightsU.Audit.WebAPI.Filters
{
    public class CustomExceptionFilter : ExceptionFilterAttribute
    {
        public override async Task OnExceptionAsync(HttpActionExecutedContext actionExecutedContext, CancellationToken cancellationToken)
        {
            string exceptionMessage = string.Empty;
            if (actionExecutedContext.Exception.InnerException == null)
            {
                exceptionMessage = actionExecutedContext.Exception.Message;
            }
            else
            {
                exceptionMessage = actionExecutedContext.Exception.InnerException.Message;
            }

            #region Error Logging

            UTOLogInput logObj = new UTOLogInput();
            logObj.ApplicationName = "AuditLog";
            logObj.RequestId = HttpContext.Current.Request.Headers["LogRequestId"]; //Guid.NewGuid().ToString();
            logObj.RequestUri = actionExecutedContext.Request.RequestUri.AbsoluteUri;
            logObj.RequestMethod = actionExecutedContext.Request.RequestUri.AbsolutePath;

            if (actionExecutedContext.Request.Method.Method == "GET")
            {
                logObj.RequestContent = JsonConvert.SerializeObject(actionExecutedContext.ActionContext.ActionArguments);
                logObj.IsSuccess = false.ToString();
                logObj.TimeTaken = "0";
            }
            else
            {
                logObj.RequestContent = JsonConvert.SerializeObject(actionExecutedContext.ActionContext.ActionArguments["Input"]);
                logObj.IsSuccess = false.ToString();
                logObj.TimeTaken = "0";
            }

            logObj.RequestLength = Convert.ToString(logObj.RequestContent.ToString().Length);
            logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
            logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
            logObj.ResponseContent = actionExecutedContext.Exception.StackTrace;
            logObj.ResponseLength = Convert.ToString(logObj.ResponseContent.Length);
            logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
            logObj.UserAgent = "AutidLog API";
            logObj.Method = actionExecutedContext.Request.Method.Method;
            logObj.ClientIpAddress = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();

            logObj.HttpStatusCode = HttpStatusCode.InternalServerError.GetHashCode().ToString();

            string GlobalAuthKey = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString();
            logObj.AuthenticationKey = GlobalAuthKey;

            var logDetails = await UTOLogger.LogService(logObj, GlobalAuthKey);
            HttpResponses logData = JsonConvert.DeserializeObject<HttpResponses>(logDetails);

            //We can log this exception message to the file or database.
            var response = new HttpResponseMessage(HttpStatusCode.InternalServerError)
            {
                Content = new StringContent("An unhandled exception was thrown by service."),
                ReasonPhrase = "Internal Server Error.Please Contact your Administrator."
            };
            actionExecutedContext.Response = response;
            actionExecutedContext.Response.Headers.Add("requestid", logObj.RequestId);
            actionExecutedContext.Response.Headers.Add("message", "Internal Server Error.Please Contact your Administrator.");
            actionExecutedContext.Response.Headers.Add("issuccess", "False");

            #endregion

            //return base.OnExceptionAsync(actionExecutedContext, cancellationToken);
        }
    }
}