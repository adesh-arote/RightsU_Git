using Newtonsoft.Json;
using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Text;
using System.Web.Mvc;
using UTO.Framework.Shared.Configuration;

namespace RightsU_Plus.Controllers
{
    public class NotificationController : BaseController
    {
        public static string baseUri;
        public static string AuthKey;

        public NotificationController()
        {
            string hostName = Dns.GetHostName(); // Retrive the Name of HOST
            string myIP = Dns.GetHostByName(hostName).AddressList[0].ToString();

            byte[] bytesToBeEncrypted = Encoding.UTF8.GetBytes("abc123");
            byte[] passwordBytes = Encoding.UTF8.GetBytes(myIP);

            byte[] bytesEncrypted = AES_Encrypt(bytesToBeEncrypted, passwordBytes);
            AuthKey = Convert.ToBase64String(bytesEncrypted);

            baseUri = new ApplicationConfiguration().GetConfigurationValue("NotificationApi");
        }
        private byte[] AES_Encrypt(byte[] bytesToBeEncrypted, byte[] passwordBytes)
        {
            byte[] encryptedBytes = null;
            byte[] saltBytes = new byte[] { 1, 2, 3, 4, 5, 6, 7, 8 };
            using (MemoryStream ms = new MemoryStream())
            {
                using (RijndaelManaged AES = new RijndaelManaged())
                {
                    AES.KeySize = 256;
                    AES.BlockSize = 128;

                    var key = new Rfc2898DeriveBytes(passwordBytes, saltBytes, 1000);
                    AES.Key = key.GetBytes(AES.KeySize / 8);
                    AES.IV = key.GetBytes(AES.BlockSize / 8);

                    AES.Mode = CipherMode.CBC;

                    using (var cs = new CryptoStream(ms, AES.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(bytesToBeEncrypted, 0, bytesToBeEncrypted.Length);
                        cs.Close();
                    }
                    encryptedBytes = ms.ToArray();
                }
            }

            return encryptedBytes;
        }
        public List<EventCategoryMsgCount> GetSummarisedMessageStatus()
        {
            int timeout = 3600;
            string result = "";

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(baseUri + "NEGetSummarisedMessageStatus");

            request.KeepAlive = false;
            request.ProtocolVersion = HttpVersion.Version10;
            request.ContentType = "application/Json";
            request.Method = "POST";
            request.Headers.Add("ContentType", "application/json");
            request.Headers.Add("AuthKey", AuthKey);
            request.Headers.Add("Service", "true");
            //Ragnar_Tygerian@uto.in;sds_daf@uto.in
            var objEmail = new
            {
                UserEmail = "Ragnar_Tygerian@uto.in"// objLoginUser.Email_Id
            };

            using (var streamWriter = new StreamWriter(request.GetRequestStream()))
            {
                string json = JsonConvert.SerializeObject(objEmail);
                streamWriter.Write(json);
            }

            var httpResponse = (HttpWebResponse)request.GetResponse();
            try
            {
                using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                {
                    result = streamReader.ReadToEnd();
                }
            }
            catch (Exception ex)
            {
                request.Abort();
            }

            if (result != "")
            {
                HttpResponseClass objData = JsonConvert.DeserializeObject<HttpResponseClass>(result);
                List<EventCategoryMsgCount> lst = JsonConvert.DeserializeObject<List<EventCategoryMsgCount>>(objData.Response.ToString());

                return lst;
                //return PartialView("~/Views/Shared/_Email_Pannel.cshtml", lst);
            }
            return new List<EventCategoryMsgCount>();
            //return PartialView("~/Views/Shared/_Email_Pannel.cshtml", new List<EventCategoryMsgCount>());
        }

        public ActionResult Show_Email_Popup(string Email_Type)
        {
            string result = "";

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(baseUri + "NEGetMessageStatus");

            request.KeepAlive = false;
            request.ProtocolVersion = HttpVersion.Version10;
            request.ContentType = "application/Json";
            request.Method = "POST";
            request.Headers.Add("ContentType", "application/json");
            request.Headers.Add("AuthKey", AuthKey);
            request.Headers.Add("Service", "true");

            var objNoti = new
            {
                NECode = "",
                TransType = "",
                TransCode = "",
                UserCode = "",
                NotificationType = "",
                ScheduleDateTime ="",
                SentDateTime = "",
                EventCategory = Email_Type, //"Channel Unutilized Run",
                Recipient = "Ragnar_Tygerian@uto.in",// objLoginUser.Email_Id,
                Subject = "",
                Status = "",
                isRead = "0",
                isSend = "",
                NoOfRetry = "",
                size = "500",
                from = "0"
            };

            using (var streamWriter = new StreamWriter(request.GetRequestStream()))
            {
                string json = JsonConvert.SerializeObject(objNoti);
                streamWriter.Write(json);
            }

            var httpResponse = (HttpWebResponse)request.GetResponse();
            try
            {
                using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                {
                    result = streamReader.ReadToEnd();
                }
            }
            catch (Exception ex)
            {
                request.Abort();
            }

            if (result != "")
            {
                HttpResponseClass objData = JsonConvert.DeserializeObject<HttpResponseClass>(result);
                HttpResponseClass lstResponse = JsonConvert.DeserializeObject<HttpResponseClass>(objData.Response.ToString());
                List<GetMessageStatus> lstGetMessageStatus = JsonConvert.DeserializeObject<List<GetMessageStatus>>(lstResponse.lstGetMessages.ToString());

                return PartialView("_Email_Notification_Popup", lstGetMessageStatus);
            }
            return PartialView("_Email_Notification_Popup", new GetMessageStatus());
        }

        public JsonResult UpdateMessageStatus(int NECode, int NEDetailCode)
        {
            string result = "";
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(baseUri + "NEUpdateMessageStatus");

            request.KeepAlive = false;
            request.ProtocolVersion = HttpVersion.Version10;
            request.ContentType = "application/Json";
            request.Method = "POST";
            request.Headers.Add("ContentType", "application/json");
            request.Headers.Add("AuthKey", AuthKey);
            request.Headers.Add("Service", "true");

            var objEmailStatus = new
            {
                NECode = NECode,
                NEDetailCode = NEDetailCode,
                UpdatedStatus = "Read",
                ReadDateTime = System.DateTime.Now.ToString("dd-MMM-yyyy hh:mm:ss")
            };

            using (var streamWriter = new StreamWriter(request.GetRequestStream()))
            {
                string json = JsonConvert.SerializeObject(objEmailStatus);
                streamWriter.Write(json);
            }

            var httpResponse = (HttpWebResponse)request.GetResponse();
            try
            {
                using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                {
                    result = streamReader.ReadToEnd();
                }
            }
            catch (Exception ex)
            {
                request.Abort();
            }

            if (result != "")
            {
                HttpResponseClass objData = JsonConvert.DeserializeObject<HttpResponseClass>(result);

                return Json(new EmailStatus());
            }
            return Json(new EmailStatus());
        }
    }

