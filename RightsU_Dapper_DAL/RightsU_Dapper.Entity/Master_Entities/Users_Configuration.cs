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
    [Table("Users_Configuration")]
    public partial class Users_Configuration
    {
        [PrimaryKey]
        public int? User_Configuration_Code { get; set; }
        public string Dashboard_Key { get; set; }
        public Nullable<int> Dashboard_Value { get; set; }
        [ForeignKeyReference(typeof(User))]
        public Nullable<int> Users_Code { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual User User { get; set; }
    }
}
