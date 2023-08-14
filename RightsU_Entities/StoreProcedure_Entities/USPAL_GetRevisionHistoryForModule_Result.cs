using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public partial class USPAL_GetRevisionHistoryForModule_Result
    {
        public int Module_Status_Code { get; set; }
        public Nullable<System.DateTime> Last_Action_On { get; set; }
        public string Last_Action_By { get; set; }
        public string Remark { get; set; }
        public string Workflow_Status { get; set; }
    }
}
