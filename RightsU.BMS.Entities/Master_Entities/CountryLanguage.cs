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
    [Table("Country_Language")]
    public partial class CountryLanguage
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "country_language_id")]
        public int ? Country_Language_Code { get; set; }

        [ForeignKeyReference(typeof(Country))]
        [JsonProperty(PropertyName = "country_id")]
        public Nullable<int> Country_Code { get; set; }

        [ForeignKeyReference(typeof(Language))]
        [JsonProperty(PropertyName = "language_id")]
        public Nullable<int> Language_Code { get; set; }

        [Column("Language_Code")]
        [SimpleSaveIgnore]
        [ManyToOne]
        public Language Language { get; set; }
    }
}
