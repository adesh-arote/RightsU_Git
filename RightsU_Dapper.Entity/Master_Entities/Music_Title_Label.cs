
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Music_Title_Label")]
    public partial class Music_Title_Label
    {
        [PrimaryKey]
        public int? Music_Title_Label_Code { get; set; }
        [ForeignKeyReference(typeof(Music_Title))]
        public Nullable<int> Music_Title_Code { get; set; }
        [ForeignKeyReference(typeof(Music_Label))]
        public Nullable<int> Music_Label_Code { get; set; }
        public Nullable<System.DateTime> Effective_From { get; set; }
        public Nullable<System.DateTime> Effective_To { get; set; }

        public virtual Music_Label Music_Label { get; set; }
        public virtual Music_Title Music_Title { get; set; }
    }
}