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
    [Table("Version")]
    public partial class Version
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }
        [PrimaryKey]
        //[Column("Version_Code")]
        [JsonProperty(PropertyName = "version_id")]
        public int? Version_Code { get; set; }

        //[Column("Version_Name")]
        [JsonProperty(PropertyName = "version_name")]
        public string Version_Name { get; set; }

        [JsonIgnore]
        public string BMS_Version_ID { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
        [JsonIgnore]
        public string Is_Active { get; set; }
    }
}
