using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
    //using RightsU_Entities;
    using System;
    using System.Collections.Generic;
    using System_Setting_Entities;

    [Table("System_Module_Message")]
    public partial class System_Module_Message
    {
        public System_Module_Message()
        {
            this.System_Language_Message = new HashSet<System_Language_Message>();
        }

        [PrimaryKey]
        public int? System_Module_Message_Code { get; set; }
        [ForeignKeyReference(typeof(System_Setting_Entities.System_Module))]
        public Nullable<int> Module_Code { get; set; }
        public string Form_ID { get; set; }
        public Nullable<int> System_Message_Code { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }

        [OneToMany]
        public virtual ICollection<System_Language_Message> System_Language_Message { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual System_Message System_Message { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual System_Module System_Module { get; set; }
    }
}
