
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Title_Content_Mapping")]
    public partial class Title_Content_Mapping
    {
        [PrimaryKey]
        public int? Title_Content_Mapping_Code { get; set; }
        //[ForeignKeyReference(typeof(Title_Content))]
        public Nullable<int> Title_Content_Code { get; set; }
        public string Deal_For { get; set; }
        public Nullable<int> Acq_Deal_Movie_Code { get; set; }
        public Nullable<int> Provisional_Deal_Title_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Acq_Deal_Movie Acq_Deal_Movie { get; set; }
        //public virtual Provisional_Deal_Title Provisional_Deal_Title { get; set; }
        public virtual Title_Content Title_Content { get; set; }
    }
}


