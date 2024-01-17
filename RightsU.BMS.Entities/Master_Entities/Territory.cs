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
        [JsonProperty(PropertyName = "territory_code")]
        public int? Territory_Code { get; set; }

        [JsonProperty(PropertyName = "territory_name")]
        public string Territory_Name { get; set; }
    }
}
