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
    
    public partial class AT_Acq_Deal_Digital
    {
        public AT_Acq_Deal_Digital()
        {
            this.AT_Acq_Deal_Digital_detail = new HashSet<AT_Acq_Deal_Digital_detail>();
        }
    
    	public State EntityState { get; set; }    public int AT_Acq_Deal_Digital_Code { get; set; }
    	    public Nullable<int> AT_Acq_Deal_Code { get; set; }
    	    public Nullable<int> Title_code { get; set; }
    	    public Nullable<int> Episode_From { get; set; }
    	    public Nullable<int> Episode_To { get; set; }
    	    public string Remarks { get; set; }
    	    public Nullable<int> Acq_Deal_Digital_Code { get; set; }
    
        public virtual ICollection<AT_Acq_Deal_Digital_detail> AT_Acq_Deal_Digital_detail { get; set; }
    }
}
