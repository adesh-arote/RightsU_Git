using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class AP_Vendor_Details
    {
        public State EntityState { get; set; }
        public int AP_Vendor_Detail_Code { get; set; }
        public Nullable<int> Vendor_Code { get; set; }
        public string OEM_Codes { get; set; }
        public string Banner_Codes { get; set; }
        public string Pref_Exclusion_Codes { get; set; }

        public virtual Vendor Vendor { get; set; }
    }
}
