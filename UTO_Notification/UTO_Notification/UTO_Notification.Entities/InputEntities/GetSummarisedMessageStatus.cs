using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO_Notification.Entities
{
    public class GetSummarisedMessageStatus
    {
        public string ClientName { get; set; }
        public string UserEmail { get; set; }
        public string NotificationApp { get; set; }
        public string CallFor { get; set; }
    }
}