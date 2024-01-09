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

        [JsonIgnore]
        public string Role_Type { get; set; }
        [JsonIgnore]
        public string Is_Rate_Card { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Last_Action_By { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]       
        [ForeignKeyReference(typeof(Deal_Type))]
        public Nullable<int> Deal_Type_Code { get; set; }
    }
}
