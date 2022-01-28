using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO_Notification.Entities
{
    public class HttpResponses
    {
        public string ResponseCode { get; set; }
        public bool Status { get; set; }

        public string Message { get; set; }

        public Nullable<long> NECode { get; set; }
        public string ErrorCode { get; set; }
        public string ErrorMessage { get; set; }



        public object Response { get; set; }
        public HttpResponses()
        {
            ResponseCode = string.Empty;
            ErrorCode = string.Empty;
            ErrorMessage = string.Empty;
            Status = true;
            NECode = 0;



        }
    }
}
