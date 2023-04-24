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
    
    public partial class AL_Booking_Sheet
    {
        public AL_Booking_Sheet()
        {
            this.AL_Booking_Sheet_Details = new HashSet<AL_Booking_Sheet_Details>();
            this.AL_Load_Sheet_Details = new HashSet<AL_Load_Sheet_Details>();
            this.AL_Purchase_Order = new HashSet<AL_Purchase_Order>();
        }
    
    	public State EntityState { get; set; }    public int AL_Booking_Sheet_Code { get; set; }
    	    public Nullable<int> AL_Recommendation_Code { get; set; }
    	    public Nullable<int> Vendor_Code { get; set; }
    	    public string Booking_Sheet_No { get; set; }
    	    public Nullable<int> Version_No { get; set; }
    	    public Nullable<int> Movie_Content_Count { get; set; }
    	    public Nullable<int> Show_Content_Count { get; set; }
    	    public string Remarks { get; set; }
    	    public string Record_Status { get; set; }
    	    public Nullable<int> Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Inserted_On { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    	    public Nullable<System.DateTime> Lock_Time { get; set; }
    	    public string Excel_File { get; set; }
    
        public virtual ICollection<AL_Booking_Sheet_Details> AL_Booking_Sheet_Details { get; set; }
        public virtual Vendor Vendor { get; set; }
        public virtual AL_Recommendation AL_Recommendation { get; set; }
        public virtual ICollection<AL_Load_Sheet_Details> AL_Load_Sheet_Details { get; set; }
        public virtual ICollection<AL_Purchase_Order> AL_Purchase_Order { get; set; }
    }
}