    public class HttpResponseClass
    {
        public string ResponseCode { get; set; }
        public bool Status { get; set; }
        public string Message { get; set; }
        public string NECode { get; set; }
        public string ErrorCode { get; set; }
        public string ErrorMessage { get; set; }
        public Object Response { get; set; }
        public Object lstGetMessages { get; set; }
    }

    public class EventCategoryMsgCount
    {
        public int Email_Config_Code { get; set; }
        public string EventCategory { get; set; }
        public int cnt { get; set; }
    }

    public class GetMessageStatus
    {
        public Nullable<int> TotalRecords { get; set; }
        public Nullable<long> RowNum { get; set; }
        public long NotificationsCode { get; set; }
        public string EventCategory { get; set; }
        public Nullable<long> TransactionCode { get; set; }
        public string TransactionType { get; set; }
        public string MessageType { get; set; }
        public string Subject { get; set; }
        public string Message { get; set; }
        public string SentTo { get; set; }
        public string Status { get; set; }
        public int NoOfRetry { get; set; }
        public string ScheduleDateTime { get; set; }
        public string SentDateTime { get; set; }
        public int NECode { get; set; }
        public int NotificationDetailCode { get; set; }
    }

    //-----------------------------------
    public class EmailStatus
    {
        public string Status { get; set; }
        public string Message { get; set; }
        public int ErrorCode { get; set; }
        public string ErrorMessage { get; set; }
    }
    public class EmailViewModel
    {
        public int totalRecords { get; set; }
        //public ICollection<Data> Datas { get; set; }
    }

    //public class Data
    //{
    //    public string Email_Config_Code { get; set; }
    //    public string EventCategory { get; set; }
    //    public int Count { get; set; }
    //    public int TransactionCode { get; set; }
    //    public int TransactionType { get; set; }
    //    public string MessageType { get; set; }
    //    public string Subject { get; set; }
    //    public string Message { get; set; }
    //    public string SentTo { get; set; }
    //    public string Status { get; set; }
    //    public int NoOfRetry { get; set; }
    //    public Nullable<System.DateTime> SentDateTime { get; set; }
    //    public Nullable<System.DateTime> ScheduleDateTime { get; set; }
    //    public int NECode { get; set; }
    //    public int NEDetailCode { get; set; }
    //}

}
