using Dapper.SimpleLoad;
using Dapper.SimpleSave;
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
            this.Map_Extended_Columns_Details = new HashSet<Map_Extended_Columns_Details>();
        }

        [PrimaryKey]
        public int? Map_Extended_Columns_Code { get; set; }
        public Nullable<int> Record_Code { get; set; }
        public string Table_Name { get; set; }   
        [ForeignKeyReference(typeof(Extended_Columns))]  
        [ManyToOne]        
        public Extended_Columns Columns_Code { get; set; }        
        //public string Column_Name { get; set; }
        [ForeignKeyReference(typeof(Extended_Columns_Value))]        
        public Nullable<int> Columns_Value_Code { get; set; }
        public string Column_Value { get; set; }
        public string Is_Multiple_Select { get; set; }
        public Nullable<int> Row_No { get; set; }

        //public virtual Extended_Columns Extended_Columns { get; set; }

        //public virtual Extended_Columns_Value Extended_Columns_Value { get; set; }  
        [OneToMany]
        public virtual ICollection<Map_Extended_Columns_Details> Map_Extended_Columns_Details { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }
    }
}
