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
    
    public partial class Workflow_Role
    {
        public Workflow_Role()
        {
            this.Workflow_Module_Role = new HashSet<Workflow_Module_Role>();
        }
    
    	public State EntityState { get; set; }    public int Workflow_Role_Code { get; set; }
    	    public Nullable<short> Group_Level { get; set; }
    	    public Nullable<int> Workflow_Code { get; set; }
    	    public Nullable<int> Group_Code { get; set; }
    	    public Nullable<int> Primary_User_Code { get; set; }
    
        public virtual Security_Group Security_Group { get; set; }
        public virtual Workflow Workflow { get; set; }
        public virtual ICollection<Workflow_Module_Role> Workflow_Module_Role { get; set; }
    }
}
