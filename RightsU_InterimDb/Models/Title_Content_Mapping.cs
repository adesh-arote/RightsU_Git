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
    
    public partial class Title_Content_Mapping
    {
    	public State EntityState { get; set; }    public int Title_Content_Mapping_Code { get; set; }
    	    public Nullable<int> Title_Content_Code { get; set; }
    	    public string Deal_For { get; set; }
    	    public Nullable<int> Acq_Deal_Movie_Code { get; set; }
    	    public Nullable<int> Provisional_Deal_Title_Code { get; set; }
    
        public virtual Acq_Deal_Movie Acq_Deal_Movie { get; set; }
        public virtual Provisional_Deal_Title Provisional_Deal_Title { get; set; }
        public virtual Title_Content Title_Content { get; set; }
    }
}
