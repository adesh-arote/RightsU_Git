using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper.SimpleSave;

namespace RightsU_Dapper.Entity
{
    [Table("IPR_Opp_Channel")]
    public partial class IPR_Opp_Channel
    { 
        [PrimaryKey]
        public int? IPR_Opp_Channel_Code { get; set; }
        [ForeignKeyReference(typeof(IPR_Opp))]
        public Nullable<int> IPR_Opp_Code { get; set; }
        public Nullable<int> Channel_Code { get; set; }

        public virtual Channel Channel { get; set; }
        public virtual IPR_Opp IPR_Opp { get; set; }
    }
}
