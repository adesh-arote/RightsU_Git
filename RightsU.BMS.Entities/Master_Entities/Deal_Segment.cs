using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Deal_Segment")]
    public partial class Deal_Segment
    {
        [PrimaryKey]
        [JsonProperty(PropertyName = "deal_segment_id")]
        public int? Deal_Segment_Code { get; set; }

        [JsonProperty(PropertyName = "deal_segment_name")]
        public string Deal_Segment_Name { get; set; }
    }
}
