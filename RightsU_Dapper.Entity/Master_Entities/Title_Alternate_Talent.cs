
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Title_Alternate_Talent")]
    public partial class Title_Alternate_Talent
    {
        //public State EntityState { get; set; }
        [PrimaryKey]
        public int? Title_Alternate_Talent_Code { get; set; }
        [ForeignKeyReference(typeof(Title_Alternate))]
        public Nullable<int> Title_Alternate_Code { get; set; }
        public Nullable<int> Talent_Code { get; set; }
        public Nullable<int> Role_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Role Role { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Talents Talent { get; set; }
        public virtual Title_Alternate Title_Alternate { get; set; }
    }
}


