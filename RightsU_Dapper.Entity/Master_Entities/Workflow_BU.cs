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

    [Table("Workflow_BU")]
    public partial class Workflow_BU
    {
        public Workflow_BU()
        {
            this.Workflow_BU_Role = new HashSet<Workflow_BU_Role>();
            this.Workflow_Module_BU = new HashSet<Workflow_Module_BU>();
        }
        [PrimaryKey]
        public int? Workflow_BU_Code { get; set; }
        public Nullable<int> Workflow_Code { get; set; }
        public Nullable<int> Business_Unit_Code { get; set; }

        public virtual Business_Unit Business_Unit { get; set; }
        public virtual Workflow Workflow { get; set; }
        public virtual ICollection<Workflow_BU_Role> Workflow_BU_Role { get; set; }
        public virtual ICollection<Workflow_Module_BU> Workflow_Module_BU { get; set; }
    }
}
