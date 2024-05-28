using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
{
    public class PartyReturn : ListReturn
    {
        public PartyReturn()
        {
            content = new List<Party>();
            paging = new paging();
        }

        /// <summary>
        /// Party Details
        /// </summary>
        public override object content { get; set; }
    }
}
