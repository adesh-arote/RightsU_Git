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
    
    public partial class AT_Acq_Deal_Digital_detail
    {
    	public State EntityState { get; set; }    public int AT_Acq_Deal_Digital_Detail_Code { get; set; }
    	    public Nullable<int> Digital_Tab_Code { get; set; }
    	    public Nullable<int> Digital_Config_Code { get; set; }
    	    public string Digital_Data_Code { get; set; }
    	    public string User_Value { get; set; }
    	    public Nullable<int> Row_Num { get; set; }
    	    public Nullable<int> Acq_Deal_Digital_Detail_Code { get; set; }
    
        public virtual AT_Acq_Deal_Digital AT_Acq_Deal_Digital { get; set; }
    }
}