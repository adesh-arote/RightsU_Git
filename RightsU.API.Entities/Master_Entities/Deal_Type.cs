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
    [Table("Deal_Type")]
    public partial class Deal_Type
    {
        [PrimaryKey]
        //[Column("Deal_Type_Code")]
        [JsonProperty(PropertyName = "deal_type_id")]
        public int? Deal_Type_Code { get; set; }
        //[Column("Deal_Type_Name")]
        [JsonProperty(PropertyName = "deal_type_name")]
        public string Deal_Type_Name { get; set; }

        [JsonProperty(PropertyName = "is_default")]
        public string Is_Default { get; set; }

        [JsonProperty(PropertyName = "is_grid_required")]
        public string Is_Grid_Required { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }

        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }

        [JsonProperty(PropertyName = "is_master_deal")]
        public string Is_Master_Deal { get; set; }

        [JsonProperty(PropertyName = "parent_code")]
        public Nullable<int> Parent_Code { get; set; }

        [JsonProperty(PropertyName = "deal_or_title")]
        public string Deal_Or_Title { get; set; }

        [JsonProperty(PropertyName = "deal_title_mapping_code")]
        public Nullable<int> Deal_Title_Mapping_Code { get; set; }
    }
}
