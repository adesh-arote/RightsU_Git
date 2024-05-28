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
    [Table("Territory_Details")]

    public partial class Territory_Details
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "territory_details_id")]
        public int ? Territory_Details_Code { get; set; }

        [ForeignKeyReference(typeof(Country))]
        [JsonProperty(PropertyName = "country_id")]
        public int Country_Code { get; set; }

        [ForeignKeyReference(typeof(Territory))]
        [JsonProperty(PropertyName = "territory_id")]
        public int Territory_Code { get; set; }
    }
}
