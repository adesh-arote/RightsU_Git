using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class AP_Vendor_Rule_Criteria
    {
        public State EntityState { get; set; }
        public int AP_Vendor_Rule_Criteria_Code { get; set; }
        public Nullable<int> AP_Vendor_Rule_Code { get; set; }
        public Nullable<int> Columns_Code { get; set; }
        public string Columns_Value { get; set; }

        public virtual AP_Vendor_Rule AP_Vendor_Rule { get; set; }
        public virtual Extended_Columns Extended_Columns { get; set; }
    }
}
