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
    
    public partial class Acq_Deal_Run_Repeat_On_Day
    {
        public State EntityState { get; set; }
        public int Acq_Deal_Run_Repeat_On_Day_Code { get; set; }
        public Nullable<int> Acq_Deal_Run_Code { get; set; }
        public Nullable<int> Day_Code { get; set; }
    
        public virtual Acq_Deal_Run Acq_Deal_Run { get; set; }
    }
}
