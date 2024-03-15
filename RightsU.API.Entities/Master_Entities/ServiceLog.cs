using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("ServiceLog")]
    public partial class ServiceLog
    {
        [PrimaryKey]
        public int? ServiceLogID { get; set; }
        public int LogType { get; set; }
        public int UserCode { get; set; }
        public string UserName { get; set; }
        public string MethodName { get; set; }
        public string Request { get; set; }
        public string Response { get; set; }
        public Nullable<System.DateTime> RequestTime { get; set; }
        public Nullable<System.DateTime> ResponseTime { get; set; }
    }
}
