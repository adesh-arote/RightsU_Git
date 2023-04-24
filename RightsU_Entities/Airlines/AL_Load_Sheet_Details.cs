using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class AL_Load_Sheet_Details
    {
        public State EntityState { get; set; }
        public int AL_Load_Sheet_Details_Code { get; set; }
        public Nullable<int> AL_Load_Sheet_Code { get; set; }
        public Nullable<int> AL_Booking_Sheet_Code { get; set; }

        public virtual AL_Booking_Sheet AL_Booking_Sheet { get; set; }
        public virtual AL_Load_Sheet AL_Load_Sheet { get; set; }
    }
}
