using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity.Master_Entities
{
    using RightsU_Entities;
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;

    [Table("Music_Deal_Language")]
    public partial class Music_Deal_Language
    {
        [PrimaryKey]
        public int? Music_Deal_Language_Code { get; set; }
        public Nullable<int> Music_Deal_Code { get; set; }
        public Nullable<int> Music_Language_Code { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Music_Deal Music_Deal { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Music_Language Music_Language { get; set; }
    }
}
