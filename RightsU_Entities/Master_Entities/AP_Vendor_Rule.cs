using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class AP_Vendor_Rule
    {
        public AP_Vendor_Rule()
        {
            this.AP_Vendor_Rule_Criteria = new HashSet<AP_Vendor_Rule_Criteria>();
        }

        public State EntityState { get; set; }
        public int AP_Vendor_Rule_Code { get; set; }
        public Nullable<int> Vendor_Code { get; set; }
        public string Rule_Name { get; set; }
        public string Rule_Short_Name { get; set; }
        public string Criteria { get; set; }

        public virtual ICollection<AP_Vendor_Rule_Criteria> AP_Vendor_Rule_Criteria { get; set; }
        public virtual Vendor Vendor { get; set; }
    }
}
