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
    [Table("Acq_Deal_Run_Yearwise_Run")]
    public partial class Acq_Deal_Run_Yearwise_Run
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_run_year_id")]
        public int? Acq_Deal_Run_Yearwise_Run_Code { get; set; }

        [ForeignKeyReference(typeof(Acq_Deal_Run))]
        [JsonProperty(PropertyName = "deal_run_id")]
        public Nullable<int> Acq_Deal_Run_Code { get; set; }

        [JsonProperty(PropertyName = "start_date")]
        public Nullable<System.DateTime> Start_Date { get; set; }

        [JsonProperty(PropertyName = "end_date")]
        public Nullable<System.DateTime> End_Date { get; set; }

        [JsonProperty(PropertyName = "define_runs")]
        public Nullable<int> No_Of_Runs { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "scheduled_define_runs")]
        public Nullable<int> No_Of_Runs_Sched { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "no_of_asruns")]
        public Nullable<int> No_Of_AsRuns { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "year_no")]
        public Nullable<int> Year_No { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_by")]
        public Nullable<int> Inserted_By { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_on")]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "last_action_by")]
        public Nullable<int> Last_action_By { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "last_updated_time")]
        public Nullable<System.DateTime> Last_updated_Time { get; set; }
        
    }
}
