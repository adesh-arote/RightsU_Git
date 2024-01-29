﻿using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.ReturnClasses
{
    public class LanguageReturn : ListReturn
    {
        public LanguageReturn()
        {
            content = new List<Language>();
            paging = new paging();
        }

        /// <summary>
        /// Language Details 
        /// </summary>
        public override object content { get; set; }
    }
}
