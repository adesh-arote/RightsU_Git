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
    
    public partial class IPR_REP_ATTACHMENTS
    {
    	public State EntityState { get; set; }    public int IPR_Rep_Attachment_Code { get; set; }
    	    public Nullable<int> IPR_Rep_Code { get; set; }
    	    public string System_File_Name { get; set; }
    	    public string File_Name { get; set; }
    	    public string Flag { get; set; }
    	    public string Description { get; set; }
    
        public virtual IPR_REP IPR_REP { get; set; }
    }
}
