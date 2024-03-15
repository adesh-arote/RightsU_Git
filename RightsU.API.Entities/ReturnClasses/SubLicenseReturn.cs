using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
{
    public class SubLicenseReturn : ListReturn
    {
        public SubLicenseReturn()
        {
            content = new List<Sub_License>();
            paging = new paging();
        }

        /// <summary>
        /// Sub License Details 
        /// </summary>
        public override object content { get; set; }
    }
}
