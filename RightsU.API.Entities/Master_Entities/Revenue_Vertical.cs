using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("Revenue_Vertical")]
    public partial class Revenue_Vertical
    {
        [PrimaryKey]
        [JsonProperty(PropertyName = "revenue_vertical_id")]
        public int? Revenue_Vertical_Code { get; set; }

        [JsonProperty(PropertyName = "revenue_vertical_name")]
        public string Revenue_Vertical_Name { get; set; }

     
        [JsonProperty(PropertyName = "type")]
        public string Type { get; set; }

     
        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }
    }
}
