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
    
    public partial class System_Right
    {
        public System_Right()
        {
            this.System_Module_Right = new HashSet<System_Module_Right>();
        }
    
        public int Right_Code { get; set; }
        public string Right_Name { get; set; }
    
        public virtual ICollection<System_Module_Right> System_Module_Right { get; set; }
    }
}
