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
    
    public partial class MHRequestType
    {
        public MHRequestType()
        {
            this.MHRequests = new HashSet<MHRequest>();
        }
    
    	public State EntityState { get; set; }    public int MHRequestTypeCode { get; set; }
    	    public string RequestTypeName { get; set; }
    	    public string IsActive { get; set; }
    
        public virtual ICollection<MHRequest> MHRequests { get; set; }
    }
}
