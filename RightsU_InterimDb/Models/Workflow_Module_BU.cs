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
    
    public partial class Workflow_Module_BU
    {
        public Workflow_Module_BU()
        {
            this.Workflow_Module_BU_Role = new HashSet<Workflow_Module_BU_Role>();
        }
    
    	public State EntityState { get; set; }    public int Workflow_Module_BU_Code { get; set; }
    	    public Nullable<int> Workflow_Module_Code { get; set; }
    	    public Nullable<int> Workflow_BU_Code { get; set; }
    	    public Nullable<int> Business_Unit_Code { get; set; }
    
        public virtual Business_Unit Business_Unit { get; set; }
        public virtual Workflow_BU Workflow_BU { get; set; }
        public virtual Workflow_Module Workflow_Module { get; set; }
        public virtual ICollection<Workflow_Module_BU_Role> Workflow_Module_BU_Role { get; set; }
    }
}
