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
        public Extended_Columns_Value()
        {
            //this.Map_Extended_Columns_Details = new HashSet<Map_Extended_Columns_Details>();
            this.Map_Extended_Columns = new HashSet<Map_Extended_Columns>();
        }
        [PrimaryKey]
        public int? Columns_Value_Code { get; set; }
        [ForeignKeyReference(typeof(Extended_Columns))]
        [OneToOne]
        public Extended_Columns Columns_Code { get; set; }
        
        //public string Columns_Name { get; set; }
        
        public string Columns_Value { get; set; }

        
        //public virtual Extended_Columns Extended_Columns { get; set; }
        //[OneToMany]
        //public virtual ICollection<Map_Extended_Columns_Details> Map_Extended_Columns_Details { get; set; }
        [OneToMany]
        public virtual ICollection<Map_Extended_Columns> Map_Extended_Columns { get; set; }
    }
}
