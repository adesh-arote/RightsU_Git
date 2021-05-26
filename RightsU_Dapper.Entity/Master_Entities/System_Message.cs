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

    [Table("System_Message")]
    public partial class System_Message
    {
        public System_Message()
        {
            this.System_Module_Message = new HashSet<System_Module_Message>();
        }
        [PrimaryKey]
        public int? System_Message_Code { get; set; }
        public string Message_Key { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }

        [OneToMany]
        public virtual ICollection<System_Module_Message> System_Module_Message { get; set; }
    }
}
