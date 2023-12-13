//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace RightsU_Entities
{
    using Newtonsoft.Json;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations.Schema;

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

        [JsonIgnore]
        public State EntityState { get; set; }
        [JsonProperty(Order = -1)]
        public int Talent_Code { get; set; }
        public string Talent_Name { get; set; }
        public string Gender { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_By { get; set; }
        [NotMapped]
        public string Inserted_By_User { get; set; }
        [JsonIgnore]
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
        [NotMapped]
        public string Last_Action_By_User { get; set; }
        public string Is_Active { get; set; }

        [JsonProperty(Order = 1)]
        public virtual ICollection<Talent_Role> Talent_Role { get; set; }
        [JsonIgnore]
        public virtual ICollection<Title_Audio_Details_Singers> Title_Audio_Details_Singers { get; set; }
        [JsonIgnore]
        public virtual ICollection<Title_Talent> Title_Talent { get; set; }
        [JsonIgnore]
        public virtual ICollection<Music_Title_Talent> Music_Title_Talent { get; set; }
        [JsonIgnore]
        public virtual ICollection<Music_Album_Talent> Music_Album_Talent { get; set; }
        [JsonIgnore]
        public virtual ICollection<Title_Alternate_Talent> Title_Alternate_Talent { get; set; }
        [JsonIgnore]
        public virtual ICollection<Title_Milestone> Title_Milestone { get; set; }
        [JsonIgnore]
        public virtual ICollection<ProjectMilestone> ProjectMilestones { get; set; }

    }
}
