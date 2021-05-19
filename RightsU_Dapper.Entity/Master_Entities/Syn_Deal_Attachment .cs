
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Syn_Deal_Attachment")]
    public partial class Syn_Deal_Attachment
    {
        [PrimaryKey]
        public int? Syn_Deal_Attachment_Code { get; set; }
        [ForeignKeyReference(typeof(Syn_Deal))]
        public Nullable<int> Syn_Deal_Code { get; set; }
        public string Attachment_Title { get; set; }
        public string Attachment_File_Name { get; set; }
        public string System_File_Name { get; set; }
        public Nullable<int> Document_Type_Code { get; set; }
        public Nullable<int> Episode_From { get; set; }
        public Nullable<int> Episode_To { get; set; }

        public virtual Document_Type Document_Type { get; set; }
        public virtual Syn_Deal Syn_Deal { get; set; }
        public virtual Title Title { get; set; }
        public Nullable<int> Title_Code { get; set; }
    }
}


