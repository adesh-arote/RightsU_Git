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
    
    public partial class Title_Content_Version
    {
        public Title_Content_Version()
        {
            this.Content_Music_Link = new HashSet<Content_Music_Link>();
            this.Title_Content_Version_Details = new HashSet<Title_Content_Version_Details>();
        }
    
    	public State EntityState { get; set; }    public int Title_Content_Version_Code { get; set; }
    	    public Nullable<int> Title_Content_Code { get; set; }
    	    public Nullable<int> Version_Code { get; set; }
    	    public Nullable<decimal> Duration { get; set; }
    	    public Nullable<int> MusicSystemCode { get; set; }
    
        public virtual ICollection<Content_Music_Link> Content_Music_Link { get; set; }
        public virtual Title_Content Title_Content { get; set; }
        public virtual Version Version { get; set; }
        public virtual ICollection<Title_Content_Version_Details> Title_Content_Version_Details { get; set; }
    }
}
