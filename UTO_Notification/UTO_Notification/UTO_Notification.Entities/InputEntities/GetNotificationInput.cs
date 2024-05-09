using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO_Notification.Entities.InputEntities
{
    public class GetNotificationInput
    {
        public long ForeignId { get; set; }
        public string ClientName { get; set; }
        public string NotificationType { get; set; }
    }
}
