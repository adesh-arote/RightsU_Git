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
    
    public partial class Acq_Deal_Sport_Monetisation_Ancillary_Type
    {
    	public State EntityState { get; set; }    public int Acq_Deal_Sport_Monetisation_Ancillary_Type_Code { get; set; }
    	    public Nullable<int> Acq_Deal_Sport_Monetisation_Ancillary_Code { get; set; }
    	    public Nullable<int> Monetisation_Type_Code { get; set; }
    	    public Nullable<int> Monetisation_Rights { get; set; }
    
        public virtual Acq_Deal_Sport_Monetisation_Ancillary Acq_Deal_Sport_Monetisation_Ancillary { get; set; }
        public virtual Monetisation_Type Monetisation_Type { get; set; }
    }
}
