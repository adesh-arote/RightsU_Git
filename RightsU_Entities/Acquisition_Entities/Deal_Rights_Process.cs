using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class Deal_Rights_Process
    {
        public State EntityState { get; set; }
        public int Deal_Rights_Process_Code { get; set; }
        public Nullable<int> Deal_Code { get; set; }
        public Nullable<int> Module_Code { get; set; }
        public Nullable<int> Deal_Rights_Code { get; set; }
        public string Record_Status { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Process_Start { get; set; }
        public Nullable<System.DateTime> Porcess_End { get; set; }
        public Nullable<int> User_Code { get; set; }
        public string Error_Messages { get; set; }
        public string Button_Visibility { get; set; }
        public Nullable<int> Rights_Bulk_Update_Code { get; set; }
        public Nullable<int> Title_Code { get; set; }
    }
}
