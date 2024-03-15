using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
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
