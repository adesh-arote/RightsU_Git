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

    [Table("Channel_Entity")]
    public partial class Channel_Entity
    {
        [PrimaryKey]
        public int? Channel_Entity_Code { get; set; }
        [ForeignKeyReference(typeof(Channel))]
        public Nullable<int> Channel_Code { get; set; }
        [ForeignKeyReference(typeof(Entity))]
        public Nullable<int> Entity_Code { get; set; }
        public System.DateTime Effective_Start_Date { get; set; }
        public Nullable<System.DateTime> System_End_Date { get; set; }
        public Nullable<System.DateTime> Last_Updated_Time { get; set; }
        public Nullable<int> Last_Action_By { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Channel Channel { get; set; }
    }
}
