using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;

using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("Promoter_Remarks")]
    public partial class  PromoterRemark
    {
        [PrimaryKey]
        [JsonProperty(PropertyName = "promoter_remarks_id")]
        public int? Promoter_Remarks_Code { get; set; }

        [JsonProperty(PropertyName = "promoter_remark_desc")]
        public string Promoter_Remark_Desc { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }

        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }

        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }

        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }
    }
}
