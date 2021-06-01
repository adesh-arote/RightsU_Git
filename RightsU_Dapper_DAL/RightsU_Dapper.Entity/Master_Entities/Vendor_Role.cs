using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Vendor_Role")]
    public partial class Vendor_Role
    {
        [PrimaryKey]
        public int? Vendor_Role_Code { get; set; }
        [ForeignKeyReference(typeof(Vendor))]
        public int Vendor_Code { get; set; }
        [ForeignKeyReference(typeof(Role))]
        public int? Role_Code { get; set; }
        public string Is_Active { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Vendor Vendor { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [ManyToOne]
        public virtual Role Role { get; set; }
    }
}
