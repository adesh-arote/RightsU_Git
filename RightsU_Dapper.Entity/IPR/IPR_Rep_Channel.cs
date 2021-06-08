using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper.SimpleSave;

namespace RightsU_Dapper.Entity
{
    [Table("IPR_Rep_Channel")]
    public partial class IPR_Rep_Channel
    {
        [PrimaryKey]
        public int? IPR_Rep_Channel_Code { get; set; }
        [ForeignKeyReference(typeof(IPR_REP))]
        public Nullable<int> IPR_Rep_Code { get; set; }
        public Nullable<int> Channel_Code { get; set; }

        public virtual Channel Channel { get; set; }
        public virtual IPR_REP IPR_REP { get; set; }
    }
}
