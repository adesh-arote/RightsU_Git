using System;
using System.Collections.Generic;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Business_Unit")]
    public partial class Business_Unit
    {
        [PrimaryKey]
        [JsonProperty(PropertyName = "business_unit_id")]
        public int? Business_Unit_Code { get; set; }

        [JsonProperty(PropertyName = "business_unit_name")]
        public string Business_Unit_Name { get; set; }

        [JsonProperty(PropertyName = "is_Active")]
        public string Is_Active { get; set; }
    }
}
