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

    [Table("Security_Group_Rel")]
    public partial class Security_Group_Rel
    {
        [PrimaryKey]
        public int? Security_Rel_Code { get; set; }
        [ForeignKeyReference(typeof(Security_Group))]
        public Nullable<int> Security_Group_Code { get; set; }
        public Nullable<int> System_Module_Rights_Code { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Security_Group Security_Group { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual System_Module_Right System_Module_Right { get; set; }
    }
}
