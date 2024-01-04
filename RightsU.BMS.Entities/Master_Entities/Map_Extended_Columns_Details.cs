using Dapper.SimpleLoad;
using Dapper.SimpleSave;
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
        public int? Map_Extended_Columns_Details_Code { get; set; } 
        [ForeignKeyReference(typeof(Map_Extended_Columns))]        
        public Nullable<int> Map_Extended_Columns_Code { get; set; }        
        public Nullable<int> Columns_Value_Code { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }

        //public virtual Extended_Columns_Value Extended_Columns_Value { get; set; }

        //public virtual Map_Extended_Columns Map_Extended_Columns { get; set; }
    }
}
