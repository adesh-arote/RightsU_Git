using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("Extended_Group_Config")]
    public class Extended_Group_Config
    {
        [PrimaryKey]
        public int Extended_Group_Config_Code { get; set; }
        [ForeignKeyReference(typeof(Extended_Group))]
        public Nullable<int> Extended_Group_Code { get; set; }
        [ForeignKeyReference(typeof(Extended_Columns))]
        public Nullable<int> Columns_Code { get; set; }
        public Nullable<int> Group_Control_Order { get; set; }
        public string Validations { get; set; }
        public string Additional_Condition { get; set; }
        public string Inter_Group_Name { get; set; }
        public string Display_Name { get; set; }
        public string Allow_Import { get; set; }
        public string Is_Active { get; set; }
        public string Target_Table { get; set; }
        public string Target_Column { get; set; }
        public string Default_Value { get; set; }        
    }
}
