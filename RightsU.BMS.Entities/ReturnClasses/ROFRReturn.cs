using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.ReturnClasses
{
    public class ROFRReturn : ListReturn
    {
        public ROFRReturn()
        {
            content = new List<ROFR>();
            paging = new paging();
        }

        /// <summary>
        /// ROFR Details 
        /// </summary>
        public override object content { get; set; }
    }
}
