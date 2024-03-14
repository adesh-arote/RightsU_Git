using Newtonsoft.Json;
using RightsU.API.Entities.HttpModel;
using RightsU.API.Entities;
using RightsU.API.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http.Filters;

namespace RightsU.API.Filters
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
            logObj.ApplicationName = "Assets";
            logObj.RequestId = HttpContext.Current.Request.Headers["LogRequestId"]; //Guid.NewGuid().ToString();
            logObj.RequestUri = actionExecutedContext.Request.RequestUri.AbsoluteUri;
            logObj.RequestMethod = actionExecutedContext.Request.RequestUri.AbsolutePath;
            logObj.RequestContent = JsonConvert.SerializeObject(actionExecutedContext.ActionContext.ActionArguments);
            //if (actionExecutedContext.Request.Method.Method == "GET")
            //{
            //    logObj.RequestContent = JsonConvert.SerializeObject(actionExecutedContext.ActionContext.ActionArguments);
            //}
            //else
            //{
            //    logObj.RequestContent = JsonConvert.SerializeObject(actionExecutedContext.ActionContext.ActionArguments["Input"]);                
            //}
            logObj.IsSuccess = false.ToString();
            logObj.TimeTaken = "0";
            logObj.RequestLength = Convert.ToString(logObj.RequestContent.ToString().Length);
            logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
            logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
            logObj.ResponseContent = actionExecutedContext.Exception.StackTrace;
            logObj.ResponseLength = Convert.ToString(logObj.ResponseContent.Length);
            logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
            logObj.UserAgent = "Asset API";
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
            actionExecutedContext.Response.Headers.Add("request_completion", "False");

            #endregion

            //return base.OnExceptionAsync(actionExecutedContext, cancellationToken);
        }
    }
}