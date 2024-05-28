using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public class Acq_Sport_Ancillary_Wrapper
    {
        public int Acq_Deal_Sport_Ancillary_Code { get; set; }
        public string Title { get; set; }
        public Nullable<int> Sport_Ancillary_Type_Code { get; set; }
        public string TitleCode { get; set; }
        public string  Type { get; set; }
        public string Obligation_Broadcast { get; set; }
        public string Obligation { get; set; }
        public string Duration { get; set; }
        public string Source { get; set; }
        public string Remarks { get; set; }
        public string Time_Slot { get; set; }
        public string Broadcast { get; set; }

        // Properties for Acq Sport Ancillary Sales

        public int Acq_Deal_Sport_Sales_Ancillary_Code { get; set; }
        public string Type_Of_Sponsor { get; set; }
        public string Sponsor { get; set; }
        public string FRO_To_Given { get; set; }
        public string Price_Protection { get; set; }
        public string Last_Matching_Right { get; set; }

        //

        // Properties for Acq Sport Ancillary Monetisation

        public int Acq_Deal_Sport_Monetisation_Ancillary_Code { get; set; }
        public string Broadcast_Sponsor { get; set; }
        public string Title_Broadcast_Sponsor { get; set; }
        public string Monetisations_Type { get; set; }

        //
    }
}
