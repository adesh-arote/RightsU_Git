
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Title_Audio_Details_Singers")]
    public partial class Title_Audio_Details_Singers
    {
        [PrimaryKey]
        public int? Title_Audio_Details_Singers_Code { get; set; }
        [ForeignKeyReference(typeof(Title))]
        public Nullable<int> Title_Code { get; set; }
        public Nullable<int> Title_Audio_Details_Code { get; set; }
        public Nullable<int> Talent_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Talent Talent { get; set; }
        public virtual Title Title { get; set; }
    }
}


