using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public partial class USPMHNotificationList
    {
        public int MHNotificationLogCode { get; set; }
        public string Subject { get; set; }
        public string UserName { get; set; }
        //public Nullable<System.DateTime> CreatedTime { get; set; }
        public string CreatedTime { get; set; }
        public string IsRead { get; set; }
    }
}
