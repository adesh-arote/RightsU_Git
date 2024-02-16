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

    public partial class Attrib_Report_Column
    {
        public State EntityState { get; set; }
        public int Attrib_Report_Column_Code { get; set; }
        public Nullable<int> DP_Attrib_Group_Code { get; set; }
        public Nullable<int> BV_Attrib_Group_Code { get; set; }
        public Nullable<int> Column_Code { get; set; }
        public Nullable<int> Control_Type { get; set; }
        public Nullable<int> Display_Order { get; set; }
        public Nullable<int> Output_Group { get; set; }
        public string Is_Mandatory { get; set; }
        public string Icon { get; set; }
        public string Css_Class { get; set; }
        public string Type { get; set; }
        public string IsSelectCriteria { get; set; }

        public virtual Attrib_Group Attrib_Group { get; set; }
        public virtual Attrib_Group Attrib_Group1 { get; set; }
        public virtual Report_Column_Setup_IT Report_Column_Setup_IT { get; set; }
    }
}
