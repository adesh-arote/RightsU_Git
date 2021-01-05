using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("Email_Notification_Log")]
    public partial class Email_Notification_Log
    {
        [PrimaryKey]
        public int Email_Config_Detail_Code { get; set; }
        public Nullable<int> Email_Config_Code { get; set; }
        public string OnScreen_Notification { get; set; }
        public string Notification_Frequency { get; set; }
        public Nullable<int> Notification_Days { get; set; }
        public Nullable<System.TimeSpan> Notification_Time { get; set; }

    }
}
