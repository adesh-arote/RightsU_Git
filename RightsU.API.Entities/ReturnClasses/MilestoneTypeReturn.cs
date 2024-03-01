using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
{
    public class MilestoneTypeReturn : ListReturn
    {
        public MilestoneTypeReturn()
        {
            content = new List<Milestone_Type>();
            paging = new paging();
        }

        /// <summary>
        /// Milestone Type Details 
        /// </summary>
        public override object content { get; set; }
    }
}
