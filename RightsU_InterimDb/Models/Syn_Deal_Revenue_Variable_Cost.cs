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
    
    public partial class Syn_Deal_Revenue_Variable_Cost
    {
    	public State EntityState { get; set; }    public int Syn_Deal_Revenue_Variable_Cost_Code { get; set; }
    	    public Nullable<int> Syn_Deal_Revenue_Code { get; set; }
    	    public Nullable<int> Entity_Code { get; set; }
    	    public Nullable<int> Vendor_Code { get; set; }
    	    public Nullable<decimal> Percentage { get; set; }
    	    public Nullable<decimal> Amount { get; set; }
    	    public System.DateTime Inserted_On { get; set; }
    	    public int Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    
        public virtual Entity Entity { get; set; }
        public virtual Syn_Deal_Revenue Syn_Deal_Revenue { get; set; }
        public virtual Vendor Vendor { get; set; }
    }
}
