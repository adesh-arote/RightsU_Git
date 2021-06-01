using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    using Dapper.SimpleSave;
    using System;
    using System.Collections.Generic;

    [Table("Party_Group")]

    public partial class Party_Group
    {
        public Party_Group()
        {
            this.Vendors = new HashSet<Vendor>();
        }
        [PrimaryKey]
        public int? Party_Group_Code { get; set; }
        public string Party_Group_Name { get; set; }
        public Nullable<System.DateTime> InsertedOn { get; set; }
        public Nullable<System.DateTime> Last_Updated_By { get; set; }
        public string Is_Active { get; set; }
        [OneToMany]
        public virtual ICollection<Vendor> Vendors { get; set; }
    }
}
