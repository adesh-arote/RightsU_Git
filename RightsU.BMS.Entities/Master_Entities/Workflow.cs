using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Workflow")]
    public partial class Workflow
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "workflow_id")]
        public int ? Workflow_Code { get; set; }

        [JsonProperty(PropertyName = "workflow_name")]
        public string Workflow_Name { get; set; }

        [JsonIgnore]
        public string Workflow_Type { get; set; }

        [JsonIgnore]
        public Nullable<int> Business_Unit_Code { get; set; }

        [JsonIgnore]
        public string Remarks { get; set; }

        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }

    }
}
