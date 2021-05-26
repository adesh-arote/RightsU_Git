
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Upload_Files")]
    public partial class USP_Uploaded_File_List_Result
    {
        [PrimaryKey]
        public long? File_Code { get; set; }
        public string File_Name { get; set; }
        public Nullable<System.DateTime> Upload_Date { get; set; }
        public string Is_Error { get; set; }
        public string Upload_Type { get; set; }
        public string Is_Review_Pending { get; set; }
        public int Total_Record_Uploaded { get; set; }
        public int Total_Records_Inserted { get; set; }
        public int Total_Records_Updated { get; set; }
        public int Bank_Code { get; set; }
        public int Total_Errors { get; set; }
        public Nullable<int> Channel_Code { get; set; }
        public Nullable<System.DateTime> Start_Date { get; set; }
        public Nullable<System.DateTime> End_Date { get; set; }
        public long Upload_Detail_Code { get; set; }
    }
}


