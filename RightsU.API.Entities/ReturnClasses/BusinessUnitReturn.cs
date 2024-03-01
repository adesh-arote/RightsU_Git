using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
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
