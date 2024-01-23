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
    [Table("Acq_Deal_Run_Repeat_On_Day")]
    public partial class Acq_Deal_Run_Repeat_On_Day
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_run_repeaton_id")]
        public int? Acq_Deal_Run_Repeat_On_Day_Code { get; set; }

        [ForeignKeyReference(typeof(Acq_Deal_Run))]
        [JsonProperty(PropertyName = "deal_run_id")]
        public Nullable<int> Acq_Deal_Run_Code { get; set; }

        [JsonProperty(PropertyName = "day_id")]
        public Nullable<int> Day_Code { get; set; }
    }
}
