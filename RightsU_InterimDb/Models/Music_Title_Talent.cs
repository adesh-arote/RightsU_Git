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
    
    public partial class Music_Title_Talent
    {
    	public State EntityState { get; set; }    public int Music_Title_Talent_Code { get; set; }
    	    public Nullable<int> Music_Title_Code { get; set; }
    	    public Nullable<int> Talent_Code { get; set; }
    	    public Nullable<int> Role_Code { get; set; }
    
        public virtual Role Role { get; set; }
        public virtual Talent Talent { get; set; }
        public virtual Music_Title Music_Title { get; set; }
    }
}
