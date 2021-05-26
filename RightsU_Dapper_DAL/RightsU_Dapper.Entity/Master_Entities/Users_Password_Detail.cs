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
    [Table("Users_Password_Detail")]
    public partial class Users_Password_Detail
    {
        [PrimaryKey]
        public int? Users_Password_Detail_Code { get; set; }
        [ForeignKeyReference(typeof(User))]
        public Nullable<int> Users_Code { get; set; }
        public string Users_Passwords { get; set; }
        public Nullable<System.DateTime> Password_Change_Date { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual User User { get; set; }
    }
}
