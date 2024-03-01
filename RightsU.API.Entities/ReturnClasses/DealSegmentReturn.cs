using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
namespace RightsU.API.Entities.ReturnClasses
{
    public class DealSegmentReturn : ListReturn
    {
        public DealSegmentReturn()
        {
            content = new List<Deal_Segment>();
            paging = new paging();
        }

        /// <summary>
        /// DealSegment Details
        /// </summary>
        public override object content { get; set; }
    }
}
