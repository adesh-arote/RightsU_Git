using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;

namespace RightsU.API.Entities.ReturnClasses
{
    public class  CurrencyReturn:ListReturn
    {
        public CurrencyReturn()
        {
            content = new List<Currency>();
            paging = new paging();
        }
        /// <summary>
        /// Currency Details 
        /// </summary>
        public override object content { get; set; }
    }
}
