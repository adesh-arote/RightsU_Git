using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
namespace RightsU.API.Entities.ReturnClasses
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
