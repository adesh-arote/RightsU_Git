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
    
    public partial class Music_Deal_Channel
    {
    	public State EntityState { get; set; }    public int Music_Deal_Channel_Code { get; set; }
    	    public Nullable<int> Music_Deal_Code { get; set; }
    	    public Nullable<int> Channel_Code { get; set; }
    	    public Nullable<int> Defined_Runs { get; set; }
    	    public Nullable<int> Scheduled_Runs { get; set; }
    
        public virtual Channel Channel { get; set; }
        public virtual Music_Deal Music_Deal { get; set; }
    }
}
