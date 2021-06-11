
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("BV_Schedule_Transaction")]
    public partial class BV_Schedule_Transaction
    {
        [PrimaryKey]
        public decimal? BV_Schedule_Transaction_Code { get; set; }
        public string Program_Episode_Title { get; set; }
        public string Program_Episode_Number { get; set; }
        public string Program_Title { get; set; }
        public string Program_Category { get; set; }
        public string Schedule_Item_Log_Date { get; set; }
        public string Schedule_Item_Log_Time { get; set; }
        public string Schedule_Item_Duration { get; set; }
        public string Scheduled_Version_House_Number_List { get; set; }
        public string Found_Status { get; set; }
        public Nullable<long> File_Code { get; set; }
        public Nullable<int> Channel_Code { get; set; }
        public string IsProcessed { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [ForeignKeyReference(typeof(Title))]
        public Nullable<decimal> Title_Code { get; set; }
        public Nullable<decimal> Deal_Movie_Code { get; set; }
        public Nullable<decimal> Deal_Movie_Rights_Code { get; set; }
        public string IsRevertCnt_OnAsRunLoad { get; set; }
        public string IsException { get; set; }
        public string Program_Episode_ID { get; set; }
        public string Program_Version_ID { get; set; }
        public string IsDealApproved { get; set; }
    }
}


