using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_BMS_ScheduleProcess.Entities
{
    [Table("Upload_Files")]
    public class Upload_Files
    {
        [PrimaryKey]
        public int? File_Code { get; set; }
        public string File_Name { get; set; }
        public string Err_YN { get; set; }
        public Nullable<System.DateTime> Upload_Date { get; set; }
        public Nullable<int> Uploaded_By { get; set; }
        public string Upload_Type { get; set; }
        public string Pending_Review_YN { get; set; }
        public Nullable<int> Upload_Record_Count { get; set; }
        public Nullable<int> Bank_Code { get; set; }
        public Nullable<int> Records_Inserted { get; set; }
        public Nullable<int> Records_Updated { get; set; }
        public Nullable<int> Total_Errors { get; set; }
        public Nullable<int> ChannelCode { get; set; }
        public Nullable<System.DateTime> StartDate { get; set; }
        public Nullable<System.DateTime> EndDate { get; set; }
        public string Record_Status { get; set; }
    }
}
