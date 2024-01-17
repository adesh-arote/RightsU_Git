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

    [Table("Acq_Deal_Rights_Platform")]
    public partial class Acq_Deal_Rights_Platform
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_rights_platform_id")]
        public int? Acq_Deal_Rights_Platform_Code { get; set; }

        [ForeignKeyReference(typeof(Acq_Deal_Rights))]
        [JsonProperty(PropertyName = "deal_rights_id")]
        public Nullable<int> Acq_Deal_Rights_Code { get; set; }

        [ForeignKeyReference(typeof(Platform))]
        [JsonProperty(PropertyName = "platform_id")]
        public Nullable<int> Platform_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]
        [Column("Platform_Code")]
        public virtual Platform platform { get; set; }
    }
}
