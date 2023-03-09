using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class AP_Vendor_TnC
    {
        public State EntityState { get; set; }
        public int AP_Vendor_TnC_Code { get; set; }
        public Nullable<int> Vendor_Code { get; set; }
        public string TnC_Description { get; set; }

        public virtual Vendor Vendor { get; set; }
    }
}
