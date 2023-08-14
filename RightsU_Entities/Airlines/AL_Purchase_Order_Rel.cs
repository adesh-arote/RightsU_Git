using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    public partial class AL_Purchase_Order_Rel
    {
        public State EntityState { get; set; }
        public int AL_Purchase_Order_Rel_Code { get; set; }
        public Nullable<int> AL_Purchase_Order_Code { get; set; }
        public Nullable<int> AL_Purchase_Order_Details_Code { get; set; }
        public string Status { get; set; }

        public virtual AL_Purchase_Order AL_Purchase_Order { get; set; }
        public virtual AL_Purchase_Order_Details AL_Purchase_Order_Details { get; set; }
    }
}
