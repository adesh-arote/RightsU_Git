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
    
    public partial class Acq_Deal_Ancillary
    {
        public Acq_Deal_Ancillary()
        {
            this.Acq_Deal_Ancillary_Platform = new HashSet<Acq_Deal_Ancillary_Platform>();
            this.Acq_Deal_Ancillary_Title = new HashSet<Acq_Deal_Ancillary_Title>();
        }
    
    	public State EntityState { get; set; }    public int Acq_Deal_Ancillary_Code { get; set; }
    	    public Nullable<int> Acq_Deal_Code { get; set; }
    	    public Nullable<int> Ancillary_Type_code { get; set; }
    	    public Nullable<decimal> Duration { get; set; }
    	    public Nullable<decimal> Day { get; set; }
    	    public string Remarks { get; set; }
    	    public Nullable<int> Group_No { get; set; }
    	    public string Catch_Up_From { get; set; }
    
        public virtual Acq_Deal Acq_Deal { get; set; }
        public virtual Ancillary_Type Ancillary_Type { get; set; }
        public virtual ICollection<Acq_Deal_Ancillary_Platform> Acq_Deal_Ancillary_Platform { get; set; }
        public virtual ICollection<Acq_Deal_Ancillary_Title> Acq_Deal_Ancillary_Title { get; set; }
    }
}
