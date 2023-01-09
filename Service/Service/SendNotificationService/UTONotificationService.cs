using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Security.Cryptography;
using System.ServiceProcess;
using System.Text;
using System.Timers;
using Timer = System.Timers.Timer;

namespace SendNotificationService
{
    public partial class UTONotificationService : ServiceBase
    {
        Timer timer;
        public static string strHostName { get; private set; }
        public static string ipAddress { get; private set; }
        public static string WriteLog { get; private set; }
        public static int LogLevel { get; private set; }
        public static string AuthKey { get; private set; }
        public void OnStart()
        {
            throw new NotImplementedException();
        }

        int count;

        public UTONotificationService()
        {
            InitializeComponent();
        }

        public void OnDebug()
        {
            OnStart(null);
        }

        protected override void OnStart(string[] args)
        {
            //System.Diagnostics.Debugger.Launch();
            strHostName = Dns.GetHostName();
            IPHostEntry ipEntry = Dns.GetHostEntry(strHostName);
            IPAddress[] addr = ipEntry.AddressList;
            ipAddress = addr[addr.Length - 1].ToString();

            string salt = ConfigurationSettings.AppSettings["salt"].ToString();

            byte[] bytesToBeEncrypted = Encoding.UTF8.GetBytes(salt);
            byte[] passwordBytes = Encoding.UTF8.GetBytes(ipAddress);

            byte[] bytesEncrypted = AES_Encrypt(bytesToBeEncrypted, passwordBytes);

            AuthKey = Convert.ToBase64String(bytesEncrypted);

            WriteLog = ConfigurationSettings.AppSettings["WriteLog"];
            LogLevel = Convert.ToInt16(ConfigurationSettings.AppSettings["LogLevel"]);
            if (Convert.ToBoolean(WriteLog)) { LogService("Service Started"); }
            if (LogLevel > 3) LogError("Service Started");
            StartTimer();
        }

        void StartTimer()
        {
            int runAtInterval = Convert.ToInt32(ConfigurationSettings.AppSettings["RunAtInterval"]);

            timer = new Timer(runAtInterval);
            timer.Elapsed += new ElapsedEventHandler(TimerElapsed);
            timer.Enabled = true;
            timer.Start();
        }

        void StopTimer()
        {
            timer.Stop();
            timer.Enabled = false;
        }

        public void TimerElapsed(object sender, ElapsedEventArgs e)
        {
            StopTimer();

            string process = "Timer Tick " + count + DateTime.Now;
            if (Convert.ToBoolean(WriteLog)) { LogService(process); }
            if (LogLevel > 3) LogError(process);
            count++;

            try
            {
                if (Convert.ToBoolean(WriteLog)) { LogService("Running Notification started"); }
                if (LogLevel > 3) LogError("Running Notification started");
                USPGetConfig objConfig = RunUSPGetConfigProcedure();

                if (Convert.ToBoolean(WriteLog)) { LogService("After fetching config"); }

                List<USPGetPendingNotifications> lstNotifications = RunUSPGetPendingNotificationsProcedure();

                if (Convert.ToBoolean(WriteLog)) { LogService("After Getting Pending List"); }

                RunNotifications(lstNotifications, objConfig);


                int time = DateTime.Now.Hour;
                int RunTime = Convert.ToInt32(ConfigurationSettings.AppSettings["ArchiveRunAtHrs"]);
                if (RunTime == time)
                {
                    if (DateTime.Now.Minute < 5)
                    {
                        if (Convert.ToBoolean(WriteLog)) { LogService("Running Archive started"); }
                        if (LogLevel > 3) LogError("Running Archive started");
                        int ArchiveDaysBefore = Convert.ToInt32(ConfigurationSettings.AppSettings["ArchiveDaysBefore"]);
                        RunUSPArchiveNotificationsProcedure(ArchiveDaysBefore);
                    }
                }

            }
            catch (Exception ex)
            {
                if (Convert.ToBoolean(WriteLog)) { LogService(ex.Message + " " + ex.StackTrace); }
                if (LogLevel > 3) LogError(ex.Message + " " + ex.StackTrace);
                throw;
            }

            StartTimer();
        }

