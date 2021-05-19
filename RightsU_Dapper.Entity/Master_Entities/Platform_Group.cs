
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Platform_Group")]
    public partial class Platform_Group
    {
        public Platform_Group()
        {
            this.Platform_Group_Details = new HashSet<Platform_Group_Details>();
        }
        [PrimaryKey]
        public int? Platform_Group_Code { get; set; }
        public string Platform_Group_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public string Group_For { get; set; }
        [OneToMany]
        public virtual ICollection<Platform_Group_Details> Platform_Group_Details { get; set; }
    }
}


