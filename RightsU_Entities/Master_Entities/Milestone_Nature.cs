﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class Milestone_Nature
    {
        public Milestone_Nature()
        {
            this.Title_Milestone = new HashSet<Title_Milestone>();
            this.ProjectMilestones = new HashSet<ProjectMilestone>();
        }

        public State EntityState { get; set; }
        public int Milestone_Nature_Code { get; set; }
        public string Milestone_Nature_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_by { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public Nullable<System.TimeSpan> Lock_Time { get; set; }

        public virtual ICollection<Title_Milestone> Title_Milestone { get; set; }
        public virtual ICollection<ProjectMilestone> ProjectMilestones { get; set; }
    }
}
