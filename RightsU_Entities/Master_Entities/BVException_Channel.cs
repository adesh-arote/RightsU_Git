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
    
    public partial class BVException_Channel
    {
        public int Bv_Exception_Channel_Code { get; set; }
        public State EntityState { get; set; }
        public int Bv_Exception_Code { get; set; }
        public int Channel_Code { get; set; }
    
        public virtual BVException BVException { get; set; }
        public virtual Channel Channel { get; set; }
    }
}
