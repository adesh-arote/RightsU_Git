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
    
    public partial class Users_Entity
    {
        public int Users_Entity_Code { get; set; }
        public Nullable<int> Users_Code { get; set; }
        public Nullable<int> Entity_Code { get; set; }
        public string Is_Default { get; set; }
    
        public virtual User User { get; set; }
    }
}
