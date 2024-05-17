using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO.Notification.Email
{
    public class USPGetPendingNotifications
    {
        public long NotificationsCode { get; set; }
        public string Email { get; set; }
        public string cc { get; set; }
        public string bcc { get; set; }
        public string Subject { get; set; }
        public string HtmlBody { get; set; }
        public long UserCode { get; set; }
        public DateTime RequestDateTime { get; set; }
        public string Credentials { get; set; }        
    }
}
