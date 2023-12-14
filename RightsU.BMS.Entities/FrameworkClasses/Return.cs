using Newtonsoft.Json;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.FrameworkClasses
{
    public class Return
    {
        public string Message { get; set; }
        public bool IsSuccess { get; set; }        
        public int LogId { get; set; }
        public string Token { get; set; }
        public Nullable<int> SecurityGroupCode { get; set; }
        public string UserName { get; set; }
        public string IsSystemPassword { get; set; }
    }

    public class GenericReturn
    {
        [JsonIgnore]
        public string Message { get; set; }
        [JsonIgnore]
        public bool IsSuccess { get; set; }
        [JsonIgnore]
        public double TimeTaken { get; set; }
        [JsonIgnore]
        public HttpStatusCode StatusCode { get; set; }
        public object Response { get; set; }
    }

    public class PostReturn
    {
        public string Message { get; set; }
        public bool IsSuccess { get; set; }
        [JsonIgnore]
        public double TimeTaken { get; set; }
        [JsonIgnore]
        public HttpStatusCode StatusCode { get; set; }
    }
}
