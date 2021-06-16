using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper.SimpleLoad;
using Dapper.SimpleSave;
namespace RightsU_Dapper.Entity
{
    [Table("Deal_Workflow_Status")]
    public partial class Deal_Workflow_Status
    {
        [PrimaryKey]
        public int? Deal_Workflow_Status_Code { get; set; }
        public string Deal_Workflow_Status_Name { get; set; }
        public string Deal_WorkflowFlag { get; set; }
        public string Deal_Type { get; set; }
    }
}
