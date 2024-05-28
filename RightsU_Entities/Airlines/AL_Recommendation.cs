using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;
    public partial class AL_Recommendation
    {
        public AL_Recommendation()
        {
            this.AL_Booking_Sheet = new HashSet<AL_Booking_Sheet>();
            this.AL_Recommendation_Content = new HashSet<AL_Recommendation_Content>();
        }

        public State EntityState { get; set; }
        public int AL_Recommendation_Code { get; set; }
        public Nullable<int> AL_Proposal_Code { get; set; }
        public Nullable<System.DateTime> Start_Date { get; set; }
        public Nullable<System.DateTime> End_Date { get; set; }
        public Nullable<int> Refresh_Cycle_No { get; set; }
        public string Version_No { get; set; }
        public string Finally_Closed { get; set; }
        public string Remarks { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public string Workflow_Status { get; set; }
        public Nullable<int> Workflow_Code { get; set; }
        public string Excel_File { get; set; }
        public string PDF_File { get; set; }

        public virtual ICollection<AL_Booking_Sheet> AL_Booking_Sheet { get; set; }
        public virtual ICollection<AL_Recommendation_Content> AL_Recommendation_Content { get; set; }
    }
}
