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
    [Table("Acq_Deal_Run_Channel")]
    public partial class Acq_Deal_Run_Channel
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_run_channel_id")]
        public int? Acq_Deal_Run_Channel_Code { get; set; }

        [ForeignKeyReference(typeof(Acq_Deal_Run))]
        [JsonProperty(PropertyName = "deal_run_id")]
        public Nullable<int> Acq_Deal_Run_Code { get; set; }

        //[ForeignKeyReference(typeof(Channel))]
        [JsonProperty(PropertyName = "channel_id")]
        public Nullable<int> Channel_Code { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        //[ManyToOne]
        //[Column("Channel_Code")]
        public virtual Channel Channel { get; set; }

        [JsonProperty(PropertyName = "define_runs")]
        public Nullable<int> Min_Runs { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "max_runs")]
        public Nullable<int> Max_Runs { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "no_of_runs_sched")]
        public Nullable<int> No_Of_Runs_Sched { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "no_of_asruns")]
        public Nullable<int> No_Of_AsRuns { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "do_not_consume_rights")]
        public string Do_Not_Consume_Rights { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "is_primary")]
        public string Is_Primary { get; set; }

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
