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
    
    public partial class Syn_Deal_Supplementary
    {
        public Syn_Deal_Supplementary()
        {
            this.Syn_Deal_Supplementary_Detail = new HashSet<Syn_Deal_Supplementary_Detail>();
        }
    
    	public State EntityState { get; set; }    public int Syn_Deal_Supplementary_Code { get; set; }
    	    public Nullable<int> Syn_Deal_Code { get; set; }
    	    public Nullable<int> Title_code { get; set; }
    	    public Nullable<int> Episode_From { get; set; }
    	    public Nullable<int> Episode_To { get; set; }
    	    public string Remarks { get; set; }
    
        public virtual ICollection<Syn_Deal_Supplementary_Detail> Syn_Deal_Supplementary_Detail { get; set; }
    }
}
