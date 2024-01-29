using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.ReturnClasses
{
    public class PartyReturn : ListReturn
    {
        public PartyReturn()
        {
            content = new List<Vendor>();
            paging = new paging();
        }

        /// <summary>
        /// Party Details
        /// </summary>
        public override object content { get; set; }
    }
}
