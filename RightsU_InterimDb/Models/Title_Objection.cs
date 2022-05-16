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
    
    public partial class Title_Objection
    {
        public Title_Objection()
        {
            this.Title_Objection_Platform = new HashSet<Title_Objection_Platform>();
            this.Title_Objection_Rights_Period = new HashSet<Title_Objection_Rights_Period>();
            this.Title_Objection_Territory = new HashSet<Title_Objection_Territory>();
        }
    
    	public State EntityState { get; set; }    public int Title_Objection_Code { get; set; }
    	    public Nullable<int> Title_Objection_Status_Code { get; set; }
    	    public Nullable<int> Title_Objection_Type_Code { get; set; }
    	    public Nullable<int> Title_Code { get; set; }
    	    public Nullable<int> Record_Code { get; set; }
    	    public string Record_Type { get; set; }
    	    public Nullable<System.DateTime> Objection_Start_Date { get; set; }
    	    public Nullable<System.DateTime> Objection_End_Date { get; set; }
    	    public string Objection_Remarks { get; set; }
    	    public string Resolution_Remarks { get; set; }
    	    public Nullable<System.DateTime> Inserted_On { get; set; }
    	    public Nullable<int> Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    
        public virtual Title Title { get; set; }
        public virtual ICollection<Title_Objection_Platform> Title_Objection_Platform { get; set; }
        public virtual ICollection<Title_Objection_Rights_Period> Title_Objection_Rights_Period { get; set; }
        public virtual ICollection<Title_Objection_Territory> Title_Objection_Territory { get; set; }
        public virtual Title_Objection_Status Title_Objection_Status { get; set; }
        public virtual Title_Objection_Type Title_Objection_Type { get; set; }
    }
}
