using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class AL_Purchase_Order
    {
        public AL_Purchase_Order()
        {
            this.AL_Purchase_Order_Rel = new HashSet<AL_Purchase_Order_Rel>();
        }

        public State EntityState { get; set; }
        public int AL_Purchase_Order_Code { get; set; }
        public Nullable<int> AL_Booking_Sheet_Code { get; set; }
        public Nullable<int> AL_Proposal_Code { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Updated_By { get; set; }
        public Nullable<System.DateTime> Updated_On { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }

        public virtual AL_Booking_Sheet AL_Booking_Sheet { get; set; }
        public virtual ICollection<AL_Purchase_Order_Details> AL_Purchase_Order_Details { get; set; }
        public virtual ICollection<AL_Purchase_Order_Rel> AL_Purchase_Order_Rel { get; set; }
    }
}
