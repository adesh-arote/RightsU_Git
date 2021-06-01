using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;

    [Table("Amort_Rule")]
    public partial class Amort_Rule
    {
        public Amort_Rule()
        {
            this.Amort_Rule_Details = new HashSet<Amort_Rule_Details>();
        }
        [PrimaryKey]
        public int? Amort_Rule_Code { get; set; }
        public string Rule_Type { get; set; }
        public string Rule_No { get; set; }
        public string Rule_Desc { get; set; }
        public string Distribution_Type { get; set; }
        public string Period_For { get; set; }
        public string Year_Type { get; set; }
        public Nullable<int> Nos { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        [OneToMany]
        public virtual ICollection<Amort_Rule_Details> Amort_Rule_Details { get; set; }
    }
}
