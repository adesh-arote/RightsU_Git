using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class Acq_Deal_Run_LP
    {
        public State EntityState { get; set; }
        public int Acq_Deal_Run_MultiYear_Code { get; set; }
        public Nullable<int> Acq_Deal_Run_Code { get; set; }
        public Nullable<System.DateTime> Year_Start { get; set; }
        public Nullable<System.DateTime> Year_End { get; set; }

        public virtual Acq_Deal_Run Acq_Deal_Run { get; set; }
    }
}
