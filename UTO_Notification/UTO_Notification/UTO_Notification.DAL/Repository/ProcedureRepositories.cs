using Dapper;
using System;
using System.Collections.Generic;
using System.Net;
using UTO_Notification.Entities;
using UTO_Notification.Entities.ProcedureEntities;

namespace UTO_Notification.DAL
{

    public class ProcedureRepositories : ProcRepository
    {
        public ProcedureRepositories(string connectionStr) : base(connectionStr) { }

        HttpResponses httpResponses = new HttpResponses();

        public IEnumerable<USPInsertNotification> USPInsertNotification(string EventCategory, string NotificationType, string TO, string CC, string BCC, string Subject, string HTMLMessage, string TextMessage, string TransType, long TransCode, string ScheduleDateTime, long UserCode, string ClientName, long ForeignId, string AttachmentFileName)
        {
            var param = new DynamicParameters();
            param.Add("@EventCategory", EventCategory);
            param.Add("@NotificationType", NotificationType);
            param.Add("@TO", TO);
            param.Add("@CC", CC);
            param.Add("@BCC", BCC);
            param.Add("@Subject", Subject);
            param.Add("@HTMLMessage", HTMLMessage);
            param.Add("@TextMessage", TextMessage);
            param.Add("@TransType", TransType);
            param.Add("@TransCode", TransCode);
            param.Add("@ScheduleDateTime", ScheduleDateTime);
            param.Add("@UserCode", UserCode);
            param.Add("@ClientName", ClientName);
            param.Add("@ForeignId", ForeignId);
            param.Add("@AttachmentFileName", AttachmentFileName); 

            return base.ExecuteSQLProcedure<USPInsertNotification>("USPInsertNotification", param);
        }

        public IEnumerable<USPInsertNotification> USPInsertNotification_Teams(string EventCategory, string NotificationType, string TO, string CC, string BCC, string Subject, string HTMLMessage, string TextMessage, string TransType, long TransCode, string ScheduleDateTime, long UserCode, string ClientName, long ForeignId, string AttachmentFileName)
        {
            var param = new DynamicParameters();
            param.Add("@EventCategory", EventCategory);
            param.Add("@NotificationType", NotificationType);
            param.Add("@TO", TO);
            param.Add("@CC", CC);
            param.Add("@BCC", BCC);
            param.Add("@Subject", Subject);
            param.Add("@HTMLMessage", HTMLMessage);
            param.Add("@TextMessage", TextMessage);
            param.Add("@TransType", TransType);
            param.Add("@TransCode", TransCode);
            param.Add("@ScheduleDateTime", ScheduleDateTime);
            param.Add("@UserCode", UserCode);
            param.Add("@ClientName", ClientName);
            param.Add("@ForeignId", ForeignId);
            param.Add("@AttachmentFileName", AttachmentFileName);

            return base.ExecuteSQLProcedure<USPInsertNotification>("USPInsertNotification_Teams", param);
        }

        public IEnumerable<USPInsertNotification> USPInsertNotification_InApp(string EventCategory, string NotificationType, string TO, string CC, string BCC, string Subject, string HTMLMessage, string TextMessage, string TransType, long TransCode, string ScheduleDateTime, long UserCode, string ClientName, long ForeignId, string AttachmentFileName)
        {
            var param = new DynamicParameters();
            param.Add("@EventCategory", EventCategory);
            param.Add("@NotificationType", NotificationType);
            param.Add("@TO", TO);
            param.Add("@CC", CC);
            param.Add("@BCC", BCC);
            param.Add("@Subject", Subject);
            param.Add("@HTMLMessage", HTMLMessage);
            param.Add("@TextMessage", TextMessage);
            param.Add("@TransType", TransType);
            param.Add("@TransCode", TransCode);
            param.Add("@ScheduleDateTime", ScheduleDateTime);
            param.Add("@UserCode", UserCode);
            param.Add("@ClientName", ClientName);
            param.Add("@ForeignId", ForeignId);
            param.Add("@AttachmentFileName", AttachmentFileName);

            return base.ExecuteSQLProcedure<USPInsertNotification>("USPInsertNotification_InApp", param);
        }

        public IEnumerable<USPInsertNotification> USPUpdateNotification(long NECode, string UpdatedStatus, string ReadDateTime, string NEDetailCode, string Client_Name = "", string Notification_App = "")
        {
            var param = new DynamicParameters();
            param.Add("@NECode", NECode);
            param.Add("@UpdatedStatus", UpdatedStatus);
            param.Add("@ReadDateTime", ReadDateTime);
            param.Add("@NEDetailCode", NEDetailCode);

            param.Add("@ClientName", Client_Name);
            param.Add("@NotificationApp", Notification_App);


            return base.ExecuteSQLProcedure<USPInsertNotification>("USPUpdateNotification", param);
        }

