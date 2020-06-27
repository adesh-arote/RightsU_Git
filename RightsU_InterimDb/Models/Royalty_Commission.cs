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
    
    public partial class Royalty_Commission
    {
        public Royalty_Commission()
        {
            this.Royalty_Commission_Details = new HashSet<Royalty_Commission_Details>();
            this.Acq_Deal_Cost_Commission = new HashSet<Acq_Deal_Cost_Commission>();
            this.Syn_Deal_Revenue_Commission = new HashSet<Syn_Deal_Revenue_Commission>();
        }
    
    	public State EntityState { get; set; }    public int Royalty_Commission_Code { get; set; }
    	    public string Royalty_Commission_Name { get; set; }
    	    public string Is_Active { get; set; }
    	    public System.DateTime Inserted_On { get; set; }
    	    public int Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Lock_Time { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    
        public virtual ICollection<Royalty_Commission_Details> Royalty_Commission_Details { get; set; }
        public virtual ICollection<Acq_Deal_Cost_Commission> Acq_Deal_Cost_Commission { get; set; }
        public virtual ICollection<Syn_Deal_Revenue_Commission> Syn_Deal_Revenue_Commission { get; set; }
    }
}
