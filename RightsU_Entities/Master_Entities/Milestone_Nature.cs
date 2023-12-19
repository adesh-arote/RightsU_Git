using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using Newtonsoft.Json;
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations.Schema;

    public partial class Milestone_Nature
    {
        public Milestone_Nature()
        {
            this.Title_Milestone = new HashSet<Title_Milestone>();
            this.ProjectMilestones = new HashSet<ProjectMilestone>();
        }
        [JsonIgnore]
        public State EntityState { get; set; }
        [JsonProperty(Order = -1)]
        public int Milestone_Nature_Code { get; set; }
        [JsonProperty(Order = 1)]
        public string Milestone_Nature_Name { get; set; }
        [JsonProperty(Order = 2)]
        public Nullable<System.DateTime> Inserted_On { get; set; }
        [JsonIgnore]
        public Nullable<int> Inserted_by { get; set; }
        [NotMapped]
        [JsonProperty(Order = 3)]
        public string Inserted_By_User { get; set; }
        [JsonProperty(Order = 4)]
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        [JsonIgnore]
        public Nullable<int> Last_Action_By { get; set; }
        [NotMapped]
        [JsonProperty(Order = 5)]
        public string Last_Action_By_User { get; set; }
        [JsonProperty(Order = 6)]
        public string Is_Active { get; set; }
        [JsonIgnore]
        public Nullable<System.TimeSpan> Lock_Time { get; set; }
        [JsonIgnore]
        public virtual ICollection<Title_Milestone> Title_Milestone { get; set; }
        [JsonIgnore]
        public virtual ICollection<ProjectMilestone> ProjectMilestones { get; set; }
    }
}
