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


    [Table("System_Language_Message")]
    public partial class System_Language_Message
    {
        [PrimaryKey]
        public int? System_Language_Message_Code { get; set; }
        [ForeignKeyReference(typeof(System_Language))]
        public Nullable<int> System_Language_Code { get; set; }
        [ForeignKeyReference(typeof(System_Module_Message))]
        public Nullable<int> System_Module_Message_Code { get; set; }
        public string Message_Desc { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual System_Language System_Language { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual System_Module_Message System_Module_Message { get; set; }
    }
}
