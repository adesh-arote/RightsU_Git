using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Milestone_Type")]
    public partial class Milestone_Type
    {
        [PrimaryKey]
        [JsonProperty(PropertyName = "milestone_type_code")]
        public int? Milestone_Type_Code { get; set; }
        [JsonProperty(PropertyName = "milestone_type_name")]
        public string Milestone_Type_Name { get; set; }
        [JsonProperty(PropertyName = "is_automated")]
        public string Is_Automated { get; set; }
        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }
    }
}
