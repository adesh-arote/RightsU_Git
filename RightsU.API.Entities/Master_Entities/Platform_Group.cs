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
    [Table("Platform_Group")]
    public partial class Platform_Group
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }
        [JsonProperty(PropertyName ="platform_group_id")]
        public int Platform_Group_Code { get; set; }

        [JsonProperty(PropertyName = "platform_group_name")]
        public string Platform_Group_Name { get; set; }

    }
}
