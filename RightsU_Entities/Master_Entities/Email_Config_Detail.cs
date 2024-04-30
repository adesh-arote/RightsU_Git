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
    using Newtonsoft.Json;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class Email_Config_Detail
    {
        public Email_Config_Detail()
        {
            this.Email_Config_Detail_Alert = new HashSet<Email_Config_Detail_Alert>();
            this.Email_Config_Detail_User = new HashSet<Email_Config_Detail_User>();
        }
        [JsonIgnore]
    	public State EntityState { get; set; }
        [JsonProperty(Order = -1)]
        public int Email_Config_Detail_Code { get; set; }
        [JsonProperty(Order = 1)]
        public Nullable<int> Email_Config_Code { get; set; }
        [NotMapped]
        [JsonProperty(Order = 2)]
        public string Email_Type { get; set; }
        [JsonProperty(Order = 3)]
        public string OnScreen_Notification { get; set; }
        [JsonProperty(Order = 4)]
        public string Notification_Frequency { get; set; }
        [JsonProperty(Order = 5)]
        public Nullable<int> Notification_Days { get; set; }
        [JsonProperty(Order = 6)]
        public Nullable<System.TimeSpan> Notification_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [JsonIgnore]
        [NotMapped]
        public string Inserted_By_User { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Updated_By { get; set; }     
        [NotMapped]
        [JsonProperty(Order = 7)]
        public string Last_Updated_By_User { get; set; }
        [JsonProperty(Order = 8)]
        public Nullable<System.DateTime> Last_Updated_On { get; set; }
        [JsonIgnore]
        public Nullable<int> Event_Platform_Code { get; set; }
        [JsonIgnore]
        public string Event_Template_Type { get; set; }
        [JsonIgnore]
        public virtual Email_Config Email_Config { get; set; }
        [JsonIgnore]
        public virtual ICollection<Email_Config_Detail_Alert> Email_Config_Detail_Alert { get; set; }
        [JsonIgnore]
        public virtual ICollection<Email_Config_Detail_User> Email_Config_Detail_User { get; set; }
    }
}
