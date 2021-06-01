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

    [Table("BVException")]
    public partial class BVException
    {
        public BVException()
        {
            this.BVException_Channel = new HashSet<BVException_Channel>();
            this.BVException_Users = new HashSet<BVException_Users>();
        }
        [PrimaryKey]
        public int? Bv_Exception_Code { get; set; }
        public string Bv_Exception_Type { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<System.DateTime> Lock_Time { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }

        [OneToMany]
        public virtual ICollection<BVException_Channel> BVException_Channel { get; set; }
        [OneToMany]
        public virtual ICollection<BVException_Users> BVException_Users { get; set; }
    }
}
