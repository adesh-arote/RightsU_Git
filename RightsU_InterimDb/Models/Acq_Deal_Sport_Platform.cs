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
    
    public partial class Acq_Deal_Sport_Platform
    {
    	public State EntityState { get; set; }    public int Acq_Deal_Sport_Platform_Code { get; set; }
    	    public int Acq_Deal_Sport_Code { get; set; }
    	    public int Platform_Code { get; set; }
    	    public string Type { get; set; }
    
        public virtual Acq_Deal_Sport Acq_Deal_Sport { get; set; }
        public virtual Platform Platform { get; set; }
    }
}
