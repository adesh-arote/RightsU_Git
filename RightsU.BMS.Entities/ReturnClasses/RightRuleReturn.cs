using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
namespace RightsU.BMS.Entities.ReturnClasses
{
    public class RightRuleReturn : ListReturn
    {
        public RightRuleReturn()
        {
            content = new List<RightRule>();
            paging = new paging();
        }
        /// <summary>
        /// RightRule Details 
        /// </summary>
        public override object content { get; set; }
    }
}
