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
    [Table("Currency")]
    public partial class Currency
    {
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }
        
        [PrimaryKey]
        [JsonProperty(PropertyName = "currency_id")]
        public int? Currency_Code { get; set; }

        [JsonProperty(PropertyName = "currency_name")]
        public string Currency_Name { get; set; }

        [JsonProperty(PropertyName = "currency_sign")]
        public string Currency_Sign { get; set; }

        [JsonProperty(PropertyName = "is_base_currency")]
        public string Is_Base_Currency { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_on")]
        public System.DateTime Inserted_On { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_by")]
        public int Inserted_By { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_on")]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_by")]
        public Nullable<int> Last_Action_By { get; set; }
        
        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }
    }
}
