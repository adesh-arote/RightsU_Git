using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
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
