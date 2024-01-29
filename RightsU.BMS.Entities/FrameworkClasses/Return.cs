using Newtonsoft.Json;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
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
        public GenericReturn()
        {
            Errors = new List<string>();
        }

        public int? id { get; set; }

        [JsonProperty(PropertyName = "message")]
        public string Message { get; set; }
        [JsonProperty(PropertyName = "completion_status")]
        public bool IsSuccess { get; set; }
        [JsonProperty(PropertyName = "errors")]
        public List<string> Errors { get; set; }
        [JsonIgnore]
        public double TimeTaken { get; set; }
        [JsonIgnore]
        public HttpStatusCode StatusCode { get; set; }                
        [JsonIgnore]
        [JsonProperty(PropertyName = "response")]
        public object Response { get; set; }
    }

    //public class PostReturn
    //{
    //    public string Message { get; set; }
    //    public bool IsSuccess { get; set; }
    //    [JsonIgnore]
    //    public double TimeTaken { get; set; }
    //    [JsonIgnore]
    //    public HttpStatusCode StatusCode { get; set; }
    //}
}
