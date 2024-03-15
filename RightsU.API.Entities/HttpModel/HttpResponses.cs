using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.HttpModel
{
    public class HttpResponses
    {
        public string ResponseCode { get; set; }
        public bool Status { get; set; }

        public string Message { get; set; }

        public Nullable<long> LGCode { get; set; }
        public string starttime { get; set; }
        public double TimeTaken { get; set; }

        public object Response { get; set; }
        public HttpResponses()
        {
            ResponseCode = string.Empty;
            Status = true;
            LGCode = 0;
        }
    }
}
