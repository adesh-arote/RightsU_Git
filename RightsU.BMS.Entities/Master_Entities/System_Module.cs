using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Table("System_Module")]
    public class System_Module
    {
        [PrimaryKey]
        public int Module_Code { get; set; }
        public string Module_Name { get; set; }
        public string Module_Position { get; set; }
        public int Parent_Module_Code { get; set; }
        public string Is_Sub_Module { get; set; }
        public string Url { get; set; }
        public string Target { get; set; }
        public string Css { get; set; }
        public string Can_Workflow_Assign { get; set; }
        public string Is_Active { get; set; }
    }
}
