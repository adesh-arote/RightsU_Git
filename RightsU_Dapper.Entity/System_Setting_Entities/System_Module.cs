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
    using Master_Entities;
    using RightsU_Entities;

    [Table("System_Module")]
    public partial class System_Module
    {
        public System_Module()
        {
            this.Module_Status_History = new HashSet<Module_Status_History>();
            this.Module_Workflow_Detail = new HashSet<Module_Workflow_Detail>();
            this.System_Module_Right = new HashSet<System_Module_Right>();
            this.Workflow_Module = new HashSet<Workflow_Module>();
            this.System_Module_Message = new HashSet<System_Module_Message>();
            this.MHRequestStatus = new HashSet<MHRequestStatu>();
        }

        [PrimaryKey]
        public int? Module_Code { get; set; }
        public string Module_Name { get; set; }
        public string Module_Position { get; set; }
        public Nullable<int> Parent_Module_Code { get; set; }
        public string Is_Sub_Module { get; set; }
        public string Url { get; set; }
        public string Target { get; set; }
        public string Css { get; set; }
        public string Can_Workflow_Assign { get; set; }
        public string Is_Active { get; set; }

        [OneToMany]
        public virtual ICollection<Module_Status_History> Module_Status_History { get; set; }
        [OneToMany]
        public virtual ICollection<Module_Workflow_Detail> Module_Workflow_Detail { get; set; }
        [OneToMany]
        public virtual ICollection<System_Module_Right> System_Module_Right { get; set; }
        [OneToMany]
        public virtual ICollection<Workflow_Module> Workflow_Module { get; set; }
        [OneToMany]
        public virtual ICollection<System_Module_Message> System_Module_Message { get; set; }
        [OneToMany]
        public virtual ICollection<MHRequestStatu> MHRequestStatus { get; set; }
    }
}
