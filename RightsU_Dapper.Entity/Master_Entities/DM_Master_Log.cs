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
    public partial class DM_Master_Log
    {
        [PrimaryKey]
        public int? DM_Master_Log_Code { get; set; }
        [ForeignKeyReference(typeof(DM_Master_Import))]
        public string DM_Master_Import_Code { get; set; }
        public string Name { get; set; }
        public string Master_Type { get; set; }
        public Nullable<int> Master_Code { get; set; }
        public string User_Action { get; set; }
        public Nullable<int> Action_By { get; set; }
        public Nullable<System.DateTime> Action_On { get; set; }
        public string Roles { get; set; }
        public bool Is_Create_New { get; set; }
        public Nullable<int> Mapped_Code { get; set; }
        public string Mapped_Name { get; set; }
        public bool IsIgnore { get; set; }
        public string Is_Ignore { get; set; }
        public string Mapped_By { get; set; }
        public string System_Mapped_Name { get; set; }
        public Nullable<int> System_Mapped_Code { get; set; }
        public virtual DM_Master_Import DM_Master_Import { get; set; }
        [ForeignKeyReference(typeof(Music_Album))]
        public Nullable<int> Music_Album_Code { get; set; }
        public string Music_Album { get; set; }
    }
}
