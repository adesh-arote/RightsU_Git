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
    using RightsU_Entities;

    [Table("Users_Exclusion_Rights")]
    public partial class Users_Exclusion_Rights
    {
        [PrimaryKey]
        public int? Users_Exclusion_Rights_Code { get; set; }
        [ForeignKeyReference(typeof(User))]
        public Nullable<int> Users_Code { get; set; }
        public Nullable<int> Module_Right_Code { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual System_Module_Right System_Module_Right { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual User User { get; set; }
    }
}
