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
    using RightsU_Entities;

    [Table("Workflow")]
    public partial class Workflow
    {
        public Workflow()
        {
            this.Acq_Deal = new HashSet<Acq_Deal>();
            this.Syn_Deal = new HashSet<Syn_Deal>();
            this.Workflow_Module = new HashSet<Workflow_Module>();
            this.Workflow_Role = new HashSet<Workflow_Role>();
            this.Workflow_BU = new HashSet<Workflow_BU>();
        }
        [PrimaryKey]
        public int? Workflow_Code { get; set; }
        public string Workflow_Name { get; set; }
        public string Remarks { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public string Workflow_Type { get; set; }
        public Nullable<int> Business_Unit_Code { get; set; }

        [OneToMany]
        public virtual ICollection<Acq_Deal> Acq_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal> Syn_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Workflow_Module> Workflow_Module { get; set; }
        [OneToMany]
        public virtual ICollection<Workflow_Role> Workflow_Role { get; set; }
        [OneToMany]
        public virtual ICollection<Workflow_BU> Workflow_BU { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Business_Unit Business_Unit { get; set; }
    }
}
