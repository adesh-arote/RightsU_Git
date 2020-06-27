﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class Title_Milestone
    {
        public State EntityState { get; set; }
        public int Title_Milestone_Code { get; set; }
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

        public virtual Milestone_Nature Milestone_Nature { get; set; }
        public virtual Talent Talent { get; set; }
        public virtual Title Title { get; set; }
    }
}
