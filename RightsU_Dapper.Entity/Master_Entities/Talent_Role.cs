
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Talent_Role")]
    public partial class Talent_Role
    {
        //public State EntityState { get; set; }
        [PrimaryKey]
        public int? Talent_Role_Code { get; set; }
        [ForeignKeyReference(typeof(Talent))]
        public Nullable<int> Talent_Code { get; set; }
        [ForeignKeyReference(typeof(Role))]
        public Nullable<int> Role_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Role Role { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Talent Talent { get; set; }
    }
}


