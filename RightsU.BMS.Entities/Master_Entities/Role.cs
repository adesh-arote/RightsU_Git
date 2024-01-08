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
        [Column("Role_Code")]
        public int? role_id { get; set; }

        [Column("Role_Name")]
        public string role_name { get; set; }

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
