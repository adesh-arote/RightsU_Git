using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.ReturnClasses
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
