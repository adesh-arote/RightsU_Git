using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.StoredProcedure_Entities
{
    using System;

    public partial class USPRUBVMappingList_Result
    {
        public string Title { get; set; }
        public Nullable<int> EpisodeNo { get; set; }
        public Nullable<int> RUID { get; set; }
        public Nullable<int> BVID { get; set; }
        public string ErrorDescription { get; set; }
        public string RecordStatus { get; set; }
        public string LicenseRefNo { get; set; }
        public Nullable<System.DateTime> StartDate { get; set; }
        public Nullable<System.DateTime> EndDate { get; set; }
        public Nullable<int> ChannelCode { get; set; }
        public string VendorName { get; set; }
        public Nullable<System.DateTime> RequestTime { get; set; }
    }
}
