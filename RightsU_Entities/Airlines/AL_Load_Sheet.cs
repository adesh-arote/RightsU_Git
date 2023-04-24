using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Entities
{
    using System;
    using System.Collections.Generic;

    public partial class AL_Load_Sheet
    {
        public AL_Load_Sheet()
        {
            this.AL_Load_Sheet_Details = new HashSet<AL_Load_Sheet_Details>();
        }

        public State EntityState { get; set; }
        public int AL_Load_Sheet_Code { get; set; }
        public string Load_Sheet_No { get; set; }
        public Nullable<System.DateTime> Load_Sheet_Month { get; set; }
        public string Remarks { get; set; }
        public string Status { get; set; }
        public string Download_File_Name { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Updated_By { get; set; }
        public Nullable<System.DateTime> Updated_On { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }

        public virtual ICollection<AL_Load_Sheet_Details> AL_Load_Sheet_Details { get; set; }
    }
}
