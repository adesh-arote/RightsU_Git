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
    [Table("Acq_Deal_Licensor")]
    public partial class Acq_Deal_Licensor
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_licensor_id")]
        public int? Acq_Deal_Licensor_Code { get; set; }

        [ForeignKeyReference(typeof(Acq_Deal))]
        [JsonProperty(PropertyName = "deal_id")]
        public Nullable<int> Acq_Deal_Code { get; set; }

        [ForeignKeyReference(typeof(Vendor))]
        [JsonProperty(PropertyName = "vendor_id")]
        public Nullable<int> Vendor_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]
        [Column("Vendor_Code")]
        public virtual Vendor vendor { get; set; }
    }
}
