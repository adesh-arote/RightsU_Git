using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class AL_Purchase_Order_Details
    {
        public AL_Purchase_Order_Details()
        {
            this.AL_Purchase_Order_Rel = new HashSet<AL_Purchase_Order_Rel>();
        }
        public State EntityState { get; set; }
        public int AL_Purchase_Order_Details_Code { get; set; }
        public Nullable<int> AL_Proposal_Code { get; set; }
        public string PO_Number { get; set; }
        public Nullable<System.DateTime> LP_Start { get; set; }
        public Nullable<System.DateTime> LP_End { get; set; }
        public Nullable<int> Title_Code { get; set; }
        public Nullable<int> Title_Content_Code { get; set; }
        public Nullable<int> Vendor_Code { get; set; }
        public string Status { get; set; }
        public string Excel_File_Name { get; set; }
        public string PDF_File_Name { get; set; }
        public Nullable<System.DateTime> Generated_On { get; set; }

        public virtual Title Title { get; set; }
        public virtual Title_Content Title_Content { get; set; }
        public virtual Vendor Vendor { get; set; }
        public virtual ICollection<AL_Purchase_Order_Rel> AL_Purchase_Order_Rel { get; set; }
    }
}
