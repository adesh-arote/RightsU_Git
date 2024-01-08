using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public class PlatformReturn : ListReturn
    {
        public PlatformReturn()
        {
            assets = new List<platforms>();
            paging = new paging();
        }

        /// <summary>
        /// DealType Details
        /// </summary>
        public override object assets { get; set; }
    }

    public class platforms
    {
        public int id { get; set; }
        public string PlatformName { get; set; }
        public string IsNoOfRun{ get; set; }
        public string ApplicableForHoldback { get; set; }
        public string ApplicableForDemesticTerritory { get; set; }
        public string ApplicableForAsrunSchedule { get; set; }
        public int ParentPlatformCode { get; set; }
        public string IsLastLevel { get; set; }
        public string ModulePosition { get; set; }
        public int BasePlatformCode { get; set; }
        public string PlatformHiearachy { get; set; }
        public string IsSportRight { get; set; }
        public string IsApplicableSynRun { get; set; }
        public string IsActive { get; set; }
    }
}
