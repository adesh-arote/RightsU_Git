
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("ProjectMilestone")]
    public partial class ProjectMilestone
    {
        public ProjectMilestone()
        {
            this.ProjectMilestoneDetails = new HashSet<ProjectMilestoneDetail>();
            this.ProjectMilestoneTitles = new HashSet<ProjectMilestoneTitle>();
        }
        [PrimaryKey]
        public int? ProjectMilestoneCode { get; set; }
        public string AgreementNo { get; set; }
        public Nullable<System.DateTime> AgreementDate { get; set; }
        public string ProjectName { get; set; }
        public Nullable<int> MileStone_Nature_Code { get; set; }
        public Nullable<int> TalentCode { get; set; }
        public string PeriodType { get; set; }
        public Nullable<System.DateTime> StartDate { get; set; }
        public Nullable<System.DateTime> EndDate { get; set; }
        public Nullable<int> Milestone_Type_Code { get; set; }
        public Nullable<int> Milestone_No_Of_Unit { get; set; }
        public Nullable<int> Milestone_Unit_Type { get; set; }
        public string IsClosed { get; set; }
        public string IsTentitive { get; set; }
        public string Term { get; set; }
        public string Version { get; set; }
        public string WorkflowStatus { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Milestone_Nature Milestone_Nature { get; set; }
        //  public virtual Milestone_Type Milestone_Type { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Talents Talent { get; set; }
        public virtual ICollection<ProjectMilestoneDetail> ProjectMilestoneDetails { get; set; }
        public virtual ICollection<ProjectMilestoneTitle> ProjectMilestoneTitles { get; set; }
    }
}


