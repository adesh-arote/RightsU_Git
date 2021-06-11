
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Music_Schedule_Transaction")]
    public partial class Music_Schedule_Transaction
    {
        [PrimaryKey]
        public decimal? Music_Schedule_Transaction_Code { get; set; }
        [ForeignKeyReference(typeof(BV_Schedule_Transaction))]
        public Nullable<decimal> BV_Schedule_Transaction_Code { get; set; }
        [ForeignKeyReference(typeof(Content_Music_Link))]
        public Nullable<int> Content_Music_Link_Code { get; set; }
        [ForeignKeyReference(typeof(Channel))]
        public Nullable<int> Channel_Code { get; set; }
        [ForeignKeyReference(typeof(Music_Label))]
        public Nullable<int> Music_Label_Code { get; set; }
        public string Is_Ignore { get; set; }
        public string Is_Exception { get; set; }
        public string Is_Processed { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public string Initial_Response { get; set; }
        public Nullable<int> Music_Override_Reason_Code { get; set; }
        public string Remarks { get; set; }
        public string Workflow_Status { get; set; }
        public string Is_Mail_Sent { get; set; }
        [ForeignKeyReference(typeof(Music_Deal))]
        public Nullable<int> Music_Deal_Code { get; set; }
    }
}


