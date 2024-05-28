using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
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
