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
    
    public partial class Email_Config_Detail
    {
        public Email_Config_Detail()
        {
            this.Email_Config_Detail_Alert = new HashSet<Email_Config_Detail_Alert>();
            this.Email_Config_Detail_User = new HashSet<Email_Config_Detail_User>();
        }
    
    	public State EntityState { get; set; }    public int Email_Config_Detail_Code { get; set; }
    	    public Nullable<int> Email_Config_Code { get; set; }
    	    public string OnScreen_Notification { get; set; }
    	    public string Notification_Frequency { get; set; }
    	    public Nullable<int> Notification_Days { get; set; }
    	    public Nullable<System.TimeSpan> Notification_Time { get; set; }
    	    public Nullable<int> Inserted_By { get; set; }
    	    public Nullable<System.DateTime> Inserted_On { get; set; }
    	    public Nullable<int> Last_Updated_By { get; set; }
    	    public Nullable<System.DateTime> Last_Updated_On { get; set; }
    	    public Nullable<int> Event_Platform_Code { get; set; }
    	    public string Event_Template_Type { get; set; }
    
        public virtual Email_Config Email_Config { get; set; }
        public virtual ICollection<Email_Config_Detail_Alert> Email_Config_Detail_Alert { get; set; }
        public virtual ICollection<Email_Config_Detail_User> Email_Config_Detail_User { get; set; }
    }
}
