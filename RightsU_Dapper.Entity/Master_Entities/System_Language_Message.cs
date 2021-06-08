
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

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
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual System_Language System_Language { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual System_Module_Message System_Module_Message { get; set; }
    }
}


