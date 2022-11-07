using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    public partial class USP_Get_Dashboard_Detail_Payment_Term_Result
    {
        public Nullable<int> Deal_Code { get; set; }
        public string Agreement_No { get; set; }
        public string Payment_Terms { get; set; }
        public Nullable<int> Days_After { get; set; }
        public string Cost_Percentage { get; set; }
        public System.DateTime Due_Date { get; set; }
    }
}
