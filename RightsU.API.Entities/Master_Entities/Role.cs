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
    [Table("Role")]
    public partial class Role
    {
        [PrimaryKey]
        //[Column("Role_Code")]
        [JsonProperty(PropertyName = "role_id")]
        public int? Role_Code { get; set; }

        //[Column("Role_Name")]
        [JsonProperty(PropertyName = "role_name")]
        public string Role_Name { get; set; }

        [JsonProperty(PropertyName = "role_type")]
        public string Role_Type { get; set; }
        [JsonIgnore]
        public string Is_Rate_Card { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Last_Action_By { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
      
        [ForeignKeyReference(typeof(Deal_Type))]
        [JsonProperty(PropertyName = "deal_type_id")]
        public Nullable<int> Deal_Type_Code { get; set; }

        [ForeignKeyReference(typeof(Deal_Type))]
        [ManyToOne]
        [Column("Deal_Type_Code")]
        [SimpleSaveIgnore]
        public virtual Deal_Type deal_type { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        [JsonIgnore]
        public string AssetType { get; set; }
        //[JsonProperty(PropertyName = "deal_type")]
        //public string Deal_Type { get; set; }

    }
}