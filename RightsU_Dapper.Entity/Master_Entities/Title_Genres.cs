
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Title_Geners")]
    public partial class Title_Geners
    {
        [PrimaryKey]
        public int? Title_Geners_Code { get; set; }
        [ForeignKeyReference(typeof(Title))]
        public Nullable<int> Title_Code { get; set; }
        [ForeignKeyReference(typeof(Genres))]
        public Nullable<int> Genres_Code { get; set; }
        public virtual Genres Genre { get; set; }
        public virtual Title Title { get; set; }
    }
}


