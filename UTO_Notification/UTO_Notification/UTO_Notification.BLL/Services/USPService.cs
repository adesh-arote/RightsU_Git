using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UTO_Notification.DAL;
using UTO_Notification.Entities;
using UTO_Notification.Entities.InputEntities;
using UTO_Notification.Entities.ProcedureEntities;

namespace UTO_Notification.BLL
{
    public class USPService
    {
        public USPInsertNotification USPInsertNotification(string EventCategory, string NotificationType, string TO, string CC, string BCC, string Subject, string HTMLMessage, string TextMessage, string TransType, long TransCode, string ScheduleDateTime, long UserCode,string ClientName,long ForeignId)
        {
            ProcedureRepositories objProcedureRepositories = new ProcedureRepositories("EmailConnection");

            USPInsertNotification objUSPInsertNotification = objProcedureRepositories.USPInsertNotification(EventCategory, NotificationType, TO, CC, BCC, Subject, HTMLMessage, TextMessage, TransType, TransCode, ScheduleDateTime, UserCode,ClientName,ForeignId).FirstOrDefault();
            return objUSPInsertNotification;
        }

        public USPInsertNotification USPInsertNotification_Teams(string EventCategory, string NotificationType, string TO, string CC, string BCC, string Subject, string HTMLMessage, string TextMessage, string TransType, long TransCode, string ScheduleDateTime, long UserCode, string ClientName, long ForeignId)
        {
            ProcedureRepositories objProcedureRepositories = new ProcedureRepositories("TeamsConnection");

            USPInsertNotification objUSPInsertNotification_Teams = objProcedureRepositories.USPInsertNotification_Teams(EventCategory, NotificationType, TO, CC, BCC, Subject, HTMLMessage, TextMessage, TransType, TransCode, ScheduleDateTime, UserCode, ClientName, ForeignId).FirstOrDefault();
            return objUSPInsertNotification_Teams;
        }

        public USPInsertNotification USPUpdateNotification(long NECode, string UpdatedStatus, string ReadDateTime, string NEDetailCode)
        {
            ProcedureRepositories objProcedureRepositories = new ProcedureRepositories("EmailConnection");

            USPInsertNotification objUSPUpdateNotification = objProcedureRepositories.USPUpdateNotification(NECode, UpdatedStatus, ReadDateTime, NEDetailCode).FirstOrDefault();
            return objUSPUpdateNotification;
        }

        public List<USPGetMessageStatus> USPGetMessageStatus(string NECode, string TransType, string TransCode, string UserCode, string NotificationType, string EventCategory, string Subject, string Status, int NoOfRetry, int size, int from, string ScheduleStartDateTime, string ScheduleEndDateTime, string SentStartDateTime, string SentEndDateTime, string Recipient, string isRead, string isSend)
        {
            ProcedureRepositories objProcedureRepositories = new ProcedureRepositories("EmailConnection");

            List<USPGetMessageStatus> lstUSPGetMessageStatus = objProcedureRepositories.USPGetMessageStatus(NECode, TransType, TransCode, UserCode, NotificationType, EventCategory, Subject, Status, NoOfRetry, size, from, ScheduleStartDateTime, ScheduleEndDateTime, SentStartDateTime, SentEndDateTime, Recipient, isRead, isSend).ToList();
            return lstUSPGetMessageStatus;
        }

        public List<USPGetMasters> USPGetMasters()
        {
            ProcedureRepositories objProcedureRepositories = new ProcedureRepositories("DefaultConnection");

            List<USPGetMasters> lstUSPGetMasters = objProcedureRepositories.USPGetMasters().ToList();
            return lstUSPGetMasters;
        }

        public List<USPGetConfig> USPGetConfig()
        {
            ProcedureRepositories objProcedureRepositories = new ProcedureRepositories("DefaultConnection");

            List<USPGetConfig> lstUSPGetConfig = objProcedureRepositories.USPGetConfig().ToList();
            return lstUSPGetConfig;
        }

        public USPGetConfig USPInsertConfig(long NotificationConfigCode, int NoOfTimesToRetry, int DurationBetweenTwoRetriesMin, bool RetryOptionForFailed
         , bool ResendOptionForSuccessful, string SMTPServer, int SMTPPort, bool UseDefaultCredentials, string UserName, string Password)
        {
            ProcedureRepositories objProcedureRepositories = new ProcedureRepositories("DefaultConnection");

            USPGetConfig objUSPInsertConfig = objProcedureRepositories.USPInsertConfig(NotificationConfigCode, NoOfTimesToRetry, DurationBetweenTwoRetriesMin, RetryOptionForFailed
         , ResendOptionForSuccessful, SMTPServer, SMTPPort, UseDefaultCredentials, UserName, Password).FirstOrDefault();

            return objUSPInsertConfig;
        }

        public List<USPEventCategoryMsgCount> USPEventCategoryMsgCount(string UserEmail)
        {
            ProcedureRepositories objProcedureRepositories = new ProcedureRepositories("DefaultConnection");

            List<USPEventCategoryMsgCount> objGetSummarisedMessage = objProcedureRepositories.USPEventCategoryMsgCount(UserEmail).ToList();
            return objGetSummarisedMessage;
        }

        public USPInsertNotificationType USPInsertNotificationType(string NotificationType, string ClientName, string PlatformName, string Credentials, string IsActive)
        {
            ProcedureRepositories objProcedureRepositories = new ProcedureRepositories("DefaultConnection");

            USPInsertNotificationType objUSPInsertNotificationType = objProcedureRepositories.USPInsertNotificationType(NotificationType, ClientName, PlatformName, Credentials, IsActive).FirstOrDefault();

            return objUSPInsertNotificationType;
        }
    }
}
