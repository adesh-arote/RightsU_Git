using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
{
    public class CountryReturn : ListReturn
    {
        public CountryReturn()
        {
            content = new List<Country>();
            paging = new paging();
        }
        /// <summary>
        /// Country Details 
        /// </summary>
        public override object content { get; set; }
    }
}
