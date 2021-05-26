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

    [Table("Music_Language")]
    public partial class Music_Language
    {
        public Music_Language()
        {
            this.Music_Title_Language = new HashSet<Music_Title_Language>();
            this.Music_Deal_Language = new HashSet<Music_Deal_Language>();
        }
        [PrimaryKey]
        public int? Music_Language_Code { get; set; }
        public string Language_Name { get; set; }
        public Nullable<System.DateTime> Inserted_On { get; set; }
        public Nullable<int> Inserted_By { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        public string Is_Active { get; set; }
        public Nullable<int> Original_Language_Code { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Title_Language> Music_Title_Language { get; set; }
        [OneToMany]
        public virtual ICollection<Music_Deal_Language> Music_Deal_Language { get; set; }
    }
}
