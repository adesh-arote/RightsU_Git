﻿using System;
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
            Boolean isSuccess = false; double TimeTaken;
            DateTime startTime;
            startTime = DateTime.Now;

            HttpResponses httpResponses = new HttpResponses();
            IHttpResponseMapper httpResponseMapper = new HttpResponseMapper();
            if (obj.NotificationType == "email_ntf")
            {
                if (obj.TO != null && obj.TO != "")
                {
                    string[] to;
                    string Toemails = "";
                    if (Convert.ToString(obj.TO).IndexOf(';') > 0)
                        to = obj.TO.Split(';');
                    else
                        to = obj.TO.Split(',');

                    foreach (string str in to)
                    {
                        if (str != "")
                            Toemails = str.Trim();
                        Regex regex = new Regex(@"^[^@\s]+@[^@\s]+\.[^@\s]+$");
                        Match match = regex.Match(Toemails);

                        if (match.Success == false)
                        {
                            httpResponses.Message = "Email Id is not valid";

                            return Request.CreateResponse(HttpStatusCode.InternalServerError, httpResponses);
                        }
                    }
                }
                else
                {
                    httpResponses.Message = "Email Id is mandatory";

                    return Request.CreateResponse(HttpStatusCode.InternalServerError, httpResponses);
                }

                if (obj.CC != null && obj.CC != "")
                {

                    string[] C;
                    string ccemails = "";
                    if (Convert.ToString(obj.CC).IndexOf(';') > 0)
                        C = obj.CC.Split(';');
                    else
                        C = obj.CC.Split(',');

                    foreach (string str in C)
                    {
                        if (str != "")
                            ccemails = str.Trim();
                        Regex regex = new Regex(@"^[^@\s]+@[^@\s]+\.[^@\s]+$");
                        Match match = regex.Match(ccemails);

                        if (match.Success == false)
                        {
                            httpResponses.Message = "Email Id is not valid";
                            return Request.CreateResponse(HttpStatusCode.InternalServerError, httpResponses);

                        }

                    }
                }

                if (obj.BCC != null && obj.BCC != "")
                {
                    string[] B;
                    string bccemails = "";

                    if (Convert.ToString(obj.BCC).IndexOf(';') > 0)
                        B = obj.BCC.Split(';');
                    else
                        B = obj.BCC.Split(',');

                    foreach (string str in B)
                    {
                        if (str != "")

                            bccemails = str.Trim();
                        Regex regex = new Regex(@"^[^@\s]+@[^@\s]+\.[^@\s]+$");
                        Match match = regex.Match(bccemails);

                        if (match.Success == false)
                        {
                            httpResponses.Message = "Email Id is not valid";
                            return Request.CreateResponse(HttpStatusCode.InternalServerError, httpResponses);

                        }
                    }
                }
            }

            if (obj.NotificationType == "SMS_NTF" || obj.NotificationType == "Whatsapp_ntf")
            {
                if (obj.TO != null && obj.TO != "")
                {
                    string[] to;
                    string Toemails = "";
                    to = obj.TO.Split(';');
                    foreach (string str in to)
                    {
                        if (str != "")
                            Toemails = str.Trim();
                        Regex regex = new Regex(@"^(\+?\d{1,4}[\s-])?(?!0+\s+,?$)\d{10}\s*,?$");
                        Match match = regex.Match(Toemails);

                        if (match.Success == false)
                        {
                            httpResponses.Message = "Mobile number is not valid";

                            return Request.CreateResponse(HttpStatusCode.InternalServerError, httpResponses);
                        }
                    }

                }
                else
                {
                    httpResponses.Message = "Mobile number is mandatory";

                    return Request.CreateResponse(HttpStatusCode.InternalServerError, httpResponses);
                }
            }

            USPInsertNotification objOutput = objUspService.USPInsertNotification(obj.EventCategory, obj.NotificationType, obj.TO, obj.CC, obj.BCC, obj.Subject, obj.HTMLMessage, obj.TextMessage, obj.TransType, obj.TransCode, obj.ScheduleDateTime, obj.UserCode);

            httpResponses = httpResponseMapper.GetHttpSuccessResponse(objOutput);
            httpResponses.NECode = objOutput.NotificationsCode;
            TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            if (httpResponses.NECode > 0)
            {
                isSuccess = true;
                httpResponses.Message = "Request Queued Successfully";
            }
            if (Convert.ToInt16((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogLevel"]) <= 2)
            {
                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "")
                {
                    logObj.RequestId = Convert.ToString(obj.NECode);
                    logObj.UserId = Convert.ToString(obj.UserCode);
                    logObj.RequestUri = Request.RequestUri.AbsoluteUri;
                    logObj.RequestMethod = "api/Notification/NESendMessage";
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
            USPInsertNotification objOutput = objUspService.USPUpdateNotification(obj.NECode, obj.UpdatedStatus, obj.ReadDateTime, obj.NEDetailCode);


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
                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "")
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

            List<USPGetMessageStatus> uSPGetMessageStatuses = objUspService.USPGetMessageStatus(obj.NECode, obj.TransType, obj.TransCode, obj.UserCode, obj.NotificationType, obj.EventCategory, obj.Subject, obj.Status, obj.NoOfRetry, obj.size, obj.from, obj.ScheduleStartDateTime, obj.ScheduleEndDateTime, obj.SentStartDateTime, obj.SentEndDateTime, obj.Recipient, obj.isSend, obj.isRead);
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

                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "")
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
                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "")
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

                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "")
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

                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "")
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
            List<USPEventCategoryMsgCount> objGetSummarisedMessage = objUspService.USPEventCategoryMsgCount(obj.UserEmail);
            httpResponses = httpResponseMapper.GetHttpSuccessResponse(objGetSummarisedMessage);

            TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;
            if (httpResponses != null)
            {
                isSuccess = true;
                httpResponses.Message = "Ok";
            }
            if (Convert.ToInt16((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogLevel"]) <= 2)
            {

                if ((HttpContext.Current.ApplicationInstance as WebApiApplication).Application["LogURL"] != "")
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


    }
}
