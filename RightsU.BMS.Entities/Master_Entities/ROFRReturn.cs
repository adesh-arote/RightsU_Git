﻿using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public class ROFRReturn : ListReturn
    {
        public ROFRReturn()
        {
            content = new List<ROFR>();
            paging = new paging();
        }

        /// <summary>
        /// ROFR Details 
        /// </summary>
        public override object content { get; set; }
    }
}