using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public class Deal_TypeReturn : ListReturn
    {
        public Deal_TypeReturn()
        {
            content = new List<dealType>();
            paging = new paging();
        }

        /// <summary>
        /// DealType Details
        /// </summary>
        public override object content { get; set; }
    }

    public class dealType
    {
        public int id { get; set; }
        public string DealTypeName { get; set; }
        public string IsDefault { get; set; }
        public string IsGridRequired { get; set; }
        public string IsActive { get; set; }
        public string IsMasterDeal { get; set; }
        public int? ParentCode { get; set; }
        public string DealOrTitle { get; set; }
        public int DealTitleMappingCode { get; set; }
    }

   
}
