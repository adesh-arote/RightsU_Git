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
    
    public partial class AL_Vendor_TnC
    {
    	public State EntityState { get; set; }    public int AL_Vendor_TnC_Code { get; set; }
    	    public Nullable<int> Vendor_Code { get; set; }
    	    public string TnC_Description { get; set; }
    
        public virtual Vendor Vendor { get; set; }
    }
}
