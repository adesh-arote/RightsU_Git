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
    
    public partial class Cost_Center
    {
        public Cost_Center()
        {
            this.Acq_Deal = new HashSet<Acq_Deal>();
            this.Acq_Deal_Cost = new HashSet<Acq_Deal_Cost>();
            this.Syn_Deal_Revenue = new HashSet<Syn_Deal_Revenue>();
        }
    
    	public State EntityState { get; set; }    public int Cost_Center_Id { get; set; }
    	    public string Cost_Center_Code { get; set; }
    	    public string Cost_Center_Name { get; set; }
    	    public Nullable<System.DateTime> Inserted_On { get; set; }
    	    public Nullable<int> Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Lock_Time { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    	    public string Is_Active { get; set; }
    
        public virtual ICollection<Acq_Deal> Acq_Deal { get; set; }
        public virtual ICollection<Acq_Deal_Cost> Acq_Deal_Cost { get; set; }
        public virtual ICollection<Syn_Deal_Revenue> Syn_Deal_Revenue { get; set; }
    }
}