        public static USPGetConfig RunUSPGetConfigProcedure()
        {
            SqlConnection myConn = new SqlConnection();
            myConn.ConnectionString = ConfigurationSettings.AppSettings["DefaultConnection"];
            myConn.Open();
            try
            {
                SqlCommand nonQryCommand = new SqlCommand();
                nonQryCommand.CommandType = CommandType.StoredProcedure;
                nonQryCommand.CommandText = "USPGetConfig";
                nonQryCommand.Connection = myConn;
                nonQryCommand.ExecuteNonQuery();
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = nonQryCommand;
                da.Fill(ds);

                List<USPGetConfig> lst = ds.Tables[0].AsEnumerable()
            .Select(dataRow => new USPGetConfig
            {
                NotificationConfigCode = dataRow.Field<long>("NotificationConfigCode"),
                NoOfTimesToRetry = dataRow.Field<int>("NoOfTimesToRetry"),
                DurationBetweenTwoRetriesMin = dataRow.Field<int>("DurationBetweenTwoRetriesMin"),
                RetryOptionForFailed = dataRow.Field<bool>("RetryOptionForFailed"),
                ResendOptionForSuccessful = dataRow.Field<bool>("ResendOptionForSuccessful"),
                SMTPServer = dataRow.Field<string>("SMTPServer"),
                SMTPPort = dataRow.Field<int>("SMTPPort"),
                UseDefaultCredentials = dataRow.Field<bool>("UseDefaultCredentials"),
                UserName = dataRow.Field<string>("UserName"),
                Password = dataRow.Field<string>("Password"),
            }).ToList();

                myConn.Close();
                myConn.Dispose();

                return lst.FirstOrDefault();
            }
            catch (Exception ex)
            {
                myConn.Close();
                myConn.Dispose();

                SendErrorEmail("API : RunUSPGetConfigProcedure => " + Convert.ToString(ex.InnerException), "Error on api : RunUSPGetConfigProcedure");
                if (Convert.ToBoolean(WriteLog)) { LogService("API : RunUSPGetConfigProcedure => " + Convert.ToString(ex.InnerException)); }
                if (LogLevel > 3) LogError("API : RunUSPGetConfigProcedure => " + Convert.ToString(ex.InnerException));

                return new USPGetConfig();
            }
        }

        public static List<USPGetPendingNotifications> RunUSPGetPendingNotificationsProcedure()
        {
            SqlConnection myConn = new SqlConnection();
            myConn.ConnectionString = ConfigurationSettings.AppSettings["DefaultConnection"];
            myConn.Open();

            try
            {
                SqlCommand nonQryCommand = new SqlCommand();
                nonQryCommand.CommandType = CommandType.StoredProcedure;
                nonQryCommand.CommandText = "USPGetPendingNotifications";
                nonQryCommand.Parameters.Add(new SqlParameter("@FromDateTime", SqlDbType.VarChar)).Value = DateTime.Now.ToString("dd-MMM-yyyy HH:mm");
                nonQryCommand.Connection = myConn;
                nonQryCommand.ExecuteNonQuery();
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = nonQryCommand;
                da.Fill(ds);

                List<USPGetPendingNotifications> lst = ds.Tables[0].AsEnumerable()
                .Select(dataRow => new USPGetPendingNotifications
                {
                    NotificationsCode = dataRow.Field<long>("NotificationsCode"),
                    Email = dataRow.Field<string>("Email"),
                    cc = dataRow.Field<string>("cc"),
                    bcc = dataRow.Field<string>("bcc"),
                    Subject = dataRow.Field<string>("Subject"),
                    HtmlBody = dataRow.Field<string>("HtmlBody"),
                    UserCode = dataRow.Field<long>("UserCode"),
                    RequestDateTime = dataRow.Field<DateTime>("RequestDateTime")
                }).ToList();

                myConn.Close();
                myConn.Dispose();

                return lst;
            }
            catch (Exception ex)
            {
                myConn.Close();
                myConn.Dispose();
                SendErrorEmail("API : RunUSPGetPendingNotificationsProcedure => " + Convert.ToString(ex.InnerException), "Error on api : RunUSPGetPendingNotificationsProcedure");
                if (Convert.ToBoolean(WriteLog)) { LogService("API : RunUSPGetPendingNotificationsProcedure => " + Convert.ToString(ex.InnerException)); }
                if (LogLevel > 3) LogError("API : RunUSPGetPendingNotificationsProcedure => " + Convert.ToString(ex.InnerException));
                return new List<USPGetPendingNotifications>();
            }
        }

