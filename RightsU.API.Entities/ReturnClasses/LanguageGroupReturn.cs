using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;

namespace RightsU.API.Entities.ReturnClasses
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
