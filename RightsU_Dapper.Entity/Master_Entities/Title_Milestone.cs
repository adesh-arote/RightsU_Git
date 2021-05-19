
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Title_Milestone")]
    public partial class Title_Milestone
    {
        [PrimaryKey]
        public int? Title_Milestone_Code { get; set; }
        [ForeignKeyReference(typeof(Title))]
        public Nullable<int> Title_Code { get; set; }
        public Nullable<int> Talent_Code { get; set; }
        public Nullable<int> Milestone_Nature_Code { get; set; }
        public Nullable<System.DateTime> Expiry_Date { get; set; }
        public string Milestone { get; set; }
        public string Action_Item { get; set; }
        public string Is_Abandoned { get; set; }
        public string Remarks { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_by { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public Nullable<System.TimeSpan> Lock_Time { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Milestone_Nature Milestone_Nature { get; set; }
        public virtual Talent Talent { get; set; }
        public virtual Title Title { get; set; }
    }
}


