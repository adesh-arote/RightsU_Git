using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SendNotificationService
{
    public class UTOLog
    {
        public string ApplicationName { get; set; }
        public string RequestId { get; set; }
        public string UserId { get; set; }
        public string RequestUri { get; set; }
        public string RequestMethod { get; set; }
        public string Method { get; set; }
        public string IsSuccess { get; set; }
        public string TimeTaken { get; set; }
        public string RequestContent { get; set; }
        public string RequestLength { get; set; }
        public string RequestDateTime { get; set; }
        public string ResponseContent { get; set; }
        public string ResponseLength { get; set; }
        public string ResponseDateTime { get; set; }
        public string HttpStatusCode { get; set; }
        public string HttpStatusDescription { get; set; }
        public string AuthenticationKey { get; set; }
        public string UserAgent { get; set; }
        public string ServerName { get; set; }
        public string ClientIpAddress { get; set; }
    }
}