        public IEnumerable<USPGetMessageStatus> USPGetMessageStatus(string NECode, string TransType, string TransCode, string UserCode, string NotificationType, string EventCategory, string Subject, string Status, int NoOfRetry, int size, int from, string ScheduleStartDateTime, string ScheduleEndDateTime, string SentStartDateTime, string SentEndDateTime, string Recipient, string isRead, string isSend, string ClientName = "", string NotificationApp = "", string CallFor = "")
        {
            var param = new DynamicParameters();
            param.Add("@NECode", NECode);

            string TType = "";
            string[] t;

            t = TransType.Split(',');

            foreach (string str in t)
            {
                if (str != "")
                    TType = TType + "'" + str.Trim() + "',";
            }

            TType = TType.TrimEnd(new Char[] { ',' });

            param.Add("@TransType", TType);

            param.Add("@TransCode", TransCode);
            param.Add("@UserCode", UserCode);
            param.Add("@NotificationType", NotificationType);

            string ecType = "";
            string[] e;

            e = EventCategory.Split(',');

            foreach (string str in e)
            {
                if (str != "")
                    ecType = ecType + "'" + str.Trim() + "',";
            }

            ecType = ecType.TrimEnd(new Char[] { ',' });
            
            param.Add("@EventCategory", ecType);
            param.Add("@Subject", Subject);
            param.Add("@Status", Status);
            param.Add("@NoOfRetry", NoOfRetry);
            param.Add("@size", size);
            param.Add("@from", from);
            param.Add("@ScheduleStartDateTime", ScheduleStartDateTime);
            param.Add("@ScheduleEndDateTime", ScheduleEndDateTime);
            param.Add("@SentStartDateTime", SentStartDateTime);
            param.Add("@SentEndDateTime", SentEndDateTime);
            param.Add("@Recipient", Recipient);
            param.Add("@isRead", isRead);
            param.Add("@isSend", isSend);
            param.Add("@ClientName", ClientName);
            param.Add("@NotificationApp", NotificationApp);
            param.Add("@CallFor", CallFor);

            return base.ExecuteSQLProcedure<USPGetMessageStatus>("USPGetMessageStatus", param);
        }

        public IEnumerable<USPGetMasters> USPGetMasters()
        {
            var param = new DynamicParameters();


            return base.ExecuteSQLProcedure<USPGetMasters>("USPGetMasters", param);
        }

        public IEnumerable<USPGetConfig> USPGetConfig()
        {
            var param = new DynamicParameters();

            return base.ExecuteSQLProcedure<USPGetConfig>("USPGetConfig", param);
        }

        public IEnumerable<USPGetConfig> USPInsertConfig(long @NotificationConfigCode, int NoOfTimesToRetry, int DurationBetweenTwoRetriesMin, bool RetryOptionForFailed
         , bool ResendOptionForSuccessful, string SMTPServer, int SMTPPort, bool UseDefaultCredentials, string UserName, string Password)
        {
            var param = new DynamicParameters();
            param.Add("@NotificationConfigCode", NotificationConfigCode);
            param.Add("@NoOfTimesToRetry", NoOfTimesToRetry);
            param.Add("@DurationBetweenTwoRetriesMin", DurationBetweenTwoRetriesMin);
            param.Add("@RetryOptionForFailed", RetryOptionForFailed);
            param.Add("@ResendOptionForSuccessful", ResendOptionForSuccessful);
            param.Add("@SMTPServer", SMTPServer);
            param.Add("@SMTPPort", SMTPPort);
            param.Add("@UseDefaultCredentials", UseDefaultCredentials);
            param.Add("@UserName", UserName);
            param.Add("@Password", Password);

            return base.ExecuteSQLProcedure<USPGetConfig>("USPInsertConfig", param);
        }
        public IEnumerable<USPEventCategoryMsgCount> USPEventCategoryMsgCount(string ClientName, string UserEmail, string NotificationApp, string CallFor)
        {
            var param = new DynamicParameters();
            param.Add("@ClientName", ClientName);
            param.Add("@UserEmail", UserEmail);
            param.Add("@NotificationApp", NotificationApp);
            param.Add("@CallFor", CallFor);
            return ExecuteSQLProcedure<USPEventCategoryMsgCount>("USPEventCategoryMsgCount", param);
        }

        public IEnumerable<USPInsertNotificationType> USPInsertNotificationType(string NotificationType, string ClientName, string PlatformName, string Credentials, string IsActive)
        {
            var param = new DynamicParameters();
            param.Add("@NotificationType", NotificationType);
            param.Add("@ClientName", ClientName);
            param.Add("@PlatformName", PlatformName);
            param.Add("@Credentials", Credentials);
            param.Add("@IsActive", IsActive);
            
            return base.ExecuteSQLProcedure<USPInsertNotificationType>("USPInsertNotificationType", param);
        }

        public IEnumerable<USPGetNotificationByForeignId> USPGetEmailNotificationByForeignId(long foreignId, string ClientName)
        {
            var param = new DynamicParameters();
            param.Add("@ForeignId", foreignId);
            param.Add("@ClientName", ClientName);            

            return base.ExecuteSQLProcedure<USPGetNotificationByForeignId>("USPGetEmailNotificationByForeignId", param);
        }

        public IEnumerable<USPGetNotificationByForeignId> USPGetTeamsNotificationByForeignId(long foreignId, string ClientName)
        {
            var param = new DynamicParameters();
            param.Add("@ForeignId", foreignId);
            param.Add("@ClientName", ClientName);

            return base.ExecuteSQLProcedure<USPGetNotificationByForeignId>("USPGetTeamsNotificationByForeignId", param);
        }

    }


}
