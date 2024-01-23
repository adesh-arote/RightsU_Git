using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;

namespace RightsU.BMS.Entities.ReturnClasses
{
    public class LanguageGroupReturn : ListReturn
    {
        public LanguageGroupReturn()
        {
            content = new List<LanguageGroup>();
            paging = new paging();
        }
        /// <summary>
        /// LanguageGroup Details 
        /// </summary>
        public override object content { get; set; }
    }
}
