using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("ROFR")]

    public partial class ROFR
    {
        [PrimaryKey]
        [JsonProperty(PropertyName = "rofr_id")]
        public int? ROFR_Code { get; set; }
        [JsonProperty(PropertyName = "rofr_type")]
        public string ROFR_Type { get; set; }
        [JsonProperty(PropertyName = "Is_Active")]
        public string is_active { get; set; }

    }
}
