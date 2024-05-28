using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
{
    public class AcqDealRunReturn : ListReturn
    {
        public AcqDealRunReturn()
        {
            content = new List<USP_Acq_List_Runs>();
            paging = new paging();
        }

        /// <summary>
        /// Deal General Details
        /// </summary>
        public override object content { get; set; }
    }
}
