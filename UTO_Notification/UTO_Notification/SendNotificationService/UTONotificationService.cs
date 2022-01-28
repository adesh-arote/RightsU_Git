using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Timers;
using Timer = System.Timers.Timer;
using System.Net;
using System.Net.Mail;

namespace SendNotificationService
{
    public partial class UTONotificationService : ServiceBase
    {
        Timer timer;

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
            System.Diagnostics.Debugger.Launch();
            LogService("Service Started");
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
            LogService(process);
            count++;
            

            try
            {
                LogService("Running Notification started");
                USPGetConfig objConfig = RunUSPGetConfigProcedure();
                List<USPGetPendingNotifications> lstNotifications = RunUSPGetPendingNotificationsProcedure();
                RunNotifications(lstNotifications, objConfig);

                int time = DateTime.Now.Hour;
                int RunTime = Convert.ToInt32(ConfigurationSettings.AppSettings["ArchiveRunAtHrs"]);
                if(RunTime == time)
                {
                    if(DateTime.Now.Minute < 5)
                    {
                        LogService("Running Archive started");
                        int ArchiveDaysBefore = Convert.ToInt32(ConfigurationSettings.AppSettings["ArchiveDaysBefore"]);
                        RunUSPArchiveNotificationsProcedure(ArchiveDaysBefore);
                    }
                }
                
            }
            catch (Exception ex)
            {
                LogService(ex.Message + " " + ex.StackTrace);
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

                LogService("API : RunUSPGetConfigProcedure => " + Convert.ToString(ex.InnerException));
                return new USPGetConfig();
            }
            //pass the stored procedure name
            // cmd.CommandText = "data_ins";

            //pass the parameter to stored procedure
            //  cmd.Parameters.Add(new SqlParameter("@name", SqlDbType.VarChar)).Value = name;
            // cmd.Parameters.Add(new SqlParameter("@age", SqlDbType.Int)).Value = age;

