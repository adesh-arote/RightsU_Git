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
    [Table("Acq_Deal_Run_Title")]
    public partial class Acq_Deal_Run_Title
    {
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_run_title_id")]
        public int? Acq_Deal_Run_Title_Code { get; set; }

        [ForeignKeyReference(typeof(Acq_Deal_Run))]
        [JsonProperty(PropertyName = "deal_run_id")]
        public Nullable<int> Acq_Deal_Run_Code { get; set; }

        [ForeignKeyReference(typeof(Title))]
        [JsonProperty(PropertyName = "title_id")]
        public Nullable<int> Title_Code { get; set; }

        [JsonProperty(PropertyName = "episode_from")]
        public Nullable<int> Episode_From { get; set; }

        [JsonProperty(PropertyName = "episode_to")]
        public Nullable<int> Episode_To { get; set; }

    }
}
