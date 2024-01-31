using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.LogClasses
{
    public class MasterAuditLog
    {
        public int moduleCode { get; set; }
        public int intCode { get; set; }
        public string logData { get; set; }
        public string actionBy { get; set; }
        public int actionOn { get; set; }
        public string actionType { get; set; }
        public string requestId { get; set; }
    }
}
