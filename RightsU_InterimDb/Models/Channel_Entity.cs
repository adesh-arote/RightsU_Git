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
    
    public partial class Channel_Entity
    {
    	public State EntityState { get; set; }    public int Channel_Entity_Code { get; set; }
    	    public Nullable<int> Channel_Code { get; set; }
    	    public Nullable<int> Entity_Code { get; set; }
    	    public System.DateTime Effective_Start_Date { get; set; }
    	    public Nullable<System.DateTime> System_End_Date { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    
        public virtual Channel Channel { get; set; }
    }
}
