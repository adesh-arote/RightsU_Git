using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO_Notification.Entities
{
 
    public class USPGetMessageStatus
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
        public string NotificationDetailCode { get; set; }

    }
}
