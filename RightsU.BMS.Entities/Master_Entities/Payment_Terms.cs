using Dapper.SimpleSave;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Payment_Terms")]
    public partial class Payment_Terms
    {
        [JsonIgnore]
        public State EntityState { get; set; }
        
        [PrimaryKey]
        [JsonProperty(PropertyName = "payment_terms_id")]
        public int? Payment_Terms_Code { get; set; }

        [JsonProperty(PropertyName = "payment_terms")]
        [Column("Payment_Terms")]
        public string Payment_Terms1 { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_on")]
        public Nullable<System.DateTime> Inserted_On { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "inserted_by")]
        public Nullable<int> Inserted_By { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_on")]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "updated_by")]
        public Nullable<int> Last_Action_By { get; set; }

        [JsonIgnore]
        [JsonProperty(PropertyName = "is_active")]
        public string Is_Active { get; set; }
    }
}
