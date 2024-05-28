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
    
    public partial class Milestone_Type
    {
        public Milestone_Type()
        {
            this.Acq_Deal_Rights = new HashSet<Acq_Deal_Rights>();
            this.Syn_Deal_Rights = new HashSet<Syn_Deal_Rights>();
            this.Acq_Deal_Pushback = new HashSet<Acq_Deal_Pushback>();
            this.ProjectMilestones = new HashSet<ProjectMilestone>();
        }
    
    	public State EntityState { get; set; }    public int Milestone_Type_Code { get; set; }
    	    public string Milestone_Type_Name { get; set; }
    	    public string Is_Automated { get; set; }
    	    public string Is_Active { get; set; }
    
        public virtual ICollection<Acq_Deal_Rights> Acq_Deal_Rights { get; set; }
        public virtual ICollection<Syn_Deal_Rights> Syn_Deal_Rights { get; set; }
        public virtual ICollection<Acq_Deal_Pushback> Acq_Deal_Pushback { get; set; }
        public virtual ICollection<ProjectMilestone> ProjectMilestones { get; set; }
    }
}
