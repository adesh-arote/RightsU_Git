
namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Category")]
    public partial class Category
    {
        public Category()
        {
            this.Acq_Deal = new HashSet<Acq_Deal>();
            this.Syn_Deal = new HashSet<Syn_Deal>();
        }
        [PrimaryKey]
        public int? Category_Code { get; set; }
        public string Category_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public string Is_System_Generated { get; set; }
        [OneToMany]
        public virtual ICollection<Acq_Deal> Acq_Deal { get; set; }
        [OneToMany]
        public virtual ICollection<Syn_Deal> Syn_Deal { get; set; }
    }
}


