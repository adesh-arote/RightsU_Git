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
    
    public partial class Acq_Deal_Rights_Promoter_Group
    {
    	public State EntityState { get; set; }    public int Acq_Deal_Rights_Promoter_Group_Code { get; set; }
    	    public Nullable<int> Acq_Deal_Rights_Promoter_Code { get; set; }
    	    public Nullable<int> Promoter_Group_Code { get; set; }
    
        public virtual Acq_Deal_Rights_Promoter Acq_Deal_Rights_Promoter { get; set; }
        public virtual Promoter_Group Promoter_Group { get; set; }
    }
}
