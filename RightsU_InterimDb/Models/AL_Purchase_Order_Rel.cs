//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_InterimDb.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class AL_Purchase_Order_Rel
    {
    	public State EntityState { get; set; }    public int AL_Purchase_Order_Rel_Code { get; set; }
    	    public Nullable<int> AL_Purchase_Order_Code { get; set; }
    	    public Nullable<int> AL_Purchase_Order_Details_Code { get; set; }
    	    public string Status { get; set; }
    
        public virtual AL_Purchase_Order AL_Purchase_Order { get; set; }
        public virtual AL_Purchase_Order_Details AL_Purchase_Order_Details { get; set; }
    }
}