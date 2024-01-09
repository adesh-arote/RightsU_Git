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
    [Dapper.SimpleSave.Table("Map_Extended_Columns")]
    public partial class Map_Extended_Columns
    {
        public Map_Extended_Columns()
        {
            this.metadata_values = new HashSet<Map_Extended_Columns_Details>();
        }

        [PrimaryKey]
        [Column("Map_Extended_Columns_Code")]
        [JsonProperty(PropertyName = "metadata_id")]
        public int? Map_Extended_Columns_Code { get; set; }

        //[Column("Record_Code")]
        [JsonProperty(PropertyName = "title_id")]
        public Nullable<int> Record_Code { get; set; }

        [ForeignKeyReference(typeof(Extended_Columns))]
        //[Column("Columns_Code")]
        [JsonProperty(PropertyName = "columns_id")]
        public Nullable<int> Columns_Code { get; set; }

        [ForeignKeyReference(typeof(Extended_Columns))]
        [ManyToOne]
        [Column("Columns_Code")]
        [SimpleSaveIgnore]
        public virtual Extended_Columns extended_columns { get; set; }

        //[Column("Column_Value")]
        [JsonProperty(PropertyName = "columns_value")]
        public string Column_Value { get; set; }

        //[Column("Columns_Value_Code")]
        [JsonProperty(PropertyName = "columns_value_id")]
        public Nullable<int> Columns_Value_Code { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Extended_Columns_Value extended_columns_value { get; set; }

        //[Column("Row_No")]
        [JsonProperty(PropertyName = "row_no")]
        public Nullable<int> Row_No { get; set; }

        [OneToMany]
        public virtual ICollection<Map_Extended_Columns_Details> metadata_values { get; set; }

        [JsonIgnore]
        public string Table_Name { get; set; }   
        [JsonIgnore]
        public string Is_Multiple_Select { get; set; }
        [JsonIgnore]
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }
    }
}
