using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public partial class USP_List_Syn_Ancillary_Result
    {
        public int Syn_Deal_Ancillary_Code { get; set; }
        public string TitleName { get; set; }
        public int Ancillary_Type_Code { get; set; }
        public string Ancillary_Type_Name { get; set; }
        public int Duration { get; set; }
        public int ADay { get; set; }
        public string Remarks { get; set; }
        public string Platform_Name { get; set; }
        public string Ancillary_Medium_Name { get; set; }
        public Nullable<int> PageNo { get; set; }
        public Nullable<int> PageCount { get; set; }
        public Nullable<int> RecordCount { get; set; }
        public Nullable<int> txtPageSize { get; set; }
    }
}
