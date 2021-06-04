using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
    using RightsU_Entities;
    using System;
    using System.Collections.Generic;

    [Table("Security_Group")]
    public partial class Security_Group
    {
        public Security_Group()
        {
            this.Module_Workflow_Detail = new HashSet<Module_Workflow_Detail>();
            this.Module_Workflow_Detail1 = new HashSet<Module_Workflow_Detail>();
            this.Security_Group_Rel = new HashSet<Security_Group_Rel>();
            this.Users = new HashSet<User>();
            this.Workflow_Role = new HashSet<Workflow_Role>();
            this.Workflow_BU_Role = new HashSet<Workflow_BU_Role>();
            this.Workflow_Module_BU_Role = new HashSet<Workflow_Module_BU_Role>();
        }

        [PrimaryKey]
        public int? Security_Group_Code { get; set; }
        public string Security_Group_Name { get; set; }
        public System.DateTime Inserted_On { get; set; }
        public int Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }

        [OneToMany]
        public virtual ICollection<Module_Workflow_Detail> Module_Workflow_Detail { get; set; }
        [OneToMany]
        public virtual ICollection<Module_Workflow_Detail> Module_Workflow_Detail1 { get; set; }
        [OneToMany]
        public virtual ICollection<Security_Group_Rel> Security_Group_Rel { get; set; }
        [OneToMany]
        public virtual ICollection<User> Users { get; set; }
        [OneToMany]
        public virtual ICollection<Workflow_Role> Workflow_Role { get; set; }
        [OneToMany]
        public virtual ICollection<Workflow_BU_Role> Workflow_BU_Role { get; set; }
        [OneToMany]
        public virtual ICollection<Workflow_Module_BU_Role> Workflow_Module_BU_Role { get; set; }
    }
}
