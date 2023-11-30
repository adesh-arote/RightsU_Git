using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.Audit.Entities.FrameworkClasses
{
    public class Return
    {
        public string Message { get; set; }
        public bool IsSuccess { get; set; }   
        [JsonIgnore]
        public double TimeTaken { get; set; }
        [JsonIgnore]
        public HttpStatusCode StatusCode { get; set; }
        [JsonIgnore]
        public object LogObject { get; set; }
    }
}
