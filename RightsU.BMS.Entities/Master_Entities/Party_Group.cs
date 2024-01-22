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
    [Table("Party_Group")]
    public partial class Party_Group
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "party_group_id")]
        public int? Party_Group_Code { get; set; }

        [JsonProperty(PropertyName = "party_group_name")]
        public string Party_Group_Name { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> InsertedOn { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_By { get; set; }
        [JsonIgnore]
        public string Is_Active { get; set; }
    }
}
