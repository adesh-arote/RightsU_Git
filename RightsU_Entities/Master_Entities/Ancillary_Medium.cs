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
    
    public partial class Ancillary_Medium
    {
        public Ancillary_Medium()
        {
            this.Ancillary_Platform_Medium = new HashSet<Ancillary_Platform_Medium>();
        }
    
        public int Ancillary_Medium_Code { get; set; }
        public string Ancillary_Medium_Name { get; set; }
    
        public virtual ICollection<Ancillary_Platform_Medium> Ancillary_Platform_Medium { get; set; }
    }
}
