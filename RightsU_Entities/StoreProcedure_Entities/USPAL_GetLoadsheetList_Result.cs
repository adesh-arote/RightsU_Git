using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    public partial class USPAL_GetLoadsheetList_Result
    {
        public int AL_Load_Sheet_Code { get; set; }
        public string Load_sheet_No { get; set; }
        public System.DateTime Load_Sheet_Month { get; set; }
        public int NoOfBookingSheet { get; set; }
        public string Status { get; set; }
        public string InsertedBy { get; set; }
        public System.DateTime Inserted_On { get; set; }
    }
}
