namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using Dapper.SimpleLoad;
    using System;
    using System.Collections.Generic;

    [Table("Talent")]
    public partial class Talent
    {
        public Talent()
        {
            this.Talent_Role = new HashSet<Talent_Role>();
            this.Title_Audio_Details_Singers = new HashSet<Title_Audio_Details_Singers>();
            this.Title_Talent = new HashSet<Title_Talent>();
            this.Music_Title_Talent = new HashSet<Music_Title_Talent>();
            this.Music_Album_Talent = new HashSet<Music_Album_Talent>();
            this.Title_Alternate_Talent = new HashSet<Title_Alternate_Talent>();
            this.Title_Milestone = new HashSet<Title_Milestone>();
            this.ProjectMilestones = new HashSet<ProjectMilestone>();
        }
        [PrimaryKey]
        public int? Talent_Code { get; set; }
        public string Talent_Name { get; set; }
        public string Gender { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }

        [OneToMany]
        public virtual ICollection<Talent_Role> Talent_Role { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Audio_Details_Singers> Title_Audio_Details_Singers { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Talent> Title_Talent { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Title_Talent> Music_Title_Talent { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Album_Talent> Music_Album_Talent { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Alternate_Talent> Title_Alternate_Talent { get; set; }
        [OneToMany]
        public virtual ICollection<Title_Milestone> Title_Milestone { get; set; }
        [OneToMany]
        public virtual ICollection<ProjectMilestone> ProjectMilestones { get; set; }

    }
}
