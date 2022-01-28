using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SendNotificationService
{
    public class USPGetPendingNotifications
    {
        public long NotificationsCode { get; set; }
        public string Email { get; set; }
        public string cc { get; set; }
        public string bcc { get; set; }
        public string Subject { get; set; }
        public string HtmlBody { get; set; }

    }
}
