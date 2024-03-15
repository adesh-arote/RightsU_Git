using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
{
    public class EntityReturn : ListReturn
    {
        public EntityReturn()
        {
            content = new List<Entity>();
            paging = new paging();
        }

        /// <summary>
        /// Entity Details 
        /// </summary>
        public override object content { get; set; }
    }
}
