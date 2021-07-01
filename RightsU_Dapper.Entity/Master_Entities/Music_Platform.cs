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

    [Table("Music_Platform")]
    public partial class Music_Platform
    {
        public Music_Platform()
        {
            this.Music_Deal_Platform = new HashSet<Music_Deal_Platform>();
        }
        [PrimaryKey]
        public int? Music_Platform_Code { get; set; }
        public string Platform_Name { get; set; }
        public Nullable<int> Parent_Code { get; set; }
        public string Is_Last_Level { get; set; }
        public string Module_Position { get; set; }
        public string Platform_Hierarchy { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Deal_Platform> Music_Deal_Platform { get; set; }
    }
}
