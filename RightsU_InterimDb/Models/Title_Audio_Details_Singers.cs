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
    
    public partial class Title_Audio_Details_Singers
    {
    	public State EntityState { get; set; }    public int Title_Audio_Details_Singers_Code { get; set; }
    	    public Nullable<int> Title_Code { get; set; }
    	    public Nullable<int> Title_Audio_Details_Code { get; set; }
    	    public Nullable<int> Talent_Code { get; set; }
    
        public virtual Talent Talent { get; set; }
        public virtual Title Title { get; set; }
    }
}
