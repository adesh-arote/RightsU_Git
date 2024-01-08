using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    public class ProgramReturn : ListReturn
    {
        public ProgramReturn()
        {
            content = new List<Program>();
            paging = new paging();
        }

        /// <summary>
        /// Program Details
        /// </summary>
        public override object content { get; set; }
    }

    public class Program_List
    {
        public Program_List()
        {
            //StarCast = new List<string>();
        }
        /// <summary>
        /// This is Program Code ,Example:RUBMSA11
        /// </summary>
        public int id { get; set; }
        public string ProgramName { get; set; }
        public string DealType { get; set; }
        public string Genre { get; set; }
        public string IsActive { get; set; }
    }
}
