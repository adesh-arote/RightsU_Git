using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("Platform")]
    public class Platform
    {

        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "platform_id")]
        public int? Platform_Code { get; set; }

        [JsonProperty(PropertyName = "platform_name")]
        public string Platform_Name { get; set; }

        [JsonProperty(PropertyName = "is_no_of_run")]
        public string Is_No_Of_Run { get; set; }

        [JsonProperty(PropertyName = "applicable_for_holdback")]
        public string Applicable_For_Holdback { get; set; }

        [JsonProperty(PropertyName = "applicable_for_demestic_territory")]
        public string Applicable_For_Demestic_Territory { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }

        [JsonProperty(PropertyName = "applicable_for_asrun_schedule")]
        public string Applicable_For_Asrun_Schedule { get; set; }

        [JsonProperty(PropertyName = "parent_platform_code")]
        public Nullable<int> Parent_Platform_Code { get; set; }

        [JsonProperty(PropertyName = "is_last_level")]
        public string Is_Last_Level { get; set; }

        [JsonProperty(PropertyName = "module_position")]
        public string Module_Position { get; set; }

        [JsonProperty(PropertyName = "base_platform_code")]
        public Nullable<int> Base_Platform_Code { get; set; }

        [JsonProperty(PropertyName = "platform_hiearachy")]
        public string Platform_Hiearachy { get; set; }

        [JsonProperty(PropertyName = "is_sport_right")]
        public string Is_Sport_Right { get; set; }

        [JsonProperty(PropertyName = "is_applicable_syn_run")]
        public string Is_Applicable_Syn_Run { get; set; }

        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }

    }
}
