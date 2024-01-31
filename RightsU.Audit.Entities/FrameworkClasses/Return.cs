using Newtonsoft.Json;
using RightsU.Audit.Entities.MasterEntities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.Audit.Entities.FrameworkClasses
{
    public class GenericReturn
    {
        //[JsonIgnore]
        //public string Message { get; set; }
        //[JsonIgnore]
        //public bool IsSuccess { get; set; }   
        //[JsonIgnore]
        //public double TimeTaken { get; set; }
        //[JsonIgnore]
        //public HttpStatusCode StatusCode { get; set; }
        //public object Response { get; set; }

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
