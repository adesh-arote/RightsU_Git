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
    
    public partial class System_Module_Right
    {
        public System_Module_Right()
        {
            this.Security_Group_Rel = new HashSet<Security_Group_Rel>();
            this.Users_Exclusion_Rights = new HashSet<Users_Exclusion_Rights>();
        }
    
    	public State EntityState { get; set; }    public int Module_Right_Code { get; set; }
    	    public int Module_Code { get; set; }
    	    public int Right_Code { get; set; }
    
        public virtual ICollection<Security_Group_Rel> Security_Group_Rel { get; set; }
        public virtual System_Module System_Module { get; set; }
        public virtual System_Right System_Right { get; set; }
        public virtual ICollection<Users_Exclusion_Rights> Users_Exclusion_Rights { get; set; }
    }
}
