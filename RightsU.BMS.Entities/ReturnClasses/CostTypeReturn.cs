using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.ReturnClasses
{
    public class CostTypeReturn : ListReturn
    {
        public CostTypeReturn()
        {
            content = new List<Cost_Type>();
            paging = new paging();
        }

        /// <summary>
        /// CostType Details
        /// </summary>
        public override object content { get; set; }

    }
}
