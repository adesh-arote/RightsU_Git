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
    
    public partial class Digital
    {
        public Digital()
        {
            this.Digital_Config = new HashSet<Digital_Config>();
        }
    
    	public State EntityState { get; set; }    public int Digital_Code { get; set; }
    	    public string Digital_Name { get; set; }
    	    public string Is_Active { get; set; }
    
        public virtual ICollection<Digital_Config> Digital_Config { get; set; }
    }
}
