using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;
    public partial class Title_Content_Material
    {
        public State EntityState { get; set; }
        public int Title_Content_Matreial_Code { get; set; }
        public Nullable<int> Title_Content_Code { get; set; }
        public Nullable<int> Material_Medium_Code { get; set; }
        public Nullable<System.DateTime> Delivery_Date { get; set; }
        public Nullable<System.DateTime> TC_QC_Date { get; set; }
        public Nullable<System.DateTime> SNP_Date { get; set; }
        public Nullable<int> Inserted_On { get; set; }
        public Nullable<System.DateTime> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }

        public virtual Material_Medium Material_Medium { get; set; }
        public virtual Title_Content Title_Content { get; set; }
    }
}
