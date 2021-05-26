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

    [Table("Channel_Territory")]
    public partial class Channel_Territory
    {
        [PrimaryKey]
        public int? Channel_Territory_Code { get; set; }
        [ForeignKeyReference(typeof(Channel))]
        public Nullable<int> Channel_Code { get; set; }
        [ForeignKeyReference(typeof(Country))]
        public Nullable<int> Country_Code { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Channel Channel { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Country Country { get; set; }
    }
}
