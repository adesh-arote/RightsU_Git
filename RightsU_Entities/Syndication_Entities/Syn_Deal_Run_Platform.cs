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

    public partial class Syn_Deal_Run_Platform
    {
        public State EntityState { get; set; }
        public int Syn_Deal_Run_Platform_Code { get; set; }
        public Nullable<int> Syn_Deal_Run_Code { get; set; }
        public Nullable<int> Platform_Code { get; set; }

        public virtual Platform Platform { get; set; }
        public virtual Syn_Deal_Run Syn_Deal_Run { get; set; }
    }
}
