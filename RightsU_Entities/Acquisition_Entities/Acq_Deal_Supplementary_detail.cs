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
    
    public partial class Acq_Deal_Supplementary_detail
    {
    	public State EntityState { get; set; }    public int Acq_Deal_Supplementary_Detail_Code { get; set; }
    	    public Nullable<int> Acq_Deal_Supplementary_Code { get; set; }
    	    public Nullable<int> Supplementary_Tab_Code { get; set; }
    	    public Nullable<int> Supplementary_Config_Code { get; set; }
    	    public string Supplementary_Data_Code { get; set; }
    	    public string User_Value { get; set; }
    	    public Nullable<int> Row_Num { get; set; }
    
        public virtual Acq_Deal_Supplementary Acq_Deal_Supplementary { get; set; }
    }
}
