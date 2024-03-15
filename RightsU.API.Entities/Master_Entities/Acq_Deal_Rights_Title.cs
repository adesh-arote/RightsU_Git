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
    [Table("Acq_Deal_Rights_Title")]
    public partial class Acq_Deal_Rights_Title
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_rights_title_id")]
        public int? Acq_Deal_Rights_Title_Code { get; set; }

        [ForeignKeyReference(typeof(Acq_Deal_Rights))]
        [JsonProperty(PropertyName = "deal_rights_id")]
        public Nullable<int> Acq_Deal_Rights_Code { get; set; }

        [ForeignKeyReference(typeof(Title))]
        [JsonProperty(PropertyName = "title_id")]
        public Nullable<int> Title_Code { get; set; }

        [SimpleSaveIgnore]
        [ManyToOne]
        [Column("Title_Code")]
        public virtual Title title { get; set; }

        [JsonProperty(PropertyName = "episode_from")] 
        public Nullable<int> Episode_From { get; set; }

        [JsonProperty(PropertyName = "episode_to")]
        public Nullable<int> Episode_To { get; set; }


    }
}
