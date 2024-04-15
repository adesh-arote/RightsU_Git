﻿using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("Acq_Deal_Movie")]
    public partial class Acq_Deal_Movie
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_title_id")]
        public int? Acq_Deal_Movie_Code { get; set; }

        [ForeignKeyReference(typeof(Acq_Deal))]
        [JsonProperty(PropertyName = "deal_id")]
        public Nullable<int> Acq_Deal_Code { get; set; }

        [ForeignKeyReference(typeof(Title))]
        [JsonProperty(PropertyName = "title_id")]
        public Nullable<int> Title_Code { get; set; }

        [JsonProperty(PropertyName = "episode_from")]
        public Nullable<int> Episode_Starts_From { get; set; }

        [JsonProperty(PropertyName = "episode_to")]
        public Nullable<int> Episode_End_To { get; set; }

        [JsonProperty(PropertyName = "note")]
        public string Notes { get; set; }
                
        [JsonProperty(PropertyName = "title_type")]
        public string Title_Type { get; set; }
                
        [JsonProperty(PropertyName = "public_notice")]
        public string Due_Diligence { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_on")]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_by")]
        public Nullable<int> Inserted_By { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_on")]
        public Nullable<System.DateTime> Last_UpDated_Time { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_by")]
        public Nullable<int> Last_Action_By { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "no_of_episodes")]
        public Nullable<int> No_Of_Episodes { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "no_of_files")]
        public Nullable<int> No_Of_Files { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "is_closed")]
        public string Is_Closed { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "amort_type")]
        public string Amort_Type { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "closing_remarks")]
        public string Closing_Remarks { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "movie_closed_date")]
        public Nullable<System.DateTime> Movie_Closed_Date { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "remark")]
        public string Remark { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "ref_bms_movie_code")]
        public string Ref_BMS_Movie_Code { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "duration_restriction")]
        public Nullable<decimal> Duration_Restriction { get; set; }

        //[ManyToOne]
        //[SimpleSaveIgnore]
        //[Column("Title_Code")]
        //public virtual Title Title { get; set; }
    }
}