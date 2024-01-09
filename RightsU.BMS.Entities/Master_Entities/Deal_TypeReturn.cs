using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public class Deal_TypeReturn : ListReturn
    {
        public Deal_TypeReturn()
        {
            content = new List<Deal_Type>();
            paging = new paging();
        }

        /// <summary>
        /// DealType Details
        /// </summary>
        public override object content { get; set; }
    }
}
