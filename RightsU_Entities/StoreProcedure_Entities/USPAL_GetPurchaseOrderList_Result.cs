using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;

    public partial class USPAL_GetPurchaseOrderList_Result
    {
        public string Vendor_Name { get; set; }
        public string Proposal_CY { get; set; }
        public string Booking_Sheet_No { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public string Status { get; set; }
        public int AL_Purchase_Order_Code { get; set; }
        public Nullable<int> AL_Booking_Sheet_Code { get; set; }
        public Nullable<int> AL_Proposal_Code { get; set; }
        public string Remarks { get; set; }
        public string Workflow_Status { get; set; }
        public string ShowHideButtons { get; set; }
        public int Vendor_Code { get; set; }
        public string CreatedBy { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public string Final_PO_Workflow_Status { get; set; }
    }
}
