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
    
    public partial class Channel_Territory
    {
        public int Channel_Territory_Code { get; set; }
        public Nullable<int> Channel_Code { get; set; }
        public Nullable<int> Country_Code { get; set; }
    
        public virtual Channel Channel { get; set; }
        public virtual Country Country { get; set; }

        public State EntityState { get; set; }
    }
}
