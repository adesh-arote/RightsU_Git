//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;
    
    public partial class Extended_Columns
    {
        public Extended_Columns()
        {
            this.Extended_Columns_Value = new HashSet<Extended_Columns_Value>();
            this.Map_Extended_Columns = new HashSet<Map_Extended_Columns>();
        }
    
        public int Columns_Code { get; set; }
        public string Columns_Name { get; set; }
        public string Control_Type { get; set; }
        public string Is_Ref { get; set; }
        public string Is_Defined_Values { get; set; }
        public string Is_Multiple_Select { get; set; }
        public string Ref_Table { get; set; }
        public string Ref_Display_Field { get; set; }
        public string Ref_Value_Field { get; set; }
        public string Additional_Condition { get; set; }
    
        public virtual ICollection<Extended_Columns_Value> Extended_Columns_Value { get; set; }
        public virtual ICollection<Map_Extended_Columns> Map_Extended_Columns { get; set; }
    }
}
