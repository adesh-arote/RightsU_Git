using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class Title_Episode_Details
    {
        public Title_Episode_Details()
        {
            this.Title_Episode_Details_TC = new HashSet<Title_Episode_Details_TC>();
        }

        public State EntityState { get; set; }
        public int Title_Episode_Detail_Code { get; set; }
        public Nullable<int> Title_Code { get; set; }
        public Nullable<int> Episode_Nos { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }

        public virtual Title Title { get; set; }
        public virtual ICollection<Title_Episode_Details_TC> Title_Episode_Details_TC { get; set; }
    }
}
