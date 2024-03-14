using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("LoggedInUsers")]
    public class LoggedInUsers
    {
        [PrimaryKey]
        public int? LoggedInUsersCode { get; set; }
        public string LoginName { get; set; }
        public string HostIP { get; set; }
        public string BrowserDetails { get; set; }
        public string AccessToken { get; set; }
        public string RefreshToken { get; set; }
        public string LoggedInUrl { get; set; }
        public Nullable<System.DateTime> LoggedinTime { get; set; }
        public Nullable<System.DateTime> LastUpdatedTime { get; set; }
    }
}
