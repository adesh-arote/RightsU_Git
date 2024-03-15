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
    [Table("Right_Rule")]
    public partial class RightRule
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "right_rule_id")]
        public int? Right_Rule_Code { get; set; }

        [JsonProperty(PropertyName = "right_rule_name")]
        public string Right_Rule_Name { get; set; }

        [JsonProperty(PropertyName = "start_time")]
        public string Start_Time { get; set; }

        [JsonProperty(PropertyName = "play_per_day")]
        public Nullable<int> Play_Per_Day { get; set; }

        [JsonProperty(PropertyName = "duration_of_day")]
        public Nullable<int> Duration_Of_Day { get; set; }

        [JsonProperty(PropertyName = "no_of_repeat")]
        public Nullable<int> No_Of_Repeat { get; set; }

        [JsonIgnore]
        public System.DateTime Inserted_On { get; set; }

        [JsonIgnore]
        public int Inserted_By { get; set; }
       
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }

        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }

        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }

        [JsonProperty(PropertyName = "is_first_air")]
        public Nullable<bool> IS_First_Air { get; set; }

        [JsonProperty(PropertyName = "short_key")]
        public string Short_Key { get; set; }
    }
}
