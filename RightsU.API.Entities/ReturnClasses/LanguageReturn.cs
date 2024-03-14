using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
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
