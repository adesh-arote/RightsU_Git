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
    
    public partial class Email_Config
    {
        public Email_Config()
        {
            this.Email_Config_Detail = new HashSet<Email_Config_Detail>();
            this.Email_Notification_Log = new HashSet<Email_Notification_Log>();
        }
    
    	public State EntityState { get; set; }    public int Email_Config_Code { get; set; }
    	    public string Email_Type { get; set; }
    	    public string OnScreen_Notification { get; set; }
    	    public string Allow_Config { get; set; }
    	    public string IsChannel { get; set; }
    	    public string IsBusinessUnit { get; set; }
    	    public string Notification_Frequency { get; set; }
    	    public string Days_Config { get; set; }
    	    public string Days_Freq { get; set; }
    	    public string Remarks { get; set; }
    
        public virtual ICollection<Email_Config_Detail> Email_Config_Detail { get; set; }
        public virtual ICollection<Email_Notification_Log> Email_Notification_Log { get; set; }
    }
}
