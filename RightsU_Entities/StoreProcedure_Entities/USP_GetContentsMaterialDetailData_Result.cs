using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{

    public partial class USP_GetContentsMaterialDetailData_Result
    {
        public Nullable<int> Title_Content_Matreial_Code { get; set; }
        public int Material_Medium_Code { get; set; }
        public string Material_Medium_Name { get; set; }
        public Nullable<System.DateTime> Delivery_Date { get; set; }
        public Nullable<System.DateTime> TC_QC_Date { get; set; }
        public Nullable<System.DateTime> SNP_Date { get; set; }
    }
}
