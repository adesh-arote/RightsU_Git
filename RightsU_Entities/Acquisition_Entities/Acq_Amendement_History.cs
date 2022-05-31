using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class Acq_Amendement_History
    {
        public State EntityState { get; set; }
        public int Acq_Amendement_History_Code { get; set; }
        public Nullable<int> Record_Code { get; set; }
        public Nullable<int> Module_Code { get; set; }
        public Nullable<int> Version { get; set; }
        public Nullable<System.DateTime> Amendment_Date { get; set; }
        public string Amended_By { get; set; }
        public string Remarks { get; set; }
    }
}
