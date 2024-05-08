using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UTO_Notification.Entities;

namespace UTO_Notification.BLL.Notifications
{
    public abstract class Notification
    {
        public abstract HttpResponses SaveNotification(NotificationInput obj);
    }
}
