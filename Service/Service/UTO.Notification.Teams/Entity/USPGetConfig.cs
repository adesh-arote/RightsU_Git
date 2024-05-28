using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO.Notification.Teams
{
   public class USPGetConfig
    {
        public long NotificationConfigCode { get; set; }
        public int NoOfTimesToRetry { get; set; }
        public int DurationBetweenTwoRetriesMin { get; set; }
        public bool RetryOptionForFailed { get; set; }
        public bool ResendOptionForSuccessful { get; set; }
        public string ClientId { get; set; }
        public string TenantId { get; set; }
        public string scope { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }        
    }
}
