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
    
    public partial class Syn_Deal_Run_Yearwise_Run
    {
    	public State EntityState { get; set; }    public int Syn_Deal_Run_Yearwise_Run_Code { get; set; }
    	    public Nullable<int> Syn_Deal_Run_Code { get; set; }
    	    public Nullable<System.DateTime> Start_Date { get; set; }
    	    public Nullable<System.DateTime> End_Date { get; set; }
    	    public Nullable<int> No_Of_Runs { get; set; }
    	    public Nullable<int> Year_No { get; set; }
    
        public virtual Syn_Deal_Run Syn_Deal_Run { get; set; }
    }
}
