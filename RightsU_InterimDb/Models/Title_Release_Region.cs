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
    
    public partial class Title_Release_Region
    {
    	public State EntityState { get; set; }    public int Title_Release_Region_Code { get; set; }
    	    public Nullable<int> Title_Release_Code { get; set; }
    	    public Nullable<int> Territory_Code { get; set; }
    	    public Nullable<int> Country_Code { get; set; }
    
        public virtual Title_Release Title_Release { get; set; }
    }
}
