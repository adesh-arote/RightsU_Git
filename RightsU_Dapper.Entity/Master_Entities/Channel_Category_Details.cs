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
    using RightsU_Entities;

    [Table("Channel_Category_Details")]
    public partial class Channel_Category_Details
    {
        [PrimaryKey]
        public int? Channel_Category_Details_Code { get; set; }
        public Nullable<int> Channel_Category_Code { get; set; }
        public Nullable<int> Channel_Code { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Channel Channel { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Channel_Category Channel_Category { get; set; }
    }
}
