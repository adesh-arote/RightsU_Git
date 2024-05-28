using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO_Notification.Entities
{

    public class USPGetMessages
    {
        public virtual ICollection<USPGetMessageStatus> lstGetMessages { get; set; }
        public int TotalRecords { get; set; }

        public USPGetMessages()
        {
            lstGetMessages = new HashSet<USPGetMessageStatus>();
            TotalRecords = 0;
        }
    }
}
