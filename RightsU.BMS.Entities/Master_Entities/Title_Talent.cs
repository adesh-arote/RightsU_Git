using Dapper.Contrib.Extensions;
using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.Entities.Master_Entities
{
    [Dapper.SimpleSave.Table("Title_Talent")]
    public partial class Title_Talent
    {
        [PrimaryKey]
        public int? Title_Talent_Code { get; set; }
        [ForeignKeyReference(typeof(Title))]
        public Nullable<int> Title_Code { get; set; }
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
        public virtual Title Title { get; set; }
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public State EntityState { get; set; }
    }
}
