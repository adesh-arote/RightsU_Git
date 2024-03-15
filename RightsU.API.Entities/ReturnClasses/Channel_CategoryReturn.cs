using RightsU.API.Entities.FrameworkClasses;
using RightsU.API.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities.ReturnClasses
{
   public class Channel_CategoryReturn : ListReturn
    {
        public Channel_CategoryReturn()
        {
            content = new List<Channel_Category>();
            paging = new paging();
        }
        /// <summary>
        /// ChannelCategory Details
        /// </summary>
        public override object content { get; set; }
    }
}
