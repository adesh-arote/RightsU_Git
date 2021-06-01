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
    [Table("Users_Business_Unit")]
    public partial class Users_Business_Unit
    {
        [PrimaryKey]
        public int? Users_Business_Unit_Code { get; set; }
        [ForeignKeyReference(typeof(User))]
        public Nullable<int> Users_Code { get; set; }
        [ForeignKeyReference(typeof(Business_Unit))]
        public Nullable<int> Business_Unit_Code { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Business_Unit Business_Unit { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual User User { get; set; }
    }
}
