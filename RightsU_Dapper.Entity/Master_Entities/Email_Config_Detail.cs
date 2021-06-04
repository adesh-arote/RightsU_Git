
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Email_Config_Detail")]
    public partial class Email_Config_Detail
    {
        public Email_Config_Detail()
        {
            this.Email_Config_Detail_Alert = new HashSet<Email_Config_Detail_Alert>();
            this.Email_Config_Detail_User = new HashSet<Email_Config_Detail_User>();
        }
        [PrimaryKey]
        public int? Email_Config_Detail_Code { get; set; }
        [ForeignKeyReference(typeof(Email_Config))]
        public Nullable<int> Email_Config_Code { get; set; }
        public string OnScreen_Notification { get; set; }
        public string Notification_Frequency { get; set; }
        public Nullable<int> Notification_Days { get; set; }
        public Nullable<System.TimeSpan> Notification_Time { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Email_Config Email_Config { get; set; }
        [OneToMany]
        public virtual ICollection<Email_Config_Detail_Alert> Email_Config_Detail_Alert { get; set; }
        [OneToMany]
        public virtual ICollection<Email_Config_Detail_User> Email_Config_Detail_User { get; set; }
    }
}


