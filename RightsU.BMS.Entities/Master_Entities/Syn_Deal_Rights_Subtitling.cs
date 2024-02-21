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
    [Table("Syn_Deal_Rights_Subtitling")]
    public partial class Syn_Deal_Rights_Subtitling
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "syn_deal_rights_subtitling_id")]
        public int? Syn_Deal_Rights_Subtitling_Code { get; set; }

        [ForeignKeyReference(typeof(Syn_Deal_Rights))]
        [JsonProperty(PropertyName = "syn_deal_rights_id")]
        public Nullable<int> Syn_Deal_Rights_Code { get; set; }

        [JsonProperty(PropertyName = "subtitling_type")]
        public string Language_Type { get; set; }

        [JsonProperty(PropertyName = "language_group_code")]
        public Nullable<int> Language_Group_Code { get; set; }

        [JsonProperty(PropertyName = "language_code")]
        public Nullable<int> Language_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]
        [Column("Language_Code")]
        public virtual Language language { get; set; }
    }
}
