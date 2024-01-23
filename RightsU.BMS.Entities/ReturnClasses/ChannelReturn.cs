using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.ReturnClasses
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
