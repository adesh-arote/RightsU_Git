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
    
    public partial class Acq_Deal_Rights_Blackout_Territory
    {
        public State EntityState { get; set; }
        public int Acq_Deal_Rights_Blackout_Territory_Code { get; set; }
        public Nullable<int> Acq_Deal_Rights_Blackout_Code { get; set; }
        public string Territory_Type { get; set; }
        public Nullable<int> Country_Code { get; set; }
        public Nullable<int> Territory_Code { get; set; }
    
        public virtual Acq_Deal_Rights_Blackout Acq_Deal_Rights_Blackout { get; set; }
        public virtual Country Country { get; set; }
        public virtual Territory Territory { get; set; }
    }
}
