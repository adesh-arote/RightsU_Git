using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class AP_OEM
    {
        public State EntityState { get; set; }
        public int AP_OEM_Code { get; set; }
        public string Device_Name { get; set; }
        public string Company { get; set; }
        public string Aspect_Ratio { get; set; }
        public string MPEG { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
    }
}
