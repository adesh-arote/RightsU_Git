using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
{
    public class CategoryReturn : ListReturn
    {
        public CategoryReturn()
        {
            content = new List<Category>();
            paging = new paging();
        }
        /// <summary>
        /// Category Details 
        /// </summary>
        public override object content { get; set; }
    }
}
