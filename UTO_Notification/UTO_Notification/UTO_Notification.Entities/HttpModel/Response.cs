using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
namespace UTO_Notification.Entities
{
    public class Response
    {
        [JsonProperty("id")]
        public Int64 ID { get; set; }
        [JsonProperty("responseCode")]
        public string ResponseCode { get; set; }
        [JsonProperty("name")]
        public string Name { get; set; }
        [JsonProperty("responseMessage")]
        public string ResponseMessage { get; set; }
        [JsonProperty("response")]
        public object ResponseObject { get; set; }
        public Response()
        {
            ID = 0;
            ResponseCode = string.Empty;
            Name = string.Empty;
            ResponseMessage = string.Empty;
        }
    }
}
