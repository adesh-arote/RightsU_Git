using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace RightsU_Plus.Controllers
{
    public class Dispatcher_SearchController : BaseController
    {
        private List<RightsU_Entities.Notifications> lstNotifications_Searched
        {
            get
            {
                if (Session["lstNotifications_Searched"] == null)
                    Session["lstNotifications_Searched"] = new List<RightsU_Entities.Notifications>();
                return (List<RightsU_Entities.Notifications>)Session["lstNotifications_Searched"];
            }
            set { Session["lstNotifications_Searched"] = value; }
        }
        private List<RightsU_Entities.Notifications> lstNotifications
        {
            get
            {
                if (Session["lstNotifications"] == null)
                    Session["lstNotifications"] = new List<RightsU_Entities.Notifications>();
                return (List<RightsU_Entities.Notifications>)Session["lstNotifications"];
            }
            set { Session["lstNotifications"] = value; }
        }
        public ActionResult Index()
        {
            BindDDL();
            return View();
        }
        public void BindDDL()
        {
            ViewBag.EventType = new SelectList(new Email_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).OrderBy(x => x.Email_Type), "Email_Config_Code", "Email_Type").ToList();
            ViewBag.EventPlatform = new SelectList(new Event_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).OrderBy(x => x.Short_Code), "Event_Platform_Code", "Short_Code").ToList();
        }

        public ActionResult GetNotifications( int pageNo, int recordPerPage, string sortType)
        {
            int RecordCount = 0;
            RecordCount = lstNotifications.Count;
            List<Notifications> lst = new List<Notifications>();
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                {
                    lst = lstNotifications.OrderByDescending(o => o.NotificationsCode).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                }
            }
            return PartialView("_Dispatcher_List", lst);
        }

        private int GetPaging(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
        {
            noOfRecordSkip = noOfRecordTake = 0;
            if (recordCount > 0)
            {
                int cnt = pageNo * recordPerPage;
                if (cnt >= recordCount)
                {
                    int v1 = recordCount / recordPerPage;
                    if ((v1 * recordPerPage) == recordCount)
                        pageNo = v1;
                    else
                        pageNo = v1 + 1;
                }
                noOfRecordSkip = recordPerPage * (pageNo - 1);
                if (recordCount < (noOfRecordSkip + recordPerPage))
                    noOfRecordTake = recordCount - noOfRecordSkip;
                else
                    noOfRecordTake = recordPerPage;
            }
            return pageNo;
        }

        public JsonResult SearchDispatcher(string strStartDate, string strEndDate, string EventType, string Platform, string MessageType, string MessageTo, string BtnType)
        {
            FetchData();
            string status = "S", message = "";
            DateTime StartDate = new DateTime(), EndDate = new DateTime();
            
            if (strStartDate != "" && strEndDate != "")
            {
                StartDate = Convert.ToDateTime(strStartDate);
                EndDate = Convert.ToDateTime(strEndDate).AddDays(1).AddTicks(-1);
            }

            System_Parameter_New_Service objSPNService = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
            Notification_Service objNotificationService = new Notification_Service(objLoginEntity.ConnectionStringName);

            #region Startdate Validation
            DateTime CurrentDate = DateTime.Now;
            if (BtnType == "NA")   //Non archive
            {
                if (strStartDate != "" && strEndDate != "")
                {
                    System_Parameter_New objSPN = objSPNService.SearchFor(s => s.Parameter_Name == "Dispatcher_Days_Diff" && s.IsActive == "Y").FirstOrDefault();
                    DateTime CalStartDate = CurrentDate.AddDays(-(Convert.ToInt32(objSPN.Parameter_Value)));
                    if (StartDate < CalStartDate)
                    {
                        status = "E";
                        message = "Select start date above " + objSPN.Parameter_Value + " days";
                        var obj = new
                        {
                            Status = status,
                            Message = message
                        };
                        return Json(obj);
                    }
                }
            }
            if (BtnType == "AR")   //Archive
            {
                StartDate = CurrentDate.AddDays(-10);
                EndDate = DateTime.Now;
            }
            #endregion

            lstNotifications = null;
            if (MessageType != null)
            {
                Session["MessageType"] = MessageType;
                if (MessageType == "HTML")
                    lstNotifications = lstNotifications_Searched.Where(a => a.HtmlBody != null).ToList();
                if (MessageType == "TEXT")
                    lstNotifications = lstNotifications_Searched.Where(a => a.TextBody != null).ToList();
            }
            if (BtnType == "NA")
                if (strStartDate != "" && strEndDate != "")
                    lstNotifications = lstNotifications.Where(a => (a.CreatedOn >= StartDate && a.CreatedOn <= EndDate)).ToList();
            if (BtnType == "AR")
                lstNotifications = lstNotifications.Where(a => (a.CreatedOn >= StartDate && a.CreatedOn <= EndDate)).ToList();
            if (EventType != null && EventType != "")
                lstNotifications = lstNotifications.Where(a => a.Email_Config_Code == Convert.ToInt32(EventType)).ToList();
            if (Platform != null && Platform != "")
                lstNotifications = lstNotifications.Where(a => a.Event_Platform_Code == Convert.ToInt32(Platform)).ToList();
            if (MessageTo != null && MessageTo != "")
                lstNotifications = lstNotifications.Where(a => a.Email.Contains(MessageTo)).ToList();

            var jsonobj = new
            {
                Record_Count = lstNotifications.Count
            };
            return Json(jsonobj);
        }
        private void FetchData()
        {
            lstNotifications_Searched = null;
            Notification_Service objNotificationService = new Notification_Service(objLoginEntity.ConnectionStringName);
            lstNotifications_Searched = objNotificationService.SearchFor(x => true).OrderBy(o => o.NotificationsCode).ToList();
        }
        public ActionResult MessagePopUpBody(long NotificationCode, string MsgType)
        {
            try
            {
                Notification_Service objNotificationService = new Notification_Service(objLoginEntity.ConnectionStringName);
                Notifications Objnotifications = new Notifications();
                Objnotifications = objNotificationService.SearchFor(x => true).Where(x => x.NotificationsCode == NotificationCode).FirstOrDefault();

                if (Objnotifications.Email_Config != null)
                    if (Objnotifications.Email_Config.Email_Type != null)
                        ViewBag.EventType = Objnotifications.Email_Config.Email_Type;

                if (MsgType == "HTML")
                {
                    if (Objnotifications.HtmlBody != null)
                    {
                        ViewBag.Html = new HtmlString(Objnotifications.HtmlBody);
                    }
                    else
                    {
                        ViewBag.Html = "There is no Message for this event";
                    }
                }
                if (MsgType == "TEXT")
                {
                    if (Objnotifications.HtmlBody != null)
                    {
                        ViewBag.Html = new HtmlString(Objnotifications.TextBody);
                    }
                    else
                    {
                        ViewBag.Html = "There is no Message for this event";
                    }
                }
                return PartialView("_MessageViewPopUp");
            }
            catch (Exception ex)
            {
                throw;
            }

        }
        public PartialViewResult GetNotificationStatus(long NotificationCode, string NotificationType)
        {
            string AuthKey = GetAuthKey();
            var result = (dynamic)null;
            string RequestUri = Convert.ToString(ConfigurationManager.AppSettings["NotificationURL"]);
            System_Parameter_New_Service objSPNService = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
            System_Parameter_New objSPN = objSPNService.SearchFor(s => s.Parameter_Name == "Notification_ClientName" && s.IsActive == "Y").FirstOrDefault();
            NotificationStatus notificationStatus = new NotificationStatus();

            using (var client = new WebClient())
            {
                client.Headers.Add("Content-Type:application/json");
                client.Headers.Add("Accept:application/json");
                client.Headers.Add("AuthKey", AuthKey);
                client.Headers.Add("Service", "false");
                var Response = new
                {
                    ForeignId = NotificationCode,
                    ClientName = objSPN.Parameter_Value,
                    NotificationType = NotificationType
                };
                try
                {
                    ViewBag.Status = "STATUS";

                    CommonUtil.WriteErrorLog(DateTime.Now + "- Dispatcher screen 'NEGetNotificationByForeignId' API Called", "Authkey " + AuthKey);
                    CommonUtil.WriteErrorLog(DateTime.Now + "- Link API Called - " + RequestUri + "NEGetNotificationByForeignId", " - Data - " + JsonConvert.SerializeObject(Response));

                    result = client.UploadString(RequestUri + "NEGetNotificationByForeignId", JsonConvert.SerializeObject(Response));
                    notificationStatus = JsonConvert.DeserializeObject<NotificationStatus>(result);

                    CommonUtil.WriteErrorLog(DateTime.Now + "- Dispatcher screen API Called Successfully", "Response -" + result);
                    

                }
                catch (Exception ex)
                {
                    CommonUtil.WriteErrorLog(DateTime.Now + "-Dispatcher screen API Call Failed", ex.Message + ex.InnerException);
                    throw ex;
                }

                return PartialView("_MessageViewPopUp", notificationStatus);
            }
        }


        public class Response
        {
            public int NotificationsCode { get; set; }
            public int NotificationType { get; set; }
            public int EventCategory { get; set; }
            public int UserCode { get; set; }
            public int TransType { get; set; }
            public int TransCode { get; set; }
            public string Email { get; set; }
            public string Mobile { get; set; }
            public bool IsSend { get; set; }
            public bool IsRead { get; set; }
            public string CC { get; set; }
            public string BCC { get; set; }
            public string Subject { get; set; }
            public DateTime ScheduleDateTime { get; set; }
            public int NoOfRetry { get; set; }
            public int MsgStatusCode { get; set; }
            public DateTime SentOrReadDateTime { get; set; }
            public string ErrorCode { get; set; }
            public string ErrorDetails { get; set; }
            public DateTime CreatedOn { get; set; }
            public int CreatedBy { get; set; }
            public DateTime ModifiedOn { get; set; }
            public int ModifiedBy { get; set; }
            public bool IsAutoEscalated { get; set; }
            public bool IsReminderMail { get; set; }
            public string ClientName { get; set; }
            public int ForeignId { get; set; }
        }

        public class NotificationStatus
        {
            public string ResponseCode { get; set; }
            public bool Status { get; set; }
            public string Message { get; set; }
            public int NECode { get; set; }
            public string ErrorCode { get; set; }
            public string ErrorMessage { get; set; }
            public Response Response { get; set; }
        }

    }
}