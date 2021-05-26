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
    [Table("Users_Channel")]
    public partial class Users_Channel
    {
        [PrimaryKey]
        public int? Users_Channel_Code { get; set; }
        [ForeignKeyReference(typeof(User))]
        public Nullable<int> Users_Code { get; set; }
        [ForeignKeyReference(typeof(Channel))]
        public Nullable<int> Channel_Code { get; set; }
        public string S_Default { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual User User { get; set; }
    }
}
