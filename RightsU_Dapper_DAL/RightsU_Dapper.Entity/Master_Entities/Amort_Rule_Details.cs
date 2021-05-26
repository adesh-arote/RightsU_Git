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

    [Table("Amort_Rule_Details")]
    public partial class Amort_Rule_Details
    {
        [PrimaryKey]
        public int? Amort_Rule_Details_Code { get; set; }
        [ForeignKeyReference(typeof(Amort_Rule))]
        public Nullable<int> Amort_Rule_Code { get; set; }
        public Nullable<int> From_Range { get; set; }
        public Nullable<int> To_Range { get; set; }
        public Nullable<decimal> Per_Cent { get; set; }
        public Nullable<int> Month { get; set; }
        public Nullable<int> Year { get; set; }
        public Nullable<int> End_Of_Year { get; set; }
        public string Period_Type { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Amort_Rule Amort_Rule { get; set; }
    }
}
