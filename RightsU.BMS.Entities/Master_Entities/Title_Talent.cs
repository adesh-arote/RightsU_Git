using Dapper.Contrib.Extensions;
using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using Newtonsoft.Json;
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
        [Column("Title_Talent_Code")]
        public int? title_talent_id { get; set; }

        [ForeignKeyReference(typeof(Title))]
        [Column("Title_Code")]
        public Nullable<int> title_id { get; set; }

        [ForeignKeyReference(typeof(Talent))]
        [Column("Talent_Code")]
        public Nullable<int> talent_id { get; set; }

        [ForeignKeyReference(typeof(Role))]
        [Column("Role_Code")]
        public Nullable<int> role_id { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Talent talent { get; set; }

        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        public virtual Role role { get; set; }
        
        [SimpleSaveIgnore]
        [SimpleLoadIgnore]
        [JsonIgnore]
        public State EntityState { get; set; }
    }
}
