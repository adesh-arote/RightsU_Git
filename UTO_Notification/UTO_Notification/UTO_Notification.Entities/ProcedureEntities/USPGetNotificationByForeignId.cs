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
        public long NotificationsCode { get; set; }
        public long NotificationType { get; set; }
        public long EventCategory { get; set; }
        public long UserCode { get; set; }
        public long TransType { get; set; }
        public long TransCode { get; set; }
        public string Email { get; set; }
        public string Mobile { get; set; }
        public bool IsSend { get; set; }
        public bool IsRead { get; set; }
        public string CC { get; set; }
        public string BCC { get; set; }
        public string Subject { get; set; }
        [JsonIgnore]
        public string HtmlBody { get; set; }
        [JsonIgnore]
        public string TextBody { get; set; }
        public DateTime ScheduleDateTime { get; set; }
        public Int32 NoOfRetry { get; set; }
        public Int32 MsgStatusCode { get; set; }
        public DateTime SentOrReadDateTime { get; set; }
        public string ErrorCode { get; set; }
        public string ErrorDetails { get; set; }
        public DateTime CreatedOn { get; set; }
        public Int64 CreatedBy { get; set; }
        public DateTime ModifiedOn { get; set; }
        public Int64 ModifiedBy { get; set; }
        public bool IsAutoEscalated { get; set; }
        public bool IsReminderMail { get; set; }
        public string ClientName { get; set; }
        public Int64 ForeignId { get; set; }
    }
}
