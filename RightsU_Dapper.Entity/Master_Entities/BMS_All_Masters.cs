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
    
    [Table("BMS_All_Masters")]
    public partial class BMS_All_Masters
    {
        [PrimaryKey]
        public int? Order_Id { get; set; }
        public string Module_Name { get; set; }
        public string BaseAddress { get; set; }
        public string Is_Active { get; set; }
        public string Method_Type { get; set; }
        public string RequestUri { get; set; }
    }
}
