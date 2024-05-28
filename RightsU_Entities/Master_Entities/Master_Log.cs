using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public partial class Master_Log
    {
        public State EntityState { get; set; }
        public int Log_Code { get; set; }
        public Nullable<int> Module_Code { get; set; }
        public Nullable<int> IntCode { get; set; }
        public string Log_Data { get; set; }
        public Nullable<int> Action_By { get; set; }
        public Nullable<System.DateTime> Action_On { get; set; }
        public string Action_Type { get; set; }
    }
}
