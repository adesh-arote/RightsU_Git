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
    
    public partial class Acq_Deal_Sport_Ancillary_Broadcast
    {
    	public State EntityState { get; set; }    public int Acq_Deal_Sport_Ancillary_Broadcast_Code { get; set; }
    	    public Nullable<int> Acq_Deal_Sport_Ancillary_Code { get; set; }
    	    public Nullable<int> Sport_Ancillary_Broadcast_Code { get; set; }
    
        public virtual Acq_Deal_Sport_Ancillary Acq_Deal_Sport_Ancillary { get; set; }
        public virtual Sport_Ancillary_Broadcast Sport_Ancillary_Broadcast { get; set; }
    }
}
