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

    [Table("BVException_Channel")]
    public partial class BVException_Channel
    {
        [PrimaryKey]
        public int? Bv_Exception_Channel_Code { get; set; }
        [ForeignKeyReference(typeof(BVException))]
        public int Bv_Exception_Code { get; set; }
        public int Channel_Code { get; set; }

        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual BVException BVException { get; set; }
        [SimpleLoadIgnore]
        [SimpleSaveIgnore]
        public virtual Channel Channel { get; set; }
    }
}
