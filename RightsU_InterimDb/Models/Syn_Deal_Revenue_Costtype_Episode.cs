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
    
    public partial class Syn_Deal_Revenue_Costtype_Episode
    {
    	public State EntityState { get; set; }    public int Syn_Deal_Revenue_Costtype_Episode_Code { get; set; }
    	    public Nullable<int> Syn_Deal_Revenue_Costtype_Code { get; set; }
    	    public Nullable<int> Episode_From { get; set; }
    	    public Nullable<int> Episode_To { get; set; }
    	    public string Amount_Type { get; set; }
    	    public Nullable<decimal> Amount { get; set; }
    	    public Nullable<decimal> Percentage { get; set; }
    	    public string Remarks { get; set; }
    
        public virtual Syn_Deal_Revenue_Costtype Syn_Deal_Revenue_Costtype { get; set; }
    }
}
