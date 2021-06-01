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

    [Table("Workflow_Role")]
    public partial class Workflow_Role
    {
        public Workflow_Role()
        {
            this.Workflow_Module_Role = new HashSet<Workflow_Module_Role>();
        }
        [PrimaryKey]
        public int? Workflow_Role_Code { get; set; }
        public Nullable<short> Group_Level { get; set; }
        public Nullable<int> Workflow_Code { get; set; }
        public Nullable<int> Group_Code { get; set; }
        public Nullable<int> Primary_User_Code { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public string _Dummy_Guid { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public string Dummy_Guid
        {
            get
            {
                if (string.IsNullOrEmpty(_Dummy_Guid))
                    _Dummy_Guid = GetDummy_Guid();
                return _Dummy_Guid;
            }
        }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        private string GetDummy_Guid()
        {
            return Guid.NewGuid().ToString();
        }
        public Nullable<short> Reminder_Days { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Security_Group Security_Group { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Workflow Workflow { get; set; }
        [OneToMany]
        public virtual ICollection<Workflow_Module_Role> Workflow_Module_Role { get; set; }
    }
}
