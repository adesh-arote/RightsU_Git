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

    [Table("Channel_Region_Mapping")]
    public partial class Channel_Region_Mapping
    {
        [PrimaryKey]
        public int? Channel_Region_Mapping_code { get; set; }
        public Nullable<int> Channel_Region_Code { get; set; }
        public Nullable<int> Channel_code { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Channel Channel { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Channel_Region Channel_Region { get; set; }
    }
}
