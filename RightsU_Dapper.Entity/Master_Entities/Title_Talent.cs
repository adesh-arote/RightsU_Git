
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Title_Talent")]
    public partial class Title_Talent
    {
        [PrimaryKey]
        public int? Title_Talent_Code { get; set; }
        [ForeignKeyReference(typeof(Title))]
        public Nullable<int> Title_Code { get; set; }
        public Nullable<int> Talent_Code { get; set; }
        public Nullable<int> Role_Code { get; set; }
        //public State EntityState { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Role Role { get; set; }
        public virtual Talent Talent { get; set; }
        public virtual Title Title { get; set; }
    }
}


