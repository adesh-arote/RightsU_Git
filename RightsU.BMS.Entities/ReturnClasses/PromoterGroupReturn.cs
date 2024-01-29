using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.ReturnClasses
{
    public class PromoterGroupReturn : ListReturn
    {
        public PromoterGroupReturn()
        {
            content = new List<PromoterGroup>();
            paging = new paging();
        }
        /// <summary>
        /// PromoterGroup Details
        /// </summary>
        public override object content { get; set; }
    }
}
