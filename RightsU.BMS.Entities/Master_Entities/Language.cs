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
    [Table("Language")]
    public partial class Language
    {
        [PrimaryKey]
        [Column("Language_Code")]
        public int? language_id { get; set; }

        [Column("Language_Name")]
        public string language_name { get; set; }

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
        [JsonIgnore]
        public string Is_Active { get; set; }
        
    }
}
