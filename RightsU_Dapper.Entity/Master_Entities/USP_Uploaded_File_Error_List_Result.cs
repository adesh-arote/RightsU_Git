
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Upload_Err_Detail")]
    public partial class USP_Uploaded_File_Error_List_Result
    {
        [PrimaryKey]
        public long? upload_detail_code { get; set; }
        public Nullable<int> Row_Num { get; set; }
        public string error_description { get; set; }
    }
}


