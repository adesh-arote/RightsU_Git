using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class Title_Episode_Details_TC
    {
        public State EntityState { get; set; }
        public int Title_Episode_Detail_TC_Code { get; set; }
        public Nullable<int> Title_Episode_Detail_Code { get; set; }
        public Nullable<int> Title_Content_Code { get; set; }

        public virtual Title_Content Title_Content { get; set; }
        public virtual Title_Episode_Details Title_Episode_Details { get; set; }
    }
}
