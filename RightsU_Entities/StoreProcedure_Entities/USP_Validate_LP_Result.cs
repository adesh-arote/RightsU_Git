using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;

    public partial class USP_Validate_LP_Result
    {
        public int RowID { get; set; }
        public int Acq_Deal_Rights_Code { get; set; }
        public System.DateTime RightsStartDate { get; set; }
        public System.DateTime RightsEndDate { get; set; }
        public int DtDiff { get; set; }
        public string DtType { get; set; }
    }
}
