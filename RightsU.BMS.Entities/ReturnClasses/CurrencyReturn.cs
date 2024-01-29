using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;

namespace RightsU.BMS.Entities.ReturnClasses
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
