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
        public int? metadata_id { get; set; }

        [Column("Record_Code")]
        public Nullable<int> title_id { get; set; }

        [ForeignKeyReference(typeof(Extended_Columns))]
        [Column("Columns_Code")]
        public Nullable<int> columns_id { get; set; }

        [ForeignKeyReference(typeof(Extended_Columns))]
        [ManyToOne]
        [Column("Columns_Code")]
        public virtual Extended_Columns extended_columns { get; set; }

        [Column("Column_Value")]
        public string columns_value { get; set; }

        [Column("Columns_Value_Code")]
        public Nullable<int> columns_value_id { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual object extended_columns_value { get; set; }

        [Column("Row_No")]
        public Nullable<int> row_no { get; set; }

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
