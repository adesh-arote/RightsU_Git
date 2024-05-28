using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO_Notification.Entities
{
    public class GetMessagesInput
    {
        public string NECode { get; set; }
        public string TransType { get; set; }
        public string TransCode { get; set; }
        public string UserCode { get; set; }
        public string NotificationType { get; set; }
        public string EventCategory { get; set; }
        public string Subject { get; set; }
        public string Status { get; set; }
        public int NoOfRetry { get; set; }
        public int size { get; set; }
        public int from { get; set; }
        public string ScheduleStartDateTime { get; set; }
        public string ScheduleEndDateTime { get; set; }
        public string NEDetailCode { get; set; }
        public string SentStartDateTime { get; set; }
        public string SentEndDateTime { get; set; }
        public string Recipient { get; set; }

        public string Type { get; set; }
        public string isRead { get; set; }
        public string isSend { get; set; }

        public string ClientName { get; set; }
        public string NotificationApp { get; set; }
        public string CallFor { get; set; }

    }
}
