using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
    public class USP_List_Territory_Result
    {
        public int Territory_Code { get; set; }
        public string Territory_Name { get; set; }
        public string Theatrical { get; set; }
        public string Country_Names { get; set; }
        public string Disable_Message { get; set; }
        public string Status { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
    }
}
