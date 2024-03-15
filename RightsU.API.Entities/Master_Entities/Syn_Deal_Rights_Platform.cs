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

    [Table("Syn_Deal_Rights_Platform")]
    public partial class Syn_Deal_Rights_Platform
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "syn_deal_rights_platform_id")]
        public int? Syn_Deal_Rights_Platform_Code { get; set; }

        [ForeignKeyReference(typeof(Syn_Deal_Rights))]
        [JsonProperty(PropertyName = "syn_deal_rights_id")]
        public Nullable<int> Syn_Deal_Rights_Code { get; set; }

        [ForeignKeyReference(typeof(Platform))]
        [JsonProperty(PropertyName = "platform_id")]
        public Nullable<int> Platform_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]
        [Column("Platform_Code")]
        public virtual Platform platform { get; set; }
    }
}
