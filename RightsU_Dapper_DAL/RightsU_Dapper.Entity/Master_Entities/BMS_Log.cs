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
    [Table("BMS_Log")]
    public partial class BMS_Log
    {
        [PrimaryKey]
        public int? BMS_Log_Code { get; set; }
        public string Module_Name { get; set; }
        public string Method_Type { get; set; }
        public Nullable<System.DateTime> Request_Time { get; set; }
        public Nullable<System.DateTime> Response_Time { get; set; }
        public string Request_Xml { get; set; }
        public string Response_Xml { get; set; }
        public string Record_Status { get; set; }
        public string Error_Description { get; set; }
    }
}
