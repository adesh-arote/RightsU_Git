using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class AL_Material_Tracking_OEM
    {
        public State EntityState { get; set; }
        public int AL_Material_Tracking_OEM_Code { get; set; }
        public Nullable<int> AL_Material_Tracking_Code { get; set; }
        public Nullable<int> AL_OEM_Code { get; set; }
        public string Data_For { get; set; }
        public string Column_Value { get; set; }
        public Nullable<System.DateTime> Delivery_Date { get; set; }
        public Nullable<int> Updated_By { get; set; }
        public Nullable<System.DateTime> Updated_On { get; set; }

        public virtual AL_Material_Tracking AL_Material_Tracking { get; set; }
        public virtual AL_OEM AL_OEM { get; set; }
    }
}
