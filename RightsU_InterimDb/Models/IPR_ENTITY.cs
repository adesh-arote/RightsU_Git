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
    
    public partial class IPR_ENTITY
    {
        public IPR_ENTITY()
        {
            this.IPR_REP = new HashSet<IPR_REP>();
        }
    
    	public State EntityState { get; set; }    public int IPR_Entity_Code { get; set; }
    	    public string Entity { get; set; }
    
        public virtual ICollection<IPR_REP> IPR_REP { get; set; }
    }
}
