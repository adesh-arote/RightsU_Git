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

    [Table("Users_Entity")]
    public partial class Users_Entity
    {
        [PrimaryKey]
        public int? Users_Entity_Code { get; set; }
        [ForeignKeyReference(typeof(User))]
        public Nullable<int> Users_Code { get; set; }
        [ForeignKeyReference(typeof(Entity))]
        public Nullable<int> Entity_Code { get; set; }
        public string Is_Default { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual User User { get; set; }
    }
}
