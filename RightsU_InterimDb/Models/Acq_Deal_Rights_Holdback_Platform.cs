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
    
    public partial class Acq_Deal_Rights_Holdback_Platform
    {
    	public State EntityState { get; set; }    public int Acq_Deal_Rights_Holdback_Platform_Code { get; set; }
    	    public Nullable<int> Acq_Deal_Rights_Holdback_Code { get; set; }
    	    public Nullable<int> Platform_Code { get; set; }
    
        public virtual Acq_Deal_Rights_Holdback Acq_Deal_Rights_Holdback { get; set; }
        public virtual Platform Platform { get; set; }
    }
}
