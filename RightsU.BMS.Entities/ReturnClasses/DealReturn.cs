using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.ReturnClasses
{
    public class DealReturn : ListReturn
    {
        public DealReturn()
        {
            content = new List<Acq_Deal_List>();
            paging = new paging();
        }

        /// <summary>
        /// Deal General Details
        /// </summary>
        public override object content { get; set; }
    }
}
