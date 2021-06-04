
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Party_Category")]
    public partial class Party_Category
    {
        public Party_Category()
        {
            this.Vendors = new HashSet<Vendor>();
        }
        [PrimaryKey]
        public int? Party_Category_Code { get; set; }
        public string Party_Category_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_On { get; set; }
        public Nullable<int> Last_Updated_By { get; set; }
        public string Is_Active { get; set; }

        [OneToMany]
        public ICollection<Vendor> Vendors { get; set; }
    }
}


