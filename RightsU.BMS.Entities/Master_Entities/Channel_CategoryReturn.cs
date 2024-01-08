using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
   public class Channel_CategoryReturn : ListReturn
    {
        public Channel_CategoryReturn()
        {
            assets = new List<channelCategory>();
            paging = new paging();
        }

        /// <summary>
        /// ChannelCategory Details
        /// </summary>
        public override object assets { get; set; }
    }

    public class channelCategory
    {
        public int id { get; set; }
        public string ChannelCategoryName { get; set; }
        public string Type { get; set; }
        public string IsActive { get; set; }
    }
}
