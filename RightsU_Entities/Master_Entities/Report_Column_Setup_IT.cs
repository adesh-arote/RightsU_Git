using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    //using RightsU_Entities.Master_Entities;
    using System.Collections.Generic;

    public partial class Report_Column_Setup_IT
    {
        public Report_Column_Setup_IT()
        {
            this.Attrib_Report_Column = new HashSet<Attrib_Report_Column>();
        }

        public State EntityState { get; set; }
        public int Column_Code { get; set; }
        public string View_Name { get; set; }
        public string Name_In_DB { get; set; }
        public string Display_Name { get; set; }
        public Nullable<short> Valued_As { get; set; }
        public Nullable<int> Display_Order { get; set; }
        public string IsPartofSelectOnly { get; set; }
        public string List_Source { get; set; }
        public string Lookup_Column { get; set; }
        public string Display_Column { get; set; }
        public Nullable<int> Right_Code { get; set; }
        public string Max_Length { get; set; }
        public string WhCondition { get; set; }
        public string ValidOpList { get; set; }
        public string Alternate_Config_Code { get; set; }
        public string Display_Type { get; set; }

        public virtual ICollection<Attrib_Report_Column> Attrib_Report_Column { get; set; }
    }
}
