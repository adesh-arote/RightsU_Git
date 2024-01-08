using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public class USPAPI_GetModuleRights
    {
        public Int32 Module_Code { get; set; }
        public string Module_Name { get; set; }
        public string Url { get; set; }
        public Int32 Right_Code { get; set; }
        public string Right_Name { get; set; }
    }
}
