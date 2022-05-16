using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UTO_Notification.Entities
{
    public class USPGetMasters
    {
        public long Code { get; set; }
        public string Name { get; set; }

        public string Type { get; set; }
    }
}
