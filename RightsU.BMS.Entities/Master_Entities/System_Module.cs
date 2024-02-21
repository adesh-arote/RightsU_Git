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
    [Table("System_Module")]
    public class System_Module
    {
        [PrimaryKey]
        [JsonProperty(PropertyName = "module_id")]
        public int Module_Code { get; set; }

        [JsonProperty(PropertyName = "module_name")]
        public string Module_Name { get; set; }

        [JsonIgnore]
        public string Module_Position { get; set; }

        [JsonIgnore]
        public int Parent_Module_Code { get; set; }

        [JsonIgnore]
        public string Is_Sub_Module { get; set; }

        [JsonIgnore]
        public string Url { get; set; }

        [JsonIgnore]
        public string Target { get; set; }

        [JsonIgnore]
        public string Css { get; set; }

        [JsonIgnore]
        public string Can_Workflow_Assign { get; set; }

        [JsonIgnore]
        public string Is_Active { get; set; }
    }
}
