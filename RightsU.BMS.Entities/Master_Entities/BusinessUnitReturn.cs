using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public class BusinessUnitReturn : ListReturn
    {
        public BusinessUnitReturn()
        {
            content = new List<Business_Unit>();
            paging = new paging();
        }

        /// <summary>
        /// Business Unit Details 
        /// </summary>
        public override object content { get; set; }
    }
}
