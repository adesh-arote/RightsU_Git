using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RightsU_Plus.Controllers
{
    public class Dispatcher_SearchController : BaseController
    {
        public ActionResult Index()
        {
            BindDDL();
            return View();
        }
        public void BindDDL()
        {
            ViewBag.EventType = new SelectList(new Email_Config_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).OrderBy(x => x.Email_Type), "Email_Config_Code", "Email_Type").ToList();
            ViewBag.EventPlatform = new SelectList(new Event_Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).OrderBy(x => x.Short_Code), "Short_Code", "Short_Code").ToList();
        }

        public ActionResult GetNotifications(DateTime? StartDate, DateTime? EndDate, string EventType, string Platform, string MessageType, string MessageTo, string BtnType)
        {
            string status = "S", message = "";

            System_Parameter_New_Service objSPNService = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
            Notification_Service objNotificationService = new Notification_Service(objLoginEntity.ConnectionStringName);
            List<Notifications> lstnotification = new List<Notifications>();

            #region Startdate Validation
            DateTime CurrentDate = DateTime.Now;
            if (BtnType == "NA")
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
            if (BtnType == "AR")
            {
                StartDate = CurrentDate.AddDays(-10);
                EndDate = DateTime.Now;
            }
            #endregion

            lstnotification = objNotificationService.SearchFor(s => true).ToList().Where(a => (a.CreatedOn >= StartDate && a.CreatedOn <= EndDate)).ToList();
            if (MessageType != null)
            {
                ViewBag.MessageType = MessageType;
                if (MessageType == "HTML")
                    lstnotification = lstnotification.Where(a => a.HtmlBody != null).ToList();
                if (MessageType == "TEXT")
                    lstnotification = lstnotification.Where(a => a.TextBody != null).ToList();
            }
            if (MessageTo != null && MessageTo != "")
                lstnotification = lstnotification.Where(a => a.Email.Contains(MessageTo)).ToList();

            return PartialView("_Dispatcher_List", lstnotification);
        }


        public ActionResult MessagePopUpBody(long NotificationCode, string MsgType)
        {
            try
            {
                string status = "", message = "";
                Notification_Service objNotificationService = new Notification_Service(objLoginEntity.ConnectionStringName);
                Notifications Objnotifications = new Notifications();
                Objnotifications = objNotificationService.SearchFor(x=> true).Where(x=>x.NotificationsCode == NotificationCode).FirstOrDefault();

                if (MsgType == "HTML")
                {
                    if (Objnotifications.HtmlBody != null)
                    {                        
                        ViewBag.Html = new HtmlString(Objnotifications.HtmlBody);
                        return PartialView("_MessageViewPopUp");
                    }
                    else
                    {
                        status = "E";
                        message = "There is no Message for this event";
                    }
                }
                if (MsgType == "TEXT")
                {
                    if (Objnotifications.HtmlBody != null)
                    {
                        ViewBag.Html = new HtmlString(Objnotifications.TextBody);
                        return PartialView("_MessageViewPopUp");
                    }
                    else
                    {
                        status = "E";
                        message = "There is no Message for this event";
                    }
                }
                var obj = new
                {
                    Status = status,
                    Message = message
                };
                return Json(obj);
            }
            catch (Exception ex)
            {
                throw;
            }

        }
    }
}