using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper.SimpleLoad;
using Dapper.SimpleSave;
using RightsU_Entities;

namespace RightsU_Dapper.Entity
{
    [Table("IPR_Opp_Status")]
    public partial class IPR_Opp_Status
    {
        public IPR_Opp_Status()
        {
            this.IPR_Opp = new HashSet<IPR_Opp>();
        }
        [PrimaryKey]
        public int? IPR_Opp_Status_Code { get; set; }
        public string Opp_Status { get; set; }
        public string Is_Active { get; set; }

        [OneToMany]
        public virtual ICollection<IPR_Opp> IPR_Opp { get; set; }
    }
}
