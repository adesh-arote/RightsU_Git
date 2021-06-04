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

    [Table("Music_Title_Theme")]
    public partial class Music_Title_Theme
    {
        [PrimaryKey]
        public int? Music_Title_Theme_Code { get; set; }
        [ForeignKeyReference(typeof(Music_Title))]

        public Nullable<int> Music_Title_Code { get; set; }
        [ForeignKeyReference(typeof(Music_Theme))]
        public Nullable<int> Music_Theme_Code { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Music_Theme Music_Theme { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Music_Title Music_Title { get; set; }
    }
}
