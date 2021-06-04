
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Music_Title_Talent")]
    public partial class Music_Title_Talent
    {
        //public State EntityState { get; set; }
        [PrimaryKey]
        public int? Music_Title_Talent_Code { get; set; }
        //[ForeignKeyReference(typeof(Music_Title))]
        public Nullable<int> Music_Title_Code { get; set; }
        public Nullable<int> Talent_Code { get; set; }
        public Nullable<int> Role_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        //public virtual Music_Title Music_Title { get; set; }
        public virtual Role Role { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Talents Talent { get; set; }
    }
}


