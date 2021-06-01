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

    [Table("Music_Theme")]
    public partial class Music_Theme
    {
        public Music_Theme()
        {
            this.Music_Title_Theme = new HashSet<Music_Title_Theme>();
        }

        [PrimaryKey]
        public int? Music_Theme_Code { get; set; }
        public string Music_Theme_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }

        [OneToMany]
        public virtual ICollection<Music_Title_Theme> Music_Title_Theme { get; set; }
    }
}
