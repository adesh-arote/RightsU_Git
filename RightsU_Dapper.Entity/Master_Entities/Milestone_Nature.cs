
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Milestone_Nature")]
    public partial class Milestone_Nature
    {
        public Milestone_Nature()
        {
            this.Title_Milestone = new HashSet<Title_Milestone>();
            this.ProjectMilestones = new HashSet<ProjectMilestone>();
        }
        [PrimaryKey]
        public int? Milestone_Nature_Code { get; set; }
        public string Milestone_Nature_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_by { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public Nullable<System.TimeSpan> Lock_Time { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Milestone> Title_Milestone { get; set; }
        [OneToMany]
        public virtual ICollection<ProjectMilestone> ProjectMilestones { get; set; }
    }

}