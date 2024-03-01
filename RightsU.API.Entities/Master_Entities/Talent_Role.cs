using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.API.Entities
{
    [Table("Talent_Role")]
    public partial class Talent_Role
    {
        [PrimaryKey]
        public int? Talent_Role_Code { get; set; }
        [ForeignKeyReference(typeof(Talent))]
        public Nullable<int> Talent_Code { get; set; }
        [ForeignKeyReference(typeof(Role))]
        public Nullable<int> Role_Code { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Role Role { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Talent Talent { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }
    }
}
