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
    [Table("Acq_Deal_Rights_Dubbing")]
    public partial class Acq_Deal_Rights_Dubbing
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_rights_dubbing_id")]
        public int? Acq_Deal_Rights_Dubbing_Code { get; set; }

        [ForeignKeyReference(typeof(Acq_Deal_Rights))]
        [JsonProperty(PropertyName = "deal_rights_id")]
        public Nullable<int> Acq_Deal_Rights_Code { get; set; }

        [JsonProperty(PropertyName = "dubbing_type")]
        public string Language_Type { get; set; }

        [JsonProperty(PropertyName = "language_group_code")]
        public Nullable<int> Language_Group_Code { get; set; }

        [JsonProperty(PropertyName = "language_code")]
        [ForeignKeyReference(typeof(Language))]
        public Nullable<int> Language_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]
        [Column("Language_Code")]
        public virtual Language language { get; set; }
    }
}
