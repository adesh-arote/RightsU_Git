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
    using System_Setting_Entities;

    [Table("Workflow_Module_Role")]
    public partial class Workflow_Module_Role
    {
        public int? Workflow_Module_Role_Code { get; set; }
        [ForeignKeyReference(typeof(Workflow_Module))]
        public Nullable<int> Workflow_Module_Code { get; set; }
        public Nullable<int> Workflow_Role_Code { get; set; }
        public Nullable<short> Group_Level { get; set; }
        public Nullable<int> Group_Code { get; set; }
        public Nullable<short> Reminder_Days { get; set; }

        public virtual Workflow_Module Workflow_Module { get; set; }
        public virtual Workflow_Role Workflow_Role { get; set; }
    }
}
