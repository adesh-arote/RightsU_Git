using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
    using System_Setting_Entities;

    [Table("Workflow_Module_BU")]
    public partial class Workflow_Module_BU
    {
        public Workflow_Module_BU()
        {
            this.Workflow_Module_BU_Role = new HashSet<Workflow_Module_BU_Role>();
        }

        [PrimaryKey]
        public int? Workflow_Module_BU_Code { get; set; }
        public Nullable<int> Workflow_Module_Code { get; set; }
        public Nullable<int> Workflow_BU_Code { get; set; }
        public Nullable<int> Business_Unit_Code { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Business_Unit Business_Unit { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Workflow_BU Workflow_BU { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Workflow_Module Workflow_Module { get; set; }
        [OneToMany]
        public virtual ICollection<Workflow_Module_BU_Role> Workflow_Module_BU_Role { get; set; }
    }
}
