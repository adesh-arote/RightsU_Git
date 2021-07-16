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

    [Table("DM_Master_Import")]
    public partial class DM_Master_Import
    {
        public DM_Master_Import()
        {
            this.DM_Master_Log = new HashSet<DM_Master_Log>();
        }
        [PrimaryKey]
        public int? DM_Master_Import_Code { get; set; }
        public string File_Name { get; set; }
        public string System_File_Name { get; set; }
        public Nullable<int> Upoaded_By { get; set; }
        public Nullable<System.DateTime> Uploaded_Date { get; set; }
        public Nullable<int> Action_By { get; set; }
        public Nullable<System.DateTime> Action_On { get; set; }
        public string Status { get; set; }
        public string File_Type { get; set; }
        public string Mapped_By { get; set; }
        [OneToMany]
        public virtual ICollection<DM_Master_Log> DM_Master_Log { get; set; }
    }
}
