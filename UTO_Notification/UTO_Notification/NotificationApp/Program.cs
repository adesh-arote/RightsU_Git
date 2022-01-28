using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NotificationApp
{
    class Program
    {
        static void Main(string[] args)
        {
            USPGetConfig objConfig = RunUSPGetConfigProcedure();
            List<USPGetPendingNotifications> lstNotifications = RunUSPGetPendingNotificationsProcedure();
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
                    RunUSPUpdateNotificationStatusProcedure(notification.NotificationsCode, false, 2, DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss"), 0, Convert.ToString(ex.InnerException));
                }
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
                nonQryCommand.CommandText = "USPGetPendingNotifications";
                nonQryCommand.Parameters.Add(new SqlParameter("@NECode", SqlDbType.BigInt)).Value = NECode;
                nonQryCommand.Parameters.Add(new SqlParameter("@Issend", SqlDbType.Bit)).Value = Issend;
                nonQryCommand.Parameters.Add(new SqlParameter("@MsgstatusCode", SqlDbType.Int)).Value = MsgstatusCode;
                nonQryCommand.Parameters.Add(new SqlParameter("@SendorReadDateTime", SqlDbType.VarChar)).Value = SendorReadDateTime;
                nonQryCommand.Parameters.Add(new SqlParameter("@ErrorCode", SqlDbType.Int)).Value = ErrorCode;
                nonQryCommand.Parameters.Add(new SqlParameter("@ErrorDetails", SqlDbType.VarChar)).Value = ErrorDetails;
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


            }
            catch (Exception ex)
            {

                myConn.Close();
                myConn.Dispose();

                LogService("API : RunUSPUpdateNotificationStatusProcedure => " + Convert.ToString(ex.InnerException));
            }
        }

        private static void LogService(string content)
        {
            //ApplicationConfiguration applicationConfiguration = new ApplicationConfiguration();
            //string rootLogFolderPath = applicationConfiguration.GetConfigurationValue("RootLogFolderPath");
            //string rootAppName = applicationConfiguration.GetConfigurationValue("RootAppName");
            //string appName = applicationConfiguration.GetConfigurationValue("AppName");
            string rootLogFolderPath = ConfigurationSettings.AppSettings["LogFolderPath"];
            string FileName = rootLogFolderPath + "NotificationService" + "_" + DateTime.Now.Date.ToString("dd-MMM-yyyy") + "_" + "Log.txt";

            FileStream fs = new FileStream(FileName, FileMode.OpenOrCreate, FileAccess.Write);
            StreamWriter sw = new StreamWriter(fs);
            sw.BaseStream.Seek(0, SeekOrigin.End);
            sw.WriteLine(content);
            sw.Flush();
            sw.Close();
        }

    }
}
