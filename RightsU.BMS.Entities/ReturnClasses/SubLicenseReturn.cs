using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.ReturnClasses
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
