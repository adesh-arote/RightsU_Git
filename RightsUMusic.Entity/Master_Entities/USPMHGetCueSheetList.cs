using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public partial class USPMHGetCueSheetList
    {
        public int MHCueSheetCode { get; set; }
        public string RequestID { get; set; }
        public string FileName { get; set; }
        public string RequestedBy { get; set; }
        public Nullable<System.DateTime> RequestedDate { get; set; }
        public string Status { get; set; }
        public int TotalRecords { get; set; }
        public int ErrorRecords { get; set; }
        public string RecordStatus { get; set; }
        public string WarningRecords { get; set; }
        public string SuccessRecords { get; set; }

    }
}
