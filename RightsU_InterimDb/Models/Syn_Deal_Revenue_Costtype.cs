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
    
    public partial class Syn_Deal_Revenue_Costtype
    {
        public Syn_Deal_Revenue_Costtype()
        {
            this.Syn_Deal_Revenue_Costtype_Episode = new HashSet<Syn_Deal_Revenue_Costtype_Episode>();
        }
    
    	public State EntityState { get; set; }    public int Syn_Deal_Revenue_Costtype_Code { get; set; }
    	    public Nullable<int> Syn_Deal_Revenue_Code { get; set; }
    	    public Nullable<int> Cost_Type_Code { get; set; }
    	    public Nullable<decimal> Amount { get; set; }
    	    public Nullable<decimal> Consumed_Amount { get; set; }
    	    public System.DateTime Inserted_On { get; set; }
    	    public int Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    
        public virtual Cost_Type Cost_Type { get; set; }
        public virtual Syn_Deal_Revenue Syn_Deal_Revenue { get; set; }
        public virtual ICollection<Syn_Deal_Revenue_Costtype_Episode> Syn_Deal_Revenue_Costtype_Episode { get; set; }
    }
}
