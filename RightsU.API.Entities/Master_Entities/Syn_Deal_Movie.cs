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
    [Table("Syn_Deal_Movie")]
    public partial class Syn_Deal_Movie
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "syn_deal_title_id")]
        public int? Syn_Deal_Movie_Code { get; set; }

        [ForeignKeyReference(typeof(Syn_Deal))]
        [JsonProperty(PropertyName = "syn_deal_id")]
        public Nullable<int> Syn_Deal_Code { get; set; }

        [ForeignKeyReference(typeof(Title))]
        [JsonProperty(PropertyName = "title_id")]
        public Nullable<int> Title_Code { get; set; }

        [JsonProperty(PropertyName = "episode_from")]
        public Nullable<int> Episode_From { get; set; }

        [JsonProperty(PropertyName = "episode_to")]
        public Nullable<int> Episode_End_To { get; set; }

        [JsonProperty(PropertyName = "syn_title_type")]
        public string Syn_Title_Type { get; set; }

        //Pending Columns
        [JsonIgnore]
        public string Is_Closed { get; set; }
        [JsonIgnore]
        public string Remark { get; set; }
        [JsonIgnore]
        public string Closing_Remarks { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Movie_Closed_Date { get; set; }
        [JsonIgnore]
        public string Opening_Remarks { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Movie_Opening_Date { get; set; }
        [JsonIgnore]
        public Nullable<int> Deal_Closed_By { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Deal_Closed_On { get; set; }
        [JsonIgnore]
        public Nullable<int> Deal_Opened_By { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Deal_Opened_On { get; set; }
        [JsonIgnore]
        public string Is_Reopen { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Movie_Opening_Start_Date { get; set; }
    }
}
