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
    
    public partial class AL_Purchase_Order
    {
        public AL_Purchase_Order()
        {
            this.AL_Purchase_Order_Rel = new HashSet<AL_Purchase_Order_Rel>();
        }
    
    	public State EntityState { get; set; }    public int AL_Purchase_Order_Code { get; set; }
    	    public Nullable<int> AL_Booking_Sheet_Code { get; set; }
    	    public Nullable<int> AL_Proposal_Code { get; set; }
    	    public string Remarks { get; set; }
    	    public string Status { get; set; }
    	    public Nullable<int> Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Inserted_On { get; set; }
    	    public Nullable<int> Updated_By { get; set; }
    	    public Nullable<System.DateTime> Updated_On { get; set; }
    	    public Nullable<System.DateTime> Lock_Time { get; set; }
    	    public string Workflow_Status { get; set; }
    	    public Nullable<int> Workflow_Code { get; set; }
    
        public virtual AL_Booking_Sheet AL_Booking_Sheet { get; set; }
        public virtual ICollection<AL_Purchase_Order_Rel> AL_Purchase_Order_Rel { get; set; }
    }
}
