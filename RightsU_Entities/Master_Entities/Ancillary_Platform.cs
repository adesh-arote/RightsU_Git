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
    
    public partial class Ancillary_Platform
    {
        public Ancillary_Platform()
        {
            this.Acq_Deal_Ancillary_Platform = new HashSet<Acq_Deal_Ancillary_Platform>();
            this.Ancillary_Platform_Medium = new HashSet<Ancillary_Platform_Medium>();
            this.Syn_Deal_Ancillary_Platform = new HashSet<Syn_Deal_Ancillary_Platform>();
        }
    
        public int Ancillary_Platform_code { get; set; }
        public Nullable<int> Ancillary_Type_code { get; set; }
        public string Platform_Name { get; set; }
    
        public virtual ICollection<Acq_Deal_Ancillary_Platform> Acq_Deal_Ancillary_Platform { get; set; }
        public virtual Ancillary_Type Ancillary_Type { get; set; }
        public virtual ICollection<Ancillary_Platform_Medium> Ancillary_Platform_Medium { get; set; }
        public virtual ICollection<Syn_Deal_Ancillary_Platform> Syn_Deal_Ancillary_Platform { get; set; }
    }
}
