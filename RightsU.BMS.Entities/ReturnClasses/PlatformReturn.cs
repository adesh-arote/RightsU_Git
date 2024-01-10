using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.ReturnClasses
{
    public class PlatformReturn : ListReturn
    {
        public PlatformReturn()
        {
            content = new List<Platform>();
            paging = new paging();
        }

        /// <summary>
        /// DealType Details
        /// </summary>
        public override object content { get; set; }
    }

}
