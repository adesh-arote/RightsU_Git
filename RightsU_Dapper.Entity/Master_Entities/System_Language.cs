
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

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

        public virtual ICollection<System_Language_Message> System_Language_Message { get; set; }
        public virtual ICollection<User> Users { get; set; }
    }
}


