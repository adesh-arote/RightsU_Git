using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.Entity;
using System.Diagnostics;
using System.Linq;
using System.Net;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using System.Timers;

namespace RightsU_Notification_Service
{
    public partial class NotificationService : ServiceBase
    {
        public static string IsAuthKeyRequired = "N";//Convert.ToString(ConfigurationSettings.AppSettings["IsAuthKeyRequired"]);
        public static string AuthKey = "";//AES Encryption

        public static string RequestUri = "";
        public static int Max_Retry_Limit = 5;
        public Timer timer = new Timer();

        public NotificationService()
        {
            InitializeComponent();
            string hostName = Dns.GetHostName(); // Retrive the Name of HOST
            string myIP = Dns.GetHostByName(hostName).AddressList[0].ToString();

            AuthKey = AesOperation.EncryptString("R!ghT$U@uT@", myIP);
            Error.WriteLog("Service Started", includeTime: true, addSeperater: true);
        }


        protected override void OnStart(string[] args)
        {
            timer.Interval = Convert.ToInt32(ConfigurationSettings.AppSettings["Timer"]);
            timer.Elapsed += new System.Timers.ElapsedEventHandler(this.OnTimer);
            timer.Start();
        }

        protected override void OnStop()
        {
            Error.WriteLog("Service Stoped", includeTime: true, addSeperater: true);
        }

        public void OnTimer(object sender, System.Timers.ElapsedEventArgs args)
        {
            timer.Stop();
            Error.WriteLog("EXE started", includeTime: true, addSeperater: true);
            try
            {
                SendPendingRecords();
                SendErrorRecords();
            }
            catch (Exception ex)
            {
                StringBuilder sb = new StringBuilder("Found Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                while (ex.InnerException != null)
                {
                    ex = ex.InnerException;
                    sb.Append(" | Inner Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                }

                Error.WriteLog_Conditional(sb.ToString(), addSeperater: true);
            }
            finally
            {
                Error.WriteLog("EXE Ended", includeTime: true, addSeperater: true);
                timer.Start();
            }
        }

        public static void SendErrorRecords()
        {
            using (var client = new WebClient())
            {
                using (var context = new RightsU_Plus_Entities())
                {
                    var result = (dynamic)null;

                    client.Headers.Clear();
                    client.Headers.Add("Content-Type:application/json");
                    client.Headers.Add("Accept:application/json");
                    if (IsAuthKeyRequired == "Y")
                        client.Headers.Add("Authorization", "Bearer " + AuthKey);

                    List<Notification> lstNotification = context.Notifications.Where(x => x.API_Status == "E").ToList();

                    if (lstNotification.Count > 0)
                    {
                        foreach (var x in lstNotification)
                        {
                            var Response = new
                            {
                                EventCategory = x.EventCategory,
                                NotificationType = x.NotificationType,
                                RecipientList = new { To = x.Email, CC = x.CC, BCC = x.BCC },
                                Subject = x.Subject,
                                HTMLMessage = x.HtmlBody,
                                TextMessage = x.TextBody,
                                TransType = x.TransType,
                                TransCode = x.TransCode,
                                ScheduleDateTime = x.ScheduleDateTime,
                                UserCode = x.UserCode
                            };

                            if (x.NoOfRetry >= Max_Retry_Limit)
                            {
                                //Notify to the Particular End User
                            }
                            else
                            {
                                result = client.UploadString(RequestUri, JsonConvert.SerializeObject(Response));
                                Update_Notification(x.NotificationsCode, result, true);
                            }
                        }
                    }
                }
            }
        }

        public static void SendPendingRecords()
        {
            using (var client = new WebClient())
            {
                using (var context = new RightsU_Plus_Entities())
                {
                    var result = (dynamic)null;

                    client.Headers.Clear();
                    client.Headers.Add("Content-Type:application/json");
                    client.Headers.Add("Accept:application/json");
                    if (IsAuthKeyRequired == "Y")
                        client.Headers.Add("Authorization", "Bearer " + AuthKey);

                    List<Notification> lstNotification = context.Notifications.Where(x => x.API_Status == "P").ToList();


                    if (lstNotification.Count > 0)
                    {
                        foreach (var x in lstNotification)
                        {
                            var Response = new
                            {
                                EventCategory = x.EventCategory,
                                NotificationType = x.NotificationType,
                                RecipientList = new { To = x.Email, CC = x.CC, BCC = x.BCC },
                                Subject = x.Subject,
                                HTMLMessage = x.HtmlBody,
                                TextMessage = x.TextBody,
                                TransType = x.TransType,
                                TransCode = x.TransCode,
                                ScheduleDateTime = x.ScheduleDateTime,
                                UserCode = x.UserCode
                            };

                            //“Status”:”Ok”,
                            //“Message”: “Request Queued Successfully”,
                            //“ErrorCode”:””,
                            //“ErrorMessage”: “”,
                            //“NECode”: “100020”
                            result = client.UploadString(RequestUri, JsonConvert.SerializeObject(Response));
                            Update_Notification(x.NotificationsCode, result);
                        }
                    }
                }
            }
        }
        public static void Update_Notification(long NotificationsCode, dynamic Response, bool Retry = false)
        {
            using (var context = new RightsU_Plus_Entities())
            {
                Notification objNotification = context.Notifications.Where(x => x.NotificationsCode == NotificationsCode).FirstOrDefault();
                objNotification.Service_Response = Convert.ToString(Response);
                objNotification.API_Status = Response.Status == "Ok" ? "C" : "E";
                objNotification.ErrorDetails = Response.ErrorMessage == "" ? null : Response.ErrorMessage;
                objNotification.NoOfRetry = Retry ? objNotification.NoOfRetry + 1 : 0;
                context.Entry(objNotification).State = EntityState.Modified;
                context.SaveChanges();
            }
        }
    }
}
