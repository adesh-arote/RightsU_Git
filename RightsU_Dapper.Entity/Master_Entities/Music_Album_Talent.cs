
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Talent")]
    public partial class Music_Album_Talent
    {
        //public State EntityState { get; set; }
        [PrimaryKey]
        public int? Music_Album_Talent_Code { get; set; }
        //[ForeignKeyReference(typeof(Music_Album))]
        public Nullable<int> Music_Album_Code { get; set; }
        public Nullable<int> Talent_Code { get; set; }
        public Nullable<int> Role_Code { get; set; }

        //public virtual Music_Album Music_Album { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Role Role { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Talent Talent { get; set; }
    }
}


