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
    //using RightsU_Entities;
   

    [Table("System_Language")]
    public partial class System_Language
    {
        public System_Language()
        {
            this.System_Language_Message = new HashSet<System_Language_Message>();
            this.Users = new HashSet<User>();
        }
        [PrimaryKey]
        public int? System_Language_Code { get; set; }
        public string Language_Name { get; set; }
        public string Layout_Direction { get; set; }
        public string Is_Default { get; set; }
        public string Is_Active { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }

        [OneToMany]
        public virtual ICollection<System_Language_Message> System_Language_Message { get; set; }
        [OneToMany]
        public virtual ICollection<User> Users { get; set; }
    }
}
