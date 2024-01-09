﻿using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public class PlatformReturn : ListReturn
    {
        public PlatformReturn()
        {
            content = new List<Platform>();
            paging = new paging();
        }

        /// <summary>
        /// DealType Details
        /// </summary>
        public override object content { get; set; }
    }

}
