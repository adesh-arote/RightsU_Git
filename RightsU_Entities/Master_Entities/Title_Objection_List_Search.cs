using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    public class Title_Objection_List_Search
    {
        public string Common_Search { get; set; }
        public string DealNo_Search { get; set; }
        public string TitleCodes_Search { get; set; }
        public string VendorCodes_Search { get; set; }
        public string Status_Search { get; set; }
        public string TitleObjectionStatus_Search { get; set; }
        public string isAdvanced { get; set; }
        public string TitleObjectionType_Search { get; set; }
        public int BUCodes_Search { get; set; }
        public int PageNo { get; set; }
    }
}
