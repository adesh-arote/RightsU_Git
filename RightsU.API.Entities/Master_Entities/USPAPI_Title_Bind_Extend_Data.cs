using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    public partial class USPAPI_Title_Bind_Extend_Data
    {
        public string Columns_Name { get; set; }
        public int Columns_Code { get; set; }
        public string Control_Type { get; set; }
        public string Is_Ref { get; set; }
        public string Is_Defined_Values { get; set; }
        public string Is_Multiple_Select { get; set; }
        public string Ref_Table { get; set; }
        public string Ref_Display_Field { get; set; }
        public string Ref_Value_Field { get; set; }        
        public Nullable<int> Columns_Value_Code { get; set; }
        public string Columns_Value_Code1 { get; set; }
        public string Name { get; set; }
        public int Map_Extended_Columns_Code { get; set; }
        public string Column_Value { get; set; }
        public string IsDelete { get; set; }
        public int? Extended_Group_Code { get; set; }
        public int? Row_No { get; set; }
        public string Group_Name { get; set; }
    }
}
