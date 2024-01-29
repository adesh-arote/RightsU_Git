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
    [Table("Error_Code_Master")]
    public partial class Error_Code_Master
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonIgnore]
        [JsonProperty(PropertyName = "id")]
        public int? Error_Code { get; set; }

        [JsonProperty(PropertyName = "error_id")]
        public string Upload_Error_Code { get; set; }

        [JsonProperty(PropertyName = "error_description")]
        public string Error_Description { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "error_for")]
        public string Error_For { get; set; }
    }
}
