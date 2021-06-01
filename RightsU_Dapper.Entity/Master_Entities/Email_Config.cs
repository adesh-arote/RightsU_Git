
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Email_Config")]
    public partial class Email_Config
    {
        public Email_Config()
        {
            this.Email_Config_Detail = new HashSet<Email_Config_Detail>();
        }
        [PrimaryKey]
        public int? Email_Config_Code { get; set; }
        public string Email_Type { get; set; }
        public string OnScreen_Notification { get; set; }
        public string Allow_Config { get; set; }
        public string IsChannel { get; set; }
        public string IsBusinessUnit { get; set; }
        public string Notification_Frequency { get; set; }
        public string Days_Config { get; set; }
        public string Days_Freq { get; set; }
        public string Remarks { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public string User_Count { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public int Count { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public int TotalCount { get; set; }
        [OneToMany]
        public virtual ICollection<Email_Config_Detail> Email_Config_Detail { get; set; }
        //public virtual ICollection<Email_Notification_Log> Email_Notification_Log { get; set; }
    }
}