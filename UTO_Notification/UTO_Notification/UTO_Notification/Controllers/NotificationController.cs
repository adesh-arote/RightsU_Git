using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Http;
using System.Web.Http.Cors;
using UTO_Notification.API.AuthFilter;
using UTO_Notification.BLL;
using UTO_Notification.Entities;
using System.Configuration;
using System.IO;
using System.Web.Hosting;
using UTO_Notification.Entities.InputEntities;
using UTO_Notification.Entities.ProcedureEntities;
using UTO_Notification.BLL.Notifications;
using UTO_Notification.API.CustomFilter;

namespace UTO_Notification.Controllers
{
    [AuthAttribute]

    public class NotificationController : ApiController
    {
        USPService objUspService = new USPService();
        UTOLog logObj = new UTOLog();
        string GlobalAuthKey = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString();
        [HttpPost]

        [ActionName("NESendMessage")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public HttpResponseMessage NESendMessage(NotificationInput obj)
        {

            logObj.ApplicationName = "Notification Engine";
            Boolean isSuccess = false; double TimeTaken = 0;
            DateTime startTime;
            startTime = DateTime.Now;
            HttpResponses httpResponses = new HttpResponses();

            try
            {
                if (obj.NotificationType.ToLower() == "EMAIL_NTF".ToLower())
                {
                    Email objEmail = new Email();

                    if (!string.IsNullOrEmpty(obj.AttachmentFileName) && !string.IsNullOrEmpty(obj.AttachmentFileToString))
                    {
                        byte[] imageBytes = Convert.FromBase64String(obj.AttachmentFileToString);
                        System.IO.File.WriteAllBytes(ConfigurationManager.AppSettings["EmailFileAttachmentPath"] + obj.AttachmentFileName, imageBytes);
                    }

                    httpResponses = objEmail.SaveNotification(obj);
                    if (!httpResponses.Status)
                    {
                        return Request.CreateResponse(HttpStatusCode.InternalServerError, httpResponses);
                    }
                    TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;

                    logObj.RequestContent = "To: " + obj.TO + " <br/> CC: " + obj.CC + " <br/> Bcc:" + obj.BCC;
                    logObj.RequestContent = logObj.RequestContent + " Subject: " + obj.Subject + " <br/><br/>" + obj.HTMLMessage;
                }

                if (obj.NotificationType.ToLower() == "SMS_NTF".ToLower() || obj.NotificationType.ToLower() == "WTSAPP_NTF".ToLower())
                {
                    ShortMessage objShortMessage = new ShortMessage();

                    if (!string.IsNullOrEmpty(obj.AttachmentFileName) && !string.IsNullOrEmpty(obj.AttachmentFileToString))
                    {
                        byte[] imageBytes = Convert.FromBase64String(obj.AttachmentFileToString);
                        System.IO.File.WriteAllBytes(ConfigurationManager.AppSettings["SMSFileAttachmentPath"] + obj.AttachmentFileName, imageBytes);
                    }

                    httpResponses = objShortMessage.SaveNotification(obj);
                    if (!httpResponses.Status)
                    {
                        return Request.CreateResponse(HttpStatusCode.InternalServerError, httpResponses);
                    }
                    TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;

                    logObj.RequestContent = "To: " + obj.TO;
                    logObj.RequestContent = logObj.RequestContent + " Subject: " + obj.Subject + " <br/><br/>" + obj.HTMLMessage;
                }

                if (obj.NotificationType.ToLower() == "TEAMS_NTF".ToLower())
                {
                    Teams objTeams = new Teams();

                    if (!string.IsNullOrEmpty(obj.AttachmentFileName) && !string.IsNullOrEmpty(obj.AttachmentFileToString))
                    {
                        byte[] imageBytes = Convert.FromBase64String(obj.AttachmentFileToString);
                        System.IO.File.WriteAllBytes(ConfigurationManager.AppSettings["TeamsFileAttachmentPath"] + obj.AttachmentFileName, imageBytes);
                    }

                    httpResponses = objTeams.SaveNotification(obj);
                    if (!httpResponses.Status)
                    {
                        return Request.CreateResponse(HttpStatusCode.InternalServerError, httpResponses);
                    }
                    TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;

                    logObj.RequestContent = "To: " + obj.TO;
                    logObj.RequestContent = logObj.RequestContent + " Subject: " + obj.Subject + " <br/><br/>" + obj.HTMLMessage;
                }

                if (obj.NotificationType.ToLower() == "APP_NTF".ToLower())
                {
                    InApp objInApp = new InApp();

                    if (!string.IsNullOrEmpty(obj.AttachmentFileName) && !string.IsNullOrEmpty(obj.AttachmentFileToString))
                    {
                        byte[] imageBytes = Convert.FromBase64String(obj.AttachmentFileToString);
                        System.IO.File.WriteAllBytes(ConfigurationManager.AppSettings["InAppFileAttachmentPath"] + obj.AttachmentFileName, imageBytes);
                    }

                    httpResponses = objInApp.SaveNotification(obj);
                    if (!httpResponses.Status)
                    {
                        return Request.CreateResponse(HttpStatusCode.InternalServerError, httpResponses);
                    }
                    TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;

                    logObj.RequestContent = "To: " + obj.TO;
                    logObj.RequestContent = logObj.RequestContent + " Subject: " + obj.Subject + " <br/><br/>" + obj.HTMLMessage;
                }
            }
            catch (Exception ex)
            {
                WriteLog.Log("NESendMessage", "Error Message - " + ex.Message, "");
                WriteLog.Log("NESendMessage", "Inner Exception - " + ex.InnerException, "");                
            }
            if (Convert.ToInt16((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogLevel"]) <= 2)
            {
                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "" && (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != null)
                {
                    logObj.RequestId = Convert.ToString(httpResponses.NECode);
                    logObj.UserId = Convert.ToString(obj.UserCode);
                    logObj.RequestUri = Request.RequestUri.AbsoluteUri;
                    logObj.RequestMethod = "api/Notification/NESendMessage";
                    logObj.RequestLength = Convert.ToString(logObj.RequestContent.ToString().Length);
                    logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseContent = httpResponses.Message;
                    logObj.ResponseLength = Convert.ToString(httpResponses.Message.Length);
                    logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
                    logObj.UserAgent = "Notification API";
                    logObj.Method = "Post";
                    logObj.ClientIpAddress = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();
                    logObj.IsSuccess = httpResponses.Status.ToString();
                    logObj.TimeTaken = Convert.ToString(TimeTaken);
                    logObj.HttpStatusCode = httpResponses.ResponseCode;
                    logObj.HttpStatusDescription = httpResponses.Message;
                    string GlobalAuthKey = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString();

                    HostingEnvironment.QueueBackgroundWorkItem(ctx => AuthAttribute.LogService(logObj, GlobalAuthKey));
                }
            }

            return Request.CreateResponse(HttpStatusCode.Created, httpResponses);
        }


        [HttpPost]
        [ActionName("NEUpdateMessageStatus")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public HttpResponseMessage NEUpdateMessageStatus(NotificationInput obj)
        {
            logObj.ApplicationName = "Notification Engine";
            Boolean isSuccess = false; double TimeTaken;
            DateTime startTime;
            startTime = DateTime.Now;

            HttpResponses httpResponses = new HttpResponses();
            IHttpResponseMapper httpResponseMapper = new HttpResponseMapper();
            USPInsertNotification objOutput = objUspService.USPUpdateNotification(obj.NECode, obj.UpdatedStatus, obj.ReadDateTime, obj.NEDetailCode, obj.Client_Name, obj.Notification_App);


            httpResponses = httpResponseMapper.GetHttpSuccessResponse(objOutput);
            httpResponses.NECode = objOutput.NotificationsCode;
            TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            if (httpResponses.NECode > 0)
            {
                httpResponses.Message = "Request Updated Successfully";
                isSuccess = true;
            }
            if (Convert.ToInt16((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogLevel"]) <= 2)
            {
                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "" && (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != null)
                {
                    logObj.RequestId = Convert.ToString(obj.NECode);
                    logObj.UserId = Convert.ToString(obj.UserCode);
                    logObj.RequestUri = Request.RequestUri.AbsoluteUri;
                    logObj.RequestMethod = "api/Notification/NEUpdateMessageStatus";
                    logObj.RequestContent = "To: " + obj.TO + " <br/> CC: " + obj.CC + " <br/> Bcc:" + obj.BCC;
                    logObj.RequestContent = logObj.RequestContent + " Subject: " + obj.Subject + " <br/><br/>" + obj.HTMLMessage;
                    logObj.RequestLength = Convert.ToString(logObj.RequestContent.ToString().Length);
                    logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseContent = httpResponses.Message;
                    logObj.ResponseLength = Convert.ToString(httpResponses.Message.Length);
                    logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
                    logObj.UserAgent = "Notification API";
                    logObj.Method = "Post";
                    logObj.ClientIpAddress = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();
                    logObj.IsSuccess = isSuccess.ToString();
                    logObj.TimeTaken = Convert.ToString(TimeTaken);
                    logObj.HttpStatusCode = httpResponses.ResponseCode;
                    logObj.HttpStatusDescription = httpResponses.Message;
                    string GlobalAuthKey = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString();
                    HostingEnvironment.QueueBackgroundWorkItem(ctx => AuthAttribute.LogService(logObj, GlobalAuthKey));
                }
            }
            return Request.CreateResponse(HttpStatusCode.Created, httpResponses);
        }

        [HttpPost]
        [ActionName("NEGetMessageStatus")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]
        public HttpResponseMessage NEGetMessageStatus(GetMessagesInput obj)
        {
            logObj.ApplicationName = "Notification Engine";
            Boolean isSuccess = false; double TimeTaken;
            DateTime startTime;
            startTime = DateTime.Now;

            HttpResponses httpResponses = new HttpResponses();
            IHttpResponseMapper httpResponseMapper = new HttpResponseMapper();

            USPGetMessages objOutput = new USPGetMessages();

            List<USPGetMessageStatus> uSPGetMessageStatuses = objUspService.USPGetMessageStatus(obj.NECode, obj.TransType, obj.TransCode, obj.UserCode, obj.NotificationType, obj.EventCategory, obj.Subject, obj.Status, obj.NoOfRetry, obj.size, obj.from, obj.ScheduleStartDateTime, obj.ScheduleEndDateTime, obj.SentStartDateTime, obj.SentEndDateTime, obj.Recipient, obj.isSend, obj.isRead, obj.ClientName, obj.NotificationApp, obj.CallFor);
            objOutput.lstGetMessages = uSPGetMessageStatuses;
            objOutput.TotalRecords = 0;

            httpResponses = httpResponseMapper.GetHttpSuccessResponse(objOutput);

            TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;

            if (uSPGetMessageStatuses.Count > 0)
            {
                objOutput.TotalRecords = uSPGetMessageStatuses.FirstOrDefault().TotalRecords ?? 0;
                httpResponses.Message = "Ok";
                isSuccess = true;
            }
            if (Convert.ToInt16((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogLevel"]) <= 2)
            {

                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "" && (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != null)
                {
                    logObj.RequestId = Convert.ToString(obj.NECode);
                    logObj.UserId = Convert.ToString(obj.UserCode);
                    logObj.RequestUri = Request.RequestUri.AbsoluteUri;
                    logObj.RequestMethod = "api/Notification/NEGetMessageStatus";
                    logObj.RequestContent = "NotificationType: " + obj.NotificationType + " <br/> EventCategory: " + obj.EventCategory + " <br/> NoOfRetry:" + obj.NoOfRetry;
                    logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseContent = httpResponses.Message;
                    logObj.ResponseLength = Convert.ToString(httpResponses.Message.Length);
                    logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
                    logObj.UserAgent = "Notification API";
                    logObj.Method = "Post";
                    logObj.ClientIpAddress = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();
                    logObj.IsSuccess = isSuccess.ToString();
                    logObj.TimeTaken = Convert.ToString(TimeTaken);
                    logObj.HttpStatusCode = httpResponses.ResponseCode;
                    logObj.HttpStatusDescription = httpResponses.Message;
                    string GlobalAuthKey = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString();
                    HostingEnvironment.QueueBackgroundWorkItem(ctx => AuthAttribute.LogService(logObj, GlobalAuthKey));
                }
            }
            return Request.CreateResponse(HttpStatusCode.Created, httpResponses);
        }

        [HttpPost]
        [ActionName("NEGetMasters")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]

        public HttpResponseMessage NEGetMasters()
        {
            logObj.ApplicationName = "Notification Engine";
            Boolean isSuccess = false; double TimeTaken;
            DateTime startTime;
            startTime = DateTime.Now;

            HttpResponses httpResponses = new HttpResponses();
            IHttpResponseMapper httpResponseMapper = new HttpResponseMapper();
            List<USPGetMasters> lstUSPGetMasters = objUspService.USPGetMasters();
            httpResponses = httpResponseMapper.GetHttpSuccessResponse(lstUSPGetMasters);
            TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;

            if (lstUSPGetMasters.Count > 0)
            {
                isSuccess = true;
                httpResponses.Message = "Ok";
            }
            //if((HttpContext.Current.ApplicationInstance as WebApiApplication). < 2)
            //{

            //}
            if (Convert.ToInt16((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogLevel"]) <= 2)
            {
                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "" && (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != null)
                {
                    logObj.RequestUri = Request.RequestUri.AbsoluteUri;
                    logObj.RequestMethod = "api/Notification/NEGetMasters";
                    logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseContent = httpResponses.Message;
                    logObj.ResponseLength = Convert.ToString(httpResponses.Message.Length);
                    logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
                    logObj.UserAgent = "Notification API";
                    logObj.Method = "Post";
                    logObj.ClientIpAddress = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();
                    logObj.IsSuccess = isSuccess.ToString();
                    logObj.TimeTaken = Convert.ToString(TimeTaken);
                    logObj.HttpStatusCode = httpResponses.ResponseCode;
                    logObj.HttpStatusDescription = httpResponses.Message;
                    string GlobalAuthKey = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString();
                    HostingEnvironment.QueueBackgroundWorkItem(ctx => AuthAttribute.LogService(logObj, GlobalAuthKey));
                }
            }
            return Request.CreateResponse(HttpStatusCode.Created, httpResponses);
        }

        [HttpPost]
        [ActionName("NEGetConfiguration")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]

        public HttpResponseMessage NEGetConfiguration()
        {
            logObj.ApplicationName = "Notification Engine";
            Boolean isSuccess = false; double TimeTaken;
            DateTime startTime;
            startTime = DateTime.Now;

            HttpResponses httpResponses = new HttpResponses();
            IHttpResponseMapper httpResponseMapper = new HttpResponseMapper();
            List<USPGetConfig> lstUSPGetConfig = objUspService.USPGetConfig();
            httpResponses = httpResponseMapper.GetHttpSuccessResponse(lstUSPGetConfig);

            TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            if (lstUSPGetConfig.Count > 0)
            {
                isSuccess = true;
                httpResponses.Message = "Ok";
            }
            if (Convert.ToInt16((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogLevel"]) <= 2)
            {

                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "" && (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != null)
                {
                    logObj.RequestUri = Request.RequestUri.AbsoluteUri;
                    logObj.RequestMethod = "api/Notification/NEGetConfiguration";
                    logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseContent = httpResponses.Message;
                    logObj.ResponseLength = Convert.ToString(httpResponses.Message.Length);
                    logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
                    logObj.UserAgent = "Notification API";
                    logObj.Method = "Post";
                    logObj.ClientIpAddress = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();
                    logObj.IsSuccess = isSuccess.ToString();
                    logObj.TimeTaken = Convert.ToString(TimeTaken);
                    logObj.HttpStatusCode = httpResponses.ResponseCode;
                    logObj.HttpStatusDescription = httpResponses.Message;
                    string GlobalAuthKey = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString();
                    HostingEnvironment.QueueBackgroundWorkItem(ctx => AuthAttribute.LogService(logObj, GlobalAuthKey));
                }
            }
            return Request.CreateResponse(HttpStatusCode.Created, httpResponses);
        }

        [HttpPost]
        [ActionName("NESaveConfiguration")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]

        public HttpResponseMessage NESaveConfiguration(USPGetConfig obj)
        {
            logObj.ApplicationName = "Notification Engine";
            Boolean isSuccess = false; double TimeTaken;
            DateTime startTime;
            startTime = DateTime.Now;
            HttpResponses httpResponses = new HttpResponses();
            IHttpResponseMapper httpResponseMapper = new HttpResponseMapper();
            USPGetConfig objUSPGetConfig = objUspService.USPInsertConfig(obj.NotificationConfigCode, obj.NoOfTimesToRetry, obj.DurationBetweenTwoRetriesMin, obj.RetryOptionForFailed, obj.ResendOptionForSuccessful, obj.SMTPServer, obj.SMTPPort, obj.UseDefaultCredentials, obj.UserName, obj.Password);

            httpResponses = httpResponseMapper.GetHttpSuccessResponse(objUSPGetConfig);
            TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            if (httpResponses != null)
            {
                isSuccess = true;
                httpResponses.Message = "Ok";
            }
            if (Convert.ToInt16((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogLevel"]) <= 2)
            {

                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "" && (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != null)
                {
                    logObj.RequestId = Convert.ToString(obj.NotificationConfigCode);
                    logObj.RequestUri = Request.RequestUri.AbsoluteUri;
                    logObj.RequestMethod = "api/Notification/NESaveConfiguration";
                    logObj.RequestContent = "NotificationType: " + obj.NotificationConfigCode + " <br/> UserName: " + obj.UserName + " <br/> NoOfTimesToRetry:" + obj.NoOfTimesToRetry;
                    logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseContent = httpResponses.Message;
                    logObj.ResponseLength = Convert.ToString(httpResponses.Message.Length);
                    logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
                    logObj.UserAgent = "Notification API";
                    logObj.Method = "Post";
                    logObj.ClientIpAddress = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();
                    logObj.IsSuccess = isSuccess.ToString();
                    logObj.TimeTaken = Convert.ToString(TimeTaken);
                    logObj.HttpStatusCode = httpResponses.ResponseCode;
                    logObj.HttpStatusDescription = httpResponses.Message;
                    string GlobalAuthKey = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString();
                    HostingEnvironment.QueueBackgroundWorkItem(ctx => AuthAttribute.LogService(logObj, GlobalAuthKey));
                }
            }
            return Request.CreateResponse(HttpStatusCode.Created, httpResponses);
        }

        [HttpPost]
        [ActionName("NEGetSummarisedMessageStatus")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]

        public HttpResponseMessage NEGetSummarisedMessageStatus(GetSummarisedMessageStatus obj)
        {
            logObj.ApplicationName = "Notification Engine";
            Boolean isSuccess = false; double TimeTaken;
            DateTime startTime;
            startTime = DateTime.Now;
            HttpResponses httpResponses = new HttpResponses();
            IHttpResponseMapper httpResponseMapper = new HttpResponseMapper();
            List<USPEventCategoryMsgCount> objGetSummarisedMessage = objUspService.USPEventCategoryMsgCount(obj.ClientName, obj.UserEmail, obj.NotificationApp, obj.CallFor);
            httpResponses = httpResponseMapper.GetHttpSuccessResponse(objGetSummarisedMessage);

            TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            if (httpResponses != null)
            {
                isSuccess = true;
                httpResponses.Message = "Ok";
            }
            if (Convert.ToInt16((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogLevel"]) <= 2)
            {

                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "" && (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != null)
                {
                    logObj.RequestUri = Request.RequestUri.AbsoluteUri;
                    logObj.RequestMethod = "api/Notification/NEGetSummarisedMessageStatus";
                    logObj.RequestContent = "UserEmail: " + obj.UserEmail;
                    logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseContent = httpResponses.Message;
                    logObj.ResponseLength = Convert.ToString(httpResponses.Message.Length);
                    logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
                    logObj.UserAgent = "Notification API";
                    logObj.Method = "Post";
                    logObj.ClientIpAddress = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();
                    logObj.IsSuccess = isSuccess.ToString();
                    logObj.TimeTaken = Convert.ToString(TimeTaken);
                    logObj.HttpStatusCode = httpResponses.ResponseCode;
                    logObj.HttpStatusDescription = httpResponses.Message;
                    string GlobalAuthKey = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString();
                    HostingEnvironment.QueueBackgroundWorkItem(ctx => AuthAttribute.LogService(logObj, GlobalAuthKey));


                }
            }
            return Request.CreateResponse(HttpStatusCode.Created, httpResponses);
        }

        [HttpPost]
        [ActionName("NESaveNotificationType")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]

        public HttpResponseMessage NESaveNotificationType(NotificationTypeInput obj)
        {
            logObj.ApplicationName = "Notification Engine";
            Boolean isSuccess = false; double TimeTaken;
            DateTime startTime;
            startTime = DateTime.Now;
            HttpResponses httpResponses = new HttpResponses();
            IHttpResponseMapper httpResponseMapper = new HttpResponseMapper();
            USPInsertNotificationType objUSPInsertNotificationType = objUspService.USPInsertNotificationType(obj.NotificationType, obj.ClientName, obj.Platform_Name, obj.Credentials, obj.Is_Active);

            httpResponses = httpResponseMapper.GetHttpSuccessResponse(objUSPInsertNotificationType);
            //httpResponses.NECode = objUSPInsertNotificationType.NotificationTypeCode;
            TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            if (httpResponses != null)
            {
                isSuccess = true;
                httpResponses.Message = "Ok";
            }
            if (Convert.ToInt16((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogLevel"]) <= 2)
            {

                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "" && (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != null)
                {
                    logObj.RequestId = Convert.ToString(objUSPInsertNotificationType.NotificationTypeCode);
                    logObj.RequestUri = Request.RequestUri.AbsoluteUri;
                    logObj.RequestMethod = "api/Notification/NESaveNotificationType";
                    logObj.RequestContent = "NotificationType: " + obj.NotificationType + " <br/> ClientName: " + obj.ClientName + " <br/> PlatformName:" + obj.Platform_Name + " <br/> Credentials:" + obj.Credentials + " <br/> IsActive:" + obj.Is_Active;
                    logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseContent = httpResponses.Message;
                    logObj.ResponseLength = Convert.ToString(httpResponses.Message.Length);
                    logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
                    logObj.UserAgent = "Notification API";
                    logObj.Method = "Post";
                    logObj.ClientIpAddress = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();
                    logObj.IsSuccess = isSuccess.ToString();
                    logObj.TimeTaken = Convert.ToString(TimeTaken);
                    logObj.HttpStatusCode = httpResponses.ResponseCode;
                    logObj.HttpStatusDescription = httpResponses.Message;
                    string GlobalAuthKey = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString();
                    HostingEnvironment.QueueBackgroundWorkItem(ctx => AuthAttribute.LogService(logObj, GlobalAuthKey));
                }
            }
            return Request.CreateResponse(HttpStatusCode.Created, httpResponses);
        }

        [HttpPost]
        [ActionName("NEGetNotificationByForeignId")]
        [EnableCors(origins: "*", headers: "*", methods: "*")]

        public HttpResponseMessage NEGetNotificationByForeignId(GetNotificationInput obj)
        {
            logObj.ApplicationName = "Notification Engine";
            Boolean isSuccess = false; double TimeTaken;
            DateTime startTime;
            startTime = DateTime.Now;

            HttpResponses httpResponses = new HttpResponses();
            IHttpResponseMapper httpResponseMapper = new HttpResponseMapper();

            USPGetNotificationByForeignId objNotification = new USPGetNotificationByForeignId();

            if (obj.NotificationType.ToUpper() == "EMAIL_NTF")
            {
                objNotification = objUspService.USPGetEmailNotificationByForeignId(obj.ForeignId, obj.ClientName);
            }
            else if (obj.NotificationType.ToUpper() == "TEAMS_NTF")
            {
                objNotification = objUspService.USPGetTeamsNotificationByForeignId(obj.ForeignId, obj.ClientName);
            }
            //else if (obj.NotificationType.ToUpper() == "APP_NTF")
            //{
            //    objNotification = objUspService.USPGetTeamsNotificationByForeignId(obj.ForeignId, obj.ClientName);
            //}

            httpResponses = httpResponseMapper.GetHttpSuccessResponse(objNotification);

            TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            if (objNotification != null || objNotification.NotificationsCode > 0)
            {
                isSuccess = true;
                httpResponses.Message = "Ok";
            }
            if (Convert.ToInt16((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogLevel"]) <= 2)
            {

                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "" && (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != null)
                {
                    logObj.RequestUri = Request.RequestUri.AbsoluteUri;
                    logObj.RequestMethod = "api/Notification/NEGetNotificationByForeignId";
                    logObj.RequestContent = "ForeignId: " + obj.ForeignId + " <br/> ClientName: " + obj.ClientName + " <br/> NotificationType:" + obj.NotificationType;
                    logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy HH:mm:ss");
                    logObj.ResponseContent = httpResponses.Message;
                    logObj.ResponseLength = Convert.ToString(httpResponses.Message.Length);
                    logObj.ServerName = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["strHostName"].ToString();
                    logObj.UserAgent = "Notification API";
                    logObj.Method = "Post";
                    logObj.ClientIpAddress = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["ipAddress"].ToString();
                    logObj.IsSuccess = isSuccess.ToString();
                    logObj.TimeTaken = Convert.ToString(TimeTaken);
                    logObj.HttpStatusCode = httpResponses.ResponseCode;
                    logObj.HttpStatusDescription = httpResponses.Message;
                    string GlobalAuthKey = (HttpContext.Current.ApplicationInstance as WebApiApplication).Application["AuthKey"].ToString();
                    HostingEnvironment.QueueBackgroundWorkItem(ctx => AuthAttribute.LogService(logObj, GlobalAuthKey));
                }
            }
            return Request.CreateResponse(HttpStatusCode.Created, httpResponses);
        }
    }
}

