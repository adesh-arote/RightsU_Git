using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public class TalentReturn : ListReturn
    {
        public TalentReturn()
        {
            content = new List<Talent>();
            paging = new paging();
        }

        /// <summary>
        /// Talent Details
        /// </summary>
        public override object content { get; set; }
    }
    public class Talent_List
    {
        public Talent_List()
        {
            //StarCast = new List<string>();
        }
        /// <summary>
        /// This is Talent Code ,Example:RUBMSA11
        /// </summary>
        public int id { get; set; }
        public string TalentName { get; set; }
        public string Gender { get; set; }
        public string IsActive { get; set; }
    }
}
