
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Users_Business_Unit")]
    public partial class Users_Business_Unit
    {
        [PrimaryKey]
        public int? Users_Business_Unit_Code { get; set; }
        [ForeignKeyReference(typeof(User))]
        public Nullable<int> Users_Code { get; set; }
        [ForeignKeyReference(typeof(Business_Unit))]
        public Nullable<int> Business_Unit_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Business_Unit Business_Unit { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual User User { get; set; }
    }
}