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
    
    public partial class Syn_Deal
    {
        public Syn_Deal()
        {
            this.Syn_Deal_Ancillary = new HashSet<Syn_Deal_Ancillary>();
            this.Syn_Deal_Movie = new HashSet<Syn_Deal_Movie>();
            this.Syn_Deal_Payment_Terms = new HashSet<Syn_Deal_Payment_Terms>();
            this.Syn_Deal_Rights = new HashSet<Syn_Deal_Rights>();
            this.Syn_Deal_Revenue = new HashSet<Syn_Deal_Revenue>();
            this.Syn_Deal_Attachment = new HashSet<Syn_Deal_Attachment>();
            this.Syn_Deal_Material = new HashSet<Syn_Deal_Material>();
            this.Syn_Deal_Run = new HashSet<Syn_Deal_Run>();
            this.Syn_Deal_Supplementary = new HashSet<Syn_Deal_Supplementary>();
        }
    
    	public State EntityState { get; set; }    public int Syn_Deal_Code { get; set; }
    	    public Nullable<int> Deal_Type_Code { get; set; }
    	    public string Other_Deal { get; set; }
    	    public string Agreement_No { get; set; }
    	    public string Version { get; set; }
    	    public Nullable<System.DateTime> Agreement_Date { get; set; }
    	    public string Deal_Description { get; set; }
    	    public string Status { get; set; }
    	    public Nullable<double> Total_Sale { get; set; }
    	    public string Year_Type { get; set; }
    	    public Nullable<int> Customer_Type { get; set; }
    	    public Nullable<int> Vendor_Code { get; set; }
    	    public Nullable<int> Vendor_Contact_Code { get; set; }
    	    public Nullable<int> Sales_Agent_Code { get; set; }
    	    public Nullable<int> Sales_Agent_Contact_Code { get; set; }
    	    public Nullable<int> Entity_Code { get; set; }
    	    public Nullable<int> Currency_Code { get; set; }
    	    public Nullable<decimal> Exchange_Rate { get; set; }
    	    public string Ref_No { get; set; }
    	    public string Attach_Workflow { get; set; }
    	    public string Deal_Workflow_Status { get; set; }
    	    public Nullable<int> Work_Flow_Code { get; set; }
    	    public string Is_Completed { get; set; }
    	    public Nullable<int> Category_Code { get; set; }
    	    public string Is_Migrated { get; set; }
    	    public string Payment_Terms_Conditions { get; set; }
    	    public Nullable<int> Deal_Tag_Code { get; set; }
    	    public string Is_Active { get; set; }
    	    public string Ref_BMS_Code { get; set; }
    	    public Nullable<System.DateTime> Inserted_On { get; set; }
    	    public Nullable<int> Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Lock_Time { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    	    public Nullable<int> Last_Action_By { get; set; }
    	    public string Remarks { get; set; }
    	    public Nullable<int> Parent_Syn_Deal_Code { get; set; }
    	    public string Rights_Remarks { get; set; }
    	    public string Payment_Remarks { get; set; }
    	    public Nullable<int> Business_Unit_Code { get; set; }
    	    public string Deal_Complete_Flag { get; set; }
    	    public Nullable<int> Deal_Segment_Code { get; set; }
    	    public Nullable<int> Revenue_Vertical_Code { get; set; }
    	    public string Material_Remarks { get; set; }
    
        public virtual Category Category { get; set; }
        public virtual Currency Currency { get; set; }
        public virtual Deal_Type Deal_Type { get; set; }
        public virtual Entity Entity { get; set; }
        public virtual ICollection<Syn_Deal_Ancillary> Syn_Deal_Ancillary { get; set; }
        public virtual ICollection<Syn_Deal_Movie> Syn_Deal_Movie { get; set; }
        public virtual ICollection<Syn_Deal_Payment_Terms> Syn_Deal_Payment_Terms { get; set; }
        public virtual ICollection<Syn_Deal_Rights> Syn_Deal_Rights { get; set; }
        public virtual Vendor Vendor { get; set; }
        public virtual Vendor_Contacts Vendor_Contacts { get; set; }
        public virtual Workflow Workflow { get; set; }
        public virtual Deal_Tag Deal_Tag { get; set; }
        public virtual ICollection<Syn_Deal_Revenue> Syn_Deal_Revenue { get; set; }
        public virtual ICollection<Syn_Deal_Attachment> Syn_Deal_Attachment { get; set; }
        public virtual ICollection<Syn_Deal_Material> Syn_Deal_Material { get; set; }
        public virtual Business_Unit Business_Unit { get; set; }
        public virtual ICollection<Syn_Deal_Run> Syn_Deal_Run { get; set; }
        public virtual Deal_Segment Deal_Segment { get; set; }
        public virtual Revenue_Vertical Revenue_Vertical { get; set; }
        public virtual ICollection<Syn_Deal_Supplementary> Syn_Deal_Supplementary { get; set; }
    }
}
