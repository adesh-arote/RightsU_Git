using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;

    [Table("Talent")]
    public partial class USP_Get_Talent_Name_Result
    {
        public int? Talent_Code { get; set; }
        public string Talent_Name { get; set; }
        [ForeignKeyReference(typeof(Role))]
        public Nullable<int> Role_Code { get; set; }
    }
}
