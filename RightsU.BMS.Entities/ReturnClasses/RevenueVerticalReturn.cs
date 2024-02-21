using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
namespace RightsU.BMS.Entities.ReturnClasses

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
