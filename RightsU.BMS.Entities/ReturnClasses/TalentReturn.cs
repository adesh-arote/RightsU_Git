using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.ReturnClasses
{
    public class TalentReturn : ListReturn
    {
        public TalentReturn()
        {
            content = new List<Talent>();
            paging = new paging();
        }

        /// <summary>
        /// Talent Details
        /// </summary>
        public override object content { get; set; }
    }
}
