using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Genres")]
    public partial class Genres
    {
        [PrimaryKey]
        [Column("Genres_Code")]
        public int? genres_id { get; set; }

        [Column("Genres_Name")]
        public string genres_name { get; set; }

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
