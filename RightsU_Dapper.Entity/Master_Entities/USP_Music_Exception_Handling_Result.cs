
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Music_Schedule_Transaction")]
    public partial class USP_Music_Exception_Handling_Result
    {
        [PrimaryKey]
        public int? Music_Schedule_Transaction_Code { get; set; } //Nullable<decimal>
        public string Content_Name { get; set; }
        public string Eps { get; set; }
        public string Dur { get; set; }
        public string Airing_Date { get; set; }
        public string Airing_Time { get; set; }
        public string Channel { get; set; }
        public string Music_Track { get; set; }
        public string Movie_Album { get; set; }
        public string Music_Label { get; set; }
        public Nullable<System.TimeSpan> Music_Dur { get; set; }
        public string Exceptions { get; set; }
        public string Status { get; set; }
        public string Initial_Response { get; set; }
        public string Workflow_Status { get; set; }
        public string Button_Visibility { get; set; }
        public string IsZeroWorkflow { get; set; }
    }
}


