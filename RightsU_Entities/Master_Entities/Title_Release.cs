//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;
    
    public partial class Title_Release
    {
        public Title_Release()
        {
            this.Title_Release_Platforms = new HashSet<Title_Release_Platforms>();
            this.Title_Release_Region = new HashSet<Title_Release_Region>();
        }
    
    	public State EntityState { get; set; }    public int Title_Release_Code { get; set; }
    	    public Nullable<int> Title_Code { get; set; }
    	    public Nullable<System.DateTime> Release_Date { get; set; }
    	    public string Release_Type { get; set; }
    
        public virtual Title Title { get; set; }
        public virtual ICollection<Title_Release_Platforms> Title_Release_Platforms { get; set; }
        public virtual ICollection<Title_Release_Region> Title_Release_Region { get; set; }
    }
}
