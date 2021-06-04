
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Music_Album_Talent")]
    public partial class Music_Album_Talent
    {
        [PrimaryKey]
        public int? Music_Album_Talent_Code { get; set; }
        [ForeignKeyReference(typeof(Music_Album))]
        public int? Music_Album_Code { get; set; }
        [ForeignKeyReference(typeof(Talent))]
        public Nullable<int> Talent_Code { get; set; }
        [ForeignKeyReference(typeof(Role))]
        public Nullable<int> Role_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Music_Album Music_Album { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Role Role { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Talent Talent { get; set; }
    }
}


