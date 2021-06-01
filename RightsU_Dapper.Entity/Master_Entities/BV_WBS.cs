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

    [Table("BV_WBS")]
    public partial class BV_WBS
    {
        [PrimaryKey]
        public int? BV_WBS_Code { get; set; }
        [ForeignKeyReference(typeof(SAP_WBS))]
        public Nullable<int> SAP_WBS_Code { get; set; }
        public string WBS_Code { get; set; }
        public string WBS_Description { get; set; }
        public string Short_ID { get; set; }
        public string Is_Archive { get; set; }
        public string Status { get; set; }
        public string Error_Details { get; set; }
        public string Is_Process { get; set; }
        public Nullable<long> File_Code { get; set; }
        public Nullable<int> BV_Key { get; set; }
        public string Response_Type { get; set; }
        public string Response_Status { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual SAP_WBS SAP_WBS { get; set; }
    }
}
