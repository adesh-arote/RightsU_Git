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

    [Table("Workflow_BU_Role")]
    public partial class Workflow_BU_Role
    {
        public Workflow_BU_Role()
        {
            this.Workflow_Module_BU_Role = new HashSet<Workflow_Module_BU_Role>();
        }
        [PrimaryKey]
        public int? Workflow_BU_Role_Code { get; set; }
        public Nullable<short> Group_Level { get; set; }
        public Nullable<int> Workflow_BU_Code { get; set; }
        public Nullable<int> Security_Group_Code { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Security_Group Security_Group { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Workflow_BU Workflow_BU { get; set; }
        [OneToMany]
        public virtual ICollection<Workflow_Module_BU_Role> Workflow_Module_BU_Role { get; set; }
    }
}
