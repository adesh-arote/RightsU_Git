using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
{
    public class ChannelReturn : ListReturn
    {
        public ChannelReturn()
        {
            content = new List<Channel>();
            paging = new paging();
        }

        /// <summary>
        /// Channel Details
        /// </summary>
        public override object content { get; set; }
    }
}
