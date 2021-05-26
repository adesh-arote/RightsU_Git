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

    [Table("Workflow_Module")]
    public partial class Workflow_Module
    {
        public Workflow_Module()
        {
            this.Workflow_Module_Role = new HashSet<Workflow_Module_Role>();
            this.Workflow_Module_BU = new HashSet<Workflow_Module_BU>();
        }
        [PrimaryKey]
        public int? Workflow_Module_Code { get; set; }
        public Nullable<int> Workflow_Code { get; set; }
        [ForeignKeyReference(typeof(System_Module))]
        public Nullable<int> Module_Code { get; set; }
        public Nullable<short> Ideal_Process_Days { get; set; }
        public Nullable<System.DateTime> Effective_Start_Date { get; set; }
        public Nullable<System.DateTime> System_End_Date { get; set; }
        public string Is_Active { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Business_Unit_Code { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual System_Module System_Module { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Workflow Workflow { get; set; }
        [OneToMany]
        public virtual ICollection<Workflow_Module_Role> Workflow_Module_Role { get; set; }
        [OneToMany]
        public virtual ICollection<Workflow_Module_BU> Workflow_Module_BU { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Business_Unit Business_Unit { get; set; }
    }
}
