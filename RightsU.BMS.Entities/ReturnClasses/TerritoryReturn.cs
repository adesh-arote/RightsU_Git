using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;

namespace RightsU.BMS.Entities.ReturnClasses
{
   public class TerritoryReturn : ListReturn
    {
        public TerritoryReturn()
        {
            content = new List<Territory>();
            paging = new paging();
        }
        /// <summary>
        /// Territory Details 
        /// </summary>
        public override object content { get; set; }
    }
}
