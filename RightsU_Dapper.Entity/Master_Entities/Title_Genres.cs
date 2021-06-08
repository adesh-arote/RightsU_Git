
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Title_Geners")]
    public partial class Title_Geners
    {
        [PrimaryKey]
        public int? Title_Geners_Code { get; set; }
        [ForeignKeyReference(typeof(Title))]
        public Nullable<int> Title_Code { get; set; }
        [ForeignKeyReference(typeof(Genre))]
        public Nullable<int> Genres_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Genre Genre { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Title Title { get; set; }
    }
}


