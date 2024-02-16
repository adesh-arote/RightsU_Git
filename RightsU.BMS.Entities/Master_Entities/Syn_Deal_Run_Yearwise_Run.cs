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
    [Table("Syn_Deal_Run_Yearwise_Run")]
    public partial class Syn_Deal_Run_Yearwise_Run
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "syn_deal_run_year_id")]
        public int? Syn_Deal_Run_Yearwise_Run_Code { get; set; }

        [ForeignKeyReference(typeof(Syn_Deal_Run))]
        [JsonProperty(PropertyName = "syn_deal_run_id")]
        public Nullable<int> Syn_Deal_Run_Code { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "start_date")]
        public string start_date { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Start_Date { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "end_date")]
        public string end_date { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> End_Date { get; set; }

        [JsonProperty(PropertyName = "define_runs")]
        public Nullable<int> No_Of_Runs { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "year_no")]
        public Nullable<int> Year_No { get; set; }

    }
}
