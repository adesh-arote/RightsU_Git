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
    
    public partial class Report_Territory_Country
    {
    	public State EntityState { get; set; }    public int Report_Territory_Country_Code { get; set; }
    	    public Nullable<int> Report_Territory_Code { get; set; }
    	    public Nullable<int> Country_Code { get; set; }
        public virtual Country Country { get; set; }
        public virtual Report_Territory Report_Territory { get; set; }
    }
}
