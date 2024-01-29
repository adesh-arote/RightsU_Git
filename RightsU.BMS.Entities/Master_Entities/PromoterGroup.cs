using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Promoter_Group")]
    public class PromoterGroup
    {
        
        [PrimaryKey]
        [JsonProperty(PropertyName = "promoter_group_id")]
        public int ? Promoter_Group_Code { get; set; }

        [JsonProperty(PropertyName = "promoter_group_name")]
        public string Promoter_Group_Name { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }

        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }

        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }

        [JsonProperty(PropertyName = "is_last_level")]
        public string Is_Last_Level { get; set; }

        [JsonProperty(PropertyName = "hierarchy_name")]
        public string Hierarchy_Name { get; set; }

        [JsonProperty(PropertyName = "display_order")]
        public string Display_Order { get; set; }

        [JsonProperty(PropertyName = "parent_group_id")]
        public Nullable<int> Parent_Group_Code { get; set; }
    }
}
