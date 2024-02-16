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
    [Table("Acq_Deal_Run")]
    public partial class Acq_Deal_Run
    {
        public Acq_Deal_Run()
        {
            this.titles = new HashSet<Acq_Deal_Run_Title>();
            this.channels = new HashSet<Acq_Deal_Run_Channel>();
            this.yeardefinition = new HashSet<Acq_Deal_Run_Yearwise_Run>();
            this.repeaton = new HashSet<Acq_Deal_Run_Repeat_On_Day>();
        }

        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_run_id")]
        public int? Acq_Deal_Run_Code { get; set; }

        [ForeignKeyReference(typeof(Acq_Deal))]
        [JsonProperty(PropertyName = "deal_id")]
        public Nullable<int> Acq_Deal_Code { get; set; }

        [JsonProperty(PropertyName = "run_type")]
        public string Run_Type { get; set; }

        [JsonProperty(PropertyName = "define_runs")]
        public Nullable<int> No_Of_Runs { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "scheduled_define_runs")]
        public Nullable<int> No_Of_Runs_Sched { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "define_asruns")]
        public Nullable<int> No_Of_AsRuns { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "is_yearwise_definition")]
        public string Is_Yearwise_Definition { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "is_rule_right")]
        public string Is_Rule_Right { get; set; }

        [JsonProperty(PropertyName = "syndication_runs")]
        public Nullable<int> Syndication_Runs { get; set; }

        [ForeignKeyReference(typeof(RightRule))]
        [JsonProperty(PropertyName = "right_rule_id")]
        public Nullable<int> Right_Rule_Code { get; set; }

        [ManyToOne]
        [SimpleSaveIgnore]
        [Column("Right_Rule_Code")]
        public virtual RightRule right_rule { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "no_of_days_hrs")]
        public Nullable<int> No_Of_Days_Hrs { get; set; } 

        [JsonProperty(PropertyName = "repeat_duration")]
        public string Repeat_Within_Days_Hrs { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "channel_type")]
        public string Channel_Type { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "is_channel_definition_rights")]
        public string Is_Channel_Definition_Rights { get; set; }

        [ForeignKeyReference(typeof(Channel_Category))]
        [JsonProperty(PropertyName = "channel_category_id")]
        public Nullable<int> Channel_Category_Code { get; set; }

        [ManyToOne]
        [SimpleSaveIgnore]
        [Column("Channel_Category_Code")]
        public virtual Channel_Category channel_category { get; set; }

        [ForeignKeyReference(typeof(Channel))]
        [JsonProperty(PropertyName = "primary_channel_id")]
        public Nullable<int> Primary_Channel_Code { get; set; }

        [ManyToOne]
        [SimpleSaveIgnore]
        [Column("Primary_Channel_Code")]
        public virtual Channel primary_channel { get; set; }

        [JsonProperty(PropertyName = "run_definition_type")]
        public string Run_Definition_Type { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "run_definition_group_id")]
        public Nullable<int> Run_Definition_Group_Code { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "all_channel")]
        public string All_Channel { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "prime_start_time")]
        public string prime_start_time { get; set; }

        [JsonIgnore]
        public Nullable<System.TimeSpan> Prime_Start_Time { get; set; }


        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "prime_end_time")]
        public string prime_end_time { get; set; }

        [JsonIgnore]
        public Nullable<System.TimeSpan> Prime_End_Time { get; set; }

        [JsonProperty(PropertyName = "prime_run")]
        public int Prime_Run { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "off_prime_start_time")]
        public string off_prime_start_time { get; set; }

        [JsonIgnore]
        public Nullable<System.TimeSpan> Off_Prime_Start_Time { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "off_prime_end_time")]
        public string off_prime_end_time { get; set; }

        [JsonIgnore]
        public Nullable<System.TimeSpan> Off_Prime_End_Time { get; set; }

        [JsonProperty(PropertyName = "off_prime_run")]
        public int Off_Prime_Run { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "time_lag")]
        public string time_lag { get; set; }

        [JsonIgnore]
        public Nullable<System.TimeSpan> Time_Lag_Simulcast { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "prime_time_provisional_run_count")]
        public Nullable<int> Prime_Time_Provisional_Run_Count { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "prime_time_asRun_count")]
        public Nullable<int> Prime_Time_AsRun_Count { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "prime_time_balance_count")]
        public Nullable<int> Prime_Time_Balance_Count { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "off_prime_time_provisional_run_count")]
        public Nullable<int> Off_Prime_Time_Provisional_Run_Count { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "off_prime_time_asrun_count")]
        public Nullable<int> Off_Prime_Time_AsRun_Count { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "off_prime_time_balance_count")]
        public Nullable<int> Off_Prime_Time_Balance_Count { get; set; }

        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "start_date")]
        public string start_date { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Start_Date { get; set; }

        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonProperty(PropertyName = "end_date")]
        public string end_date { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> End_Date { get; set; }

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

        [OneToMany]
        public virtual ICollection<Acq_Deal_Run_Title> titles { get; set; }

        [OneToMany]
        public virtual ICollection<Acq_Deal_Run_Channel> channels { get; set; }

        [OneToMany]
        public virtual ICollection<Acq_Deal_Run_Yearwise_Run> yeardefinition { get; set; }

        [OneToMany]
        public virtual ICollection<Acq_Deal_Run_Repeat_On_Day> repeaton { get; set; }
    }
}
