using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;

    [Table("")]
    public partial class USP_Get_Title_PreReq_Result
    {
        public int Display_Value { get; set; }
        public string Display_Text { get; set; }
        public string Data_For { get; set; }
    }
}
