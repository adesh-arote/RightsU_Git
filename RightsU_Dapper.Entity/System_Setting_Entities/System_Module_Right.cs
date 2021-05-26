using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.System_Setting_Entities
{
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
    using RightsU_Entities;
    using System;
    using System.Collections.Generic;

    [Table("System_Module_Right")]
    public partial class System_Module_Right
    {
        public System_Module_Right()
        {
            this.Security_Group_Rel = new HashSet<Security_Group_Rel>();
            this.Users_Exclusion_Rights = new HashSet<Users_Exclusion_Rights>();
        }
        [PrimaryKey]
        public int? Module_Right_Code { get; set; }
        public int Module_Code { get; set; }
        public int Right_Code { get; set; }

        [OneToMany]
        public virtual ICollection<Security_Group_Rel> Security_Group_Rel { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual System_Module System_Module { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual System_Right System_Right { get; set; }
        [OneToMany]
        public virtual ICollection<Users_Exclusion_Rights> Users_Exclusion_Rights { get; set; }
    }
}
