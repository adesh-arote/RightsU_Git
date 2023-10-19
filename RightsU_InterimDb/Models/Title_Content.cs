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
    
    public partial class Title_Content
    {
        public Title_Content()
        {
            this.Content_Music_Link = new HashSet<Content_Music_Link>();
            this.Content_Status_History = new HashSet<Content_Status_History>();
            this.Title_Content_Version = new HashSet<Title_Content_Version>();
            this.Title_Content_Mapping = new HashSet<Title_Content_Mapping>();
            this.MHCueSheetSongs = new HashSet<MHCueSheetSong>();
            this.Title_Episode_Details_TC = new HashSet<Title_Episode_Details_TC>();
            this.AL_Booking_Sheet_Details = new HashSet<AL_Booking_Sheet_Details>();
            this.AL_Recommendation_Content = new HashSet<AL_Recommendation_Content>();
            this.AL_Material_Tracking = new HashSet<AL_Material_Tracking>();
            this.AL_Purchase_Order_Details = new HashSet<AL_Purchase_Order_Details>();
        }
    
    	public State EntityState { get; set; }    public int Title_Content_Code { get; set; }
    	    public Nullable<int> Title_Code { get; set; }
    	    public Nullable<int> Episode_No { get; set; }
    	    public Nullable<decimal> Duration { get; set; }
    	    public string Ref_BMS_Content_Code { get; set; }
    	    public string Episode_Title { get; set; }
    	    public string Content_Status { get; set; }
    	    public Nullable<int> Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Inserted_On { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    	    public string Synopsis { get; set; }
    
        public virtual ICollection<Content_Music_Link> Content_Music_Link { get; set; }
        public virtual ICollection<Content_Status_History> Content_Status_History { get; set; }
        public virtual Title Title { get; set; }
        public virtual ICollection<Title_Content_Version> Title_Content_Version { get; set; }
        public virtual ICollection<Title_Content_Mapping> Title_Content_Mapping { get; set; }
        public virtual ICollection<MHCueSheetSong> MHCueSheetSongs { get; set; }
        public virtual ICollection<Title_Episode_Details_TC> Title_Episode_Details_TC { get; set; }
        public virtual ICollection<AL_Booking_Sheet_Details> AL_Booking_Sheet_Details { get; set; }
        public virtual ICollection<AL_Recommendation_Content> AL_Recommendation_Content { get; set; }
        public virtual ICollection<AL_Material_Tracking> AL_Material_Tracking { get; set; }
        public virtual ICollection<AL_Purchase_Order_Details> AL_Purchase_Order_Details { get; set; }
    }
}
