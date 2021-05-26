
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Title")]
    public partial class USP_GET_TITLE_DATA_Result
    {
        public string Title_Name { get; set; }
        public Nullable<int> Episode_Starts_From { get; set; }
        public Nullable<int> Episode_End_To { get; set; }
        public Nullable<int> Title_Code { get; set; }
    }
}


