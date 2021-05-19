
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("System_Language_Message")]
    public partial class System_Language_Message
    {
        public int System_Language_Message_Code { get; set; }
        public Nullable<int> System_Language_Code { get; set; }
        public Nullable<int> System_Module_Message_Code { get; set; }
        public string Message_Desc { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }

        //public virtual System_Language System_Language { get; set; }
        //public virtual System_Module_Message System_Module_Message { get; set; }
    }
}