            //Execute the query
            // int res = cmd.ExecuteNonQuery();

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
                nonQryCommand.Parameters.Add(new SqlParameter("@FromDateTime", SqlDbType.VarChar)).Value = DateTime.Now.ToString("dd/MM/yyyy hh:mm");
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
                    HtmlBody = dataRow.Field<string>("HtmlBody")
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
                LogService("API : RunUSPGetPendingNotificationsProcedure => " + Convert.ToString(ex.InnerException));
                return new List<USPGetPendingNotifications>();
            }
        }

        public static void RunNotifications(List<USPGetPendingNotifications> notificationList, USPGetConfig config)
        {
            foreach (USPGetPendingNotifications notification in notificationList)
            {
                try
                {
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
                    objSendEmail.Send();

                    RunUSPUpdateNotificationStatusProcedure(notification.NotificationsCode, true, 1, DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss"), 0, "");
                }
                catch (Exception ex)
                {
                    string error = "API : RunNotifications => ";
                    if (ex.InnerException != null)
                    {
                        while (ex.InnerException != null)
                        {
                            error = error + Convert.ToString(ex.InnerException);
                        }
                    }
                    else
                    {
                        error = error + ex.Message;
                    }

                    SendErrorEmail("API : RunNotifications => " + error, "Error on api : RunNotifications");
                    LogService("API : RunNotifications => " + error);
                    RunUSPUpdateNotificationStatusProcedure(notification.NotificationsCode, false, 2, DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss"), 0, Convert.ToString(ex.InnerException));
                }
            }
            LogService("Running Notification completed");
        }

        public static void SendErrorEmail(string Error,string Subject)
        {
            try
            {
                string HtmlBody = "<!DOCTYPE html>  <html>  <head>  <meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />  "+
                    " <title></title>  </head>  <style type='text/css'>      body{              margin:0;              padding:0;          }         "
                    +"   img{              border:0 none;              height:auto;              line-height:100%;              outline:none;        "
                    +"      text-decoration:none;          }            a img{              border:0 none;          }         "+
                    " table, td{              border-collapse:collapse;              padding: 0 10px;          }         "
                    +" table, th{              border-collapse:collapse;              padding: 8px 5px;          }     "
                    +"     table{               font-family: Helvetica;               mso-table-lspace:0pt;              "
                    +" mso-table-rspace:0pt;          }          p{           margin: 4px 0;          }    </style>  <body>"
                    +"   <table border='0' cellpadding='0' cellspacing='0' height='100%' width='100%'>  "
                    +"  <tr>     <td align='center' valign='top'>      <table border='0' cellpadding='0' cellspacing='0' "
                    +"width='720' style='border: 1px solid #000;background: #f1f1f1'>       <tr>        "
                    +"<td style='font-family: Helvetica;font-size:13px;padding-top: 10px;padding-bottom: 10px;'> Dear Sir/Madam,</td>       </tr> "
                    +"<tr>        <td style='font-family: Helvetica;font-size:13px;padding-bottom: 10px;'>        "
                    +"Below error found on notification service        </td>       </tr>"
                    +"<tr>        <td style='font-family: Helvetica;font-size:13px;padding-bottom: 10px;'>        "
                    +Error
                    +" </td>       </tr>       <tr>        <td style='font-family: Helvetica;font-size:13px;padding-bottom: 10px;padding-top: 10px;'>     "
                    +"    Thanks You,<br>             Notification – Admin        </td>       </tr>      </table>     </td>    </tr>   </table>  </body>  </html>";

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
            catch(Exception ex)
            {
                LogService("API : SendErrorEmail => " + Convert.ToString(ex.InnerException));
            }
        }
        public static void RunUSPUpdateNotificationStatusProcedure(long NECode, bool Issend, int MsgstatusCode, string SendorReadDateTime, int ErrorCode, string ErrorDetails)
        {
            SqlConnection myConn = new SqlConnection();
            myConn.ConnectionString = ConfigurationSettings.AppSettings["DefaultConnection"];
            myConn.Open();

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
                // commented due to bug  31326 
                //DataSet ds = new DataSet();
                //SqlDataAdapter da = new SqlDataAdapter();
                //da.SelectCommand = nonQryCommand;
                //da.Fill(ds);


                //List<USPUpdateNotificationStatus> lst = ds.Tables[0].AsEnumerable()
                //.Select(dataRow => new USPUpdateNotificationStatus
                //{
                //    NotificationsCode = dataRow.Field<long>("NotificationsCode")
                //}).ToList();
                //commented due to bug  31326 

                myConn.Close();
                myConn.Dispose();


            }
            catch (Exception ex)
            {

                myConn.Close();
                myConn.Dispose();

                SendErrorEmail("API : RunUSPUpdateNotificationStatusProcedure => " + Convert.ToString(ex.InnerException), "Error on api : RunUSPUpdateNotificationStatusProcedure");


                LogService("API : RunUSPUpdateNotificationStatusProcedure => " + Convert.ToString(ex.InnerException));
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

                LogService("Running Archive completed");
            }
            catch (Exception ex)
            {

                myConn.Close();
                myConn.Dispose();
                SendErrorEmail("API : RunUSPArchiveNotificationsProcedure => " + Convert.ToString(ex.InnerException), "Error on api : RunUSPArchiveNotificationsProcedure");

                LogService("API : RunUSPArchiveNotificationsProcedure => " + Convert.ToString(ex.InnerException));
            }
        }

        private static void LogService(string content)
        {
            //ApplicationConfiguration applicationConfiguration = new ApplicationConfiguration();
            //string rootLogFolderPath = applicationConfiguration.GetConfigurationValue("RootLogFolderPath");
            //string rootAppName = applicationConfiguration.GetConfigurationValue("RootAppName");
            //string appName = applicationConfiguration.GetConfigurationValue("AppName");
            string rootLogFolderPath = ConfigurationSettings.AppSettings["LogFolderPath"];
            string FileName = rootLogFolderPath + "NotificationService"  + "_" + DateTime.Now.Date.ToString("dd-MMM-yyyy") + "_" + "Log.txt";

            FileStream fs = new FileStream(FileName, FileMode.OpenOrCreate, FileAccess.Write);
            StreamWriter sw = new StreamWriter(fs);
            sw.BaseStream.Seek(0, SeekOrigin.End);
            sw.WriteLine(content);
            sw.Flush();
            sw.Close();
        }
    }
}
