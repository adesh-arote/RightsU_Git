using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    public partial class USP_Get_Dashboard_Detail_Material_Type_Result
    {
        public Nullable<int> Deal_Code { get; set; }
        public string Agreement_No { get; set; }
        public string Material_Type_Name { get; set; }
        public string Material_Medium_Name { get; set; }
        public Nullable<int> Quantity { get; set; }
    }
}
