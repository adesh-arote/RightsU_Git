using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO_Notification.Entities
{
    public class NotificationInput
    {
        public string EventCategory { get; set; }
        public string NotificationType { get; set; }

        public string TO { get; set; }
        public string CC { get; set; }
        public string BCC { get; set; }
        public string Subject { get; set; }
        public string HTMLMessage { get; set; }
        public string TextMessage { get; set; }
        public string TransType { get; set; }
        public long TransCode { get; set; }
        public string ScheduleDateTime { get; set; }
        public long UserCode { get; set; }

        public long NECode { get; set; }

        public string NEDetailCode { get; set; }
        public string UpdatedStatus { get; set; }
        public string ReadDateTime { get; set; }
        public string ClientName { get; set; }
        public long ForeignId { get; set; }
    }
}
