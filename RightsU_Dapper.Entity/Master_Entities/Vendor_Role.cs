
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Vendor_Role")]
    public partial class Vendor_Role
    {
       // public State EntityState { get; set; }
       [PrimaryKey]
        public int? Vendor_Role_Code { get; set; }
        //[ForeignKeyReference(typeof(Vendor))]
        public int Vendor_Code { get; set; }
        public int Role_Code { get; set; }
        public string Is_Active { get; set; }

        //public virtual Vendor Vendor { get; set; }
        //public virtual Role Role { get; set; }
    }
}


