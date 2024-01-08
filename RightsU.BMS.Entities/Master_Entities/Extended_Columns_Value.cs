using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("Extended_Columns_Value")]
    public partial class Extended_Columns_Value
    {
        [PrimaryKey]
        [Column("Columns_Value_Code")]
        public int? columns_value_id { get; set; }

        [Column("Columns_Code")]
        public Nullable<int> columns_id { get; set; }

        [Column("Columns_Value")]
        public string columns_value { get; set; }

    }
}
