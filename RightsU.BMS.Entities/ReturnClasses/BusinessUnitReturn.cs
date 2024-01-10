using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.ReturnClasses
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
