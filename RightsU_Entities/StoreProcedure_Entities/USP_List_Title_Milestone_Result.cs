using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    public partial class USP_List_Title_Milestone_Result
    {
        public int Title_Milestone_Code { get; set; }
        public string Title_Name { get; set; }
        public string Talent_Name { get; set; }
        public string Milestone_Nature_Name { get; set; }
        public Nullable<System.DateTime> Expiry_Date { get; set; }
        public string Milestone { get; set; }
        public string Action_Item { get; set; }
        public string Is_Abandoned { get; set; }
        public string Remarks { get; set; }
    }
}
