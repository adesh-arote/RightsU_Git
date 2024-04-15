﻿using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    public partial class USP_Acq_List_Runs
    {
        [JsonProperty(PropertyName = "deal_run_id")]
        public Nullable<int> Acq_Deal_Run_Code { get; set; }

        [JsonProperty(PropertyName = "title_name")]
        public string Title_Name { get; set; }

        [JsonProperty(PropertyName = "channel_names")]
        public string ChannelNames { get; set; }

        [JsonProperty(PropertyName = "run_definition_type")]
        public string Run_Definition_Type { get; set; }

        [JsonProperty(PropertyName = "run_type")]
        public string Run_Type { get; set; }

        [JsonProperty(PropertyName = "rule_right")]
        public string Is_Rule_Right { get; set; }

        [JsonProperty(PropertyName = "no_of_runs")]
        public Nullable<int> No_Of_Runs { get; set; }

        [JsonProperty(PropertyName = "no_of_runs_sched")]
        public Nullable<int> No_Of_Runs_Sched { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "data_for")]
        public string Data_For { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "is_sublicense")]
        public string Is_SubLicense { get; set; }

        [JsonProperty(PropertyName = "syndication_runs")]
        public Nullable<int> Syndication_Runs { get; set; }

        [JsonProperty(PropertyName = "deal_title_id")]
        public Nullable<int> Acq_Deal_Movie_Code { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_on")]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_on")]
        public Nullable<System.DateTime> Last_updated_Time { get; set; }
    }
}