﻿using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
{
    public class DealTagReturn : ListReturn
    {
        public DealTagReturn()
        {
            content = new List<Deal_Tag>();
            paging = new paging();
        }

        /// <summary>
        /// Deal Tag Details 
        /// </summary>
        public override object content { get; set; }
    }
}
