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
    [Table("Syn_Deal_Run")]
    public partial class Syn_Deal_Run
    {
        public Syn_Deal_Run()
        {
            this.Platform = new HashSet<Syn_Deal_Run_Platform>();
            this.YearDefinition = new HashSet<Syn_Deal_Run_Yearwise_Run>();
            this.RepeatOn = new HashSet<Syn_Deal_Run_Repeat_On_Day>();
        }

        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "syn_deal_run_id")]
        public int? Syn_Deal_Run_Code { get; set; }

        [ForeignKeyReference(typeof(Syn_Deal))]
        [JsonProperty(PropertyName = "syn_deal_id")]
        public Nullable<int> Syn_Deal_Code { get; set; }

        [JsonProperty(PropertyName = "title_id")]
        public Nullable<int> Title_Code { get; set; }

        [JsonProperty(PropertyName = "episode_from")]
        public Nullable<int> Episode_From { get; set; }

        [JsonProperty(PropertyName = "episode_to")]
        public Nullable<int> Episode_To { get; set; }

        [JsonProperty(PropertyName = "run_type")]
        public string Run_Type { get; set; }

        [JsonProperty(PropertyName = "define_runs")]
        public Nullable<int> No_Of_Runs { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "scheduled_define_runs")]
        public Nullable<int> No_Of_Runs_Sched { get; set; }

        [ForeignKeyReference(typeof(RightRule))]
        [JsonProperty(PropertyName = "right_rule_id")]
        public Nullable<int> Right_Rule_Code { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "repeat_duration")]
        public string Repeat_Within_Days_Hrs { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_on")]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_by")]
        public Nullable<int> Inserted_By { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_on")]
        public Nullable<System.DateTime> Last_updated_Time { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_by")]
        public Nullable<int> Last_action_By { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "is_yearwise_definition")]
        public string Is_Yearwise_Definition { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "is_rule_right")]
        public string Is_Rule_Right { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "no_of_days_hrs")]
        public Nullable<int> No_Of_Days_Hrs { get; set; }

        [OneToMany]
        public virtual ICollection<Syn_Deal_Run_Platform> Platform { get; set; }

        [OneToMany]
        public virtual ICollection<Syn_Deal_Run_Yearwise_Run> YearDefinition { get; set; }

        [OneToMany]
        public virtual ICollection<Syn_Deal_Run_Repeat_On_Day> RepeatOn { get; set; }

    }
}
