using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO_Notification.Entities.InputEntities
{
    public class NotificationTypeInput
    {
        public string NotificationType { get; set; }
        public string SystemName { get; set; }
        public string Platform_Name { get; set; }
        public string Credentials { get; set; }
        public string Is_Active { get; set; }
    }
}
