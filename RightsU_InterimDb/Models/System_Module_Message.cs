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
    
    public partial class System_Module_Message
    {
        public System_Module_Message()
        {
            this.System_Language_Message = new HashSet<System_Language_Message>();
        }
    
    	public State EntityState { get; set; }    public int System_Module_Message_Code { get; set; }
    	    public Nullable<int> Module_Code { get; set; }
    	    public string Form_ID { get; set; }
    	    public Nullable<int> System_Message_Code { get; set; }
    	    public Nullable<System.DateTime> Inserted_On { get; set; }
    	    public Nullable<int> Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    
        public virtual ICollection<System_Language_Message> System_Language_Message { get; set; }
        public virtual System_Message System_Message { get; set; }
        public virtual System_Module System_Module { get; set; }
    }
}
