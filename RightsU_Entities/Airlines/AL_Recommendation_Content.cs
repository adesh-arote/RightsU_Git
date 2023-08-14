using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class AL_Recommendation_Content
    {
        public State EntityState { get; set; }
        public int AL_Recommendation_Content_Code { get; set; }
        public Nullable<int> AL_Recommendation_Code { get; set; }
        public Nullable<int> AL_Vendor_Rule_Code { get; set; }
        public Nullable<int> Title_Code { get; set; }
        public Nullable<int> Title_Content_Code { get; set; }
        public string Content_Type { get; set; }
        public string Content_Status { get; set; }

        public virtual AL_Recommendation AL_Recommendation { get; set; }
        public virtual AL_Vendor_Rule AL_Vendor_Rule { get; set; }
        public virtual Title Title { get; set; }
        public virtual Title_Content Title_Content { get; set; }
    }
}
