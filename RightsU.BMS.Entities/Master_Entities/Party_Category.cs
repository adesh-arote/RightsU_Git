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
    [Table("Party_Category")]
    public partial class Party_Category
    {        
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }

        [PrimaryKey]
        [JsonProperty(PropertyName = "party_category_id")]
        public int? Party_Category_Code { get; set; }

        [JsonProperty(PropertyName = "party_category_name")]
        public string Party_Category_Name { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_on")]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_by")]
        public Nullable<int> Inserted_By { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_on")]
        public Nullable<System.DateTime> Last_Updated_On { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_by")]
        public Nullable<int> Last_Updated_By { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }
    }
}
