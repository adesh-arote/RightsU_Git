using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
namespace RightsU.API.Entities.ReturnClasses

{
   public  class RevenueVerticalReturn: ListReturn
    {
        public RevenueVerticalReturn()
        {
            content = new List<Revenue_Vertical>();
            paging = new paging();
        }

        /// <summary>
        /// RevenueVertical Details
        /// </summary>
        public override object content { get; set; }
    }
}
