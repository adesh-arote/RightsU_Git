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
    [Table("Syn_Deal_Run_Repeat_On_Day")]
    public partial class Syn_Deal_Run_Repeat_On_Day
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "syn_deal_run_repeaton_id")]
        public int? Syn_Deal_Run_Repeat_On_Day_Code { get; set; }

        [ForeignKeyReference(typeof(Syn_Deal_Run))]
        [JsonProperty(PropertyName = "syn_deal_run_id")]
        public Nullable<int> Syn_Deal_Run_Code { get; set; }

        [JsonProperty(PropertyName = "day_id")]
        public Nullable<int> Day_Code { get; set; }
    }
}
