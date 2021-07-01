using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    public partial class USP_Get_Platform_Tree_Hierarchy_Result
    {
        public int Platform_Code { get; set; }
        public string Platform_Name { get; set; }
        public int Parent_Platform_Code { get; set; }
        public string Is_Last_Level { get; set; }
        public string Module_Position { get; set; }
        public int ChildCount { get; set; }
    }
}
