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
#pragma warning disable 1591

    [Table("Acq_Deal_Rights_Territory")] 
    public partial class Acq_Deal_Rights_Territory
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_rights_region_id")]
        public int Acq_Deal_Rights_Territory_Code { get; set; }

        [JsonProperty(PropertyName = "deal_rights_id")] 
        public Nullable<int> Acq_Deal_Rights_Code { get; set; }

        [JsonProperty(PropertyName = "region_type")]
        public string Territory_Type { get; set; }

        [JsonProperty(PropertyName = "territory_id")]
        public Nullable<int> Territory_Code { get; set; }

        [ForeignKeyReference(typeof(Territory))]
        [ManyToOne]
        [SimpleSaveIgnore]
        public virtual Territory Territory { get; set; }

        [JsonProperty(PropertyName = "country_id")]
        public Nullable<int> Country_Code { get; set; }

        [ForeignKeyReference(typeof(Country))]
        [ManyToOne]
        [SimpleSaveIgnore]
        public virtual Country Country { get; set; }


    }
}
