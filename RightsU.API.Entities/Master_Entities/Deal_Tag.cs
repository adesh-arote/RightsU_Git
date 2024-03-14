using System;
using System.Collections.Generic;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("Deal_Tag")]
    public partial class Deal_Tag
    {
        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_tag_id")]
        public int? Deal_Tag_Code { get; set; }

        [JsonProperty(PropertyName = "deal_tag_description")]
        public string Deal_Tag_Description { get; set; }

        [JsonProperty(PropertyName = "deal_flag")]
        public string Deal_Flag { get; set; }
    }
}
