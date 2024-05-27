using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO_Notification.Entities.ProcedureEntities
{
    public class USPGetNotificationByForeignId
    {
        [JsonIgnore]
        public long NotificationsCode { get; set; }
        [JsonIgnore]
        public long NotificationType { get; set; }
        [JsonIgnore]
        public long EventCategory { get; set; }
        [JsonIgnore]
        public long UserCode { get; set; }
        [JsonIgnore]
        public long TransType { get; set; }
        [JsonIgnore]
        public long TransCode { get; set; }
        [JsonIgnore]
        public string Email { get; set; }
        [JsonIgnore]
        public string Mobile { get; set; }
        public bool IsSend { get; set; }
        public bool IsRead { get; set; }
        [JsonIgnore]
        public string CC { get; set; }
        [JsonIgnore]
        public string BCC { get; set; }
        [JsonIgnore]
        public string Subject { get; set; }
        [JsonIgnore]
        public string HtmlBody { get; set; }
        [JsonIgnore]
        public string TextBody { get; set; }
        public DateTime ScheduleDateTime { get; set; }
        public Int32 NoOfRetry { get; set; }
        public Int32 MsgStatusCode { get; set; }
        public string NotificationStatus { get; set; }
        public DateTime SentOrReadDateTime { get; set; }
        public string ErrorCode { get; set; }
        public string ErrorDetails { get; set; }
        public DateTime CreatedOn { get; set; }
        public Int64 CreatedBy { get; set; }
        public DateTime ModifiedOn { get; set; }
        public Int64 ModifiedBy { get; set; }
        [JsonIgnore]
        public bool IsAutoEscalated { get; set; }
        [JsonIgnore]
        public bool IsReminderMail { get; set; }
        [JsonIgnore]
        public string ClientName { get; set; }
        [JsonIgnore]
        public Int64 ForeignId { get; set; }
    }
}
