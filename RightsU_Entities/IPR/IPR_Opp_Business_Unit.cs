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
    
    public partial class IPR_Opp_Business_Unit
    {
    	public State EntityState { get; set; }    public int IPR_Opp_Business_Unit_Code { get; set; }
    	    public Nullable<int> IPR_Opp_Code { get; set; }
    	    public Nullable<int> Business_Unit_Code { get; set; }
    
        public virtual Business_Unit Business_Unit { get; set; }
        public virtual IPR_Opp IPR_Opp { get; set; }
    }
}
