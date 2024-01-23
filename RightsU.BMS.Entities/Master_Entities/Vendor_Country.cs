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
    [Table("Vendor_Country")]
    public partial class Vendor_Country
    {
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "party_country_id")]
        public int? Vendor_Country_Code { get; set; }

        [ForeignKeyReference(typeof(Party))]
        [JsonProperty(PropertyName = "party_id")]
        public Nullable<int> Vendor_Code { get; set; }

        [ForeignKeyReference(typeof(Country))]
        [JsonProperty(PropertyName = "country_id")]
        public Nullable<int> Country_Code { get; set; }

        [JsonProperty(PropertyName = "is_theatrical")]
        public string Is_Theatrical { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]
        [Column("Country_Code")]
        public virtual Country country { get; set; }        
    }
}
