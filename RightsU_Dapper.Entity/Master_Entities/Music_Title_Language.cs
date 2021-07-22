using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_Dapper.Entity
{
    using System;
    using System.Collections.Generic;
    using Dapper.SimpleLoad;
    using Dapper.SimpleSave;
    using RightsU_Entities;

    [Table("Music_Title_Language")]
    public partial class Music_Title_Language
    {
        [PrimaryKey]
        public int? Music_Title_Language_Code { get; set; }
        [ForeignKeyReference(typeof(Music_Title))]
        public Nullable<int> Music_Title_Code { get; set; }
        [ForeignKeyReference(typeof(Music_Language))]
        public Nullable<int> Music_Language_Code { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Music_Language Music_Language { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Music_Title Music_Title { get; set; }
    }
}
