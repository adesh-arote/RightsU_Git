using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsUMusic.Entity
{
    public class ConsumptionRequestListInput
    {
        public string RecordFor { get; set; }
        public string PagingRequired { get; set; }
        public int PageSize { get; set; }
        public int PageNo { get; set; }
        public string RequestID { get; set; }
        public string ChannelCode { get; set; }
        public string ShowCode { get; set; }
        public string StatusCode { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        public string ExportFor { get; set; }
        public string SortBy { get; set; }
        public string Order { get; set; }
    }
}
