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
        //[Column("Map_Extended_Columns_Details_Code")]
        [JsonProperty(PropertyName = "metadata_values_id")]
        public int? Map_Extended_Columns_Details_Code { get; set; } 
        
        [ForeignKeyReference(typeof(Map_Extended_Columns))]
        //[Column("Map_Extended_Columns_Code")]
        [JsonProperty(PropertyName = "metadata_id")]
        public Nullable<int> Map_Extended_Columns_Code { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public string name { get; set; }

        //[Column("Columns_Value_Code")]
        [JsonProperty(PropertyName = "column_value_id")]
        public Nullable<int> Columns_Value_Code { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }
    }
}
