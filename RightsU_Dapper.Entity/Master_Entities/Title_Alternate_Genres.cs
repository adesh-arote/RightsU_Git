
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Title_Alternate_Genres")]
    public partial class Title_Alternate_Genres
    {
        public int Title_Alternate_Genres_Code { get; set; }
        public Nullable<int> Title_Alternate_Code { get; set; }
        public Nullable<int> Genres_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Genre Genre { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Title_Alternate Title_Alternate { get; set; }
    }
}


