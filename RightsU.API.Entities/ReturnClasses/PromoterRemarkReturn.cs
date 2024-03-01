using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
{
    public class PromoterRemarkReturn : ListReturn
    {
        public PromoterRemarkReturn()
        {
            content = new List<PromoterRemark>();
            paging = new paging();
        }

        /// <summary>
        /// PromoterRemark Details
        /// </summary>
        public override object content { get; set; }
    }
}
