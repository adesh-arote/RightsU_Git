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
    
    public partial class MHRequestStatu
    {
        public MHRequestStatu()
        {
            this.MHRequests = new HashSet<MHRequest>();
        }
    
    	public State EntityState { get; set; }    public int MHRequestStatusCode { get; set; }
    	    public string RequestStatusName { get; set; }
    	    public Nullable<int> ModuleCode { get; set; }
    	    public string IsActive { get; set; }
    
        public virtual ICollection<MHRequest> MHRequests { get; set; }
        public virtual System_Module System_Module { get; set; }
    }
}
