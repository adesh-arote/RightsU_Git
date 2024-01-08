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
    [Table("Map_Extended_Columns_Details")]
    public partial class Map_Extended_Columns_Details
    {
        [PrimaryKey]
        [Column("Map_Extended_Columns_Details_Code")]
        public int? metadata_values_id { get; set; } 
        
        [ForeignKeyReference(typeof(Map_Extended_Columns))]
        [Column("Map_Extended_Columns_Code")]
        public Nullable<int> metadata_id { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public string name { get; set; }

        [Column("Columns_Value_Code")]
        public Nullable<int> column_value_id { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }
    }
}
