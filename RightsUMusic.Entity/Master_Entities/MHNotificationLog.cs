using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    [Table("MHNotificationLog")]
    public class MHNotificationLog
    {
        [PrimaryKey]
        public int? MHNotificationLogCode { get; set; }
        public Nullable<int> Email_Config_Code { get; set; }
        public Nullable<System.DateTime> Created_Time { get; set; }
        public string Is_Read { get; set; }
        public string Email_Body { get; set; }
        public Nullable<int> User_Code { get; set; }
        public int Vendor_Code { get; set; }
        public string Subject { get; set; }
        public string Email_Id { get; set; }
    }
}
