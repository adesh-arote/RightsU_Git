using System;
using System.Net.Http;
using System.Web.Mvc;

namespace RightsU_Plus.Controllers
{
    public class NotificationController : BaseController
    {

        public ActionResult GetEmail()
        {
            using (var client = new HttpClient())
            {
                client.BaseAddress = new Uri("http://localhost:64189/api/notification");

                var objNot = new Notification
                {
                    NECode = 5,
                    TransType = 1,
                    TransCode = 1,
                    UserCode = 0,
                    NotificationType = "",
                    ScheduleDateTime = System.DateTime.Now,
                    SentDateTime = System.DateTime.Now,
                    EventCategory = 1,
                    Recipient = "",
                    Subject = "",
                    Status = "",
                    NoOfRetry = 0
                };



                //HTTP POST
                var postTask = client.PostAsJsonAsync("", );
                postTask.Wait();

                var result = postTask.Result;
                if (result.IsSuccessStatusCode)
                {
                    return RedirectToAction("Index");
                }
            }

            return View();
        }

        // GET: api/Notification
        //public HttpResponseMessage GetNotifiation()
        //{

        //    //            {
        //    //NECode: 
        //    //TransType: Deal,
        //    //TransCode: ,
        //    //UserCode: ,
        //    //NotificationType: ,
        //    //ScheduleDateTime: ,
        //    //SentDateTime:,
        //    //EventCategory: ,
        //    //Recipient: ,
        //    //Subject: ,
        //    //Status: ,
        //    //NoOfRetry: 
        //    //}

        //    return Ok(");
        //}


    }


    public class Notification
    {
        public int NECode { get; set; }
        public string NotificationType { get; set; }
        public int EventCategory { get; set; }
        public int UserCode { get; set; }
        public int TransType { get; set; }
        public int TransCode { get; set; }
        public string Recipient { get; set; }
        public string Mobile { get; set; }
        public int IsSend { get; set; }
        public int IsRead { get; set; }
        public string CC { get; set; }
        public string BCC { get; set; }
        public string Subject { get; set; }
        public string HtmlBody { get; set; }
        public string TextBody { get; set; }
        public Nullable<System.DateTime> ScheduleDateTime { get; set; }
        public int NoOfRetry { get; set; }
        public int MsgStatusCode { get; set; }
        public Nullable<System.DateTime> SentDateTime { get; set; }
        public string Status { get; set; }
        public string ErrorDetails { get; set; }
        public Nullable<System.DateTime> CreatedOn { get; set; }
        public int CreatedBy { get; set; }
        public Nullable<System.DateTime> ModifiedOn { get; set; }
        public int ModifiedBy { get; set; }
        public int IsAutoEscalated { get; set; }
        public int IsReminderMail { get; set; }
        public string Service_Response { get; set; }
    }
}
