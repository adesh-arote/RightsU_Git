using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.StoredProcedure_Entities
{
    public partial class USP_List_Amort_Rule_Result
    {
        public int Amort_Rule_Code { get; set; }
        public string Rule_Type { get; set; }
        public string Rule_No { get; set; }
        public string Rule_Desc { get; set; }
        public string Year_Type { get; set; }
        public string Period_For { get; set; }
        public string Is_Active { get; set; }
        public string Show_Hide_Buttons { get; set; }
    }
}
