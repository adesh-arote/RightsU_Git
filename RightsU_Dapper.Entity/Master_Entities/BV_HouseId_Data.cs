
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("BV_HouseId_Data")]
    public partial class BV_HouseId_Data
    {
        [PrimaryKey]
        public int? BV_HouseId_Data_Code { get; set; }
        public string House_Ids { get; set; }
        public string BV_Title { get; set; }
        public string Episode_No { get; set; }
        public string House_Type { get; set; }
        public Nullable<int> Mapped_Deal_Title_Code { get; set; }
        public string Is_Mapped { get; set; }
        public Nullable<int> Parent_BV_HouseId_Data_Code { get; set; }
        public Nullable<long> upload_file_code { get; set; }
        public string Program_Episode_ID { get; set; }
        public string Program_Version_ID { get; set; }
        public string Schedule_Item_Log_Date { get; set; }
        public string Schedule_Item_Log_Time { get; set; }
        public string IsProcessed { get; set; }
        public string IsIgnore { get; set; }
        public string Program_Category { get; set; }
        public Nullable<int> BMS_Schedule_Process_Data_Temp_Code { get; set; }
        public Nullable<System.DateTime> LastUpdatedOn { get; set; }
        public string Type { get; set; }
        public Nullable<System.DateTime> InsertedOn { get; set; }
        public Nullable<int> Title_Content_Code { get; set; }
        public Nullable<int> Title_Code
        {
            get; set;
        }
    }
}