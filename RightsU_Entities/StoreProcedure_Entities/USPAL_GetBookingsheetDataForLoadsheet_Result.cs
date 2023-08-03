using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    public partial class USPAL_GetBookingsheetDataForLoadsheet_Result
    {
        public int AL_Booking_Sheet_Code { get; set; }
        public string Vendor_Name { get; set; }
        public string Booking_Sheet_No { get; set; }
        public string Proposal_Cycle { get; set; }
        public string Cycle { get; set; }
        public int AL_Load_Sheet_Code { get; set; }

    }
}
