//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_InterimDb.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Extended_Group_Config
    {
    	public State EntityState { get; set; }    public int Extended_Group_Config_Code { get; set; }
    	    public Nullable<int> Extended_Group_Code { get; set; }
    	    public Nullable<int> Columns_Code { get; set; }
    	    public Nullable<int> Group_Control_Order { get; set; }
    	    public string Validations { get; set; }
    	    public string Additional_Condition { get; set; }
    
        public virtual Extended_Columns Extended_Columns { get; set; }
        public virtual Extended_Group Extended_Group { get; set; }
    }
}
