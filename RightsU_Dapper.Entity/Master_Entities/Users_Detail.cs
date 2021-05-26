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
    using RightsU_Entities;

    [Table("Users_Detail")]
    public partial class Users_Detail
    {
        [PrimaryKey]
        public int? Users_Detail_Code { get; set; }
        [ForeignKeyReference(typeof(User))]
        public Nullable<int> Users_Code { get; set; }
        public Nullable<int> Attrib_Group_Code { get; set; }
        public string Attrib_Type { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Attrib_Group Attrib_Group { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual User User { get; set; }
    }
}
