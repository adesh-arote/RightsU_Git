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

    [Table("Vendor_Country")]

    public partial class Vendor_Country
    {
        [PrimaryKey]
        public int? Vendor_Country_Code { get; set; }
        [ForeignKeyReference(typeof(Vendor))]
        public Nullable<int> Vendor_Code { get; set; }
        [ForeignKeyReference(typeof(Country))]

        public Nullable<int> Country_Code { get; set; }
        public string Is_Theatrical { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Country Country { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Vendor Vendor { get; set; }
    }
}
