using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    public class USP_GetSystem_Language_Message_ByModule_Result
    {
        public int System_Language_Message_Code { get; set; }
        public string Message_Key { get; set; }
        public string Message_Desc { get; set; }
        public int System_Message_Code { get; set; }
        public int System_Module_Message_Code { get; set; }
        public string Form_Id { get; set; }
        public string Default_Message_Desc { get; set; }
    }
}