        public static void RunNotifications(List<USPGetPendingNotifications> notificationList, USPGetConfig config)
        {
            UTOLog logObj = new UTOLog();
            logObj.ApplicationName = "Notification Engine";
            Boolean isSuccess; double TimeTaken;
            String ResponseText;
            DateTime startTime;

            if (Convert.ToBoolean(WriteLog)) { LogService("Inside Run Notifications"); }

            foreach (USPGetPendingNotifications notification in notificationList)
            {
                isSuccess = false; ResponseText = ""; TimeTaken = 0;
                try
                {
                    if (Convert.ToBoolean(WriteLog)) { LogService("Sending Email"); }

                    SendMail objSendEmail = new SendMail();
                    objSendEmail.UserName = config.UserName;
                    objSendEmail.Password = config.Password;
                    objSendEmail.FromEmailId = ConfigurationSettings.AppSettings["EmailSendId"];
                    objSendEmail.Port = config.SMTPPort;
                    objSendEmail.Ip = config.SMTPServer;

                    objSendEmail.Subject = notification.Subject;
                    objSendEmail.Body = notification.HtmlBody;
                    objSendEmail.To = notification.Email;
                    objSendEmail.CC = notification.cc;
                    objSendEmail.Bcc = notification.bcc;
                    objSendEmail.UseDefaultCredential = Convert.ToBoolean(ConfigurationSettings.AppSettings["UseDefaultCredential"]);

                    startTime = DateTime.Now;
                    objSendEmail.Send();
                    TimeTaken = DateTime.Now.Subtract(startTime).TotalMilliseconds;

                    isSuccess = true;
                    ResponseText = "Message Sent Ok";

                    if (Convert.ToBoolean(WriteLog)) { LogService("mail sent updating status in table"); }

                    RunUSPUpdateNotificationStatusProcedure(notification.NotificationsCode, isSuccess, 1, DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss"), 0, "");

                }
                catch (SmtpFailedRecipientsException ex)
                {
                    for (int i = 0; i < ex.InnerExceptions.Length; i++)
                    {
                        SmtpStatusCode status = ex.InnerExceptions[i].StatusCode;
                        if (status == SmtpStatusCode.MailboxBusy ||
                            status == SmtpStatusCode.MailboxUnavailable)
                        {
                            LogService("Delivery failed");
                            ResponseText = "Delivery failed";
                        }
                        else
                        {
                            if (Convert.ToBoolean(WriteLog)) { LogService("Failed to deliver message to {0}" + ex.InnerExceptions[i].FailedRecipient); }
                            ResponseText = "Failed to deliver message to {0}" + ex.InnerExceptions[i].FailedRecipient;
                        }
                    }
                    RunUSPUpdateNotificationStatusProcedure(notification.NotificationsCode, false, 2, DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss"), 0, Convert.ToString(ex.InnerException));
                    ManageEmailFailure(ResponseText, notification);
                }
                catch (Exception ex)
                {
                    string error = "API : RunNotifications => ";
                    if (ex.InnerException != null)
                    {
                        int i = 0;
                        while (ex.InnerException != null)
                        {
                            error = error + Convert.ToString(ex.InnerException);
                            i++;
                            if (i > 5) break;
                        }
                    }
                    else
                    {
                        error = error + ex.Message;
                    }
                    ResponseText = error;
                    SendErrorEmail(error, "Error on api : RunNotifications");
                    if (Convert.ToBoolean(WriteLog)) { LogService(error); }
                    RunUSPUpdateNotificationStatusProcedure(notification.NotificationsCode, false, 2, DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss"), 0, Convert.ToString(ex.InnerException));
                    ManageEmailFailure(ResponseText, notification);
                }

                logObj.RequestId = Convert.ToString(notification.NotificationsCode);
                logObj.UserId = Convert.ToString(notification.UserCode);
                logObj.RequestContent = "To: " + notification.Email + " <br/> CC: " + notification.cc + " <br/> Bcc:" + notification.bcc;
                logObj.RequestContent = logObj.RequestContent + " Subject: " + notification.Subject + " <br/><br/>" + notification.HtmlBody;
                logObj.RequestLength = Convert.ToString(logObj.RequestContent.ToString().Length);
                logObj.RequestDateTime = notification.RequestDateTime.ToString("dd-MMM-yyyy hh:mm:ss");
                logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy hh:mm:ss");
                logObj.ResponseContent = ResponseText;
                logObj.ResponseLength = Convert.ToString(ResponseText.Length);
                logObj.ServerName = config.SMTPServer + ":" + config.SMTPPort;
                logObj.UserAgent = "SMTP Server";
                logObj.Method = "Email";
                logObj.ClientIpAddress = ipAddress;
                logObj.IsSuccess = isSuccess.ToString();
                logObj.TimeTaken = Convert.ToString(TimeTaken);

                if (LogLevel > 3) LogService(logObj);
            }
            if (Convert.ToBoolean(WriteLog)) { LogService("Running Notification completed"); }
        }

        public static void SendErrorEmail(string Error, string Subject)
        {
            try
            {
                string HtmlBody = "<!DOCTYPE html>  <html>  <head>  <meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />  " +
                    " <title></title>  </head>  <style type='text/css'>      body{              margin:0;              padding:0;          }         "
                    + "   img{              border:0 none;              height:auto;              line-height:100%;              outline:none;        "
                    + "      text-decoration:none;          }            a img{              border:0 none;          }         " +
                    " table, td{              border-collapse:collapse;              padding: 0 10px;          }         "
                    + " table, th{              border-collapse:collapse;              padding: 8px 5px;          }     "
                    + "     table{               font-family: Helvetica;               mso-table-lspace:0pt;              "
                    + " mso-table-rspace:0pt;          }          p{           margin: 4px 0;          }    </style>  <body>"
                    + "   <table border='0' cellpadding='0' cellspacing='0' height='100%' width='100%'>  "
                    + "  <tr>     <td align='center' valign='top'>      <table border='0' cellpadding='0' cellspacing='0' "
                    + "width='720' style='border: 1px solid #000;background: #f1f1f1'>       <tr>        "
                    + "<td style='font-family: Helvetica;font-size:13px;padding-top: 10px;padding-bottom: 10px;'> Dear Sir/Madam,</td>       </tr> "
                    + "<tr>        <td style='font-family: Helvetica;font-size:13px;padding-bottom: 10px;'>        "
                    + "Below error found on notification service        </td>       </tr>"
                    + "<tr>        <td style='font-family: Helvetica;font-size:13px;padding-bottom: 10px;'>        "
                    + Error
                    + " </td>       </tr>       <tr>        <td style='font-family: Helvetica;font-size:13px;padding-bottom: 10px;padding-top: 10px;'>     "
                    + "    Thanks You,<br>             Notification – Admin        </td>       </tr>      </table>     </td>    </tr>   </table>  </body>  </html>";

                SendMail objSendEmail = new SendMail();
                objSendEmail.UserName = ConfigurationSettings.AppSettings["NTUserName"];
                objSendEmail.Password = ConfigurationSettings.AppSettings["NTPassword"];
                objSendEmail.FromEmailId = ConfigurationSettings.AppSettings["EmailSendId"];
                objSendEmail.Port = Convert.ToInt32(ConfigurationSettings.AppSettings["SMTPPort"]);
                objSendEmail.Ip = ConfigurationSettings.AppSettings["SMTPServer"];

                objSendEmail.Subject = Subject;
                objSendEmail.Body = HtmlBody;
                objSendEmail.To = ConfigurationSettings.AppSettings["EmailToId"];
                objSendEmail.CC = "";
                objSendEmail.Bcc = "";
                objSendEmail.Send();
            }
            catch (Exception ex)
            {
                if (Convert.ToBoolean(WriteLog)) { LogService("API : SendErrorEmail => " + Convert.ToString(ex.InnerException)); }
                if (LogLevel > 3) LogError("API : SendErrorEmail => " + Convert.ToString(ex.InnerException));
            }
        }
        public static void RunUSPUpdateNotificationStatusProcedure(long NECode, bool Issend, int MsgstatusCode, string SendorReadDateTime, int ErrorCode, string ErrorDetails)
        {
            SqlConnection myConn = new SqlConnection();
            myConn.ConnectionString = ConfigurationSettings.AppSettings["DefaultConnection"];
            myConn.Open();

            if (Convert.ToBoolean(WriteLog)) { LogService("inside table update"); }

            try
            {
                SqlCommand nonQryCommand = new SqlCommand();
                nonQryCommand.CommandType = CommandType.StoredProcedure;
                nonQryCommand.CommandText = "USPUpdateNotificationStatus";
                nonQryCommand.Parameters.Add(new SqlParameter("@NECode", SqlDbType.BigInt)).Value = NECode;
                nonQryCommand.Parameters.Add(new SqlParameter("@Issend", SqlDbType.Bit)).Value = Issend;
                nonQryCommand.Parameters.Add(new SqlParameter("@MsgstatusCode", SqlDbType.Int)).Value = MsgstatusCode;
                nonQryCommand.Parameters.Add(new SqlParameter("@SendorReadDateTime", SqlDbType.VarChar)).Value = SendorReadDateTime;
                nonQryCommand.Parameters.Add(new SqlParameter("@ErrorCode", SqlDbType.Int)).Value = ErrorCode;
                nonQryCommand.Parameters.Add(new SqlParameter("@ErrorDetails", SqlDbType.VarChar)).Value = ErrorDetails;
                nonQryCommand.Connection = myConn;
                nonQryCommand.ExecuteNonQuery();

                myConn.Close();
                myConn.Dispose();
            }
            catch (Exception ex)
            {
                myConn.Close();
                myConn.Dispose();

                SendErrorEmail("API : RunUSPUpdateNotificationStatusProcedure => " + Convert.ToString(ex.InnerException), "Error on api : RunUSPUpdateNotificationStatusProcedure");
                if (Convert.ToBoolean(WriteLog)) { LogService("API : RunUSPUpdateNotificationStatusProcedure => " + Convert.ToString(ex.InnerException)); }
                if (LogLevel > 3) LogError("API : RunUSPUpdateNotificationStatusProcedure => " + Convert.ToString(ex.InnerException));
            }
        }

        public static void RunUSPArchiveNotificationsProcedure(int daysInterval)
        {
            SqlConnection myConn = new SqlConnection();
            myConn.ConnectionString = ConfigurationSettings.AppSettings["DefaultConnection"];
            myConn.Open();

            try
            {
                SqlCommand nonQryCommand = new SqlCommand();
                nonQryCommand.CommandType = CommandType.StoredProcedure;
                nonQryCommand.CommandText = "USPArchiveNotifications";
                nonQryCommand.Parameters.Add(new SqlParameter("@DaysBefore", SqlDbType.Int)).Value = daysInterval;
                nonQryCommand.Connection = myConn;
                nonQryCommand.ExecuteNonQuery();
                DataSet ds = new DataSet();
                SqlDataAdapter da = new SqlDataAdapter();
                da.SelectCommand = nonQryCommand;
                da.Fill(ds);

                List<USPUpdateNotificationStatus> lst = ds.Tables[0].AsEnumerable()
                .Select(dataRow => new USPUpdateNotificationStatus
                {
                    NotificationsCode = dataRow.Field<long>("NotificationsCode")
                }).ToList();

                myConn.Close();
                myConn.Dispose();

                if (Convert.ToBoolean(WriteLog)) { LogService("Running Archive completed"); }
            }
            catch (Exception ex)
            {
                myConn.Close();
                myConn.Dispose();
                SendErrorEmail("API : RunUSPArchiveNotificationsProcedure => " + Convert.ToString(ex.InnerException), "Error on api : RunUSPArchiveNotificationsProcedure");

                if (Convert.ToBoolean(WriteLog)) { LogService("API : RunUSPArchiveNotificationsProcedure => " + Convert.ToString(ex.InnerException)); }
                if (LogLevel > 3) LogError("API : RunUSPArchiveNotificationsProcedure => " + Convert.ToString(ex.InnerException));
            }
        }

        public static void LogService(string content)
        {
            try
            {
                string rootLogFolderPath = ConfigurationSettings.AppSettings["LogFolderPath"];
                string FileName = rootLogFolderPath + "NotificationService" + "_" + DateTime.Now.Date.ToString("dd-MMM-yyyy") + "_" + "Log.txt";

                FileStream fs = new FileStream(FileName, FileMode.OpenOrCreate, FileAccess.Write);
                StreamWriter sw = new StreamWriter(fs);
                sw.BaseStream.Seek(0, SeekOrigin.End);
                sw.WriteLine(content);
                sw.Flush();
                sw.Close();
            }
            catch (Exception ex)
            {
                if (LogLevel > 3) LogError("Not able to write to file - " + ex.InnerException);
            }
        }

        private static void LogError(string content)
        {
            UTOLog logObj = new UTOLog();
            logObj.RequestId = "0";
            logObj.UserId = "-1";
            logObj.RequestContent = "";
            logObj.RequestLength = "0";
            logObj.RequestDateTime = DateTime.Now.ToString("dd-MMM-yyyy hh:mm:ss");
            logObj.ResponseDateTime = DateTime.Now.ToString("dd-MMM-yyyy hh:mm:ss");
            logObj.ResponseContent = content;
            logObj.ResponseLength = Convert.ToString(logObj.ResponseContent.Length);
            logObj.ServerName = strHostName;
            logObj.UserAgent = "Notification Service";
            logObj.Method = "Email";
            logObj.ClientIpAddress = ipAddress;
            logObj.IsSuccess = "false";

            LogService(logObj);
        }

        private static void LogService(UTOLog obj)
        {
            int timeout = 3600;
            string result = "";
            string url = ConfigurationSettings.AppSettings["LogURL"];

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);

            request.KeepAlive = false;
            request.ProtocolVersion = HttpVersion.Version10;
            request.ContentType = "application/Json";
            request.Method = "POST";
            request.Headers.Add("ContentType", "application/json");
            request.Headers.Add("AuthKey", AuthKey);
            request.Headers.Add("Service", "True");

            using (var streamWriter = new StreamWriter(request.GetRequestStream()))
            {
                string json = "{" + "\"ApplicationName\": \"Notification Engine\"," +
                        "\"RequestId\": \"" + obj.RequestId + "\"," +
                        "\"User\": \"" + obj.UserId + "\"," +
                        "\"RequestUri\": \"" + obj.RequestUri + "\"," +
                        "\"RequestMethod\": \"" + obj.RequestMethod + "\"," +
                        "\"Method\": \"" + obj.Method + "\"," +
                        "\"IsSuccess\": \"" + obj.IsSuccess + "\"," +
                        "\"TimeTaken\": \"" + obj.TimeTaken + "\"," +
                        "\"RequestContent\": \"" + obj.RequestContent.Replace("\"", "'") + "\"," +
                        "\"RequestLength\": \"" + obj.RequestLength + "\"," +
                        "\"RequestDateTime\": \"" + obj.RequestDateTime + "\"," +
                        "\"ResponseContent\": \"" + obj.ResponseContent + "\"," +
                        "\"ResponseLength\": \"" + obj.ResponseLength + "\"," +
                        "\"ResponseDateTime\": \"" + obj.ResponseDateTime + "\"," +
                        "\"HttpStatusCode\": \"\"," +
                        "\"HttpStatusDescription\": \"\"," +
                        "\"AuthenticationKey\": \"\"," +
                        "\"UserAgent\": \"" + obj.UserAgent + "\"," +
                        "\"ServerName\": \"" + obj.ServerName + "\"," +
                        "\"ClientIpAddress\": \"" + obj.ClientIpAddress + "\""
                    + "}";

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
                LogService("Not able to post to Log Service");
            }

            if (result != "")
            {
                //request posted successfully;
            }
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

        private static void ManageEmailFailure(string errMessage, USPGetPendingNotifications notification)
        {
            if (Convert.ToBoolean(WriteLog)) { LogService("inside Manage Email Failure update"); }

            string email = notification.Email.Replace(";", ",");
            string cc = notification.cc.Replace(";", ",");
            string bcc = notification.bcc.Replace(";", ",");

            string failList = "";
            string successList = "";

            List<string> eList = email.Split(',').ToList();
            eList.AddRange(cc.Split(',').ToList());
            eList.AddRange(bcc.Split(',').ToList());
            eList = eList.Distinct().ToList();

            foreach (string s in eList)
            {
                if (errMessage.IndexOf(s) > 0)
                {
                    failList = failList + s + ",";
                }
                else
                {
                    successList = successList + s + ",";
                }
            }

            //insert new email in notification table with failed email ids
            //Update earlier email entry in notification table with success and success emailids

            SqlConnection myConn = new SqlConnection();
            myConn.ConnectionString = ConfigurationSettings.AppSettings["DefaultConnection"];
            myConn.Open();

            if (failList != "")
            {
                try
                {
                    SqlCommand nonQryCommand = new SqlCommand();
                    nonQryCommand.CommandType = CommandType.StoredProcedure;
                    nonQryCommand.CommandText = "USPManageEmailFailure";
                    nonQryCommand.Parameters.Add(new SqlParameter("@NotificationsCode", SqlDbType.BigInt)).Value = notification.NotificationsCode;
                    nonQryCommand.Parameters.Add(new SqlParameter("@ErrorMessage", SqlDbType.VarChar)).Value = errMessage;
                    nonQryCommand.Parameters.Add(new SqlParameter("@FailureEmail", SqlDbType.VarChar)).Value = failList;
                    nonQryCommand.Connection = myConn;
                    nonQryCommand.ExecuteNonQuery();

                    myConn.Close();
                    myConn.Dispose();
                }
                catch (Exception ex)
                {
                    myConn.Close();
                    myConn.Dispose();

                    SendErrorEmail("API : USPManageEmailFailure => " + Convert.ToString(ex.InnerException), "Error on api : USPManageEmailFailure");
                    if (Convert.ToBoolean(WriteLog)) { LogService("API : USPManageEmailFailure => " + Convert.ToString(ex.InnerException)); }
                    if (LogLevel > 3) LogError("API : USPManageEmailFailure => " + Convert.ToString(ex.InnerException));
                }
            }
        }
    }
}
