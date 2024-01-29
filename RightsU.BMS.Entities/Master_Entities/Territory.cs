using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Territory")]
    public partial class Territory
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }
        
        [PrimaryKey]
        [JsonProperty(PropertyName = "territory_id")]
        public int? Territory_Code { get; set; }

        [JsonProperty(PropertyName = "territory_name")]
        public string Territory_Name { get; set; }

        [JsonProperty(PropertyName = "is_thetrical")]
        public string Is_Thetrical { get; set; }

        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }

        [JsonIgnore]
        public System.DateTime Inserted_On { get; set; }

        [JsonIgnore]
        public int Inserted_By { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }

        [OneToMany]
        public ICollection<Territory_Details> territory_details { get; set; }
    }
}
