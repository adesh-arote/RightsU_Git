using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;

namespace RightsU.API.Entities.ReturnClasses
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
